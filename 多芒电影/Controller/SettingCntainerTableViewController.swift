//
//  SettingCntainerTableViewController.swift
//  多芒电影
//
//  Created by 柴小红 on 15/4/2.
//  Copyright (c) 2015年 珠影网络. All rights reserved.
//

import UIKit

class SettingCntainerTableViewController: UITableViewController,UIAlertViewDelegate,DataDelegate {

    @IBOutlet var uiTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.uiTableView.delegate = self
        self.uiTableView.dataSource = self
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 6
    }
    
//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
//        var cell = tableView.cellForRowAtIndexPath(indexPath)
//        cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
//        return cell!
//    }

    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        
        switch indexPath.row {
        case 0://分享好友
            var  imagePath = NSBundle.mainBundle().pathForResource("AppIcon", ofType: "png")
            //构造分享内容
            
            var publishContent = ShareSDK.content("多芒电影是一款个性化电影推荐聚合应用，主打品读式移动观影，其简洁清新的界面风格、个性独特的推荐方式，让您在电影的精深世界里尽享慢生活之乐。", defaultContent: "多芒电影，有你好看", image:ShareSDK.imageWithPath(imagePath), title: "多芒电影应用分享", url: "https://itunes.apple.com/cn/app/duo-mang-dian-ying/id789581054?mt=8&uo=4", description: "多芒电影是一款个性化电影推荐聚合应用，主打品读式移动观影，其简洁清新的界面风格、个性独特的推荐方式，让您在电影的精深世界里尽享慢生活之乐。", mediaType: SSPublishContentMediaTypeNews)
            
            
            ShareSDK.showShareActionSheet(nil, shareList: nil, content: publishContent, statusBarTips: true, authOptions: nil, shareOptions: nil, result: { (shareType:ShareType, state:SSResponseState, info:ISSPlatformShareInfo!, error:ICMErrorInfo!, Bool) -> Void in
                if state.value == SSResponseStateSuccess.value  {
                    NSLog("分享成功");
                } else if state.value == SSPublishContentStateFail.value {
                    NSLog("分享失败,错误码:%d,错误描述:%@",error.errorCode(),error.errorDescription())
                }})
            
        case 1://清除缓存
            
            var ud = NSUserDefaults.standardUserDefaults()

            var alertview = UIAlertView(title: "缓存清理", message: "缓存已清除", delegate: nil, cancelButtonTitle: "确定")
            alertview.show()
            
        case 2://关于我们
            var loadWebController = LoadWebViewController()
            loadWebController.titleText = "关于我们"
            loadWebController.webAddress  = "aboutus"
            self.navigationController?.pushViewController(loadWebController, animated: true)
            
        case 3://意见反馈
            var alertController = UIAlertController(title: "意见反馈", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addTextFieldWithConfigurationHandler {
                (textField: UITextField!) -> Void in
                textField.placeholder = "意见信息"
            }
            
            var okAction = UIAlertAction(title: "好的", style: UIAlertActionStyle.Default) {
                (action: UIAlertAction!) -> Void in
                var login = alertController.textFields?.first as! UITextField
                API().exec(self, invokeIndex: 0, invokeType: "qList", methodName: "SendFeedBack", params:login.text).loadData()
            }
            
            
            var cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
            
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
            
        case 4://字体设置
            var fontValue = NSUserDefaults.standardUserDefaults().integerForKey("fontSize")
            var large="大",medium="中",small="小",currString="(当前)"
            switch fontValue {
            case -1:
                small += currString
            case 1:
                medium += currString
            case 2:
                large += currString
            default:
                medium += currString
            }
            
            UIAlertView(title: "字体设置", message: "", delegate: self, cancelButtonTitle: large, otherButtonTitles: small, medium).show()
            
        case 5://免责声明
            var loadWebController = LoadWebViewController()
            loadWebController.titleText = "免责声明"
            loadWebController.webAddress  = "mianzhe"
            self.navigationController?.pushViewController(loadWebController, animated: true)
        default:
            println(indexPath.row)
            
            
        }
        
        return indexPath
    }

    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int){
        println("buttonIndex is:\(buttonIndex)")
        var config = NSUserDefaults.standardUserDefaults()
        
        switch buttonIndex {
        case 0: //大
            config.setInteger(2, forKey: "fontSize")
        case 1: //小
            config.setInteger(-1, forKey: "fontSize")
        case 2: //中
            config.setInteger(1, forKey: "fontSize")
        default: //中
            config.setInteger(1, forKey: "fontSize")
        }
        var fontSize = config.integerForKey("fontSize")
        println("font size value is:\(fontSize)")
    }
    func invoke(index:Int,StringResult result:String){
        
    }
    //type:方法的标识（一个页面可能有多个方法回调，以此参数作为标识区分） object:返回的数据
    func invoke(type:String,object:NSObject){
        
    }
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
