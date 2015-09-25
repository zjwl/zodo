//
//  UIView+Utils.swift
//  PinterestSwift
//
//  Created by Nicholas Tau on 7/2/14.
//  Copyright (c) 2014 Nicholas Tau. All rights reserved.
//

import Foundation
import UIKit

extension UIView{
    func origin (point : CGPoint){
        frame.origin.x = point.x
        frame.origin.y = point.y
    }
}

var kIndexPathPointer = "kIndexPathPointer"

extension UICollectionView{
//    var currentIndexPath : NSIndexPath{
//    get{
//        return objc_getAssociatedObject(self,kIndexPathPointer) as NSIndexPath
//    }set{
//        objc_setAssociatedObject(self, kIndexPathPointer, newValue, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
//    }} WTF! error when building, it's a bug 
//    http://stackoverflow.com/questions/24021291/import-extension-file-in-swift
    
    func setToIndexPath (indexPath : NSIndexPath){
        objc_setAssociatedObject(self, &kIndexPathPointer, indexPath, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    func toIndexPath () -> NSIndexPath {
        let index = self.contentOffset.x/self.frame.size.width
        if index > 0{
            return NSIndexPath(forRow: Int(index), inSection: 0)
        }else if let indexPath = objc_getAssociatedObject(self,&kIndexPathPointer) as? NSIndexPath {
            return indexPath
        }else{
            return NSIndexPath(forRow: 0, inSection: 0)
        }
    }
    
    func fromPageIndexPath () -> NSIndexPath{
        let index : Int = Int(self.contentOffset.x/self.frame.size.width)
        return NSIndexPath(forRow: index, inSection: 0)
    }
}

let ZAN="baseInfoZanCollection",COLLECTION="baseInfoCollection"

extension UIViewController{
    
        var user:Model.LoginModel{
            var userDefaults = NSUserDefaults.standardUserDefaults()
            var obj:AnyObject? = userDefaults.objectForKey("myUser")
            
            if obj != nil {
                //var result = NSKeyedUnarchiver.unarchiveObjectWithData(obj) as? NSMutableArray
               var user1 = NSKeyedUnarchiver.unarchiveObjectWithData(obj! as! NSData) as! Model.LoginModel
                user1.IsUsed = "true"
                if user1.MemberID != "" && user1.MemberID != "0" {
                    user1.IsLogin = true
                }else {
                    user1.IsLogin = false
                }
               return user1
            }else {
                return Model.LoginModel()
            }
        }
    
    
    
    func readObjectFromUD(key:String)->AnyObject?{
        var ud = NSUserDefaults.standardUserDefaults()
        return ud.objectForKey(key)
    }
    
    //检测是否已赞
    func isBasicInfoZaned(id:Int)->Bool{
        var userDefault = NSUserDefaults.standardUserDefaults()
        var zanCollection:NSString? = userDefault.stringForKey(ZAN)
        if !(zanCollection==nil){
            var str:String=","+String(id)+","
            var isContains=zanCollection!.containsString(str)
            return isContains ? true : false
        }else{
            return false
        }
    }
    
    //检测是否已收藏
    func isBasicInfoCollected(id:Int)->Bool{
        var userDefault = NSUserDefaults.standardUserDefaults()
        var zanCollection:NSString? = userDefault.stringForKey(COLLECTION)
        if !(zanCollection==nil){
            var str:String=","+String(id)+","
            var isContains=zanCollection!.containsString(str)
            return isContains ? true : false
        }else{
            return false
        }
    }
    
    //写入赞信息到本地
    func saveBasicZanInfoToLocal(id:Int){
        var userDefault = NSUserDefaults.standardUserDefaults()
        var zanCollection:String? = userDefault.stringForKey(ZAN)
        if zanCollection==nil || zanCollection==""{
            userDefault.setValue(","+String(id)+",", forKey: ZAN)
        }else{
            userDefault.setValue(zanCollection!+String(id)+",", forKey: ZAN)
        }
    }
    
    //写入收藏信息到本地
    func saveBasicCollectionInfoToLocal(id:Int){
        var userDefault = NSUserDefaults.standardUserDefaults()
        
        var zanCollection:String? = userDefault.stringForKey(COLLECTION)
        if zanCollection==nil || zanCollection==""{
            userDefault.setValue(","+String(id)+",", forKey: COLLECTION)
        }else{
            userDefault.setValue(zanCollection!+String(id)+",", forKey: COLLECTION)
        }
        var tt = userDefault.stringForKey(COLLECTION)
        print("Collection String:\(tt)")
    }
    
    //删除本地收藏信息
    func deleteBasicCollectionInfoToLocal(id:Int){
        var userDefault = NSUserDefaults.standardUserDefaults()
        var zanCollection:String? = userDefault.stringForKey(COLLECTION)
        if !(zanCollection==nil){
            var toReplaceString=",\(id),"
            var toSaveString = zanCollection?.stringByReplacingOccurrencesOfString(toReplaceString, withString: "")
            userDefault.setValue(toSaveString, forKey: COLLECTION)
        }
    }
    
    //构造分享内容
    func basicShareFunc(currentInfo:Model.BasicInfo){
        
        
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let sandboxPath = paths[0] as! String

        
       // var sandboxPath = NSString //NSHomeDirectory()
        var documentPath =  sandboxPath.stringByAppendingPathComponent("shareImg")
        
        //Get Image From URL
        var  imageFromURL = getImageFromURL(currentInfo.PicURL)
        
        //Save Image to Directory
        saveImage(imageFromURL, withFileName: "\(currentInfo.InfoID)", imageType: "jpg", directoryPath: documentPath)
        
         //Load Image From Directory
        var imageFromWeb = loadImage("\(currentInfo.InfoID)", oftype: "jpg", directoryPath: documentPath)
        
       
        
        
        var publishContent = ShareSDK.content(currentInfo.Title, defaultContent: currentInfo.Introduction, image:ShareSDK.imageWithPath(imageFromWeb), title: currentInfo.Title, url:"http://apk.zdomo.com/frontpage/?id=\(currentInfo.InfoID)", description: currentInfo.Content, mediaType: SSPublishContentMediaTypeNews)
        
        
        ShareSDK.showShareActionSheet(nil, shareList: nil, content: publishContent, statusBarTips: true, authOptions: nil, shareOptions: nil, result: { (shareType:ShareType, state:SSResponseState, info:ISSPlatformShareInfo!, error:ICMErrorInfo!, Bool) -> Void in
            if state.rawValue == SSResponseStateSuccess.rawValue  {
                NSLog("分享成功");
            } else if state.rawValue == SSPublishContentStateFail.rawValue {
                NSLog("分享失败,错误码:%d,错误描述:%@",error.errorCode(),error.errorDescription())
            }})
    }
    
    
    func getImageFromURL(fileURL:String)->UIImage{
        var  data = NSData(contentsOfURL: NSURL(string: fileURL)!)
        return UIImage(data: data!)!
    }
    
    func saveImage(image:UIImage,withFileName:String,imageType:String,directoryPath:String) {
        if imageType.lowercaseString == "png" {
            do {
                try UIImagePNGRepresentation(image).writeToFile(directoryPath.stringByAppendingFormat("\(withFileName).\(imageType)"), options: NSDataWritingOptions.AtomicWrite)
            } catch _ {
            }
        } else  if imageType.lowercaseString == "jpg" {
            do {
                try UIImageJPEGRepresentation(image,1.0).writeToFile(directoryPath.stringByAppendingFormat("\(withFileName).\(imageType)"), options: NSDataWritingOptions.AtomicWrite)
            } catch _ {
            }
        }else{
            NSLog("文件后缀不认识")
        }
    }
    
    
    func loadImage(fileName:String,oftype:String,directoryPath:String) -> String {
        return "\(directoryPath)\(fileName).\(oftype)"
    }
  
    
  
    
    
    
}
