//
//  CollectionViewController.swift
//  多芒电影
//
//  Created by 柴小红 on 15/2/13.
//  Copyright (c) 2015年 珠影网络. All rights reserved.
//

import UIKit


class CollectionViewController: UIViewController,UITableViewDelegate, UITableViewDataSource ,UIScrollViewDelegate, DataDelegate {

    @IBOutlet var uiTableView: UITableView!
    var basicList:Array<Model.Collection> = [] //影片信息列表
    
    var currentInfo:Model.BasicInfo=Model.BasicInfo()
    
    var currentPage = 0
    var isScroll = false
    var refreshControl = UIRefreshControl()
    var user:Model.LoginModel?
    var islogin=false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        refreshControl.attributedTitle = NSAttributedString(string: "松开更新信息")
        refreshControl.addTarget(self, action: "refreshData", forControlEvents: UIControlEvents.ValueChanged)
        uiTableView.addSubview(refreshControl)
        uiTableView.separatorInset=UIEdgeInsetsZero
        
        uiTableView.dataSource = self
        uiTableView.delegate = self
        
        var dele = UIApplication.sharedApplication().delegate as AppDelegate
        user = dele.user
        if ((dele.isLogin != nil) && dele.isLogin!) {
            islogin = true
            refreshData()
        }
        
    }
    
    
    func refreshData() {
        
        refreshControl.endRefreshing()
        basicList = UTIL.getCollection(客户id: user!.MemberID.toInt()!, 每页数量: 10, 当前页码: 0)
        uiTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return basicList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //tableView.registerClass(CollectionAndHistoryCell.self, forCellReuseIdentifier: collectionCellIdentifier)
        // may be no value, so use optional
        let collectionCellIdentifier: String = "collectionCell"
        var cell: CollectionAndHistoryCell?
        var cellTmp: AnyObject? = tableView.dequeueReusableCellWithIdentifier(collectionCellIdentifier)
        if cellTmp==nil {
            cell = CollectionAndHistoryCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: collectionCellIdentifier)
        }else {
            cell = (cellTmp as CollectionAndHistoryCell)
        }
        
       // var cell: CollectionAndHistoryCell = tableView.dequeueReusableCellWithIdentifier(collectionCellIdentifier) as CollectionAndHistoryCell
        
       // var cell = CollectionAndHistoryCell(frame: tableView.frame)
        let model: Model.Collection? = basicList[indexPath.row]
        
        cell!.title = model?.Title
        cell!.time="收藏时间："+model!.CollectTime
        
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        //var cell = uiTableView.cellForRowAtIndexPath(indexPath) as UIControl.basicInfolistView
       currentInfo = basicList[indexPath.row]
        self.performSegueWithIdentifier("collectionYPsegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var theSegue = segue.destinationViewController as ypDetailController
        theSegue.currentInfo = currentInfo
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if isScroll {
            return
        }
        if islogin {
            if scrollView.contentOffset.y + scrollView.frame.size.height > scrollView.contentSize.height * 0.8 {
                isScroll = true
                currentPage = currentPage + 1
                var  basicList1 = UTIL.getCollection(客户id: user!.MemberID.toInt()!, 每页数量: 10, 当前页码: currentPage)
                basicList.extend(basicList1)
                uiTableView.reloadData()    
                isScroll = false
            }
        }
        
        
    }
    
    
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if(editingStyle == UITableViewCellEditingStyle.Delete) {
            //commit change to server
            var m:Model.Collection=basicList[indexPath.row]
            API().exec(self, invokeIndex: 0, invokeType: "", methodName: "DeleteCollection", params: String(m.InfoID)+",",user!.MemberID).loadData()
            basicList.removeAtIndex(indexPath.row)
            self.uiTableView.reloadData()
        }
    }
    
    
    func invoke(index:Int,StringResult result:String){
        println(result)
    }
    func invoke(type:String,object:NSObject){
    
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
