//
//  YuViewController.swift
//  多芒电影
//
//  Created by 柴小红 on 15/2/13.
//  Copyright (c) 2015年 珠影网络. All rights reserved.
//

import UIKit

class YuViewController: UIViewController,UITableViewDelegate, UITableViewDataSource ,UIScrollViewDelegate {

    @IBOutlet var uiTableView: UITableView!
      var basicList:Array<Model.BasicInfo> = [] //影片信息列表
    
    var currentPage = 0
    var isScroll = false
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initConstraint()
        refreshControl.attributedTitle = NSAttributedString(string: "松开更新信息")
        refreshControl.addTarget(self, action: "refreshData", forControlEvents: UIControlEvents.ValueChanged)
        uiTableView.addSubview(refreshControl)
        
        uiTableView.dataSource = self
        uiTableView.delegate = self
        uiTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        refreshData()
    }
    
    func initConstraint(){
        self.view.frame=CGRectMake(0, 0, screenWidth, screenHeight)
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[uiTableView(screenWidth)]-0-|", options: nil, metrics: ["screenWidth":screenWidth], views: ["uiTableView":self.uiTableView]))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[uiTableView]-0-|", options: nil, metrics: ["screenWidth":screenWidth], views: ["uiTableView":self.uiTableView]))
    }
    
    func refreshData() {
        refreshControl.endRefreshing()
        basicList = UTIL.getLlatestUpdate(栏目id: 5, 特殊标签id: 0, 每页数量: 20, 当前页码: currentPage)
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
        let cellIdentifier: String = "cell"
        // may be no value, so use optional
        var cell: UIControl.yuInfoListView? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? UIControl.yuInfoListView
        
        if cell == nil { // no value
            cell = UIControl.yuInfoListView(style: UITableViewCellStyle.Default, reuseIdentifier: cellIdentifier)
        }
        
        let model: Model.BasicInfo? = basicList[indexPath.row]
        
        cell?.index = indexPath.row
        
        cell!.configureCell(model)
        
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        var cell = uiTableView.cellForRowAtIndexPath(indexPath) as UIControl.basicInfolistView
        println(cell.infoID)
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if isScroll {
            return
        }
        
        if scrollView.contentOffset.y + scrollView.frame.size.height > scrollView.contentSize.height * 0.8 {
            isScroll = true
            currentPage = currentPage + 1
            var  basicList1 = UTIL.getLlatestUpdate(栏目id: 5, 特殊标签id: 0, 每页数量: 20, 当前页码: currentPage)
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
