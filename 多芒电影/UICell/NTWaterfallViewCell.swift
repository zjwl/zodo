//
//  NTWaterfallViewCell.swift
//  PinterestSwift
//
//  Created by Nicholas Tau on 6/30/14.
//  Copyright (c) 2014 Nicholas Tau. All rights reserved.
//

import UIKit

class NTWaterfallViewCell :UICollectionViewCell, NTTansitionWaterfallGridViewProtocol{
    var imageName : String?
    var imageViewContent : UIImageView = UIImageView()
    var titleLbl:UILabel=UILabel()
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageViewContent)
        contentView.addSubview(titleLbl)
        
        imageViewContent.frame = CGRectMake(0, 0, frame.size.width, frame.size.height-25)
        titleLbl.frame=CGRectMake(0,frame.height-25,frame.width,25)
        titleLbl.font=UIFont(name: "ArialUnicodeMS", size: 13)
        titleLbl.textAlignment=NSTextAlignment.Center
        self.imageViewContent.contentMode = UIViewContentMode.ScaleToFill
        
        
//        var imgURL = NSURL(string: imageName!)
//        PLMImageCache.sharedInstance.imageForUrl(imgURL!, desiredImageSize: CGSizeMake(133, 133), contentMode: UIViewContentMode.Center) { (returnImage) -> Void in
//            //use image
//            if !(returnImage==nil) {
//                var image:UIImage = returnImage!
//                self.imageViewContent.image = image
//                
//            }
//        }
    }
    
    func configCell(){
        var imgURL = NSURL(string: imageName!)
        PLMImageCache.sharedInstance.imageForUrl(imgURL!, desiredImageSize: CGSizeMake(133, 133), contentMode: UIViewContentMode.Center) { (returnImage) -> Void in
            //use image
            if !(returnImage==nil) {
                var image:UIImage = returnImage!
                self.imageViewContent.image = image

            }
        }
    }
   
    
    func snapShotForTransition() -> UIView! {
        let snapShotView = UIImageView(image: self.imageViewContent.image)
        snapShotView.frame = imageViewContent.frame
        return snapShotView
    }
}