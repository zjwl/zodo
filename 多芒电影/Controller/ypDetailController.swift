//
//  ypDetailController.swift
//  多芒电影
//
//  Created by junjian chen on 15/3/13.
//  Copyright (c) 2015年 珠影网络. All rights reserved.
//

import Foundation

class ypDetailController: UIViewController,UIWebViewDelegate,DataDelegate {
    var colors:Array<UIColor> = []
    
    var currentInfo:Model.BasicInfo=Model.BasicInfo()
    
    @IBOutlet weak var bg: UIView!
    @IBOutlet weak var mainContrainer: UIScrollView!
    
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var webView: UIWebView!
    
    var mainScrollConstraintH:[AnyObject]?
    var webviewConstraintH:[AnyObject]?
    var isZanIng=false,isCollecting=false
    var tempContent:String=""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        colors.append(UIColor(red: 51/255, green: 170/255, blue: 138/255, alpha: 1))
        colors.append(UIColor(red: 72/255, green: 147/255, blue: 205/255, alpha: 1))
        colors.append(UIColor(red: 237/255, green: 126/255, blue: 1107/255, alpha: 1))
        colors.append(UIColor(red: 230/255, green: 171/255, blue: 41/255, alpha: 1))
        colors.append(UIColor(red: 161/255, green: 88/255, blue: 205/255, alpha: 1))
        colors.append(UIColor(red: 116/255, green: 170/255, blue: 24/255, alpha: 1))
        colors.append(UIColor(red: 126/255, green: 114/255, blue: 100/255, alpha: 1))
        colors.append(UIColor(red: 246/255, green: 89/255, blue: 58/255, alpha: 1))
        
        initConstraint()
        
        webView.backgroundColor = UIColor.blueColor()
        var colorIndex = random() % colors.count
        bg.backgroundColor = colors[colorIndex]
        movieTitle.text = currentInfo.Title
        
        
        webView.scrollView.scrollEnabled = false
        tempContent = currentInfo.Content.stringByReplacingOccurrencesOfString("\"/ueditor", withString: "\"http://apk.zdomo.com/ueditor", options: NSStringCompareOptions.LiteralSearch, range: nil)
        webView.delegate = self
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
        mainContrainer.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[bg(screenWidth)]-0-|", options: nil, metrics: ["screenWidth":screenWidth], views: ["bg":bg]))
        mainContrainer.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[webView(screenWidth)]-0-|", options: nil, metrics: ["screenWidth":screenWidth], views: ["webView":webView]))
        mainContrainer.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[bg(120)]", options: nil, metrics: nil, views: ["bg":bg]))
        
        
        //动态约束
        mainScrollConstraintH=NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[mainContrainer(==rootview)]-0-|", options: nil, metrics: nil, views: ["mainContrainer":mainContrainer,"rootview":self.view])
        self.view.addConstraints(mainScrollConstraintH!)
        webviewConstraintH=NSLayoutConstraint.constraintsWithVisualFormat("V:|-120-[webView(1000)]-0-|", options: nil, metrics: nil, views: ["bg":bg,"webView":webView])
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
        
        
        var metrics:Dictionary = ["webViewH":webView.scrollView.contentSize.height];
        webviewConstraintH=NSLayoutConstraint.constraintsWithVisualFormat("V:|-120-[webView(webViewH)]-70-|", options: nil, metrics: metrics, views: ["webView":webView])
        mainContrainer.addConstraints(webviewConstraintH!)
        
        
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
        var publishContent = ShareSDK.content(currentInfo.Title, defaultContent: currentInfo.Introduction, image:ShareSDK.imageWithUrl(currentInfo.PicURL), title: currentInfo.Title, url:"http://apk.zdomo.com/frontpage/?id=\(currentInfo.InfoID)", description: currentInfo.Content, mediaType: SSPublishContentMediaTypeNews)
        
        
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
    
    }
    func invoke(type:String,object:NSObject){
    
    }
}