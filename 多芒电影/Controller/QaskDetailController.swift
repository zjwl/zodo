//
//  QaskDetailController.swift
//  多芒电影
//
//  Created by junjian chen on 15/3/27.
//  Copyright (c) 2015年 珠影网络. All rights reserved.
//

import Foundation

class QaskDetailController: UIViewController,UITableViewDelegate, UITableViewDataSource, DataDelegate {
    var qid:Int=0
    var askList:Array<Model.QASK> = []
    
    var refreshControl = UIRefreshControl()
    
    @IBOutlet weak var uiTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        // 设置tableView的数据源
        self.uiTableView!.dataSource=self
        // 设置tableView的委托
        self.uiTableView!.delegate = self
        self.uiTableView.separatorStyle=UITableViewCellSeparatorStyle.None
        refreshData()
    }
    
    func refreshData(){
        API().exec(self, invokeIndex: 0, invokeType: "qaskList", methodName: "GetQASKInfo", params: String(qid),"100","0","0").loadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return askList.count
        
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = xbShuoCell(frame:CGRectMake(0, 0, tableView.frame.width, 80))
        
        if indexPath.row==0 {
            cell.configItem0(askList[indexPath.row])
        }else{
            cell.configItem(askList[indexPath.row])
        }
        
        var replyGesture = UITapGestureRecognizer(target: self, action: Selector("goWenWenPageFromXbs:"))
        cell.replyBtn.userInteractionEnabled=true
        cell.replyBtn.addGestureRecognizer(replyGesture)
        cell.replyBtn.tag=askList[indexPath.row].QASKID
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var lbl:UILabel = UILabel()
        lbl.numberOfLines = 0
        lbl.text = askList[indexPath.row].Content
        var content:NSString = lbl.text!
        var content0_size:CGSize = content.textSizeWithFont(lbl.font, constrainedToSize: CGSizeMake(tableView.frame.width-20,  CGFloat(MAXFLOAT)))
        
    
        if indexPath.row==0 {
            var content0_H:CGFloat=0,content1_H:CGFloat=0,content2_H:CGFloat=0
            content0_H = content0_size.height + 141 //10+60+10+1+10+contentH+10+30+10
            return content0_H
        }else{
            var content1:NSString = askList[indexPath.row].Content
            var content1_size:CGSize = content1.textSizeWithFont(lbl.font, constrainedToSize: CGSizeMake(tableView.frame.width-90,  CGFloat(MAXFLOAT)))
            var content1_H = content1_size.height + 50 //10+20+10+ContentH+10
            return content1_H //> 80 ? content1_H : 80
        }
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 80
    }
    
    func invoke(index:Int,StringResult result:String){
    
    }
    func invoke(type:String,object:NSObject){
        println("askList.count:\(askList.count)")
        
        askList = object as Array<Model.QASK>
        refreshControl.endRefreshing()
        
        uiTableView.reloadData()
    }
    
    func goWenWenPageFromXbs(tap:UITapGestureRecognizer){
        var dele = UIApplication.sharedApplication().delegate as AppDelegate
        if ((dele.isLogin != nil) && dele.isLogin!) {
            self.performSegueWithIdentifier("wenwenFromDetail", sender: self)
        }else{
            showAlert()
        }
    }
    
    func showAlert(message:String="需要登录才能发表"){
        var alertController:UIAlertController=UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        var loginAction = UIAlertAction(title: "去登录", style: UIAlertActionStyle.Destructive,handler:doLoginActions)
        var cancelAction = UIAlertAction(title: "先逛逛", style: UIAlertActionStyle.Destructive,handler:doCancelAction)
        alertController.addAction(loginAction)
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: true){
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var theSegue = segue.destinationViewController as WenWenViewController
        var dele = UIApplication.sharedApplication().delegate as AppDelegate
        var user=dele.user
        if user != nil {
            theSegue.uid = user!.MemberID.toInt()
        }
        theSegue.qid = qid
        theSegue.sourceid=qid
    }
    func doLoginActions(action:UIAlertAction!){
        println("lgoin")
        self.tabBarController!.selectedIndex=2
        
    }
    func doCancelAction(action:UIAlertAction!){
        println("cancel")
    }

}