//
//  daJiaShuoCellCode.swift
//  多芒电影
//
//  Created by junjian chen on 15/2/27.
//  Copyright (c) 2015年 珠影网络. All rights reserved.
//

class daJiaShuoCellCode: UITableViewCell,DataDelegate {
   
    @IBOutlet var title: UILabel!
    @IBOutlet var time: UILabel!
    @IBOutlet var userIcon: UIImageView!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var goodTimes: UILabel!
    @IBOutlet weak var replyIcon: UIImageView!
    @IBOutlet weak var heartIcon: UIImageView!
    
    var uid:Int=0
    var m:Model.QASK?
    var isZanIng=false
    
    func configureCell(model: Model.QASK,uid:Int) {
        m=model
        
        //第一层Cell
        title.text = model.NickName
        time.text = model.AddTmie
        content.text = model.Content
        self.uid = uid
        var imgURL = NSURL(string: model.iconFace)
        PLMImageCache.sharedInstance.imageForUrl(imgURL!, desiredImageSize: CGSizeMake(133, 133), contentMode: UIViewContentMode.Center) { (image) -> Void in
            //use image
            self.userIcon.image = image
            self.userIcon.contentMode = UIViewContentMode.ScaleToFill
        }
        
        self.preservesSuperviewLayoutMargins=false
        
        var zanGesture = UITapGestureRecognizer(target: self, action: Selector("goodAction"))
        self.heartIcon.userInteractionEnabled=true
        self.heartIcon.addGestureRecognizer(zanGesture)
        self.goodTimes.text = model.AuditID == 0 ? "" : String(model.AuditID)
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
    
}
