//
//  HistoryViewController.swift
//  多芒电影
//
//  Created by 柴小红 on 15/2/13.
//  Copyright (c) 2015年 珠影网络. All rights reserved.
//

import UIKit

class HistoryViewController:UIViewController, UITableViewDelegate, UITableViewDataSource ,UIScrollViewDelegate, DataDelegate,CommonAccessDelegate {

    @IBOutlet var uiTableView: UITableView!
    var basicList:Array<Model.History> = [] //影片信息列表
    
    var currentPage = 0
    var pageSize = 5
    var isScroll = false
    var isAllData = false
    var refreshControl = UIRefreshControl()
    var currentInfo:Model.BasicInfo=Model.BasicInfo()
    var noDataView:UILabel=UILabel()
    var activityIndicator : UIActivityIndicatorView!
    let reachability = Reachability.reachabilityForInternetConnection()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl.attributedTitle = NSAttributedString(string: "松开更新信息")
        refreshControl.addTarget(self, action: "refreshData", forControlEvents: UIControlEvents.ValueChanged)
        uiTableView.addSubview(refreshControl)
        uiTableView.separatorInset=UIEdgeInsetsZero
        uiTableView.dataSource = self
        uiTableView.delegate = self
        //uiTableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        self.view.addSubview(noDataView)
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0,y: 0,width: 32,height: 32))
        activityIndicator.center = view.center
        activityIndicator.activityIndicatorViewStyle =  UIActivityIndicatorViewStyle.Gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()

       
    }
    
   
    
    override func viewWillAppear(animated: Bool) {
        //basicList.removeAll(keepCapacity: false)
        refreshData()
    }
    
    
    func refreshData() {
        
        
        
        noDataView.frame = self.view.bounds
        
        refreshControl.endRefreshing()
        if user.IsLogin {

            
            activityIndicator.startAnimating()
            
            if reachability.isReachable(){
              

                CommonAccess(delegate: self, flag: "refresh").getHistory(客户id: Int(user.MemberID)!, 每页数量: pageSize, 当前页码: 0)

            }else{
                CommonAccess(delegate: self,flag:"").setObjectByCache(value: readObjectFromUD("history_0"))
            }
            

            noDataView.hidden = true
            uiTableView.hidden = false
        } else {
            uiTableView.hidden = true
            noDataView.hidden = false
            noDataView.text = "您未登录或尚未点播影视节目"
            activityIndicator.stopAnimating()
            noDataView.textAlignment = NSTextAlignment.Center
            noDataView.alignmentRectForFrame(self.view.bounds)
            noDataView.backgroundColor = UIColor.whiteColor()
        }
        
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
            cell = (cellTmp as! CollectionAndHistoryCell)
        }
        
        // var cell: CollectionAndHistoryCell = tableView.dequeueReusableCellWithIdentifier(collectionCellIdentifier) as! CollectionAndHistoryCell
        
        // var cell = CollectionAndHistoryCell(frame: tableView.frame)
        let model: Model.History? = basicList[indexPath.row]
        
        cell!.title = model?.Title
        cell!.time="上次观看时间："+model!.HistoryTime
        
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        currentInfo = basicList[indexPath.row]
        self.performSegueWithIdentifier("jl2dy", sender: self)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var theSegue = segue.destinationViewController as! movieDetailController
        theSegue.currentInfo = currentInfo
        
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if isScroll || isAllData {
            return
        }
        if user.IsLogin {
            if scrollView.contentOffset.y + scrollView.frame.size.height > scrollView.contentSize.height * 0.8 {
                isScroll = true
                currentPage = currentPage + 1
                activityIndicator.startAnimating()
                if reachability.isReachable(){
                    CommonAccess(delegate: self, flag: "").getHistory(客户id: Int(user.MemberID)!, 每页数量: pageSize, 当前页码: currentPage)
                }

            }
        }
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if(editingStyle == UITableViewCellEditingStyle.Delete) {
            //commit change to server
            var m:Model.History=basicList[indexPath.row]
            API().exec(self, invokeIndex: 0, invokeType: "", methodName: "DeleteVisitHistory", params: String(m.InfoID)+",",user.MemberID).loadData()
            basicList.removeAtIndex(indexPath.row)
            self.uiTableView.reloadData()
        }
        
    }
    func invoke(index:Int,StringResult result:String){
        //println(result)
    }
    func invoke(type:String,object:NSObject){
        
    }
    
    func setCallbackObject(flag: String, object: NSObject) {
        var  basicList1 = object as! Array<Model.History>
        if basicList1.count<pageSize {
            isAllData = true
        }
        if basicList.count==0{
            basicList = basicList1
        }else{
            if flag=="refresh"{
                filterTheSameData(basicList1,isRefresh: true)
            }else{
                filterTheSameData(basicList1)
            }
        }
        uiTableView.reloadData()
        isScroll = false
        refreshControl.endRefreshing()
        activityIndicator.stopAnimating()
    }
    
    func filterTheSameData(basicList1:Array<Model.History>,isRefresh:Bool=false){
        var tempIDs:Array<Int> = [] //已有的重复的ids
        for item in basicList{
            for item1 in basicList1{
                if item.InfoID == item1.InfoID{
                    tempIDs.append(item.InfoID)
                    break
                }
            }
        }
        var isIn = false
        for item in basicList1{
            for id in tempIDs{
                if id == item.InfoID{
                    isIn = true
                    break
                }
            }
            if !isIn {
                if isRefresh {
                    basicList.insert(item, atIndex: 0)
                }else{
                    basicList.append(item)
                }
                
            }
            isIn = false
        }
    }

}
