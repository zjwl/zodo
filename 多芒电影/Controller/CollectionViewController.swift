//
//  CollectionViewController.swift
//  多芒电影
//
//  Created by 柴小红 on 15/2/13.
//  Copyright (c) 2015年 珠影网络. All rights reserved.
//

import UIKit


class CollectionViewController: UIViewController,UITableViewDelegate, UITableViewDataSource ,UIScrollViewDelegate, DataDelegate,CommonAccessDelegate {

    @IBOutlet var uiTableView: UITableView!
    var basicList:Array<Model.Collection> = [] //影片信息列表
    
    var currentInfo:Model.BasicInfo=Model.BasicInfo()
    
    var currentPage = 0
    var isScroll = false
    var refreshControl = UIRefreshControl()
    var noDataView:UILabel=UILabel()
    var activityIndicator : UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        refreshControl.attributedTitle = NSAttributedString(string: "松开更新信息")
        refreshControl.addTarget(self, action: "refreshData", forControlEvents: UIControlEvents.ValueChanged)
        uiTableView.addSubview(refreshControl)
        uiTableView.separatorInset=UIEdgeInsetsZero
        
        uiTableView.dataSource = self
        uiTableView.delegate = self
        self.view.addSubview(noDataView)
        
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0,y: 0,width: 32,height: 32))
        activityIndicator.center = view.center
        activityIndicator.activityIndicatorViewStyle =  UIActivityIndicatorViewStyle.Gray
        view.addSubview(activityIndicator)
        

    }
    
    override func viewWillAppear(animated: Bool) {
         refreshData()

    }

    
    
    
    func refreshData() {
        
        noDataView.frame = self.view.bounds
        
        refreshControl.endRefreshing()
        if user.IsLogin {
            //basicList = UTIL.getCollection(客户id: user.MemberID.toInt()!, 每页数量: 10, 当前页码: 0)
            activityIndicator.startAnimating()
            CommonAccess(delegate: self, flag: "").getCollection(客户id: user.MemberID.toInt()!, 每页数量: 10, 当前页码: 0)
            noDataView.hidden = true
            uiTableView.hidden = false
        } else {
            uiTableView.hidden = true
            noDataView.hidden = false
            noDataView.text = "您未登录或尚未收藏信息"
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
        if cellTmp == nil {
            cell = CollectionAndHistoryCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: collectionCellIdentifier)
        }else {
            cell = ( cellTmp as! CollectionAndHistoryCell)
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
       currentInfo = basicList[indexPath.row]
        
        var identifier="cc2dy"
        switch currentInfo.ColumnID {
        case 1:
            identifier="cc2dy"
        case 2:
            identifier="cc2yp"
        case 4:
            identifier="cc2yy"
        case 5:
            identifier="cc2yp"
        case 6:
            identifier="cc2yp"
        default:
            identifier="cc2yp"
        }
        self.performSegueWithIdentifier(identifier, sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        switch currentInfo.ColumnID {
        case 1:
            var theSegue = segue.destinationViewController as! movieDetailController
            theSegue.currentInfo = currentInfo
        case 2:
            var theSegue = segue.destinationViewController as! ypDetailController
            theSegue.currentInfo = currentInfo
        case 4:
            var theSegue = segue.destinationViewController as! musicDetailController
            theSegue.currentInfo = currentInfo
        case 5:
            var theSegue = segue.destinationViewController as! ypDetailController
            theSegue.currentInfo = currentInfo
        case 6:
            var theSegue = segue.destinationViewController as! ypDetailController
            theSegue.currentInfo = currentInfo
        default:
            var tt=32
        }
        
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if isScroll {
            return
        }
        if user.IsLogin {
            if scrollView.contentOffset.y + scrollView.frame.size.height > scrollView.contentSize.height * 0.8 {
                isScroll = true
                currentPage = currentPage + 1
                //var  basicList1 = UTIL.getCollection(客户id: user.MemberID.toInt()!, 每页数量: 10, 当前页码: currentPage)
                activityIndicator.startAnimating()
                CommonAccess(delegate: self, flag: "").getCollection(客户id: user.MemberID.toInt()!, 每页数量: 10, 当前页码: currentPage)
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
            API().exec(self, invokeIndex: 0, invokeType: "", methodName: "DeleteCollection", params: String(m.InfoID)+",",user.MemberID).loadData()
            basicList.removeAtIndex(indexPath.row)
            self.uiTableView.reloadData()
        }
    }
    
    
    func invoke(index:Int,StringResult result:String){
        println("item has deleted.\(result)")
        deleteBasicCollectionInfoToLocal(currentInfo.InfoID)
    }
    func invoke(type:String,object:NSObject){
    
    }
    
    func setCallbackObject(flag: String, object: NSObject) {
        activityIndicator.stopAnimating()
        var  basicList1 = object as! Array<Model.Collection>
        if currentPage == 0 {
            basicList = basicList1
            uiTableView.reloadData()
            refreshControl.endRefreshing()
        }else {
            basicList.extend(basicList1)
            uiTableView.reloadData()
            isScroll = false
        }
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
