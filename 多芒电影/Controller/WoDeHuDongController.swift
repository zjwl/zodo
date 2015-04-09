//
//  WoDeHuDongController.swift
//  多芒电影
//
//  Created by junjian chen on 15/4/2.
//  Copyright (c) 2015年 珠影网络. All rights reserved.
//

import Foundation

class WoDeHuDongController: UIViewController ,UITableViewDelegate, UITableViewDataSource {
    var tempAskList_L0:Array<Model.QASK> = []
    var askList:Array<Model.QASK> = []
    //重组后的数据，用于不同Cell的输出，及调整cell高度
    var arraylist:Array<Array<Model.QASK>> = [[]]
    var tempArray:Array<Model.QASK> = []
    var refreshControl = UIRefreshControl()
    var toQid:Int=0,sourceID:Int=1,toViewQid=0,dajiashuoPageIndex=0,xbShuoPageIndex=0
    var _loadingMore=false
    
    @IBOutlet weak var uiTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl.addTarget(self, action: "refreshData", forControlEvents: UIControlEvents.ValueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "updtae thie data")
        self.uiTableView.addSubview(refreshControl)
        
        // 设置tableView的数据源
        self.uiTableView!.dataSource=self
        // 设置tableView的委托
        self.uiTableView!.delegate = self
        refreshData()
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool){
        // 下拉到最底部时显示更多数据
        if(!_loadingMore && scrollView.contentOffset.y > ((scrollView.contentSize.height - scrollView.frame.size.height)))
        {
            loadDataBegin()
        }
    }
    
    // 开始加载数据
    func loadDataBegin(){
        if !_loadingMore {
            _loadingMore = true
            var tableFooterActivityIndicator:UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(75, 10, 20, 20))
            tableFooterActivityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            tableFooterActivityIndicator.startAnimating()
            uiTableView.addSubview(tableFooterActivityIndicator)
            refreshData()
        }
    }
    
    
    // 创建表格底部
    func createTableFooter(){
        uiTableView.tableFooterView = nil
        var tableFooterView = UIView(frame: CGRectMake(0.0, 0.0, uiTableView.bounds.size.width, 40.0))
        var loadMoreText = UILabel(frame: CGRectMake(0, 0, 116, 40))
        loadMoreText.text = "上拉显示更多数据"
        loadMoreText.font = UIFont(name: "Helvetica Neue", size: 14)
        tableFooterView.addSubview(loadMoreText)
        uiTableView.tableFooterView = tableFooterView
    }
    
    
    func goWenWenPageFromDjs(tap:UITapGestureRecognizer){
        toQid=tap.view!.tag
        self.sourceID=1
        self.performSegueWithIdentifier("wenwen", sender: self)
    }
    
    func goWenWenPageFromXbs(tap:UITapGestureRecognizer){
        toQid=tap.view!.tag
        self.sourceID=toQid
        self.performSegueWithIdentifier("wenwen", sender: self)
    }
    
    
    
    func goQaskDetail(tap:UIButton){
        toViewQid=tap.tag
        self.performSegueWithIdentifier("QaskDetail", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier=="QaskDetail" {
            var theSegue = segue.destinationViewController as QaskDetailController
            theSegue.qid = toViewQid
        }else{
            var theSegue = segue.destinationViewController as WenWenViewController
            var dele = UIApplication.sharedApplication().delegate as AppDelegate
            var user=dele.user
            if user != nil {
                theSegue.uid = user!.MemberID.toInt()
            }
            theSegue.qid = toQid
            theSegue.sourceid=self.sourceID
        }
    }
    
    func refreshData(){
        var dele = UIApplication.sharedApplication().delegate as AppDelegate
        var uid=0
        if !(dele.user==nil){
            uid = dele.user!.MemberID.toInt()!
        }
        
        if(xbShuoPageIndex==0){
            askList = UTIL.getQASKParticipant(主题下显示条数: 2, 每页数量: 10, 当前页码: xbShuoPageIndex++, 发送者id: uid)
        }else {
            askList.extend(UTIL.getQASKParticipant(主题下显示条数: 2, 每页数量: 10, 当前页码: xbShuoPageIndex++, 发送者id: uid))
        }
        
        _loadingMore = false
        createTableFooter()
        
        refreshControl.endRefreshing()
        
        arraylist.removeAll(keepCapacity: false)
        tempArray.removeAll(keepCapacity: false)
        //数据分组处理
        var count = 0
        for item in askList {
            if item.SourceID == 0 {
                tempAskList_L0.append(item)
                count++
            }
        }
        for item in tempAskList_L0 {
            tempArray.append(item)
            for li in askList {
                if li.SourceID == item.QASKID {
                    tempArray.append(li)
                }
            }
            arraylist.append(tempArray)
            tempArray.removeAll(keepCapacity: false)
        }
        uiTableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arraylist.count
        
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = xbShuoCell(frame:CGRectMake(0, 0, tableView.frame.width, 80))
        
        //println("Cellll width~~~~~:\(cell!.frame.width)")
        cell.configureCell(arraylist[indexPath.row])
        var replyGesture = UITapGestureRecognizer(target: self, action: Selector("goWenWenPageFromXbs:"))
        cell.replyBtn.userInteractionEnabled=true
        cell.replyBtn.addGestureRecognizer(replyGesture)
        cell.replyBtn.tag=arraylist[indexPath.row][0].QASKID
        
        if !(cell.replyBtn2==nil){
            cell.replyBtn2!.tag=arraylist[indexPath.row][0].QASKID
            cell.replyBtn2!.addTarget(self, action: Selector("goQaskDetail:"), forControlEvents: UIControlEvents.TouchUpInside)
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var lbl:UILabel = UILabel()
        lbl.numberOfLines = 0
        lbl.text = tempAskList_L0[indexPath.row].Content
        var content:NSString = lbl.text!
        var content0_size:CGSize = content.textSizeWithFont(lbl.font, constrainedToSize: CGSizeMake(tableView.frame.width-20,  CGFloat(MAXFLOAT)))
        
        var content0_H:CGFloat=0,content1_H:CGFloat=0,content2_H:CGFloat=0
        content0_H = content0_size.height + 141 //10+60+10+1+10+contentH+10+30+10
        if arraylist[indexPath.row].count==2 {
            var content1:NSString = arraylist[indexPath.row][1].Content
            var content1_size:CGSize = content1.textSizeWithFont(lbl.font, constrainedToSize: CGSizeMake(tableView.frame.width-90,  CGFloat(MAXFLOAT)))
            content1_H = content1_size.height + 50 //10+20+10+ContentH+10
        }
        
        if arraylist[indexPath.row].count==3 {
            var content1:NSString = arraylist[indexPath.row][1].Content
            var content1_size:CGSize = content1.textSizeWithFont(lbl.font, constrainedToSize: CGSizeMake(tableView.frame.width-90,  CGFloat(MAXFLOAT)))
            content1_H = content1_size.height + 50
            
            var content2:NSString = arraylist[indexPath.row][2].Content
            var content2_size:CGSize = content2.textSizeWithFont(lbl.font, constrainedToSize: CGSizeMake(tableView.frame.width-90,  CGFloat(MAXFLOAT)))
            content2_H = content2_size.height + 50 + 11 //5+departViewHeight+5
        }
        
        
        
        
        //CGSize labelsize = [nameLabel.text boundingRectWithSize:size options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        // 这句非常重要，设置真实的布局宽度
        //lbl.preferredMaxLayoutWidth = CGRectGetWidth(tableView.frame)
        //var size:CGSize = lbl.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
        //println("size.height:\(content0_size.height)")
        var tempH = 0
        if arraylist[indexPath.row].count == 3 {
            tempH = 20  //查看所有的高度
        }
        var tempTotalHeight=content0_H+content1_H+content2_H+CGFloat(tempH)
        println("totol Height:\(tempTotalHeight),")
        return tempTotalHeight
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 80
    }
    
}