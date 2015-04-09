//
//  CommonViewController.swift
//  多芒电影
//
//  Created by 柴小红 on 15/4/9.
//  Copyright (c) 2015年 珠影网络. All rights reserved.
//

import UIKit

class CommonViewController: UIViewController {
    var user:Model.LoginModel?
    var isLogin:Bool?
    
    override func viewDidLoad() {
        readNSUserDefaults()
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
