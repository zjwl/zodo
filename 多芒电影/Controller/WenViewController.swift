//
//  WenViewController.swift
//  多芒电影
//
//  Created by 柴小红 on 15/2/13.
//  Copyright (c) 2015年 珠影网络. All rights reserved.
//

import UIKit

class WenViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var title_segment: UISegmentedControl!
    @IBOutlet weak var uiTableView: UITableView!
    @IBOutlet weak var askView: UIView!
    @IBOutlet weak var wenwenLbl: UILabel!
    
    var askList:Array<Model.QASK> = []
    var tempAskList_L0:Array<Model.QASK> = []
    //重组后的数据，用于不同Cell的输出，及调整cell高度
    var arraylist:Array<Array<Model.QASK>> = [[]]
    var tempArray:Array<Model.QASK> = []
    var refreshControl = UIRefreshControl()
    var tempCell:daJiaShuoCellCode = daJiaShuoCellCode()  //[self.tableView dequeueReusableCellWithIdentifier:@"C1"];
    var toQid:Int=0,sourceID:Int=1,toViewQid=0,dajiashuoPageIndex=0,xbShuoPageIndex=0
    var _loadingMore=false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets=false
        title_segment.addTarget(self, action:"segmentAction:", forControlEvents: UIControlEvents.ValueChanged)
        //title_segment.addTarget(self, action:, forControlEvents: UIControlEvents.TouchDown)
        // Do any additional setup after loading the view.
        var gesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("doAsk"))
        askView.userInteractionEnabled=true
        askView.addGestureRecognizer(gesture)
        
        
        refreshControl.addTarget(self, action: "refreshData", forControlEvents: UIControlEvents.ValueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "updtae thie data")
        self.uiTableView.addSubview(refreshControl)
        tempCell = NSBundle.mainBundle().loadNibNamed("daJiaShuoCell", owner: nil, options: nil).last as daJiaShuoCellCode
        
       
        
        // 设置tableView的数据源
        self.uiTableView!.dataSource=self
        // 设置tableView的委托
        self.uiTableView!.delegate = self
        self.uiTableView.separatorStyle = UITableViewCellSeparatorStyle.None
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
        println("comein")
        var dele = UIApplication.sharedApplication().delegate as AppDelegate
        if ((dele.isLogin != nil) && dele.isLogin!) {
            println("go wenwen,sender's tag:\(tap.view!.tag)")
            toQid=tap.view!.tag
            self.sourceID=1
            self.performSegueWithIdentifier("wenwen", sender: self)
        }else{
            showAlert()
        }
    }
    
    func goWenWenPageFromXbs(tap:UITapGestureRecognizer){
        var dele = UIApplication.sharedApplication().delegate as AppDelegate
        if ((dele.isLogin != nil) && dele.isLogin!) {
            println("go wenwen,sender's tag:\(tap.view!.tag)")
            toQid=tap.view!.tag
            self.sourceID=toQid
            self.performSegueWithIdentifier("wenwen", sender: self)
        }else{
            showAlert()
        }
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
    
    func doAsk(){
        if title_segment.selectedSegmentIndex == 1 {
            self.sourceID=0
        }
        else{
            self.sourceID=1
        }
        var dele = UIApplication.sharedApplication().delegate as AppDelegate
        if ((dele.isLogin != nil) && dele.isLogin!) {
            self.toQid=0
            self.performSegueWithIdentifier("wenwen", sender: self)
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
    
    func doLoginActions(action:UIAlertAction!){
        println("lgoin")
        self.tabBarController!.selectedIndex=2
        
    }
    func doCancelAction(action:UIAlertAction!){
        println("cancel")
    }
    
    func refreshData(){
        var dele = UIApplication.sharedApplication().delegate as AppDelegate
        var uid=0
        if !(dele.user==nil){
            uid = dele.user!.MemberID.toInt()!
        }
        if title_segment.selectedSegmentIndex == 1{
            if(xbShuoPageIndex==0){
                askList = UTIL.getQASKList(是否小编主题: false, 主题下显示条数: 2, 每页数量: 10, 当前页码: xbShuoPageIndex++, 发送者id: uid)//小编说
            }else {
                askList.extend(UTIL.getQASKList(是否小编主题: false, 主题下显示条数: 2, 每页数量: 10, 当前页码: xbShuoPageIndex++, 发送者id: uid))
            }
        }else{
            if dajiashuoPageIndex==0 {
                askList=UTIL.getEveryoneSayList(1, 每页数量: 10, 当前页码: dajiashuoPageIndex++, 发送者id: uid)
            }else{
                askList.extend(UTIL.getEveryoneSayList(1, 每页数量: 10, 当前页码: dajiashuoPageIndex++, 发送者id: uid))
            }
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func segmentAction(sender:NSObject){
        println("index is:\(title_segment.selectedSegmentIndex)")
       
        self.uiTableView.setContentOffset(CGPointMake(0, 0), animated: false)
        if title_segment.selectedSegmentIndex == 1 {
            wenwenLbl.text="问问小编"
            if self.uiTableView.tableHeaderView == nil {
                var headerView:UIView = UIView(frame: CGRectMake(0, 0, 100, 100))
                var laba:UIImageView=UIImageView(frame: CGRectMake(12, 0, 61, 32))
                laba.image=UIImage(named: "notice.png")
                
                var labelContent:UILabel = UILabel(frame: CGRectMake(10, laba.frame.origin.y+laba.frame.height, self.uiTableView.frame.width-20, 65))
                labelContent.textColor=UIColor.grayColor()
                labelContent.numberOfLines = 0
                labelContent.text = "《你问我答》是一个交流电影、答疑解惑的互动版块，请不要在这里发布任何形式的广告或软文，一经发现即刻删除，请大家共同维护良好的交流氛围。"
                labelContent.font=UIFont(name: "ArialUnicodeMS", size: 12)
                
                headerView.addSubview(laba)
                headerView.addSubview(labelContent)
                self.uiTableView.tableHeaderView = headerView //headerView
                
            }else {
                self.uiTableView.tableHeaderView?.frame = CGRectMake(0, 0, 100, 100)
                self.uiTableView.tableHeaderView?.hidden = false
            }
        } else {
            wenwenLbl.text="我要提问"
            self.uiTableView.tableHeaderView?.frame = CGRectMake(0, 0, 1, 1)
            self.uiTableView.tableHeaderView?.hidden = true
        }
        refreshData()
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  self.title_segment.selectedSegmentIndex == 0{
            return askList.count
        }else{
            return arraylist.count
        }
        
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if  self.title_segment.selectedSegmentIndex == 0{
            //cell标志符，使cell能够重用（如果不需要重用，是不是可以有更简单的配置方法？）
            let cellIdentifier:String = "daJiaShuoCell"
            // may be no value, so use optional
            var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? daJiaShuoCellCode
            
            if cell == nil { // no value
                //注册自定义cell到tableview中，并设置cell标识符为indentifier（nibName对应UItableviewcell xib的名字）
                var nib:UINib = UINib(nibName:"daJiaShuoCell", bundle: nil)
                tableView.registerNib(nib, forCellReuseIdentifier: cellIdentifier)
                //从tableview中获取标识符为papercell的cell
                cell = (tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as daJiaShuoCellCode)
                
            }
            //println("indexPath in main:\(indexPath.row)")
            let model: Model.QASK = askList[indexPath.row]
            
            cell!.configureCell(model,uid: 1)
            
            var replyGesture = UITapGestureRecognizer(target: self, action: Selector("goWenWenPageFromDjs:"))
            cell!.replyIcon.userInteractionEnabled=true
            cell!.replyIcon.addGestureRecognizer(replyGesture)
            cell!.replyIcon.tag=model.QASKID
            
            cell!.selectionStyle = UITableViewCellSelectionStyle.None
            return cell!
        }else{
            // may be no value, so use optional
            //            var cell: daJiaShuoCellCode? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? daJiaShuoCellCode
            //
            //            if cell == nil { // no value
            //                //注册自定义cell到tableview中，并设置cell标识符为indentifier（nibName对应UItableviewcell xib的名字）
            //                var nib:UINib = UINib(nibName:"daJiaShuoCell", bundle: nil)
            //                tableView.registerNib(nib, forCellReuseIdentifier: cellIdentifier)
            //                //从tableview中获取标识符为papercell的cell
            //                cell = (tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as daJiaShuoCellCode)
            //
            //            }
            
            //            var cell: daJiaShuoCellCode? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? daJiaShuoCellCode
            //            //注册自定义cell到tableview中，并设置cell标识符为indentifier（nibName对应UItableviewcell xib的名字）
            //            var nib:UINib = UINib(nibName:"daJiaShuoCell", bundle: nil)
            //            tableView.registerNib(nib, forCellReuseIdentifier: cellIdentifier)
            //            //从tableview中获取标识符为papercell的cell
            //            cell = (tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as daJiaShuoCellCode)
            
            
            
            //println("indexPath in main:\(indexPath.row)")
            //let model: Model.QASK? = tempAskList_L0[indexPath.row]
            
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
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if  self.title_segment.selectedSegmentIndex == 0{
            var lbl:UILabel = UILabel()
            lbl.numberOfLines = 0
            lbl.text = askList[indexPath.row].Content
            var content:NSString = lbl.text!
            var content0_size:CGSize = content.textSizeWithFont(lbl.font, constrainedToSize: CGSizeMake(tableView.frame.width-20,  CGFloat(MAXFLOAT)))
            
            
            return content0_size.height+160
        }else{
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
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 80
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        //var cell = tableView.cellForRowAtIndexPath(indexPath) as daJiaShuoCellCode
        
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
