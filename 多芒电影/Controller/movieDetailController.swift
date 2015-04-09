//
//  movieDetailController.swift
//  多芒电影
//
//  Created by junjian chen on 15/3/13.
//  Copyright (c) 2015年 珠影网络. All rights reserved.
//

import Foundation

class movieDetailController: CommonViewController,UIWebViewDelegate,DataDelegate {
    
    
    @IBOutlet weak var mainContrainer: UIScrollView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var movieImageView: UIImageView!
    
    @IBOutlet weak var blurViewContainer: UIView!
    @IBOutlet weak var bgImg: UIImageView!
    @IBOutlet weak var descView: UIView!
    @IBOutlet weak var descTitleLbl: UILabel!
    var descHeight:CGFloat=0
    var isZanIng:Bool=false,isCollecting=false
    
    @IBOutlet weak var webView: UIWebView!
    
    var currentInfo:Model.BasicInfo=Model.BasicInfo()
    
    var mainScrollConstraintH:[AnyObject]?
    var webviewConstraintH:[AnyObject]?
    var tempContent:String=""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        webView.backgroundColor = UIColor.blueColor()
        
        
        titleLbl.text = currentInfo.Title
        typeLbl.text = "类型："+currentInfo.LabelIDS
        descTitleLbl.text = currentInfo.Introduction
        var content:NSString = descTitleLbl.text!
        descHeight = content.textSizeWithFont(descTitleLbl.font, constrainedToSize: CGSizeMake(descTitleLbl.frame.width,  CGFloat(MAXFLOAT))).height+58
        println("descHeight is :\(descHeight)")
        initConstraint()
        
        webView.scrollView.scrollEnabled = false
        tempContent = currentInfo.Content.stringByReplacingOccurrencesOfString("\"/ueditor", withString: "\"http://apk.zdomo.com/ueditor", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        
        
        //movieImageView.image=
        movieImageView.layer.masksToBounds = true
        movieImageView.layer.cornerRadius = movieImageView.bounds.size.height / 2
        movieImageView.layer.backgroundColor = UIColor.whiteColor().CGColor
        if currentInfo.PicURL.length()>0 && ((currentInfo.PicURL as NSString).containsString("http")){
            var imgURL = NSURL(string: currentInfo.PicURL)
            PLMImageCache.sharedInstance.imageForUrl(imgURL!, desiredImageSize: CGSizeMake(133, 133), contentMode: UIViewContentMode.Center) { (image) -> Void in
                //use image
                self.movieImageView.image = image
                self.movieImageView.contentMode = UIViewContentMode.ScaleToFill
                
                
                self.bgImg.contentMode=UIViewContentMode.ScaleAspectFill
                self.bgImg.clipsToBounds=true
                self.bgImg.image = image
                
                var blurView = BlurBackground()
                
                //blurView.setUpCell(frame: self.headerView.frame, blurStyle: UIBlurEffectStyle.Light)
                blurView.setUpCellWithVibrancy(frame: self.headerView.frame,blurStyle: UIBlurEffectStyle.Light)
                
                self.blurViewContainer.addSubview(blurView)
                
            }
        }
        
       API().exec(self, invokeIndex: 10, invokeType: "qList", methodName: "ReadInfo", params: "\(currentInfo.InfoID)","0").loadData()

    }
    
    override func viewWillAppear(animated: Bool) {
        var styleString=""
        var config = NSUserDefaults.standardUserDefaults()
        var fontSize = config.integerForKey("fontSize")
        switch fontSize {
        case -1 :
            styleString="<style>p{font-size:12px;}img{width:100%;}</style>"
        case 1:
            styleString="<style>p{font-size:14px;}img{width:100%;}</style>"
        case 2:
            styleString="<style>p{font-size:16px;}img{width:100%;}</style>"
        default:
            styleString="<style>p{font-size:14px;}img{width:100%;}</style>"
        }
        
        webView.loadHTMLString(styleString+tempContent, baseURL: NSURL(fileURLWithPath: "http://apk.zdomo.com"))
        
        webView.delegate = self
    }
    
    func initConstraint(){
        self.view.frame=CGRectMake(0, 0, screenWidth, 1500)
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[mainContrainer(==rootview)]-0-|", options: nil, metrics: nil, views: ["mainContrainer":mainContrainer,"rootview":self.view]))
        mainContrainer.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[bg(screenWidth)]-0-|", options: nil, metrics: ["screenWidth":screenWidth], views: ["bg":headerView]))
        mainContrainer.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[descView(screenWidth)]-0-|", options: nil, metrics: ["screenWidth":screenWidth], views: ["descView":descView]))
        mainContrainer.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[webView(screenWidth)]-0-|", options: nil, metrics: ["screenWidth":screenWidth], views: ["webView":webView]))
        mainContrainer.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[bg(120)]", options: nil, metrics: nil, views: ["bg":headerView]))
        mainContrainer.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-120-[descView(descHeight)]", options: nil, metrics: ["descHeight":descHeight], views: ["descView":descView]))
        
        //动态约束
        mainScrollConstraintH=NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[mainContrainer(==rootview)]-0-|", options: nil, metrics: nil, views: ["mainContrainer":mainContrainer,"rootview":self.view])
        self.view.addConstraints(mainScrollConstraintH!)
        webviewConstraintH=NSLayoutConstraint.constraintsWithVisualFormat("V:|-descHeight-[webView(1000)]-0-|", options: nil, metrics: ["descHeight":descHeight+120], views: ["webView":webView])
        mainContrainer.addConstraints(webviewConstraintH!)
        
        
        
    }
    
    func webViewDidFinishLoad(webView: UIWebView){
        mainContrainer.removeConstraints(webviewConstraintH!)
        
        var frame = webView.frame;
        frame.size.height = 1;
        webView.frame = frame;
        var fittingSize = webView.sizeThatFits(CGSizeZero)
        frame.size = fittingSize;
        webView.frame = frame;
        
        
        println("webView.scrollView.contentSize.height:\(webView.scrollView.contentSize.height)")
        var metrics:Dictionary = ["webViewH":webView.scrollView.contentSize.height,"descHeight":(descHeight+120)];
        webviewConstraintH=NSLayoutConstraint.constraintsWithVisualFormat("V:|-descHeight-[webView(webViewH)]-70-|", options: nil, metrics: metrics, views: ["webView":webView])
        mainContrainer.addConstraints(webviewConstraintH!)
        
    }
    @IBAction func playAction(sender: AnyObject) {
        
        var loadWebController = LoadWebViewController()
        var userDefaults = NSUserDefaults.standardUserDefaults()
        var obj:AnyObject? = userDefaults.objectForKey("myUser")
        if obj != nil {
            //var result = NSKeyedUnarchiver.unarchiveObjectWithData(obj) as? NSMutableArray
            var user:Model.LoginModel = NSKeyedUnarchiver.unarchiveObjectWithData(obj! as NSData) as Model.LoginModel
            if  user.MemberID != "" && user.MemberID != "0" {
                loadWebController.titleText = currentInfo.Title
                loadWebController.webAddress  =  currentInfo.LinkUrl
                API().exec(self, invokeIndex: 10, invokeType: "qList", methodName: "ReadInfo", params: "\(currentInfo.InfoID)",user.MemberID).loadData()
            }
        }

        self.navigationController?.pushViewController(loadWebController, animated: true)
    }
    
    
    
    @IBAction func collectionAction(sender: AnyObject) {
        var dele = UIApplication.sharedApplication().delegate as AppDelegate
        var user=dele.user
        if user != nil {
            if !isCollecting {
                isCollecting=true
                API().exec(self, invokeIndex: 1, invokeType: "", methodName: "InsertCollection", params: String(currentInfo.InfoID),user!.MemberID).loadData()
            }
        }else{
            showAlert()
        }
        
        
    }
    
    func showAlert(message:String="需要登录才能使用此功能"){
        var alertController:UIAlertController=UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        var loginAction = UIAlertAction(title: "去登录", style: UIAlertActionStyle.Destructive,handler:doLoginActions)
        var cancelAction = UIAlertAction(title: "先逛逛", style: UIAlertActionStyle.Destructive,handler:doCancelAction)
        alertController.addAction(loginAction)
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: true){
        }
    }
    
    func doLoginActions(action:UIAlertAction!){
        println("lgoin")
        self.tabBarController!.selectedIndex=2
        
    }
    func doCancelAction(action:UIAlertAction!){
        println("cancel")
    }
    
    @IBAction func shareFunc(sender: AnyObject) {
      
        //构造分享内容
        var publishContent = ShareSDK.content(currentInfo.Introduction, defaultContent: currentInfo.Introduction, image:ShareSDK.imageWithUrl(currentInfo.PicURL), title: currentInfo.Title, url:"http://apk.zdomo.com/frontpage/?id=\(currentInfo.InfoID)", description: currentInfo.Content, mediaType: SSPublishContentMediaTypeNews)
        
        
        ShareSDK.showShareActionSheet(nil, shareList: nil, content: publishContent, statusBarTips: true, authOptions: nil, shareOptions: nil, result: { (shareType:ShareType, state:SSResponseState, info:ISSPlatformShareInfo!, error:ICMErrorInfo!, Bool) -> Void in
            if state.value == SSResponseStateSuccess.value  {
                NSLog("分享成功");
            } else if state.value == SSPublishContentStateFail.value {
                NSLog("分享失败,错误码:%d,错误描述:%@",error.errorCode(),error.errorDescription())
            }})
    }
    
    @IBAction func goodFunc(sender: AnyObject) {
        println("good")
        var userDefault = NSUserDefaults.standardUserDefaults()
        var zanCollection:NSString? = userDefault.stringForKey("baseInfoZanCollection")
        
        
        
        if !(zanCollection==nil){
            var str:String=","+String(currentInfo.InfoID)+","
            var isContains=zanCollection!.containsString(str)
            if isContains {
                UIAlertView(title: "", message: "已赞", delegate: nil, cancelButtonTitle: "确定").show()
                
                return
            }
        }
        
        if !isZanIng {
            isZanIng=true
            API().exec(self, invokeIndex: 0, invokeType: "", methodName: "insertZanInfo", params: String(currentInfo.InfoID),"0").loadData()
        }
    }
    
    func invoke(index:Int,StringResult result:String){
        switch index{
        case 0:
            isZanIng=false
            //write to database
            var userDefault = NSUserDefaults.standardUserDefaults()
            var zanCollection:String? = userDefault.stringForKey("baseInfoZanCollection")
            if zanCollection==nil{
                userDefault.setValue(","+String(currentInfo.InfoID)+",", forKey: "baseInfoZanCollection")
            }else{
                userDefault.setValue(zanCollection!+String(currentInfo.InfoID)+",", forKey: "baseInfoZanCollection")
            }
            UIAlertView(title: "", message: "已赞", delegate: nil, cancelButtonTitle: "确定").show()
        case 1:
            println("collection action result is\(result)")
            isCollecting=false
            UIAlertView(title: "", message: "已收藏", delegate: nil, cancelButtonTitle: "确定").show()
        default:
            var t = 3
        }
    }
    func invoke(type:String,object:NSObject){
    
    }
    
}