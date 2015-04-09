//
//  ViewController.swift
//  多芒电影
//
//  Created by 柴小红 on 15/1/13.
//  Copyright (c) 2015年 珠影网络. All rights reserved.
//

import UIKit

class ViewController: UIViewController,DataDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
           API().exec(self, invokeIndex: 0, invokeType: "qList", methodName: "GetQASKList", params: "true","3","10","0","0").loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func GetData(sender: AnyObject) {
        //GameAccess(source: self, methodName: "GetQASKList", params: "10","0").loadData()
        //GetQASKInfo(source: self, invokeIndex: 0, methodName: "GetQASKList", params: "true","3","10","0","0").loadData()
        //ReadInfo(source: self, invokeIndex: 0, methodName: "ReadInfo", params: "22","0").loadData()
        //API().exec(self, invokeIndex: 0, methodName: "SaveFile", params: "","3692","abc.gif").loadData()
        //API().exec(self, invokeIndex: 0, invokeType: "", methodName: "SaveFile", params: "","","").loadData()
        API().exec(self, invokeIndex: 0, invokeType: "qList", methodName: "GetQASKList", params: "true","3","10","0","0").loadData()
    }
    
    
    func invoke(index:Int,StringResult result:String){
        switch index
        {
        case 0:
            println(0)
        case 1:
            println(1)
        default :
            println(2)
        }
      //  helloWorld.text = result
    }
    
    func invoke(type: String, object: NSObject) {
        //        switch type{
        //        case "a":
        //            println(type)
        //        case "b":
        //            println(type)
        //        default:
        //            break
        //        }
        var gameList:QaskList = object as QaskList
        var str:String = "type:\(type),"
        for item:Qask in gameList.list{
            str += item.NickName + ","
        }
       print(str)
    }


}

