//
//  LoginRegisterViewController.swift
//  多芒电影
//
//  Created by 柴小红 on 15/2/13.
//  Copyright (c) 2015年 珠影网络. All rights reserved.
//

import UIKit

class LoginRegisterViewController: UIViewController,DataDelegate,UITextFieldDelegate{

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtRePassword: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func regTapped(sender: AnyObject) {
        
        
        if !UTIL.checkEmail(txtEmail.text){
            var alert = UIAlertView()
            alert.title = "邮箱信息"
            alert.message = "您输入的邮箱地址不正确，不能注册！"
            alert.addButtonWithTitle("Ok")
            alert.show()
            return
        }
        
        if txtPassword.text.trim().length() < 1 || txtRePassword.text.trim().length() < 1 {
            var alert = UIAlertView()
            alert.title = "密码信息"
            alert.message = "密码信息不能为空！"
            alert.addButtonWithTitle("Ok")
            alert.show()
            return
        }
        
        if txtPassword.text.trim() != txtRePassword.text.trim() {
            var alert = UIAlertView()
            alert.title = "密码信息"
            alert.message = "两次输入的密码不相同！"
            alert.addButtonWithTitle("Ok")
            txtRePassword.text = ""
            txtPassword.text = ""
            alert.show()
            return
        }
        
           API().exec(self, invokeIndex: 0, invokeType: "email", methodName: "CheckEmail", params: txtEmail.text.trim()).loadData()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func invoke(index:Int,StringResult result:String){
        if index == 0 {
            if result == "1" {
                var alert = UIAlertView()
                alert.title = "Email检测信息"
                alert.message = "您的Email已在本系统中注册后，请换个Email重新注册！"
                alert.addButtonWithTitle("Ok")
                alert.show()
                return
            } else {
                 API().exec(self, invokeIndex: 1, invokeType: "email", methodName: "AddUser", params: txtEmail.text.trim(),txtPassword.text.trim(),txtEmail.text.trim(),"","").loadData()
            }
        }
        
        if index == 1 {
            if result.has("zdomo_") {
                var alert = UIAlertView()
                alert.title = "注册信息"
                alert.message = "激活邮件已发到您的注册邮箱，请查收并激活！"
                txtEmail.text = ""
                txtPassword.text = ""
                txtRePassword.text = ""
                alert.addButtonWithTitle("Ok")
                alert.show()
            } else {
                var alert = UIAlertView()
                alert.title = "注册信息"
                alert.message = result
                alert.addButtonWithTitle("Ok")
            }
        }
        
    }
    
    //type:方法的标识（一个页面可能有多个方法回调，以此参数作为标识区分） object:返回的数据
    func invoke(type: String, object: NSObject) {
        
        
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
