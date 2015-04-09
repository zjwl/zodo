//
//  LoadWebViewController.swift
//  多芒电影
//
//  Created by 柴小红 on 15/4/2.
//  Copyright (c) 2015年 珠影网络. All rights reserved.
//

import UIKit

class LoadWebViewController: UIViewController {

    
// @IBOutlet weak var uiWebView: UIWebView!
    var webAddress  = ""
    var titleText   = ""
    var activityIndicator : UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        activityIndicator.center = self.view.center
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.White
        self.view.addSubview(activityIndicator)

        if webAddress != "" {
            self.navigationItem.title = titleText
            var uiWebView = UIWebView(frame: self.view.bounds)
            var baseURL:NSURL
            
            if webAddress.length() == 7 {
                var filepath = NSBundle.mainBundle().pathForResource(webAddress, ofType: "html")
                var htmlstring = NSString(contentsOfFile: filepath!, encoding: NSUTF8StringEncoding, error: nil)
                var url = NSURL(fileURLWithPath: filepath!)
                var request  = NSURLRequest(URL: url!)
                var path = NSBundle.mainBundle().bundlePath
                var baseURL = NSURL.fileURLWithPath(path)
                uiWebView.loadHTMLString(htmlstring, baseURL:baseURL)
            } else {
                baseURL  = NSURL(string: webAddress)!
                uiWebView.loadRequest(NSURLRequest(URL: baseURL))
            }
                       
            self.view.addSubview(uiWebView)
        }
        
        // Do any additional setup after loading the view.
    }
    

    func webViewDidStartLoad(webView:UIWebView){
        activityIndicator.startAnimating()
    }
    
    func webViewDidFinishLoad(webView:UIWebView){
        activityIndicator.stopAnimating()
        var view = self.view.viewWithTag(103)
        view?.removeFromSuperview()
    }
    
    
    func showWaiting () {
        
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
