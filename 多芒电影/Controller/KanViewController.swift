//
//  KanViewController.swift
//  多芒电影
//
//  Created by 柴小红 on 15/2/13.
//  Copyright (c) 2015年 珠影网络. All rights reserved.
//

import UIKit

class KanViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource ,UIScrollViewDelegate{
    
    @IBOutlet var scwv: UIScrollView!
    @IBOutlet weak var uiTableView: UITableView!
    
    var specalLabes:Array<Model.SpecilLabel> = [] //特殊标签列表
    
    @IBOutlet var columnName: UILabel!
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
        self.initConstraint()
        self.setScollViewValues()
        
        refreshControl.attributedTitle = NSAttributedString(string: "松开更新信息")
        refreshControl.addTarget(self, action: "refreshData", forControlEvents: UIControlEvents.ValueChanged)
        uiTableView.addSubview(refreshControl)
        refreshData()
        
        uiTableView.dataSource = self
        uiTableView.delegate = self
    }
    
    func initConstraint(){
        self.view.frame=CGRectMake(0, 0, screenWidth, screenHeight)
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[scwv(screenWidth)]-0-|", options: nil, metrics: ["screenWidth":screenWidth], views: ["scwv":self.scwv]))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-60-[scwv(32)]", options: nil, metrics: ["screenWidth":screenWidth], views: ["scwv":self.scwv]))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-95-[columnName(25)]", options: nil, metrics: ["screenWidth":screenWidth], views: ["columnName":self.columnName]))
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[uiTableView(screenWidth)]-0-|", options: nil, metrics: ["screenWidth":screenWidth], views: ["uiTableView":self.uiTableView]))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-123-[uiTableView]-0-|", options: nil, metrics: ["screenWidth":screenWidth], views: ["uiTableView":self.uiTableView]))
    }
    
    func refreshData() {
        basicList = UTIL.getLlatestUpdate(栏目id: 1, 特殊标签id: currentLableID, 每页数量: 20, 当前页码: currentPage)
        uiTableView.reloadData()
        refreshControl.endRefreshing()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        scwv.contentSize = CGSize(width: 704, height: 32)
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
    func setScollViewValues(){
        specalLabes = UTIL.getSpecilLabel()
        var labelitems:Dictionary<Int,String> = [0:"icon_tsbq_0_zxtj",20:"icon_tsbq_0_dmfx",11:"icon_tsbq_1_bmh",12:"icon_tsbq_2_znl",13:"icon_tsbq_3_gzs",14:"icon_tsbq_4_dmx",15:"icon_tsbq_5_wlt",16:"icon_tsbq_6_zqc",17:"icon_tsbq_7_xhh",18:"icon_tsbq_8_ash",19:"icon_tsbq_9_dsj"]
        
        var btn     = UIButton(frame: CGRect(x: 0,y:0,width: 64,height: 32))
        var imv     = UIImageView(frame: btn.bounds) //创建一个UIimageView（v_headerImageView）
        imv.image   = UIImage(named: "icon_tsbq_0_zxtj") //给ImageView设置图片
        
        btn.addSubview(imv)
        btn.tag = 0
        btn.addTarget(self, action:"buttonPress:", forControlEvents: UIControlEvents.TouchDown)
        scwv.addSubview(btn)
        
        
        btn     = UIButton(frame: CGRect(x: 64,y:0,width: 64,height: 32))
        imv     = UIImageView(frame: btn.bounds) //创建一个UIimageView（v_headerImageView）
        imv.image   = UIImage(named: "icon_tsbq_0_dmfx") //给ImageView设置图片
        
        btn.addSubview(imv)
        btn.tag = 20
        btn.addTarget(self, action:"buttonPress:", forControlEvents: UIControlEvents.TouchDown)
        scwv.addSubview(btn)
        
        for item in specalLabes {
            var value = labelitems[item.LabelID]
            var pointx:Int
            if(item.LabelID == 20) {
                return
            } else {
                pointx = 64 * (item.LabelID - 9 )
            }
            var btn1     = UIButton(frame: CGRect(x: pointx, y: 0, width: 64, height: 32))
            var imv1     = UIImageView(frame: btn1.bounds) //创建一个UIimageView（v_headerImageView）
            imv1.image   = UIImage(named: value!) //给ImageView设置图片
            
            btn1.addSubview(imv1)
            btn1.tag = item.LabelID
            //  println(btn1)
            btn1.addTarget(self, action:"buttonPress:", forControlEvents: UIControlEvents.TouchDown)
            scwv.addSubview(btn1)
            
        }
        
    }
    
    
    func playTarget(sender:UIButton){
        var loadWebController = LoadWebViewController()
        
        for item in basicList {
            if item.InfoID == sender.tag {
                loadWebController.titleText = item.Title
                loadWebController.webAddress  = item.LinkUrl
            }
        }
        
        self.navigationController?.pushViewController(loadWebController, animated: true)
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return basicList.count
    }
    
    func buttonPress(sender:UIButton){
        currentPage = 0
        currentLableID = sender.tag
        
        
        var labelName = "最新推荐"
        
        if currentLableID == 20 {
            labelName = "多芒发行"
        }
        
        for item in specalLabes {
            if item.LabelID == sender.tag {
                labelName = item.LabelName
            }
        }
        columnName.text = labelName
        
        basicList = UTIL.getLlatestUpdate(栏目id: 1, 特殊标签id: currentLableID, 每页数量: 20, 当前页码: currentPage)
        uiTableView.reloadData()
        self.uiTableView.setContentOffset(CGPoint(x: 0,y: 0), animated: true)
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
            playBtn?.tag = model!.InfoID
            playBtn?.addTarget(self, action: "playTarget:", forControlEvents: UIControlEvents.TouchDown)
        }
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
