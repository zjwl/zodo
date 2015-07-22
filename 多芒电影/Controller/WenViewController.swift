//
//  WenViewController.swift
//  多芒电影
//
//  Created by 柴小红 on 15/2/13.
//  Copyright (c) 2015年 珠影网络. All rights reserved.
//

import UIKit
import WebKit

class WenViewController: UIViewController, WKScriptMessageHandler,QaskCallbackDataDelegate,DataDelegate  {
    var appWebView:WKWebView?
    var tempreplyQasid:Int=0
    var iszaning=false
    var source:Int=0 //0:大家说    1：小编说
    @IBOutlet weak var title_segment: UISegmentedControl!
    
    @IBOutlet weak var askView: UIView!
    @IBOutlet weak var webviewHolder: UIView!
    
    @IBOutlet weak var wenwenLbl: UILabel!
    
    var toQid:Int=0,sourceID:Int=1,toViewQid=0,dajiashuoPageIndex=0,xbShuoPageIndex=0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets=false
        title_segment.addTarget(self, action:"segmentAction:", forControlEvents: UIControlEvents.ValueChanged)
        var gesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("doAsk"))
        askView.userInteractionEnabled=true
        askView.addGestureRecognizer(gesture)
        
        
        let (theWebView,errorOptional) = buildSwiftly(self,"http://apk.zdomo.com/ios/dajiashuo.html?id=\(tempreplyQasid)&senderid=\(user.MemberID)" ,["js","css","html","png","jpg","gif"])
        if let errorDescription = errorOptional?.description{
            println(errorDescription)
        }
        else{
            appWebView = theWebView
        }
    }
    
    func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage){
        var sentData = message.body as! NSDictionary
        tempreplyQasid = Int(sentData["id"] as! NSNumber)
        source = Int(sentData["s"] as! NSNumber)
        var method:NSString = sentData["m"] as! NSString
        
        if(method=="reply"){
            if(source==0){
                goWenWenPageFromDjs()
            }
            if(source==1){
                goWenWenPageFromXbs()
            }
        }
        if(method=="lookall"){
            goQaskDetail()
        }
        
        if(method=="addzan"){
            if iszaning {return}
            iszaning=true
            var userDefault = NSUserDefaults.standardUserDefaults()
            var zanCollection:NSString? = userDefault.stringForKey("zanCollection")
            
            
            
            if !(zanCollection==nil){
                var str:String=","+String(tempreplyQasid)+","
                var isContains=zanCollection!.containsString(str)
                if isContains {
                    iszaning=false
                    //UIAlertView(title: "", message: "已赞", delegate: nil, cancelButtonTitle: "确定").show()
                    return
                }
            }
            
            //the last parameter of evaluateJavaScript is a closure that is called after the JavaScript is run.
            //If there is a value returned from the JavaScript it is passed to the closure as its first parameter.
            //If there is an error calling the JavaScript, that error is passed as the second parameter.
            appWebView!.evaluateJavaScript("updateCount({id:\(tempreplyQasid)})"){(JSReturnValue:AnyObject?, error:NSError?) in
                if let errorDescription = error?.description{
                    println("returned value: \(errorDescription)")
                }
                else if JSReturnValue != nil{
                    println("returned value: \(JSReturnValue!)")
                }
                else{
                    println("no return from JS")
                }
            }
            
            API().exec(self, invokeIndex: 0, invokeType: "", methodName: "insertZanQASK", params: String(tempreplyQasid),"0").loadData()
            
            
            
        }
        
        
    }
    
    func setCallbackContent(content:String){
        //http://ww1.sinaimg.cn/crop.160.347.338.338.1024/86961b4ejw8esta6jwx79j20ia0wigm1.jpg
        println("the return content is:\(content)")
        var timeFormat = NSDateFormatter()
        timeFormat.dateFormat = "yyyy-MM-dd HH:mm"
        var nowtime = timeFormat.stringFromDate(NSDate())
        
        
        appWebView!.evaluateJavaScript("updateItem({QASKID:\(tempreplyQasid),Content:'\(content)',iconFace:'\(user.HeadPhotoURL)',NickName:'\(user.NickName)',AddTmie:'\(nowtime)',AuditID:0})"){(JSReturnValue:AnyObject?, error:NSError?) in
            if let errorDescription = error?.description{
                println("returned value: \(errorDescription)")
            }
            else if JSReturnValue != nil{
                println("returned value: \(JSReturnValue!)")
            }
            else{
                println("no return from JS")
            }
        }
    }
    
    func goWenWenPageFromDjs(){
        println("comein")
       
        if  user.IsLogin {
            toQid=tempreplyQasid
            self.sourceID=1
            self.performSegueWithIdentifier("wenwen", sender: self)
        }else{
            showAlert()
        }
    }
    
    func goWenWenPageFromXbs(){
      
        if   user.IsLogin  {
            toQid=tempreplyQasid
            self.sourceID=toQid
            self.performSegueWithIdentifier("wenwen", sender: self)
        }else{
            showAlert()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    func goQaskDetail(){
        toViewQid=tempreplyQasid
        self.performSegueWithIdentifier("QaskDetail", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier=="QaskDetail" {
            var theSegue = segue.destinationViewController as! QaskDetailController
            theSegue.tempreplyQasid = toViewQid
        }else{
            var theSegue = segue.destinationViewController as! WenWenViewController
            var dele = UIApplication.sharedApplication().delegate as! AppDelegate
            var user=dele.user
            if user != nil {
                theSegue.uid = user!.MemberID.toInt()
            }
            theSegue.qid = toQid
            theSegue.sourceid=self.sourceID
            theSegue.delete=self
        }
    }
    
    func doAsk(){
        if title_segment.selectedSegmentIndex == 1 {
            self.sourceID=0
        }
        else{
            self.sourceID=1
        }
      
        if   user.IsLogin  {
            self.toQid=0
            self.performSegueWithIdentifier("wenwen", sender: self)
        }else{
            showAlert()
        }
        
    }
    func showAlert(message:String="需要登录才能发表"){
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
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func segmentAction(sender:NSObject){
        println("index is:\(title_segment.selectedSegmentIndex)")
        dajiashuoPageIndex=0
        xbShuoPageIndex=0
        println("memberid issss:\(user.MemberID)")
        if title_segment.selectedSegmentIndex == 1 {
            wenwenLbl.text="问问小编"
            appWebView?.loadRequest(NSURLRequest(URL: NSURL(string: "http://apk.zdomo.com/ios/xbshuo.html?senderid=\(user.MemberID)")!))
            
        } else {
            wenwenLbl.text="我要提问"
            appWebView?.loadRequest(NSURLRequest(URL: NSURL(string: "http://apk.zdomo.com/ios/dajiashuo.html?id=\(tempreplyQasid)&senderid=\(user.MemberID)")!))
        }
        
    }
    
    
    func invoke(index:Int,StringResult result:String){
        //write to database
        var userDefault = NSUserDefaults.standardUserDefaults()
        var zanCollection:String? = userDefault.stringForKey("zanCollection")
        if zanCollection==nil{
            userDefault.setValue(","+String(tempreplyQasid)+",", forKey: "zanCollection")
        }else{
            userDefault.setValue(zanCollection!+String(tempreplyQasid)+",", forKey: "zanCollection")
        }
        iszaning=false
    }
    //type:方法的标识（一个页面可能有多个方法回调，以此参数作为标识区分） object:返回的数据
    func invoke(type:String,object:NSObject){
        
        
    }
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
