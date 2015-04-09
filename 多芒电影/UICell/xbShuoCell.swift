//
//  xbShuoCell.swift
//  多芒电影
//
//  Created by junjian chen on 15/3/3.
//  Copyright (c) 2015年 珠影网络. All rights reserved.
//

class xbShuoCell: UITableViewCell,DataDelegate{
    var userIcon:UIImageView = UIImageView(frame: CGRectMake(10, 10, 60, 60))
    var lblTitile:UILabel = UILabel(frame: CGRectMake(20, 10, 100, 20))
    var lblTime:UILabel = UILabel(frame: CGRectMake(20, 40, 100, 20))
    var hrView:UIView = UIView()
    var lblContent:UILabel = UILabel()
    var tableWidth = UIScreen.mainScreen().applicationFrame.width
    var heartBtn:UIImageView = UIImageView()
    var replyBtn:UIImageView = UIImageView()
    var goodTimes:UILabel=UILabel()
    var holdView=UIView()
    var m:Model.QASK?
    var isZanIng=false
    var replyBtn2:UIButton?
    var itemHrView:UIView=UIView()
    
    func configureCell(askModelList: Array<Model.QASK>) {
        
        //第一层Cell
        var model = askModelList[0]
        m=model
        self.configItem0Base(model)
        //println("self ' s y is:\(userIcon.frame.origin.y) +++++ height is:\(self.frame.height)")
        //println("usericon ' s y is:\(userIcon.frame.origin.y) +++++ height is:\(userIcon.frame.height)")
        //println("hrView ' s y is:\(hrView.frame.origin.y) +++++ height is:\(hrView.frame.height)")
        //println("lblContent ' s y is:\(lblContent.frame.origin.y) +++++ height is:\(lblContent.frame.height)")
        
        if askModelList.count==2 {
            var tempView = self.setReplyItem(askModelList[1])
            tempView.frame = CGRectMake(10, heartBtn.frame.height+heartBtn.frame.origin.y, tempView.frame.width, tempView.frame.height)
            holdView.addSubview(tempView)
        }
        if askModelList.count==3 {
            //println("list[1]' title:\(askModelList[1].NickName)")
            var tempView = self.setReplyItem(askModelList[1])
            tempView.frame = CGRectMake(10, heartBtn.frame.height+heartBtn.frame.origin.y, tempView.frame.width, tempView.frame.height)
            holdView.addSubview(tempView)
            
            var departView = UIView(frame: CGRectMake(10, tempView.frame.height+tempView.frame.origin.y+5, self.tableWidth-20, 1))
            departView.backgroundColor = UIColor.grayColor()
            holdView.addSubview(departView)
            
            var tempView2 = self.setReplyItem(askModelList[2])
            tempView2.frame = CGRectMake(10, departView.frame.height+departView.frame.origin.y+5, tempView2.frame.width, tempView2.frame.height)
            holdView.addSubview(tempView2)
            
            replyBtn2 = UIButton(frame: CGRectMake(0, tempView2.frame.height+tempView2.frame.origin.y, self.tableWidth, 30))
            replyBtn2!.backgroundColor = UIColor.grayColor()
            replyBtn2!.setTitle("查看全部回复", forState: UIControlState.Normal)
            println("回复的y:\(replyBtn2!.frame.origin.y)")
            holdView.addSubview(replyBtn2!)
        }
        holdView.backgroundColor=UIColor.whiteColor()
        self.backgroundColor=UIColor.grayColor()
        self.addSubview(holdView)
    }
    
    func configItem0Base(model:Model.QASK){
        var content:NSString = model.Content
        var contentSize:CGSize = content.textSizeWithFont(lblContent.font, constrainedToSize: CGSizeMake(self.frame.width-20,  CGFloat(MAXFLOAT)))
        self.frame = CGRectMake(0, 0, self.tableWidth, contentSize.height+91) //整个Cell的高度
        println("content is:\(content)")
        println("xbshuo content height:\(contentSize.height)")
        lblTitile.frame = CGRectMake(80, 10, self.frame.width - 90, 40)
        lblTime.frame  = CGRectMake(80, 50, lblTitile.frame.width, 20)
        hrView.frame = CGRectMake(10, userIcon.frame.height + userIcon.frame.origin.y+10, self.frame.width - 20, 1)
        lblContent.frame = CGRectMake(10, userIcon.frame.height + userIcon.frame.origin.y+21, self.frame.width-20, contentSize.height)
        
        heartBtn.frame = CGRectMake(self.frame.width - 122, lblContent.frame.height+lblContent.frame.origin.y+10, 30, 30)
        goodTimes.frame = CGRectMake(self.frame.width-84, lblContent.frame.height+lblContent.frame.origin.y+10, 30, 30)
        replyBtn.frame = CGRectMake(self.frame.width - (8*2+30), lblContent.frame.height+lblContent.frame.origin.y+10, 30, 30)
        replyBtn.image = UIImage(named: "reply.png")
        heartBtn.image = UIImage(named: "praise_nwwd.png")
        
        var zanGesture = UITapGestureRecognizer(target: self, action: Selector("goodAction"))
        self.heartBtn.userInteractionEnabled=true
        self.heartBtn.addGestureRecognizer(zanGesture)
        self.goodTimes.text = model.AuditID == 0 ? "" : String(model.AuditID)
        
        //heartBtn.titleLabel?.font = UIFont(descriptor: UIFontDescriptor(), size: 25)
        hrView.backgroundColor = UIColor(red: 222/255, green: 222/255, blue: 222/255, alpha: 0.5)
        lblContent.numberOfLines = 0
        
        lblTitile.text = model.NickName
        lblTime.text = model.AddTmie
        lblContent.text = model.Content
        
        lblTime.font=UIFont(name: "ArialUnicodeMS", size: 14)
        lblTime.textColor=UIColor.lightGrayColor()
        
        var imgURL = NSURL(string: model.iconFace)
        PLMImageCache.sharedInstance.imageForUrl(imgURL!, desiredImageSize: CGSizeMake(133, 133), contentMode: UIViewContentMode.Center) { (image) -> Void in
            //use image
            self.userIcon.image = image
            self.userIcon.contentMode = UIViewContentMode.ScaleToFill
        }
        
        holdView.addSubview(userIcon)
        holdView.addSubview(lblTitile)
        holdView.addSubview(lblTime)
        holdView.addSubview(hrView)
        holdView.addSubview(lblContent)
        holdView.addSubview(heartBtn)
        holdView.addSubview(replyBtn)
        holdView.addSubview(goodTimes)
        
        
    }
    
    func configItem0(model:Model.QASK){
        configItem0Base(model)
        
        var departView = UIView(frame: CGRectMake(10, heartBtn.frame.height+heartBtn.frame.origin.y+5, self.tableWidth-20, 1))
        departView.backgroundColor = UIColor.grayColor()
        holdView.addSubview(departView)
        
        holdView.backgroundColor=UIColor.whiteColor()
        self.backgroundColor=UIColor.grayColor()
        self.addSubview(holdView)
    }
    
    func configItem(model:Model.QASK){
        var tempView = self.setReplyItem(model)
        tempView.frame = CGRectMake(10, 5, tempView.frame.width, tempView.frame.height+11)
        var hrViewY:CGFloat = tempView.frame.height > 80 ? tempView.frame.height : 80
        itemHrView.frame=CGRectMake(10, hrViewY-6, screenWidth-20, 1)
        itemHrView.backgroundColor=UIColor.lightGrayColor()
        holdView.addSubview(tempView)
        holdView.addSubview(itemHrView)
        self.addSubview(holdView)
    }
    
    override func layoutSubviews() {
        holdView.frame = CGRectMake(0, 0, self.frame.width, self.frame.height-5)
    }
    
    func goodAction() {
        println("good de id is:\(m!.QASKID)")
        var userDefault = NSUserDefaults.standardUserDefaults()
        var zanCollection:NSString? = userDefault.stringForKey("zanCollection")
        
        
        
        if !(zanCollection==nil){
            var str:String=","+String(m!.QASKID)+","
            var isContains=zanCollection!.containsString(str)
            if isContains {
                UIAlertView(title: "", message: "已赞", delegate: nil, cancelButtonTitle: "确定").show()
                
                return
            }
        }
        
        if !isZanIng {
            isZanIng=true
             API().exec(self, invokeIndex: 0, invokeType: "", methodName: "insertZanQASK", params: String(m!.QASKID),"0").loadData()
        }
       
        
    }
    func invoke(index:Int,StringResult result:String){
        isZanIng=false
        self.goodTimes.text=result
        //write to database
        var userDefault = NSUserDefaults.standardUserDefaults()
        var zanCollection:String? = userDefault.stringForKey("zanCollection")
        if zanCollection==nil{
            userDefault.setValue(","+String(m!.QASKID)+",", forKey: "zanCollection")
        }else{
            userDefault.setValue(zanCollection!+String(m!.QASKID)+",", forKey: "zanCollection")
        }
        
    }
    //type:方法的标识（一个页面可能有多个方法回调，以此参数作为标识区分） object:返回的数据
    func invoke(type:String,object:NSObject){
        
    }
    
    func setReplyItem(model:Model.QASK) -> UIView{
        var tempView:UIView = UIView()
        var uIcon:UIImageView = UIImageView(frame: CGRectMake(10, 10, 60, 60))
        var who:UILabel = UILabel(frame: CGRectMake(80, 10, self.frame.width - 90, 20))
        
        var content:NSString = model.Content
        var contentSize:CGSize = content.textSizeWithFont(lblContent.font, constrainedToSize: CGSizeMake(self.frame.width-90,  CGFloat(MAXFLOAT)))
        var replyContent = UILabel(frame: CGRectMake(80, who.frame.height + who.frame.origin.y+10, self.frame.width-90, contentSize.height))
        tempView.frame = CGRectMake(0, 0, tableWidth, replyContent.frame.height+replyContent.frame.origin.y+10)
        
        var tempString:NSString = model.iconFace
        if tempString.containsString("http") || tempString.containsString("https") {
            var imgURL = NSURL(string: model.iconFace)
            PLMImageCache.sharedInstance.imageForUrl(imgURL!, desiredImageSize: CGSizeMake(133, 133), contentMode: UIViewContentMode.Center) { (image) -> Void in
                //use image
                uIcon.image = image
                uIcon.contentMode = UIViewContentMode.ScaleToFill
            }
        }
        
        who.text = model.NickName
        replyContent.text = model.Content
        replyContent.numberOfLines  = 0
        
        tempView.addSubview(uIcon)
        tempView.addSubview(who)
        tempView.addSubview(replyContent)
        return tempView
    }
    
}
