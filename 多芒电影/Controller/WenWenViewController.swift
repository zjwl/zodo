//
//  WenWenViewController.swift
//  多芒电影
//
//  Created by junjian chen on 15/3/24.
//  Copyright (c) 2015年 珠影网络. All rights reserved.
//

import Foundation

class WenWenViewController: UIViewController,DataDelegate,UITextViewDelegate {
    var qid:Int?
    var uid:Int?
    var sourceid:Int=0
    
    @IBOutlet weak var contentTextField: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("qid:\(qid);uid:\(uid),sourceid:\(sourceid)")
        contentTextField.delegate=self
        contentTextField.layer.borderWidth=1
        contentTextField.layer.borderColor=UIColor.grayColor().CGColor
        contentTextField.layer.cornerRadius=5.0
        
        var topBar:UIToolbar=UIToolbar(frame:CGRectMake(0, 0, screenWidth, 30))
        var btnSpace:UIBarButtonItem=UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: self, action: nil)
        var doneButton:UIBarButtonItem=UIBarButtonItem(title: "完成", style: UIBarButtonItemStyle.Done, target: self, action: Selector("dismissKeyBoard"))
        var buttonsArray:NSArray=NSArray(objects: btnSpace,doneButton)
        topBar.setItems(buttonsArray, animated: false)
        contentTextField.inputAccessoryView=topBar
        
    }
    
    @IBAction func commitAsk(sender: AnyObject) {
        var content=contentTextField.text
        if content.trim().length()<10{
            UIAlertView(title: "", message: "请输入至少10个字", delegate: nil, cancelButtonTitle: "确定").show()
        }else{
            UIAlertView(title: "", message: "大于10", delegate: nil, cancelButtonTitle: "确定").show()
        }
        //API().exec(self, invokeIndex: 0, invokeType: "", methodName:"InsertQASK", params: content,String(uid!),String(qid!),String(sourceid)).loadData()
    }
    
    func invoke(index:Int,StringResult result:String){
        UIAlertView(title: "", message: "提交成功", delegate: self, cancelButtonTitle: "确定").show()
        contentTextField.text=""
    }
    //type:方法的标识（一个页面可能有多个方法回调，以此参数作为标识区分） object:返回的数据
    func invoke(type:String,object:NSObject){
    
    }
    
    func dismissKeyBoard(){
        contentTextField.resignFirstResponder()
    }
}