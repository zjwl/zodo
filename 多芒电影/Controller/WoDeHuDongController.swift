//
//  WoDeHuDongController.swift
//  多芒电影
//
//  Created by junjian chen on 15/4/2.
//  Copyright (c) 2015年 珠影网络. All rights reserved.
//

import UIKit
import WebKit

class WoDeHuDongController: UIViewController, WKScriptMessageHandler,QaskCallbackDataDelegate,DataDelegate  {
    var appWebView:WKWebView?
    var tempreplyQasid:Int=0,source=1
    var iszaning=false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let (theWebView,errorOptional) = buildSwiftly(self,"http://apk.zdomo.com/ios/wodehudong.html?senderid=\(user.MemberID)" ,["js","css","html","png","jpg","gif"])
        if let errorDescription = errorOptional?.description{
            print(errorDescription)
        }
        else{
            appWebView = theWebView
            appWebView?.frame=CGRectMake(0, 0, screenWidth, screenHeight)
        }
    }
    
    func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage){
        var sentData = message.body as! NSDictionary
        tempreplyQasid = Int(sentData["id"] as! NSNumber)
        
        var method:NSString = sentData["m"] as! NSString
        
        if(method=="reply"){
            goWenWenPageFromXbs()
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
                    print("returned value: \(errorDescription)")
                }
                else if JSReturnValue != nil{
                    print("returned value: \(JSReturnValue!)")
                }
                else{
                    print("no return from JS")
                }
            }
            
            API().exec(self, invokeIndex: 0, invokeType: "", methodName: "insertZanQASK", params: String(tempreplyQasid),"0").loadData()
            
            
            
        }
        
        
    }
    
    func setCallbackContent(content:String){
        //http://ww1.sinaimg.cn/crop.160.347.338.338.1024/86961b4ejw8esta6jwx79j20ia0wigm1.jpg
        print("the return content is:\(content)")
        var timeFormat = NSDateFormatter()
        timeFormat.dateFormat = "yyyy-MM-dd HH:mm"
        var nowtime = timeFormat.stringFromDate(NSDate())
        
        
        appWebView!.evaluateJavaScript("updateItem({QASKID:\(tempreplyQasid),Content:'\(content)',iconFace:'\(user.HeadPhotoURL)',NickName:'\(user.NickName)',AddTmie:'\(nowtime)',AuditID:0})"){(JSReturnValue:AnyObject?, error:NSError?) in
            if let errorDescription = error?.description{
                print("returned value: \(errorDescription)")
            }
            else if JSReturnValue != nil{
                print("returned value: \(JSReturnValue!)")
            }
            else{
                print("no return from JS")
            }
        }
    }
    func goQaskDetail(){
        self.performSegueWithIdentifier("wodehudong2detail", sender: self)
    }
    
    func invoke(index:Int,StringResult result:String){
        var userDefault = NSUserDefaults.standardUserDefaults()
        var zanCollection:String? = userDefault.stringForKey("zanCollection")
        if zanCollection==nil{
            userDefault.setValue(","+String(tempreplyQasid)+",", forKey: "zanCollection")
        }else{
            userDefault.setValue(zanCollection!+String(tempreplyQasid)+",", forKey: "zanCollection")
        }
        iszaning=false
    }
    func invoke(type:String,object:NSObject){
    }
    
    func goWenWenPageFromXbs(){
        
        if  user.IsLogin  {
            self.performSegueWithIdentifier("wodehudong2reply", sender: self)
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier=="wodehudong2detail" {
            var theSegue = segue.destinationViewController as! QaskDetailController
            theSegue.tempreplyQasid = tempreplyQasid
        }else{
            var theSegue = segue.destinationViewController as! WenWenViewController
            var dele = UIApplication.sharedApplication().delegate as! AppDelegate
            var user=dele.user
            if user != nil {
                theSegue.uid = Int(user!.MemberID)
            }
            theSegue.delete=self
            theSegue.qid = tempreplyQasid
            theSegue.sourceid=tempreplyQasid
        }
    }
    func doLoginActions(action:UIAlertAction!){
        print("lgoin")
        self.tabBarController!.selectedIndex=2
        
    }
    func doCancelAction(action:UIAlertAction!){
        print("cancel")
    }
    
    
}