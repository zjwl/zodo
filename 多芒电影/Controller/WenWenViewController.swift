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
    var delete:QaskCallbackDataDelegate?
    var isPostSuccess=false
    var content=""
    @IBOutlet weak var contentTextField: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("qid:\(qid);uid:\(uid),sourceid:\(sourceid)")
        contentTextField.delegate=self
        contentTextField.layer.borderWidth=1
        contentTextField.layer.borderColor=UIColor.grayColor().CGColor
        contentTextField.layer.cornerRadius=5.0
        self.automaticallyAdjustsScrollViewInsets = false;
        
        
    }
    
    @IBAction func commitAsk(sender: AnyObject) {
        content=contentTextField.text
        if content.trim().length()>0{
            API().exec(self, invokeIndex: 0, invokeType: "", methodName:"InsertQASK", params: content,String(uid!),String(qid!),String(sourceid)).loadData()
        }
        //API().exec(self, invokeIndex: 0, invokeType: "", methodName:"InsertQASK", params: content,String(uid!),String(qid!),String(sourceid)).loadData()
    }
    
    func invoke(index:Int,StringResult result:String){
        UIAlertView(title: "", message: "提交成功", delegate: self, cancelButtonTitle: "确定").show()
        isPostSuccess=true
        contentTextField.text=""
    }
    override func viewWillDisappear(animated: Bool) {
        if isPostSuccess {
            delete?.setCallbackContent(content)
        }
    }
    
    
    //type:方法的标识（一个页面可能有多个方法回调，以此参数作为标识区分） object:返回的数据
    func invoke(type:String,object:NSObject){
    
    }
    
    func dismissKeyBoard(){
        contentTextField.resignFirstResponder()
    }
}