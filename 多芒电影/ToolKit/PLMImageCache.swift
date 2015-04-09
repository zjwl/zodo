//
//  PLMImageCache.swift
//  多芒电影
//
//  Created by junjian chen on 15/2/27.
//  Copyright (c) 2015年 珠影网络. All rights reserved.
//

import Foundation

typealias PLMImageCacheCompletionHandler = (image : UIImage?) -> Void

class PLMImageCache {
    let downloadImageQueue : NSOperationQueue
    var pathToContainerDictionary: [String:String] = Dictionary()
    
    //MARK:Singleton
    class var sharedInstance : PLMImageCache {
        struct Static {
            static let instance = PLMImageCache()
        }
        return Static.instance
    }
    
    //MARK:Init
    init () {
        self.downloadImageQueue = NSOperationQueue()
        //take care about the image folder structure. Ensure all is here to startup and grab what is existing
        //the structure will be originals/,   resized/22x22, resized/44x44 etc..
        var directoryPath: String = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)[0] .stringByAppendingPathComponent("/images/")
        
        ensureDirectoryAtPath(directoryPath)
        ensureDirectoryAtPath(directoryPath.stringByAppendingPathComponent("originals/"))
        self.pathToContainerDictionary["0x0"] = directoryPath.stringByAppendingPathComponent("originals/")
        
        //find what is inside
        let directoriesURL = NSURL.fileURLWithPath(directoryPath, isDirectory: true)!
        let enumerator : NSDirectoryEnumerator = NSFileManager.defaultManager().enumeratorAtURL(directoriesURL, includingPropertiesForKeys: [NSURLIsDirectoryKey], options: NSDirectoryEnumerationOptions()) { (url : NSURL!, error : NSError!) -> Bool in
            return true
            }!
        
        while (enumerator.nextObject() != nil) {
            if var url = enumerator.nextObject() as? NSURL {
                var anyError: NSError?
                var isDirectory: AnyObject?
                
                if url.getResourceValue(&isDirectory, forKey: NSURLIsDirectoryKey, error: &anyError) {
                    let subPath = url.path?.stringByStandardizingPath.substringFromIndex(directoryPath.stringByStandardizingPath.endIndex)
                    
                    if subPath!.hasPrefix("/resized/") {
                        self.pathToContainerDictionary[url.lastPathComponent!] = directoryPath.stringByAppendingPathComponent(subPath!)
                    }
                }
            }
        }
    }
    
    //MARK:Data Access
    func imageForUrl(url: NSURL, desiredImageSize imageSize: CGSize, contentMode mode: UIViewContentMode, completion completionHandler:PLMImageCacheCompletionHandler) {
        //println("[IMAGECACHE] - Asking for image url: \(url.absoluteString)")
        
        if url.absoluteString?.isEmpty == false {
            let tmpKey: String = self.keyForIdentifier(url.absoluteString!)
            if let localData = self.localDataForKey(tmpKey, andSize: imageSize) {
                let image = UIImage(data: localData)
                dispatch_async(dispatch_get_main_queue()) {
                    completionHandler(image: image)
                }
            } else if contains(["http", "https"], url.scheme!) {
                //Local data, at least original but may imply a transformation
               // println("[IMAGECACHE] - Will download image")
                //Download original image, resize it and store it
                NSURLConnection.sendAsynchronousRequest(NSURLRequest(URL: url), queue: self.downloadImageQueue, completionHandler: { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
                    if let responseFormatted = response as? NSHTTPURLResponse {
                        let errorCode: Int = responseFormatted.statusCode
                        if 0 == data.length {
                            println("[IMAGECACHE] - Returned Image is nil")
                            dispatch_async(dispatch_get_main_queue()) {
                                completionHandler(image: nil)
                            }
                        } else if errorCode == 404 {
                            println("[IMAGECACHE] - Image not found aka 404")
                            dispatch_async(dispatch_get_main_queue()) {
                                completionHandler(image: nil)
                            }
                        } else {
                            //Write the original
                            self.writeLocalData(data, forKey: tmpKey, withSize: CGSizeZero)
                        }
                        //Return the image
                        if let resizedData = self.localDataForKey(tmpKey, andSize: imageSize) {
                            let image = UIImage(data: resizedData)
                            dispatch_async(dispatch_get_main_queue()) {
                                completionHandler(image: image)
                            }
                        } else {
                            dispatch_async(dispatch_get_main_queue()) {
                                completionHandler(image: nil)
                            }
                        }
                    }
                })
            } else {
                //Bad scheme so send back nil directly
                dispatch_async(dispatch_get_main_queue()) {
                    completionHandler(image: nil)
                }
            }
        } else {
            //Empty url so send back nil directly
            dispatch_async(dispatch_get_main_queue()) {
                completionHandler(image: nil)
            }
        }
    }
    
    //MARK:Low level management
    func keyForIdentifier(identifier: String) -> String {
        var result: String?
        
        if identifier.isEmpty { return result! }
        result = identifier.md5()
        
        return result!
    }
    
    func localDataForKey(key: String, andSize desiredSizeImage: CGSize) -> NSData? {
        var result: NSData? = nil
        
        //If no size is given, look for original pic container otherwise the one of the size
        
        var width   = Int( desiredSizeImage.width )
        var height  = Int( desiredSizeImage.height)
        
         let imagePath = String(format: "%0.fx%0.f", width, height)
          let imagePathKey = imagePath.stringByAppendingPathComponent(String(format: "%@.jpg", key))
        
        result = NSData(contentsOfFile: imagePathKey)
        
        if result == nil {
            let originalImageDataPath: String = self.pathToContainerDictionary["0x0"]!.stringByAppendingPathComponent(String(format: "%@.jpg", key))
            
            if let tmpResult = self.imageWithData(NSData(contentsOfFile: originalImageDataPath), convertToSize: desiredSizeImage) {
                result = tmpResult
                self.writeLocalData(result!, forKey: key, withSize: desiredSizeImage)
            }
        }
        
        return result;
    }
    
    func writeLocalData(data: NSData, forKey key: String, withSize desiredImageSize:CGSize) {
      //  let imagePath = NSString(format: "%ix%i", desiredImageSize.width, desiredImageSize.height)
        
        var width   = Int( desiredImageSize.width )
        var height  = Int( desiredImageSize.height)
        
        let imagePath = String(format: "%0.fx%0.f", width, height)
        
        var cachePath = self.pathToContainerDictionary[imagePath]
        //If the folder does not exist this means this is a new size
        if cachePath == nil {
            cachePath = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)[0].stringByAppendingPathComponent(NSString(format: "/images/resized/%0.fx%0.f", width, height))
            
            self.ensureDirectoryAtPath(cachePath!)
            self.pathToContainerDictionary[imagePath] = cachePath
        }
        data.writeToFile(cachePath!.stringByAppendingPathComponent(String(format: "%@.jpg", key)), atomically: true)
    }
    
    func imageWithData(data: NSData?, convertToSize size:CGSize) -> NSData? {
        //warning: this will return a blank image sometimes, when url is good but not good answer
        if let tmpData = data as NSData! {
            var image = UIImage(data: data!)
            /*
            UIGraphicsBeginImageContextWithOptions(size, false, 0)//0 will take the device main screen scale -> [UIScreen mainScreen].scale, and set opaque to NO keep the mask
            image?.drawInRect(CGRectMake(0, 0, size.width, size.height))
            let finalImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext();
            */
            let imageData = UIImagePNGRepresentation(image)//UIImageJPEGRepresentation(image, 1)//1 is best quality, 0 is poor quality
            return imageData;
        } else {
            return nil
        }
    }
    
    //MARK:Utilities
    //Directory creation : check there is no file with the same name, if yes remove it, create create directory if not present
    func ensureDirectoryAtPath(path : String) -> Bool {
        var result : Bool = false
        var isDirectory : ObjCBool = false
        var cacheExists : Bool = false
        
        cacheExists = NSFileManager.defaultManager().fileExistsAtPath(path, isDirectory: &isDirectory)
        if cacheExists && !isDirectory {
            // It is not a directory. Remove it
            if !NSFileManager.defaultManager().removeItemAtPath(path, error: nil) {
                return result
            } else {
                cacheExists = false
            }
        }
        // Now we can safely create the cache directory if needed.
        if !cacheExists {
            if NSFileManager.defaultManager().createDirectoryAtPath(path, withIntermediateDirectories: true, attributes: nil, error: nil) {
                result = true
            }
        } else {
            result = true
        }
        return result
    }
}

extension String {
    func md5() -> String! {
        let str = self.cStringUsingEncoding(NSUTF8StringEncoding)
        let strLen = CUnsignedInt(self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLen)
        CC_MD5(str!, strLen, result)
        
        var hash = NSMutableString()
        for i in 0..<digestLen {
            hash.appendFormat("%02x", result[i])
        }
        result.destroy()
        return String(format: hash)
    }
}
