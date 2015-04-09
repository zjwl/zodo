//
//  UIControl.swift
//  多芒电影
//
//  Created by 柴小红 on 15/2/5.
//  Copyright (c) 2015年 珠影网络. All rights reserved.
//

import Foundation
class UIControl {
    
}
extension UIControl{
    class daJiaShuoListView: UITableViewCell {
    }
    
    class tingInfoListView: UITableViewCell {
        
        var Title               : UILabel!
        var basicPicView        : UIImageView!
        var infoID              :Int = 0
        
        
        override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            var view = UIView(frame: CGRect(x: 215, y: 5, width: 100, height: 85))
            view.backgroundColor = UIColor.grayColor()
            
            Title = UILabel(frame: CGRect(x: 5, y: 5, width: 90, height: 80))
            Title.backgroundColor = UIColor.clearColor()
            Title.numberOfLines = 4
            Title.textColor = UIColor.whiteColor()
            Title.font = UIFont.systemFontOfSize(11)
            view.addSubview(Title)
            
            
            self.contentView.addSubview(view)
            
            basicPicView = UIImageView(frame: CGRect(x: 5, y: 5, width: 210, height: 85))
            basicPicView.contentMode = UIViewContentMode.ScaleToFill
            self.contentView.addSubview(basicPicView)
            
            
            
        }
        
        required init(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
        
        func configureCell(infoModel: Model.BasicInfo?) {
            if let model = infoModel {
                infoID = model.InfoID
                
                Title.text = model.Introduction
                if model.Introduction.isEmpty {
                    Title.text = model.Title
                }
                
                var url = model.PicURL.stringByReplacingOccurrencesOfString(".jpg", withString: "_133.jpg", options: NSStringCompareOptions.CaseInsensitiveSearch)
                
                
                url = url.stringByReplacingOccurrencesOfString(".png", withString: "_133.png", options: NSStringCompareOptions.CaseInsensitiveSearch)
                var imgURL = NSURL(string: url)
                
                // println(url)
                //new image load method
                PLMImageCache.sharedInstance.imageForUrl(imgURL!, desiredImageSize: CGSize(width: 319, height: 133), contentMode: UIViewContentMode.ScaleToFill) { (image) -> Void in
                    //use image
                    if !(image == nil) {
                        //   var timage = UTIL.squareImageFromImage(image!, scaledToSize: 70, isScale: true)
                        self.basicPicView.image = image
                    }
                    
                }
                
            }
        }
        
    }

    
    
    class yuInfoListView: UITableViewCell {

        var Title               : UILabel!
        var basicPicView        : UIImageView!
        var infoID              :Int = 0
        var roundV              :UInt32 = arc4random_uniform(10)
        var index               :Int = 0
        var view                :UIView!
        
        var colorArray:Array<UIColor> = [UIColor.grayColor(),UIColor.purpleColor(),UIColor.redColor(),UIColor.magentaColor(),UIColor.blackColor(),UIColor.blueColor(),UIColor.darkGrayColor(),UIColor.orangeColor(),UIColor.brownColor()]
        

        
        
        override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            view = UIView(frame: CGRect(x: 215, y: 5, width: screenWidth-220, height: 85))
            //view.backgroundColor = UIColor.grayColor()
            
            Title = UILabel(frame: CGRect(x: 5, y: 5, width: view.frame.width-10, height: 80))
            Title.backgroundColor = UIColor.clearColor()
            Title.numberOfLines = 4
            Title.textColor = UIColor.whiteColor()
            Title.font = UIFont.systemFontOfSize(11)
            view.addSubview(Title)
            
            
            self.contentView.addSubview(view)
            
            basicPicView = UIImageView(frame: CGRect(x: 5, y: 5, width: 210, height: 85))
            basicPicView.contentMode = UIViewContentMode.ScaleToFill
            self.contentView.addSubview(basicPicView)
            
            
            
        }
        
        required init(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
        
        func configureCell(infoModel: Model.BasicInfo?) {
            if let model = infoModel {
                infoID = model.InfoID
                var color = colorArray[ (Int(roundV) + index) % colorArray.count]
                view.backgroundColor = color
                
                Title.text = model.Introduction
                if model.Introduction.isEmpty {
                    Title.text = model.Title
                }
                
                var url = model.PicURL.stringByReplacingOccurrencesOfString(".jpg", withString: "_133.jpg", options: NSStringCompareOptions.CaseInsensitiveSearch)
                
                
                url = url.stringByReplacingOccurrencesOfString(".png", withString: "_133.png", options: NSStringCompareOptions.CaseInsensitiveSearch)
                var imgURL = NSURL(string: url)
                
               // println(url)
                //new image load method
                PLMImageCache.sharedInstance.imageForUrl(imgURL!, desiredImageSize: CGSize(width: 319, height: 133), contentMode: UIViewContentMode.ScaleToFill) { (image) -> Void in
                    //use image
                    if !(image == nil) {
                     //   var timage = UTIL.squareImageFromImage(image!, scaledToSize: 70, isScale: true)
                        self.basicPicView.image = image
                    }
                    
                }
                
            }
        }
        
    }

    
    class wanInfoListView: UITableViewCell {
        
        var Title               : UILabel!
        var Desc                : UILabel!
        var basicPicView        : UIImageView!
        var packgeName          : String!
        var address             : String!
        var view                : UIView!
        var playBtn             : UIButton!
        var playItems           : NSMutableDictionary = NSMutableDictionary()
        
        
        override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            view = UIView(frame: CGRect(x: 95, y: 5, width: screenWidth-100, height: 85))
            //view.backgroundColor = UIColor.grayColor()
            
            Title = UILabel(frame: CGRect(x: 5, y: 5, width: view.frame.width-10, height: 15))
            Title.backgroundColor = UIColor.clearColor()
            Title.numberOfLines = 4
            Title.font = UIFont.systemFontOfSize(13)
            view.addSubview(Title)
            
            Desc = UILabel(frame: CGRect(x: 5, y: 20, width: view.frame.width-10, height: 30))
            Desc.backgroundColor = UIColor.clearColor()
            Desc.numberOfLines = 2
            Desc.font = UIFont.systemFontOfSize(11)
            view.addSubview(Desc)

            
            self.contentView.addSubview(view)
            
            basicPicView = UIImageView(frame: CGRect(x: 5, y: 5, width: 80, height: 80))
            basicPicView.contentMode = UIViewContentMode.ScaleToFill
            self.contentView.addSubview(basicPicView)
            
            playBtn = UIButton(frame: CGRect(x: screenWidth-100, y: 60, width: 67, height: 32))
            self.contentView.addSubview(playBtn)
            playBtn.addTarget(self, action: "playTarget:", forControlEvents: UIControlEvents.TouchDown)
            
        }
        
        required init(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
        
        func configureCell(infoModel: Model.Game?) {
            if let model = infoModel {
                
                
                playItems.setObject(model.GameAddress, forKey: model.GameID)
                
                packgeName  = model.PackageName
                address     =   model.GameAddress
                view.backgroundColor = UIColor.whiteColor()
                
                Title.text = model.GameName
                Desc.text  = model.Description
                
                var   url = model.GamePhoto
                var imgURL = NSURL(string: url)
                PLMImageCache.sharedInstance.imageForUrl(imgURL!, desiredImageSize: CGSize(width: 175, height: 175), contentMode: UIViewContentMode.ScaleToFill) { (image) -> Void in
                    //use image
                    if !(image == nil) {
                        //   var timage = UTIL.squareImageFromImage(image!, scaledToSize: 70, isScale: true)
                        self.basicPicView.image = image
                    }
                    
                }
                var imv = UIImageView(frame: playBtn.bounds)
                imv.image = UIImage(named: "play_game")
                playBtn.addSubview(imv)
                playBtn.tag = model.GameID
            }
        }
        
        func playTarget(sender:UIButton){
            if let playUrl = playItems.objectForKey(sender.tag) as? String{
                UIApplication.sharedApplication().openURL(NSURL(string: playUrl)!)
            
            }
            
        }
        
    }

    
    class duInfoListView: UITableViewCell {
        var Description     : UILabel!
        var Title               : UILabel!
        var basicPicView        : UIImageView!
        var infoID              :Int = 0
        var index               :Int = 0
        var roundV              :UInt32 = arc4random_uniform(10)
        var view                :UIView!
        
        var colorArray:Array<UIColor> = [UIColor.grayColor(),UIColor.purpleColor(),UIColor.redColor(),UIColor.magentaColor(),UIColor.blackColor(),UIColor.blueColor(),UIColor.darkGrayColor(),UIColor.orangeColor(),UIColor.brownColor()]

        
        override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            view = UIView(frame: CGRect(x: 100, y: 5, width: screenWidth-110, height: 100))
           // view.backgroundColor = UIColor.brownColor()
            
            Title = UILabel(frame: CGRect(x: 5, y: 0, width: view.frame.width-10, height: 35))
            Title.backgroundColor = UIColor.clearColor()
            Title.numberOfLines = 2
            Title.textColor = UIColor.whiteColor()
            Title.font = UIFont.systemFontOfSize(13)
            view.addSubview(Title)
            
            Description = UILabel(frame: CGRect(x: 5, y: 35,width: view.frame.width-10, height: 60))
            Description.numberOfLines = 4
            Description.font = UIFont.systemFontOfSize(11)
            Description.textColor = UIColor.whiteColor()
            view.addSubview(Description)
            
            self.contentView.addSubview(view)
            
            basicPicView = UIImageView(frame: CGRect(x: 10, y: 5, width: 85, height: 100))
            basicPicView.contentMode = UIViewContentMode.ScaleToFill
            self.contentView.addSubview(basicPicView)
            

            
        }
        
        required init(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
        
        func configureCell(infoModel: Model.BasicInfo?) {
            if let model = infoModel {
                infoID = model.InfoID
                
                var color = colorArray[ (Int(roundV) + index) % colorArray.count]
                view.backgroundColor = color
 
                Description.text = model.Content.removeHtml().trim().stringByReplacingOccurrencesOfString("&nbsp;", withString: "", options: NSStringCompareOptions.CaseInsensitiveSearch)
                Title.text = model.Introduction
                if model.Introduction.isEmpty {
                    Title.text = model.Title
                }
                
                var url =  model.PicURL.stringByReplacingOccurrencesOfString(".jpg", withString: "_133.jpg", options: NSStringCompareOptions.CaseInsensitiveSearch)
                
                
                url = url.stringByReplacingOccurrencesOfString(".png", withString: "_133.png", options: NSStringCompareOptions.CaseInsensitiveSearch)
                var imgURL = NSURL(string: url)
                
                
                //new image load method
                PLMImageCache.sharedInstance.imageForUrl(imgURL!, desiredImageSize: CGSize(width: 92, height: 133), contentMode: UIViewContentMode.ScaleToFill) { (image) -> Void in
                    //use image
                    if !(image == nil) {
                     //   var timage = UTIL.squareImageFromImage(image!, scaledToSize: 70, isScale: true)
                        self.basicPicView.image = image
                    }
                    
                }
                
            }
        }

    }
    
    class basicInfolistView : UITableViewCell {
            var columnNameLabel     : UILabel!
            var Title               : UILabel!
            var basicPicView        : UIImageView!
            var playBtn             :UIButton!
            var infoID              :Int = 0
            var playUrl             :String = ""
            var displayLabel        =  true
            var displayLink         = false
            var isCircul = false
        
        var columnNames = ["1":"[电影推荐]","2":"[说说电影]","4":"[电影源声]","5":"[轻松一刻]"]
        
        override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            
            columnNameLabel = UILabel(frame: CGRect(x: 95, y: 15, width: 200, height: 17))
            columnNameLabel.backgroundColor = UIColor.clearColor()
            columnNameLabel.font = UIFont.systemFontOfSize(14)
            self.contentView.addSubview(columnNameLabel)
            
            Title = UILabel(frame: CGRect(x: 90, y: 30,width: screenWidth-100, height: 40))
            Title.numberOfLines = 2
            Title.backgroundColor = UIColor.clearColor()
            Title.font = UIFont.systemFontOfSize(11)
           // Title.lineBreakMode = lin
            self.contentView.addSubview(Title)
            
            basicPicView = UIImageView(frame: CGRect(x: 15, y: 15, width: 70, height: 70))
            basicPicView.contentMode = UIViewContentMode.ScaleToFill
            self.contentView.addSubview(basicPicView)
            
            playBtn = UIButton(frame: CGRect(x: screenWidth-70, y: 70, width: 32, height: 20))
            self.contentView.addSubview(playBtn)
            playBtn.addTarget(self, action: "playTarget:", forControlEvents: UIControlEvents.TouchDown)

        }

        required init(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }

        func configureCell(infoModel: Model.BasicInfo?) {
            if let model = infoModel {
                infoID = model.InfoID
                playUrl = model.LinkUrl
                columnNameLabel.text = columnNames["\(model.ColumnID)"]
                Title.text = model.Introduction
                if model.Introduction.isEmpty {
                    Title.text = model.Title
                }
                
                if !displayLabel {
                    columnNameLabel.hidden = true
                }
                
                if isCircul {
                    basicPicView.layer.masksToBounds = true
                    basicPicView.layer.cornerRadius = basicPicView.bounds.size.height / 2
                    basicPicView.layer.backgroundColor = UIColor.whiteColor().CGColor
                }
                
                var url =  model.PicURL.stringByReplacingOccurrencesOfString(".jpg", withString: "_133.jpg", options: NSStringCompareOptions.CaseInsensitiveSearch)
                
                
                 url = url.stringByReplacingOccurrencesOfString(".png", withString: "_133.png", options: NSStringCompareOptions.CaseInsensitiveSearch)
                var imgURL = NSURL(string: url)
                
                /**
                *  初始化data。从URL中获取数据
                                var data = NSData(contentsOfURL:imgURL!)
               
                var image = UIImage(data:data!, scale: 1.0)
                
                if !url.hasSuffix(".png"){
                    image = UTIL.squareImageFromImage(image!, scaledToSize: 70, isScale: true)
                }
                self.basicPicView.image = image
                
                */

                
                //new image load method
                PLMImageCache.sharedInstance.imageForUrl(imgURL!, desiredImageSize: CGSize(width: 133, height: 133), contentMode: UIViewContentMode.ScaleToFill) { (image) -> Void in
                    //use image
                    if !(image == nil) {
                        var timage = UTIL.squareImageFromImage(image!, scaledToSize: 70, isScale: true)
                        self.basicPicView.image = timage
                    }
                  
                }
                
          //     basicPicView.sd_setImageWithURL(imgURL)
                if model.ColumnID == 1 || model.ColumnID == 6 {
                    var imv = UIImageView(frame: playBtn.bounds)
                    
                    imv.image = UIImage(named: "play")
                    playBtn.addSubview(imv)
                    playBtn.tag = infoID
                }else {
                    playBtn.hidden = true
                }
            }
        }

        func playTarget(sender:UIButton){
            println(playUrl)
        }
        
    }
}
