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
    
    @IBOutlet weak var collect_0: UIButton!
    @IBOutlet weak var goodTimsLbl: UILabel!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var webView: UIWebView!
    
    var mainScrollConstraintH:[AnyObject]?
    var webviewConstraintH:[AnyObject]?
    var isZanIng=false,isCollecting=false
    var tempContent:String=""
    var activityIndicator : UIActivityIndicatorView!
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
        
        
        //判断是否已赞，及设置赞次数
        if isBasicInfoZaned(currentInfo.InfoID) {
            goodTimsLbl.text = String(currentInfo.GoodTimes+1)
        }else if currentInfo.GoodTimes>0{
            goodTimsLbl.text = String(currentInfo.GoodTimes)
        }
        
        //判断是否已收藏，及设置收藏 icon
        if isBasicInfoCollected(currentInfo.InfoID) {
            collect_0.setImage(UIImage(named: "collection_white_1.png"), forState: UIControlState.Normal)
        }
        
        webView.scrollView.scrollEnabled = false
        tempContent = currentInfo.Content.stringByReplacingOccurrencesOfString("\"/ueditor", withString: "\"http://apk.zdomo.com/ueditor", options: NSStringCompareOptions.LiteralSearch, range: nil)
        webView.delegate = self
        
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0,y: 0,width: 32,height: 32))
        activityIndicator.center = view.center
        activityIndicator.activityIndicatorViewStyle =  UIActivityIndicatorViewStyle.Gray
        view.addSubview(activityIndicator)
        
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
        
        var version = (UIDevice.currentDevice().systemVersion as NSString).floatValue
        if version < 8.0 {
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "videoStarted:", name: "UIMoviePlayerControllerDidEnterFullscreenNotification", object: nil) //播放器即将播放通知
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "videoFinished:",name: "UIMoviePlayerControllerWillExitFullscreenNotification", object: nil) //播放器即将退出通知
        }else {
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "videoStarted:", name: "UIWindowDidBecomeVisibleNotification", object: nil) //播放器即将播放通知
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "videoFinished:",name: "UIWindowDidBecomeHiddenNotification", object: nil) //播放器即将退出通知
        }
        
    }
    
    
    
    
    //pragma mark 调用视频的通知方法
    func videoStarted(notification:NSNotification) {
        var  appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.isFull = true
    }
    
    
    func videoFinished(notification:NSNotification) { //完成播放
        var  appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.isFull = false
        
        
        UIDevice.currentDevice().setValue(NSNumber(integer: UIInterfaceOrientation.Portrait.rawValue),  forKey:"orientation")
        
        
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
    func webViewDidStartLoad(webView: UIWebView) {
        activityIndicator.startAnimating()
    }
    
    func webViewDidFinishLoad(webView: UIWebView){
        activityIndicator.stopAnimating()
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
        var dele = UIApplication.sharedApplication().delegate as! AppDelegate
        var user=dele.user
        if user != nil {
            if !isCollecting {
                isCollecting=true
                if isBasicInfoCollected(currentInfo.InfoID) {
                    API().exec(self, invokeIndex: 2, invokeType: "", methodName: "DeleteCollection", params: String(currentInfo.InfoID),user!.MemberID).loadData()
                }else{
                    API().exec(self, invokeIndex: 1, invokeType: "", methodName: "InsertCollection", params: String(currentInfo.InfoID),user!.MemberID).loadData()
                }
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
        basicShareFunc(currentInfo)

    }
    
    @IBAction func goodFunc(sender: AnyObject) {
        println("good")
        
        if isBasicInfoZaned(currentInfo.InfoID) {
            UIAlertView(title: "", message: "已赞", delegate: nil, cancelButtonTitle: "确定").show()
            return
        }
        
        if !isZanIng {
            isZanIng=true
            API().exec(self, invokeIndex: 0, invokeType: "", methodName: "insertZanInfo", params: String(currentInfo.InfoID),"0").loadData()
        }
    }
    
    func invoke(index:Int,StringResult result:String){
        if index==0 {
            goodTimsLbl.text = String(currentInfo.GoodTimes+1)
           saveBasicZanInfoToLocal(currentInfo.InfoID)
        }else if index==1 {
            println("collect result is:\(result)")
            isCollecting = false
            collect_0.setImage(UIImage(named: "collection_white_1.png"), forState: UIControlState.Normal)
            saveBasicCollectionInfoToLocal(currentInfo.InfoID)
        } else if index==2 {
            //取消收藏
            isCollecting = false
            collect_0.setImage(UIImage(named: "collection_white_0.png"), forState: UIControlState.Normal)
            deleteBasicCollectionInfoToLocal(currentInfo.InfoID)
        }
    }
    func invoke(type:String,object:NSObject){
    
    }
}