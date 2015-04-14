//
//  LoadWebViewController.swift
//  多芒电影
//
//  Created by 柴小红 on 15/4/2.
//  Copyright (c) 2015年 珠影网络. All rights reserved.
//

import UIKit

class LoadWebViewController: UIViewController,UIWebViewDelegate {

    
// @IBOutlet weak var uiWebView: UIWebView!
    var webAddress  = ""
    var titleText   = ""
    var activityIndicator : UIActivityIndicatorView!
    var uiWebView:UIWebView!
    var shouldRound = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
       
        self.navigationItem.title = titleText
        uiWebView = UIWebView(frame: CGRect(x: 0.0,y: 0,width: self.view.bounds.width,height: self.view.bounds.height))
        uiWebView.delegate = self
        uiWebView.opaque = false
        uiWebView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(uiWebView)
        // Do any additional setup after loading the view.
        
        //创建UIActivityIndicatorView背底半透明View
        var view1 = UIView(frame: UIScreen.mainScreen().bounds)
        view1.tag = 103
        self.view.addSubview(view1)
        
        if webAddress != "" {
            
            var baseURL:NSURL
            if webAddress.length() == 7 {
                var filepath = NSBundle.mainBundle().pathForResource(webAddress, ofType: "html")
                var htmlstring = NSString(contentsOfFile: filepath!, encoding: NSUTF8StringEncoding, error: nil)
                var url = NSURL(fileURLWithPath: filepath!)
                var request  = NSURLRequest(URL: url!)
                var path = NSBundle.mainBundle().bundlePath
                var baseURL = NSURL.fileURLWithPath(path)
                uiWebView.loadHTMLString(htmlstring?.stringByAppendingString(""), baseURL:baseURL)
            } else {
                baseURL  = NSURL(string: webAddress)!
                uiWebView.loadRequest(NSURLRequest(URL: baseURL))
                view1.backgroundColor = UIColor.grayColor()
                view1.alpha = 0.8
            }

        }

   
        
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0,y: 0,width: 32,height: 32))
        activityIndicator.center = view.center
        activityIndicator.activityIndicatorViewStyle =  UIActivityIndicatorViewStyle.White
        view.addSubview(activityIndicator)

        
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
    
    
 
    
    
    
    func webViewDidStartLoad(webView: UIWebView) {
         activityIndicator.startAnimating()
    }
    
    
    func webViewDidFinishLoad(webView:UIWebView){

        activityIndicator.stopAnimating()
        var view = self.view.viewWithTag(103)
        view?.removeFromSuperview()
    }
    
    
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        var errorString = "<html><center><font size=+5 color='red' >页面加载出错了<br/>\(error.localizedDescription)</center></html>"
        uiWebView.loadHTMLString(errorString, baseURL: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
