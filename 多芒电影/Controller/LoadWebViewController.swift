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
        self.view.addSubview(uiWebView)
        // Do any additional setup after loading the view.
        
        //创建UIActivityIndicatorView背底半透明View
        var view = UIView(frame: UIScreen.mainScreen().bounds)
        view.tag = 103
        self.view.addSubview(view)
        
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
                self.view.backgroundColor = UIColor.whiteColor()
            } else {
                baseURL  = NSURL(string: webAddress)!
                uiWebView.loadRequest(NSURLRequest(URL: baseURL))
                view.backgroundColor = UIColor.grayColor()
                view.alpha = 0.8
            }

        }

   
        
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0,y: 0,width: 32,height: 32))
        activityIndicator.center = view.center
        activityIndicator.activityIndicatorViewStyle =  UIActivityIndicatorViewStyle.White
        view.addSubview(activityIndicator)

    }
    
    override func supportedInterfaceOrientations() -> Int {
        return UIInterfaceOrientationMask.Portrait.rawValue.hashValue | UIInterfaceOrientationMask.PortraitUpsideDown.rawValue.hashValue
    }
    

    
    override func shouldAutorotate() -> Bool {
        
        println(shouldRound)
        return shouldRound
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
