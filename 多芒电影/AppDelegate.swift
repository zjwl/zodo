//
//  AppDelegate.swift
//  多芒电影
//
//  Created by 柴小红 on 15/1/13.
//  Copyright (c) 2015年 珠影网络. All rights reserved.
//


import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var user:Model.LoginModel?
    var isLogin:Bool?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
       
        initShareSDK()
        readNSUserDefaults()
        return true
        
        
    }
    
    func initShareSDK() {
        
        MobClick.startWithAppkey("54c8911dfd98c517bc0003ab", reportPolicy: BATCH, channelId: "多芒网")
        ShareSDK.registerApp("e29f62efd4b", useAppTrusteeship: false)  //参数为ShareSDK官网中添加应用后得到的AppKey
        //shareSDK key :e29f62efd4b
     
        //QQ空间
        ShareSDK.connectQZoneWithAppKey("1150080326", appSecret:"da0efeea8fa6fcc79d8532259cd6d0c", qqApiInterfaceCls: QQApiInterface.classForCoder(), tencentOAuthCls: TencentOAuth.classForCoder())
        
        //添加QQ空间应用
        //ShareSDK.connectQZoneWithAppKey("100371282", appSecret:"aed9b0303e3ed1e27bae87c33761161d",qqApiInterfaceCls: QQApiInterface.classForCoder(),tencentOAuthCls: TencentOAuth.classForCoder())
        
        //QQ QQ100371282
        ShareSDK.connectQQWithAppId("1150080326", qqApiCls:QQApiInterface.classForCoder())

        //链接微信
        ShareSDK.connectWeChatWithAppId("wx9fcf751788a3e9ba", wechatCls: WXApi.classForCoder())
        //微信好友
       ShareSDK.connectWeChatSessionWithAppId("wx9fcf751788a3e9ba", wechatCls:WXApi.classForCoder())
        //微信朋友圈
       ShareSDK.connectWeChatTimelineWithAppId("wx9fcf751788a3e9ba", wechatCls: WXApi.classForCoder())
  
        //添加新浪微博应用
       ShareSDK.connectSinaWeiboWithAppKey("731264100", appSecret: "42600f8a8e709edc4eb0f4a71b11dd3e", redirectUri: "http://www.zdomo.com")
        
        //添加腾讯微博应用
       ShareSDK.connectTencentWeiboWithAppKey("1150080326",appSecret:"da0efeea8fa6fcc79d8532259cd6d0c",redirectUri:"http://m.zdomo.com")

        //连接短信分享
        ShareSDK.connectSMS()
        //连接邮件
       ShareSDK.connectMail()

        /*

        //添加网易微博应用
        [ShareSDK connect163WeiboWithAppKey:@"T5EI7BXe13vfyDuy"
        appSecret:@"gZxwyNOvjFYpxwwlnuizHRRtBRZ2lV1j"
        redirectUri:@"http://www.zdomo.com"];

        //添加搜狐微博应用
        [ShareSDK connectSohuWeiboWithConsumerKey:@"SAfmTG1blxZY3HztESWx"
        consumerSecret:@"yfTZf)!rVwh*3dqQuVJVsUL37!F)!yS9S!Orcsij"
        redirectUri:@"http://www.zdomo.com"];

        //添加豆瓣应用
        [ShareSDK connectDoubanWithAppKey:@"02e2cbe5ca06de5908a863b15e149b0b"
        appSecret:@"9f1e7b4f71304f2f"
        redirectUri:@"http://www.zdomo.com"];

        //添加人人网应用
        [ShareSDK connectRenRenWithAppKey:@"fc5b8aed373c4c27a05b712acba0f8c3"
        appSecret:@"f29df781abdd4f49beca5a2194676ca4"];

        //添加开心网应用
        [ShareSDK connectKaiXinWithAppKey:@"358443394194887cee81ff5890870c7c"
        appSecret:@"da32179d859c016169f66d90b6db2a23"
        redirectUri:@"http://www.zdomo.com"];

        [ShareSDK connectSohuKanWithAppKey:@"e16680a815134504b746c86e08a19db0"
        appSecret:@"b8eec53707c3976efc91614dd16ef81c"
        redirectUri:@"http://www.zdomo.com"];
        */
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        return ShareSDK.handleOpenURL(url,wxDelegate:self)
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        return ShareSDK.handleOpenURL(url,sourceApplication:sourceApplication,annotation:annotation,wxDelegate:self)
    }
    
    func readNSUserDefaults() {
        var userDefaults = NSUserDefaults.standardUserDefaults()
        
        var obj:AnyObject? = userDefaults.objectForKey("myUser")
        
        if obj != nil {
            //var result = NSKeyedUnarchiver.unarchiveObjectWithData(obj) as? NSMutableArray
            var user:Model.LoginModel = NSKeyedUnarchiver.unarchiveObjectWithData(obj! as NSData) as Model.LoginModel
            self.user = user
        }
        
        if self.user != nil && self.user?.MemberID != "" && self.user?.MemberID != "0" {
            self.isLogin = true         
        } else {
            self.isLogin = false
        }
       
        
    }
    
    

}

