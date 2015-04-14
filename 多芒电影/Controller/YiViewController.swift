//
//  YiViewController.swift
//  多芒电影
//
//  Created by 柴小红 on 15/2/13.
//  Copyright (c) 2015年 珠影网络. All rights reserved.
//

import UIKit

class YiViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, CommonAccessDelegate,DataDelegate {

    @IBOutlet weak var uiTableView: UITableView!
    var basicList:Array<Model.BasicInfo> = [] //影片信息列表
    
    var currentInfo:Model.BasicInfo=Model.BasicInfo()
    var currentID=0
    
    var currentPage = 0
    var currentLableID = 0
    var currentColumn = 1
    
    var isScroll = false
    var refreshControl = UIRefreshControl()
    var activityIndicator : UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl.attributedTitle = NSAttributedString(string: "松开更新信息")
        refreshControl.addTarget(self, action: "refreshData", forControlEvents: UIControlEvents.ValueChanged)
        uiTableView.addSubview(refreshControl)
        
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0,y: 0,width: 32,height: 32))
        activityIndicator.center = view.center
        activityIndicator.activityIndicatorViewStyle =  UIActivityIndicatorViewStyle.Gray
        view.addSubview(activityIndicator)
        
        refreshData()
        
        uiTableView.dataSource = self
        uiTableView.delegate = self
    }
    

    
    
    func refreshData() {
        //basicList = UTIL.getLlatestUpdate(栏目id: 6, 特殊标签id: currentLableID, 每页数量: 20, 当前页码: currentPage)
        activityIndicator.startAnimating()
        CommonAccess(delegate: self, flag: "").getLlatestUpdate(栏目id: 6, 特殊标签id: currentLableID, 每页数量: 20, 当前页码: currentPage)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
    //设置标签
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return basicList.count
    }
   
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier: String = "cell"
        // may be no value, so use optional
        var cell: UIControl.basicInfolistView? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? UIControl.basicInfolistView
        
        if cell == nil { // no value
            cell = UIControl.basicInfolistView(style: UITableViewCellStyle.Default, reuseIdentifier: cellIdentifier)
        }
        
        let model: Model.BasicInfo? = basicList[indexPath.row]
        // cell?.frame = CGRect(x: 0, y: 0, width: 320, height: 100)
        cell!.isCircul = true
        cell!.displayLabel = false
        cell!.displayLink = true
        cell!.configureCell(model)
        
        var playBtn = cell?.playBtn
        
        if (playBtn?.hidden != true) {
            playBtn?.tag = indexPath.row
            playBtn?.addTarget(self, action: "playTarget:", forControlEvents: UIControlEvents.TouchDown)
        }

        
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        var cell = uiTableView.cellForRowAtIndexPath(indexPath) as! UIControl.basicInfolistView
        println(cell.infoID)
        currentInfo = basicList[indexPath.row]
        
        self.performSegueWithIdentifier("yi2dy", sender: self)
        //println(cell.infoID)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var theSegue = segue.destinationViewController as! movieDetailController
        theSegue.title = "多芒公益"
        theSegue.currentInfo = currentInfo
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if isScroll {
            return
        }
        
        if scrollView.contentOffset.y + scrollView.frame.size.height > scrollView.contentSize.height * 0.8 {
            isScroll = true
            currentPage = currentPage + 1
            //var  basicList1 = UTIL.getLlatestUpdate(栏目id: 1, 特殊标签id: currentLableID, 每页数量: 20, 当前页码: currentPage)
            activityIndicator.startAnimating()
            CommonAccess(delegate: self, flag: "").getLlatestUpdate(栏目id: 1, 特殊标签id: currentLableID, 每页数量: 20, 当前页码: currentPage)
        }
        
    }
    
    func playTarget(sender:UIButton){
        var loadWebController = LoadWebViewController()
        
        var memberid = "0"
        
        var userDefaults = NSUserDefaults.standardUserDefaults()
        var obj:AnyObject? = userDefaults.objectForKey("myUser")
        
        if obj != nil {
            //var result = NSKeyedUnarchiver.unarchiveObjectWithData(obj) as? NSMutableArray
            var user:Model.LoginModel = NSKeyedUnarchiver.unarchiveObjectWithData(obj! as! NSData) as! Model.LoginModel
            if  user.MemberID != "" && user.MemberID != "0" {
                memberid = user.MemberID
            }
        }
        
        var item = basicList[sender.tag]
        loadWebController.titleText = item.Title
        loadWebController.webAddress  = item.LinkUrl
        API().exec(self, invokeIndex: 0, invokeType: "qList", methodName: "ReadInfo", params: String(item.InfoID),memberid).loadData()
        
        self.navigationController?.pushViewController(loadWebController, animated: true)
    }

    
    func invoke(index:Int,StringResult result:String){
        
    }
    //type:方法的标识（一个页面可能有多个方法回调，以此参数作为标识区分） object:返回的数据
    func invoke(type:String,object:NSObject){
        
    }
    func setCallbackObject(flag: String, object: NSObject) {
        activityIndicator.stopAnimating()
        var  basicList1 = object as! Array<Model.BasicInfo>
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
    
    
}
