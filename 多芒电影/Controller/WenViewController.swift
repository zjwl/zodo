//
//  WenViewController.swift
//  多芒电影
//
//  Created by 柴小红 on 15/2/13.
//  Copyright (c) 2015年 珠影网络. All rights reserved.
//

import UIKit

class WenViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource, CommonAccessDelegate {
    
    @IBOutlet weak var title_segment: UISegmentedControl!
    @IBOutlet weak var uiTableView: UITableView!
    @IBOutlet weak var askView: UIView!
    @IBOutlet weak var wenwenLbl: UILabel!
    var askList:Array<Model.QASK> = []
    var tempAskList_L0:Array<Model.QASK> = []
    //重组后的数据，用于不同Cell的输出，及调整cell高度
    var arraylistForXBS:Array<Array<Model.QASK>> = [[]]
    var tempArray:Array<Model.QASK> = []
    var refreshControl = UIRefreshControl()
    var tableFooterActivityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    var tempCell:daJiaShuoCellCode = daJiaShuoCellCode()  //[self.tableView dequeueReusableCellWithIdentifier:@"C1"];
    var toQid:Int=0,sourceID:Int=1,toViewQid=0,dajiashuoPageIndex=0,xbShuoPageIndex=0
    var _loadingMore=false,_isXBdataLoadOver=false,_isDJSdataLoadOver=false
    
    
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
        refreshControl.attributedTitle = NSAttributedString(string: "松开更新信息")
        self.uiTableView.addSubview(refreshControl)
        tempCell = NSBundle.mainBundle().loadNibNamed("daJiaShuoCell", owner: nil, options: nil).last as! daJiaShuoCellCode
        
       tableFooterActivityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        
        // 设置tableView的数据源
        self.uiTableView!.dataSource=self
        // 设置tableView的委托
        self.uiTableView!.delegate = self
        self.uiTableView.separatorStyle = UITableViewCellSeparatorStyle.None
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
//            var tableFooterActivityIndicator:UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(75, 10, 20, 20))
//            tableFooterActivityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
//            tableFooterActivityIndicator.startAnimating()
//            uiTableView.addSubview(tableFooterActivityIndicator)
            
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
        
        if title_segment.selectedSegmentIndex == 0{
            if _isDJSdataLoadOver {
                loadMoreText.text = "已加载完所有数据"
            }else{
                loadMoreText.text = "上拉显示更多数据"
            }
        }else{
            if _isXBdataLoadOver {
                loadMoreText.text = "已加载完所有数据"
            }else{
                loadMoreText.text = "上拉显示更多数据"
            }
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
        println("comein")
       
        if  user.IsLogin {
            println("go wenwen,sender's tag:\(tap.view!.tag)")
            toQid=tap.view!.tag
            self.sourceID=1
            self.performSegueWithIdentifier("wenwen", sender: self)
        }else{
            showAlert()
        }
    }
    
    func goWenWenPageFromXbs(tap:UITapGestureRecognizer){
      
        if   user.IsLogin  {
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
    
    func doAsk(){
        if title_segment.selectedSegmentIndex == 1 {
            self.sourceID=0
        }
        else{
            self.sourceID=1
        }
      
        if   user.IsLogin  {
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
        var dele = UIApplication.sharedApplication().delegate as! AppDelegate
        var uid=0
        if !(dele.user==nil) && (dele.user!.MemberID.length()>0){
            uid = dele.user!.MemberID.toInt()!
        }
        if title_segment.selectedSegmentIndex == 1{
            CommonAccess(delegate: self, flag: "xbs").getQASKList(是否小编主题: false, 主题下显示条数: 2, 每页数量: 10, 当前页码: xbShuoPageIndex++, 发送者id: uid)//小编说
            
        }else{
            CommonAccess(delegate: self, flag: "djs").getEveryoneSayList(1, 每页数量: 10, 当前页码: dajiashuoPageIndex++, 发送者id: uid)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func segmentAction(sender:NSObject){
        println("index is:\(title_segment.selectedSegmentIndex)")
        tableFooterActivityIndicator.startAnimating()
        dajiashuoPageIndex=0
        xbShuoPageIndex=0
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
        askList.removeAll(keepCapacity: false)
        arraylistForXBS.removeAll(keepCapacity: false)
        tempArray.removeAll(keepCapacity: false)
        
        self.uiTableView.reloadData()
        //self.uiTableView.selectRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), animated: false, scrollPosition: UITableViewScrollPosition.Top)
        //arraylistForXBS.removeAll(keepCapacity: false)
        refreshData()
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  self.title_segment.selectedSegmentIndex == 0{
            return askList.count
        }else{
            return arraylistForXBS.count
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
                cell = (tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! daJiaShuoCellCode)
                
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
            lbl.font = UIFont(name: "ArialUnicodeMS", size: 15)
            var content:NSString = lbl.text!
            var content0_size:CGSize = content.textSizeWithFont(lbl.font, constrainedToSize: CGSizeMake(screenWidth-20,  CGFloat(MAXFLOAT)))
            
            var content0_H:CGFloat=0,content1_H:CGFloat=0,content2_H:CGFloat=0
            content0_H = content0_size.height + 141 //10+60+10+1+10+contentH+10+30+10
            if arraylistForXBS[indexPath.row].count==2 {
                var content1:NSString = arraylistForXBS[indexPath.row][1].Content
                var lbl1:UILabel = UILabel()
                lbl1.numberOfLines = 0
                var tempcontentwidth = IS_IPHONE_6P ? screenWidth - 100 : screenWidth - 90
                
                var content1_size:CGSize = content1.textSizeWithFont(lbl1.font, constrainedToSize: CGSizeMake(tempcontentwidth,  CGFloat(MAXFLOAT)))
                content1_H = content1_size.height + 50 //10+20+10+ContentH+10
            }
            
            if arraylistForXBS[indexPath.row].count==3 {
                var content1:NSString = arraylistForXBS[indexPath.row][1].Content
                var lbl2:UILabel = UILabel()
                lbl2.numberOfLines = 0
                var tempcontentwidth = IS_IPHONE_6P ? screenWidth - 100 : screenWidth - 90
                var content1_size:CGSize = content1.textSizeWithFont(lbl2.font, constrainedToSize: CGSizeMake(tempcontentwidth,  CGFloat(MAXFLOAT)))
                content1_H = content1_size.height + 50
                
                var lbl3:UILabel = UILabel()
                lbl3.numberOfLines = 0
                var content2:NSString = arraylistForXBS[indexPath.row][2].Content
                var content2_size:CGSize = content2.textSizeWithFont(lbl3.font, constrainedToSize: CGSizeMake(tempcontentwidth,  CGFloat(MAXFLOAT)))
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
            var iphone6puls:CGFloat=0
            if IS_IPHONE_6P {
                iphone6puls = 30
            }
            var tempTotalHeight=content0_H+content1_H+content2_H+CGFloat(tempH)+iphone6puls
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
    
    func setCallbackObject(flag: String, object: NSObject) {
        var asklistTemp = object as! Array<Model.QASK>
        
        if flag == "xbs"{
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
        }else{
            if asklistTemp.count==0 {
                _isDJSdataLoadOver = true
            }else{
                _isDJSdataLoadOver = false
            }
            if(dajiashuoPageIndex==0){
                askList = asklistTemp //大家说
            }else {
                if asklistTemp.count>0{
                    askList.extend(asklistTemp)
                }
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
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
