//
//  NTHorizontalPageViewCell.swift
//  PinterestSwift
//
//  Created by Nicholas Tau on 7/1/14.
//  Copyright (c) 2014 Nicholas Tau. All rights reserved.
//

import Foundation
import UIKit

let cellIdentify = "cellIdentify"

class NTTableViewCell : UITableViewCell{
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.textLabel?.font = UIFont.systemFontOfSize(13)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageView :UIImageView = self.imageView!;
        imageView.frame = CGRectZero
        if (imageView.image != nil) {
            let imageHeight = imageView.image!.size.height*screenWidth/imageView.image!.size.width
            imageView.frame = CGRectMake(0, 0, screenWidth, imageHeight)
        }
    }
}

class NTHorizontalPageViewCell : UICollectionViewCell,UIScrollViewDelegate{
    var imageName : String?
    var title : String?
    var container:UIScrollView = UIScrollView(frame: CGRectMake(0, navigationHeight-20, screenWidth, screenHeight))
    var titlelbl:UILabel = UILabel()
    var imageHodler:UIView = UIView()
    var pullAction : ((offset : CGPoint) -> Void)?
    var tappedAction : (() -> Void)?
    let tableView = UITableView(frame: screenBounds, style: UITableViewStyle.Plain)
    
    var parentVC:NTHorizontalPageViewController?
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        container.delegate = self
        
        self.container.addSubview(imageHodler)
        self.container.addSubview(self.titlelbl)
        self.contentView.addSubview(self.container)
        
        var gesture:UIGestureRecognizer=UILongPressGestureRecognizer(target: self, action: Selector("doSaveImage"))
        self.container.addGestureRecognizer(gesture)
    }
    
    func doSaveImage(){
        var alert:UIAlertController=UIAlertController(title: "保存图片到相册", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        var saveImageAction = UIAlertAction(title: "保存图片", style: UIAlertActionStyle.Default){
                UIAlertAction in
                self.saveImage()
                
        }
        
        var cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel){
                UIAlertAction in
                
        }
        
        // Add the actions
        alert.addAction(saveImageAction)
        alert.addAction(cancelAction)
        if !(parentVC==nil) {
            parentVC!.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func saveImage(){
        println("image saved")
        //UIImageWriteToSavedPhotosAlbum
        
        
        var imgURL = NSURL(string: imageName!)
        PLMImageCache.sharedInstance.imageForUrl(imgURL!, desiredImageSize: CGSizeMake(133, 133), contentMode: UIViewContentMode.Center) { (returnImage) -> Void in
            //use image
            if !(returnImage==nil) {
                UIImageWriteToSavedPhotosAlbum(returnImage, self, Selector("image:didFinishSavingWithError:contextInfo:"), nil)
            }
            
        }
    }
    
    func image(image: UIImage, didFinishSavingWithError error: NSErrorPointer, contextInfo: UnsafePointer<()>) {
        dispatch_async(dispatch_get_main_queue(), {
            UIAlertView(title: "", message: "😄 图片已保存", delegate: nil, cancelButtonTitle: "关闭").show()
        })
    }

    
    func saveInfo(){
        println("really save...")
    }
    
    func configCell(){
        backgroundColor = UIColor.yellowColor()
        
        var imgURL = NSURL(string: imageName!)
        PLMImageCache.sharedInstance.imageForUrl(imgURL!, desiredImageSize: CGSizeMake(133, 133), contentMode: UIViewContentMode.Center) { (returnImage) -> Void in
            //use image
            if !(returnImage==nil) {
                var imageview:UIImageView = UIImageView(frame: CGRectMake(0, 0, screenWidth,  (returnImage!.size.height)*screenWidth/(returnImage!.size.width)))
                imageview.image = returnImage
                self.titlelbl.frame = CGRectMake(0, imageview.frame.height, screenWidth, 40)
                self.titlelbl.text = self.title
                self.titlelbl.textAlignment = NSTextAlignment.Center
                for item in self.imageHodler.subviews{
                    item.removeFromSuperview()
                }
                self.imageHodler.addSubview(imageview)
                self.container.contentSize = CGSizeMake(screenWidth, imageview.frame.height+150)
                
                
            }
            
        }
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
    func scrollViewWillBeginDecelerating(scrollView : UIScrollView){
        if scrollView.contentOffset.y < -40{
            pullAction?(offset: scrollView.contentOffset)
        }
    }
}