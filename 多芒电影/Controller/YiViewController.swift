//
//  YiViewController.swift
//  多芒电影
//
//  Created by 柴小红 on 15/2/13.
//  Copyright (c) 2015年 珠影网络. All rights reserved.
//

import UIKit

class YiViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var uiTableView: UITableView!
    var basicList:Array<Model.BasicInfo> = [] //影片信息列表
    
    var currentInfo:Model.BasicInfo=Model.BasicInfo()
    var currentID=0
    
    var currentPage = 0
    var currentLableID = 0
    var currentColumn = 1
    
    var isScroll = false
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl.attributedTitle = NSAttributedString(string: "松开更新信息")
        refreshControl.addTarget(self, action: "refreshData", forControlEvents: UIControlEvents.ValueChanged)
        uiTableView.addSubview(refreshControl)
        refreshData()
        
        uiTableView.dataSource = self
        uiTableView.delegate = self
    }
    

    
    
    func refreshData() {
        basicList = UTIL.getLlatestUpdate(栏目id: 6, 特殊标签id: currentLableID, 每页数量: 20, 当前页码: currentPage)
        uiTableView.reloadData()
        refreshControl.endRefreshing()
        
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
        
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        var cell = uiTableView.cellForRowAtIndexPath(indexPath) as UIControl.basicInfolistView
        println(cell.infoID)
        currentInfo = basicList[indexPath.row]
        
        self.performSegueWithIdentifier("kanMovieSegue", sender: self)
        //println(cell.infoID)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var theSegue = segue.destinationViewController as movieDetailController
        
        theSegue.currentInfo = currentInfo
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if isScroll {
            return
        }
        
        if scrollView.contentOffset.y + scrollView.frame.size.height > scrollView.contentSize.height * 0.8 {
            isScroll = true
            currentPage = currentPage + 1
            var  basicList1 = UTIL.getLlatestUpdate(栏目id: 1, 特殊标签id: currentLableID, 每页数量: 20, 当前页码: currentPage)
            basicList.extend(basicList1)
            uiTableView.reloadData()
            isScroll = false
            
        }
        
    }
    
    
}
