//
//  LoginViewController.swift
//  多芒电影
//
//  Created by 柴小红 on 15/2/13.
//  Copyright (c) 2015年 珠影网络. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController,UITextFieldDelegate,DataDelegate {

  
    @IBOutlet weak var lblThird: UILabel!
    @IBOutlet weak var lblzdomoLoginReg: UILabel!
    @IBOutlet weak var btnSina: UIButton!
    @IBOutlet weak var btnQQ: UIButton!
    @IBOutlet weak var btnReg: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtZhanhu: UITextField!

    //let  loginVieControl = LoginThirdViewController()
  
    override func viewDidLoad() {

        
        super.viewDidLoad()
        setTiTleBack()
        txtZhanhu.delegate = self
        txtPassword.delegate = self
    }

    override func viewWillAppear(animated: Bool) {
       
        if  user.IsLogin  {
            self.performSegueWithIdentifier("UILoginMember", sender: self)
            //self.navigationController?.pushViewController(loginVieControl , animated: true)
            
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func sinaTapped(sender: AnyObject) {
        ShareSDK.getUserInfoWithType(ShareTypeSinaWeibo, authOptions: nil) { (result:Bool , userinfo:ISSPlatformUser!, error:ICMErrorInfo!) -> Void in
            if (result) {
                //成功登录后，判断该用户的ID是否在自己的数据库中。
                //如果有直接登录，没有就将该用户的ID和相关资料在数据库中创建新用户。
                self.reloadStateWithUserInfo(userinfo,whereFrom: "SINA")
            }
        }
       
    }
    
    
    //type:方法的标识（一个页面可能有多个方法回调，以此参数作为标识区分） object:返回的数据
    func invoke(type: String, object: NSObject) {
        
        var user1 = object as! Model.LoginModel
        
        
     
        if  user1.MemberID == "" || user1.MemberID == "0"   {
            let alert = UIAlertView()
            alert.title = "登录信息"
            alert.message = "您输入账号或密码不正确，不能登录！"
            alert.addButtonWithTitle("Ok")
            alert.show()
        }else {
            user1.MemberID = user1.MemberID.trim()
            user1.Mail = user1.Mail.trim()
            user1.HeadPhotoURL = user1.HeadPhotoURL.trim()
            user1.UserName = user1.UserName.trim()
            user1.NickName = user1.NickName.trim()
            user1.Password = user1.Password.trim()
            user1.WhereFrom = user1.WhereFrom.trim()
            user1.IsActivation = user1.IsActivation.trim()
            user1.IsUsed =  "true"
            user1.Identity = user1.Identity.trim()
            user1.registrationTime = user1.registrationTime.trim()
            user1.LastVisitTime = user1.LastVisitTime.trim()
            user1.IsLogin = true
            
            var userDeFaults = NSUserDefaults.standardUserDefaults()
            userDeFaults.setValue(NSKeyedArchiver.archivedDataWithRootObject(user1), forKey: "myUser")
            
            var dele = UIApplication.sharedApplication().delegate as! AppDelegate
            dele.readNSUserDefaults()
            self.performSegueWithIdentifier("UILoginMember", sender: self)
            
        }

        //self.navigationController?.pushViewController(loginVieControl , animated: true)
        
    }
    

    func invoke(index: Int, StringResult result: String) {
       
    }
    
    @IBAction func qqTapped(sender: AnyObject) {
       
        ShareSDK.getUserInfoWithType(ShareTypeQQSpace, authOptions: nil) { (result:Bool , userinfo:ISSPlatformUser!, error:ICMErrorInfo!) -> Void in
               if (result) {
                //成功登录后，判断该用户的ID是否在自己的数据库中。
                //如果有直接登录，没有就将该用户的ID和相关资料在数据库中创建新用户。
                self.reloadStateWithUserInfo(userinfo,whereFrom: "QQ")
               } else {
                
                println("\(error.errorCode()):\(error.description):\(error.errorDescription())")
            }
        }
    }
    
    func reloadStateWithUserInfo(userinfo:ISSPlatformUser,whereFrom:String) {
    //现实授权信息，包括授权ID、授权有效期等。
    //此处可以在用户进入应用的时候直接调用，如授权信息不为空且不过期可帮用户自动实现登录。
        //打印输出用户uid：
        var  date = NSDate()
        var formatter:NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd\'T\'HH:mm:ss"
        var dateString = formatter.stringFromDate(date)
        
        var user1 = Model.LoginModel()
        user1.UserName = userinfo.nickname()
        user1.NickName = userinfo.nickname()
        user1.IsUsed = "true"
        user1.IsActivation = "true"
        user1.WhereFrom = whereFrom
        user1.HeadPhotoURL = userinfo.profileImage()
        user1.Identity = userinfo.uid()
        user1.registrationTime =  dateString
        user1.LastVisitTime = dateString
        user1.Password = userinfo.uid()
        user1.Mail = ""
     
        var userDeFaults = NSUserDefaults.standardUserDefaults()
        userDeFaults.setValue(NSKeyedArchiver.archivedDataWithRootObject(user1), forKey: "myUser")
        
        
       self.performSegueWithIdentifier("UILoginMember", sender: self)
       // self.navigationController?.pushViewController(loginVieControl, animated: true)
    }
   
    
    
    func setTiTleBack(){
      /*  lblThird.backgroundColor = UIColor(patternImage: UIImage(named: "blackline")!)
        lblzdomoLoginReg.backgroundColor = UIColor(patternImage: UIImage(named: "blackline")!)

        var lbl1 = UILabel()
        lbl1.text = lblThird.text
        lbl1.backgroundColor = UIColor.whiteColor()
        lblThird.text = ""
        var lbl1x = (lblThird.frame.width - 150  ) / 2 + lblThird.bounds.origin.x
        
        lbl1.frame = CGRect(x: lbl1x,  y: 10, width: 150, height: 20)
        lbl1.textAlignment = NSTextAlignment.Center
        lblThird.addSubview(lbl1)
        
        var lbl2 = UILabel()
        lbl2.text = lblzdomoLoginReg.text
        lbl2.backgroundColor = UIColor.whiteColor()
        lblzdomoLoginReg.text = ""
         var lbl2x = (lblzdomoLoginReg.frame.width - 230)/2
        lbl2.frame = CGRect(x: lbl2x, y: 10, width: 230, height: 20)
        lbl2.textAlignment = NSTextAlignment.Center
        lblzdomoLoginReg.addSubview(lbl2)*/
        
        var sinaImg = UIImageView(frame: CGRect(x: 0, y: 0, width: 95, height: 32))
        sinaImg.image = UIImage(named: "wodezhaghu_weibo")
        btnSina.titleLabel?.text = ""
        btnSina.addSubview(sinaImg)
        
        var qqImg = UIImageView(frame: CGRect(x: 0, y: 0, width: 95, height: 32))
        qqImg.image = UIImage(named: "wodezhaghu_qq")
        btnQQ.titleLabel?.text = ""
        btnQQ.addSubview(qqImg)
      
        var loginImg = UIImageView(frame: CGRect(x: 0, y: 0, width: 95, height: 32))
        loginImg.image = UIImage(named: "wodezhaghu_denglu")
        btnLogin.titleLabel?.text = ""
        btnLogin.addSubview(loginImg)
        
        var regImg = UIImageView(frame: CGRect(x: 0, y: 0, width: 95, height: 32))
        regImg.image = UIImage(named: "wodezhaghu_zhuce")
        btnReg.titleLabel?.text = ""
        btnReg.addSubview(regImg)
        
    }
    
    @IBAction func loginTapped(sender: AnyObject) {
        if txtZhanhu.text.trim().length()<1 || txtPassword.text.trim().length()<1 {
            let alert = UIAlertView()
            alert.title = "登录信息"
            alert.message = "您输入账号或密码为空，不能登录！"
            alert.addButtonWithTitle("Ok")
            alert.show()
            return
        }
        
         API().exec(self, invokeIndex: 0, invokeType: "", methodName: "Login", params: txtZhanhu.text.trim(),txtPassword.text.trim(),"","").loadData()
        
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
