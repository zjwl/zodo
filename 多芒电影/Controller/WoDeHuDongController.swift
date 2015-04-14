//
//  WoDeHuDongController.swift
//  多芒电影
//
//  Created by junjian chen on 15/4/2.
//  Copyright (c) 2015年 珠影网络. All rights reserved.
//

import Foundation

class WoDeHuDongController: UIViewController ,UITableViewDelegate, UITableViewDataSource, CommonAccessDelegate {
    var tempAskList_L0:Array<Model.QASK> = []
    var askList:Array<Model.QASK> = []
    //重组后的数据，用于不同Cell的输出，及调整cell高度
    var arraylistForXBS:Array<Array<Model.QASK>> = [[]]
    var tempArray:Array<Model.QASK> = []
    var refreshControl = UIRefreshControl()
    var toQid:Int=0,sourceID:Int=1,toViewQid=0,dajiashuoPageIndex=0,xbShuoPageIndex=0
    var _loadingMore=false,_isXBdataLoadOver=false
    var tableFooterActivityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    @IBOutlet weak var uiTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl.addTarget(self, action: "refreshData", forControlEvents: UIControlEvents.ValueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "松开更新信息")
        self.uiTableView.addSubview(refreshControl)
        tableFooterActivityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        // 设置tableView的数据源
        self.uiTableView!.dataSource=self
        // 设置tableView的委托
        self.uiTableView!.delegate = self
        arraylistForXBS.removeAll(keepCapacity: false)
        createTableFooter()
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
            tableFooterActivityIndicator.startAnimating()
            refreshData()
        }
    }
    
    
    // 创建表格底部
    func createTableFooter(){
        uiTableView.tableFooterView = nil
        var tableFooterView = UIView(frame: CGRectMake(0.0, 0.0, uiTableView.bounds.size.width, 40.0))
        tableFooterActivityIndicator.frame = CGRectMake((uiTableView.bounds.size.width-160)/2, 10.0, 20.0, 20.0)
        var loadMoreText = UILabel(frame: CGRectMake((uiTableView.bounds.size.width-120)/2, 5, 120, 30))
        
        if _isXBdataLoadOver {
            loadMoreText.text = "已加载完所有数据"
        }else{
            loadMoreText.text = "上拉显示更多数据"
        }
        
        loadMoreText.textColor = UIColor.grayColor()
        loadMoreText.textAlignment = NSTextAlignment.Center
        loadMoreText.font = UIFont(name: "Helvetica Neue", size: 14)
        tableFooterView.addSubview(tableFooterActivityIndicator)
        tableFooterView.addSubview(loadMoreText)
        uiTableView.tableFooterView = tableFooterView
        tableFooterActivityIndicator.stopAnimating()
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
            var theSegue = segue.destinationViewController as! QaskDetailController
            theSegue.qid = toViewQid
        }else{
            var theSegue = segue.destinationViewController as! WenWenViewController
            var dele = UIApplication.sharedApplication().delegate as! AppDelegate
            var user=dele.user
            if user != nil {
                theSegue.uid = user!.MemberID.toInt()
            }
            theSegue.qid = toQid
            theSegue.sourceid=self.sourceID
        }
    }
    
    func refreshData(){
        var dele = UIApplication.sharedApplication().delegate as! AppDelegate
        var uid=0
        if !(dele.user==nil) && (dele.user!.MemberID.length()>0){
            uid = dele.user!.MemberID.toInt()!
        }
        CommonAccess(delegate: self, flag: "xbs").getQASKParticipant(主题下显示条数: 2, 每页数量: 10, 当前页码: xbShuoPageIndex++, 发送者id: uid)
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        println("arraylistForXBS.count:\(arraylistForXBS.count)")
        return arraylistForXBS.count
        
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = xbShuoCell(frame:CGRectMake(0, 0, tableView.frame.width, 80))
        
        //println("Cellll width~~~~~:\(cell!.frame.width)")
        cell.configureCell(arraylistForXBS[indexPath.row])
        var replyGesture = UITapGestureRecognizer(target: self, action: Selector("goWenWenPageFromXbs:"))
        cell.replyBtn.userInteractionEnabled=true
        cell.replyBtn.addGestureRecognizer(replyGesture)
        cell.replyBtn.tag=arraylistForXBS[indexPath.row][0].QASKID
        
        if !(cell.replyBtn2==nil){
            cell.replyBtn2!.tag=arraylistForXBS[indexPath.row][0].QASKID
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
        if arraylistForXBS[indexPath.row].count==2 {
            var content1:NSString = arraylistForXBS[indexPath.row][1].Content
            var content1_size:CGSize = content1.textSizeWithFont(lbl.font, constrainedToSize: CGSizeMake(tableView.frame.width-90,  CGFloat(MAXFLOAT)))
            content1_H = content1_size.height + 50 //10+20+10+ContentH+10
        }
        
        if arraylistForXBS[indexPath.row].count==3 {
            var content1:NSString = arraylistForXBS[indexPath.row][1].Content
            var content1_size:CGSize = content1.textSizeWithFont(lbl.font, constrainedToSize: CGSizeMake(tableView.frame.width-90,  CGFloat(MAXFLOAT)))
            content1_H = content1_size.height + 50
            
            var content2:NSString = arraylistForXBS[indexPath.row][2].Content
            var content2_size:CGSize = content2.textSizeWithFont(lbl.font, constrainedToSize: CGSizeMake(tableView.frame.width-90,  CGFloat(MAXFLOAT)))
            content2_H = content2_size.height + 50 + 11 //5+departViewHeight+5
        }
        
        
        
        
        //CGSize labelsize = [nameLabel.text boundingRectWithSize:size options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        // 这句非常重要，设置真实的布局宽度
        //lbl.preferredMaxLayoutWidth = CGRectGetWidth(tableView.frame)
        //var size:CGSize = lbl.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
        //println("size.height:\(content0_size.height)")
        var tempH = 0
        if arraylistForXBS[indexPath.row].count == 3 {
            tempH = 20  //查看所有的高度
        }
        var tempTotalHeight=content0_H+content1_H+content2_H+CGFloat(tempH)
        println("totol Height:\(tempTotalHeight),")
        return tempTotalHeight
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 80
    }
    
    func setCallbackObject(flag: String, object: NSObject) {
        var asklistTemp = object as! Array<Model.QASK>
        
        if asklistTemp.count==0 {
            _isXBdataLoadOver = true
        }else{
            _isXBdataLoadOver = false
        }
        if(xbShuoPageIndex==0){
            askList = asklistTemp //小编说
        }else {
            if asklistTemp.count>0{
                askList.extend(asklistTemp)
            }
        }
        
        arraylistForXBS.removeAll(keepCapacity: false)
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
            arraylistForXBS.append(tempArray)
            tempArray.removeAll(keepCapacity: false)
        }
        if asklistTemp.count>0{
            uiTableView.reloadData()
        }
        _loadingMore = false
        createTableFooter()
        refreshControl.endRefreshing()
    }
    
}