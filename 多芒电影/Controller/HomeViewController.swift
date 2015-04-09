//
//  homeController.swift
//  多芒电影
//
//  Created by 柴小红 on 15/1/13.
//  Copyright (c) 2015年 珠影网络. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController,UITableViewDelegate, UITableViewDataSource ,UIScrollViewDelegate {
    
    @IBOutlet weak var uiTableView: UITableView!
    
    var basicList:Array<Model.BasicInfo> = []
    var currentIndexPath: NSIndexPath?
    var scwv:UIScrollView?
    var pageControl: UIPageControl?
    var timer:NSTimer!
    var singleFingerOne:UITapGestureRecognizer?
    var refreshControl = UIRefreshControl()
    var isSetNickName = false
    var rect = UIScreen.mainScreen().bounds
    var currentClickModel:Model.BasicInfo?
    
    
    override func viewDidLoad() {
        
        
        
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
        MobClick.startWithAppkey("54c8911dfd98c517bc0003ab", reportPolicy: BATCH, channelId: "多芒网")
        
        
        refreshControl.attributedTitle = NSAttributedString(string: "松开更新信息")
        refreshControl.addTarget(self, action: "refreshData", forControlEvents: UIControlEvents.ValueChanged)
        uiTableView.addSubview(refreshControl)
        refreshData()
        //    API().exec(self, invokeIndex: 0, invokeType: "qList", methodName: "GetQASKList", params: "true","3","10","0","0").loadData()
        
        // topView.frame = CGRect(x: 0, y: 0, width: 320, height: 200)
        // self.uiTableView=UITableView(frame:self.view.frame,style:UITableViewStyle.Plain)
        // 设置tableView的数据源
        self.uiTableView!.dataSource=self
        // 设置tableView的委托
        self.uiTableView.delegate = self
        
        setTableViewHeader()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        if !isSetNickName {
            var dele = UIApplication.sharedApplication().delegate as AppDelegate
            if dele.isLogin != nil && dele.isLogin == true {
                self.tabBarController?.selectedIndex = 2
                self.tabBarController!.selectedViewController?.tabBarItem.title = dele.user?.NickName
                self.tabBarController?.selectedIndex = 0
            }
            isSetNickName = true
        }
        
        setMianZhe()
    }
    
    func refreshData() {
        basicList = UTIL.getLlatestUpdate(栏目id: 0, 特殊标签id: 0, 每页数量: 20, 当前页码: 0)
        uiTableView.reloadData()
        refreshControl.endRefreshing()
        
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
        var cell: UIControl.basicInfolistView? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? UIControl.basicInfolistView
        
        if cell == nil { // no value
            cell = UIControl.basicInfolistView(style: UITableViewCellStyle.Default, reuseIdentifier: cellIdentifier)
        }
        
        let model: Model.BasicInfo = basicList[indexPath.row]
        // cell?.frame = CGRect(x: 0, y: 0, width: 320, height: 100)
        cell!.configureCell(model)
        
        var gesture = UITapGestureRecognizer(target: self, action: Selector("goDetail"))
        cell!.addGestureRecognizer(gesture)
        
        var playBtn = cell?.playBtn
        
        if (playBtn?.hidden != true) {
            playBtn?.tag = model.InfoID
            playBtn?.addTarget(self, action: "playTarget:", forControlEvents: UIControlEvents.TouchDown)
        }
        cell!.tag = indexPath.row
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        var cell = uiTableView.cellForRowAtIndexPath(indexPath) as UIControl.basicInfolistView
        
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
    
    func goDetail(tap:UIView){
        
        currentClickModel = basicList[tap.tag]
        var identifier="home2dy"
        switch currentClickModel!.ColumnID {
        case 1:
            identifier="home2dy"
        case 2:
            identifier="home2yp"
        case 4:
            identifier="home2yy"
        case 5:
            identifier="home2dp"
        case 6:
            identifier="home2yp"
        default:
            identifier="home2yp"
        }
        self.performSegueWithIdentifier(identifier, sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if currentClickModel == nil {
            return
        }
        switch currentClickModel!.ColumnID {
        case 1:
            var theSegue = segue.destinationViewController as movieDetailController
            theSegue.currentInfo = currentClickModel!
        case 2:
            var theSegue = segue.destinationViewController as ypDetailController
            theSegue.currentInfo = currentClickModel!
        case 4:
            var theSegue = segue.destinationViewController as musicDetailController
            theSegue.currentInfo = currentClickModel!
        case 5:
            var theSegue = segue.destinationViewController as ypDetailController
            theSegue.currentInfo = currentClickModel!
        case 6:
            var theSegue = segue.destinationViewController as ypDetailController
            theSegue.currentInfo = currentClickModel!
        default:
            var tt=32
        }
        
    }
    
    func setTableViewHeader(){
        
        //println(rect)
        // 6p (0.0,0.0,414.0,736.0)
        // 6 (0.0,0.0,375.0,667.0)
        // 5S (0.0,0.0,320.0,568.0)
        var bili = rect.width / 320.0
        var addPart = 125.0 * (bili-1)
        
        var v_headerView = UIView(frame: CGRect(x: 0.0,y: 0.0,width: 320.0 * bili ,height: 360.0 + addPart ))  //创建一个视图（v_headerView）
        
        func getTag(str:String) ->Int {
            switch str{
            case "icon_kan":
                return 0
            case "icon_du":
                return 1
            case "icon_ting":
                return 2
            case "icon_yu":
                return 3
            case "icon_wan":
                return 4
            case "icon_wen":
                return 5
            case "icon_yi" :
                return 6
            default:
                return 7
            }
        }
        
        
        var jianJu = (rect.width - 196) / 5
        var dianYuan = ( jianJu + 49.0 )
        
        var dict = ["icon_kan": CGRect(x: jianJu, y: 20.0, width: 49.0, height: 71.0),
            "icon_du":  CGRect(x: jianJu+dianYuan, y: 20.0, width: 49.0, height: 71.0),
            "icon_ting":CGRect(x: jianJu+dianYuan * 2, y: 20.0, width: 49.0, height: 71.0),
            "icon_yu":  CGRect(x: jianJu+dianYuan * 3, y: 20.0, width: 49.0, height: 71.0),
            "icon_wan": CGRect(x: jianJu, y: 110.0, width: 49.0, height: 71.0),
            "icon_wen": CGRect(x: jianJu+dianYuan, y: 110.0, width: 49.0, height: 71.0),
            "icon_yi":  CGRect(x: jianJu+dianYuan * 2, y: 110.0, width: 49.0, height: 71.0),
            "icon_yue": CGRect(x: jianJu+dianYuan * 3, y: 110.0, width: 49.0, height: 71.0)]
        
        var tag = 0
        for (key,value) in dict {
            var btn     = UIButton(frame: value)
            var imv     = UIImageView(frame: btn.bounds) //创建一个UIimageView（v_headerImageView）
            imv.image   = UIImage(named: key) //给ImageView设置图片
            
            btn.addSubview(imv)
            btn.tag = getTag(key)
            tag += 1
            
            btn.addTarget(self, action:"buttonPress:", forControlEvents: UIControlEvents.TouchDown)
            v_headerView.addSubview(btn)//将btn添加到创建的视图（v_headerView）中
        }
        
        
        scwv = UIScrollView(frame: CGRect(x: 0,y: 200,width: 320*bili,height: 125 * bili))
        
        scwv!.showsHorizontalScrollIndicator = false
        v_headerView.addSubview(scwv!)//将v_headerImageView添加到创建的视图（v_headerView）中
        var hejiList = UTIL.getFilmAlbum(每页数量: 4, 当前页码: 0)
        let imageW:CGFloat = 320.0 * bili
        let imageH:CGFloat = 125.0 * bili
        var imageY:CGFloat = 0;
        var totalCount = hejiList.count
        var webSite = ""
        
        for index in 0..<totalCount{
            let imageX:CGFloat = CGFloat(index) * imageW
            var btn = UIButton(frame: CGRect(x: imageX, y: imageY, width: imageW, height: imageH))
            var imageView:UIImageView = UIImageView(frame: btn.bounds)
            
            var photo = hejiList[index].ThePhoto
            if photo.has("ueditor") {
                webSite =  "http://apk.zdomo.com"
            }else {
                webSite = "http://apk.zdomo.com/ueditor/net/"
            }
            
            var url = (webSite + photo).stringByReplacingOccurrencesOfString(".jpg", withString: "_133.jpg", options: NSStringCompareOptions.CaseInsensitiveSearch)
            url = url.stringByReplacingOccurrencesOfString(".png", withString: "_133.png", options: NSStringCompareOptions.CaseInsensitiveSearch)
            
            println("home:"+url)
            var imgURL = NSURL(string: url)
            /*var data = NSData(contentsOfURL:imgURL!)
            var image = UIImage(data:data!, scale: 1.0)
            imageView.image = image*/
            
            PLMImageCache.sharedInstance.imageForUrl(imgURL!, desiredImageSize: CGSize(width: 133, height: 133), contentMode: UIViewContentMode.Center) { (image) -> Void in
                //use image
                if !(image == nil) {
                    imageView.image = image
                }
                
            }
            
            btn.addSubview(imageView)
            btn.tag = tag + index
            btn.addTarget(self, action:"goHeJi", forControlEvents: UIControlEvents.TouchDown)
            
            var hjLbl = UILabel()
            hjLbl.frame = CGRect(x: imageX, y: imageH-20.0, width: rect.width * 0.8 , height: 20.0)
            //   hjLbl.backgroundColor = UIColor.grayColor()//设置v_headerLab的背景颜色
            hjLbl.backgroundColor = UIColor(red: 0.2, green: 0.4, blue: 0.6, alpha: 0.6)
            hjLbl.textColor = UIColor.whiteColor()//设置v_headerLab的字体颜色
            hjLbl.font =  UIFont(name: "Arial", size: 13) //设置v_headerLab的字体样式和大小
           // hjLbl.shadowColor = UIColor.grayColor()//设置v_headerLab的字体的投影
            hjLbl.text = "   合集:\(hejiList[index].Title)"
            
            
            scwv!.addSubview(btn)
            scwv!.addSubview(hjLbl)
            
            
            
        }
        let contentW:CGFloat = imageW * CGFloat(totalCount)
        scwv!.contentSize = CGSizeMake(contentW, 0)
        scwv!.pagingEnabled = true
        scwv!.delegate = self
        
        pageControl = UIPageControl(frame: CGRect(x: rect.width * 0.8 + 10, y: 181 + imageH, width: rect.width * 0.2 - 20.0, height: 20))
        pageControl?.currentPageIndicatorTintColor = UIColor.redColor()
        self.view.addSubview(pageControl!)
        
        self.pageControl!.numberOfPages = totalCount
        //  self.pageControl!.backgroundColor = UIColor.purpleColor()
        self.addTimer()
        
        var v_headerLab = UILabel(frame: CGRect(x: 10.0,y: addPart + 325,width: UIScreen.mainScreen().bounds.size.width-20 ,height: 30.0)) //创建一个UILable（v_headerLab）用来显示标题
        v_headerLab.backgroundColor = UIColor.clearColor()//设置v_headerLab的背景颜色
        v_headerLab.textColor = UIColor.grayColor()//设置v_headerLab的字体颜色
        v_headerLab.font =  UIFont(name: "Arial", size: 13) //设置v_headerLab的字体样式和大小
        //v_headerLab.shadowColor = UIColor.whiteColor()//设置v_headerLab的字体的投影
        v_headerLab.text = "最新更新";
        
        var currentTime = UILabel(frame:  CGRect(x: (UIScreen.mainScreen().bounds.size.width - 120 ) / 2  ,y: 0,width: 120.0 ,height: 30.0))
        var dateformat = NSDateFormatter()
        dateformat.dateFormat = "yyyy年MM月dd日"
        currentTime.text =  dateformat.stringFromDate(NSDate())
        currentTime.textColor = UIColor.grayColor()//设置v_headerLab的字体颜色
        currentTime.font =  UIFont(name: "Arial", size: 13) //设置字体样式和大小
        v_headerLab.addSubview(currentTime)
        
        var rightImageBtn = UIButton(frame: CGRect(x: UIScreen.mainScreen().bounds.size.width - 40 , y: 5, width: 20, height: 20))
        rightImageBtn.setImage(UIImage(named: "refresh"), forState: UIControlState.Normal)
        rightImageBtn.addTarget(self, action: "refreshData:", forControlEvents: UIControlEvents.TouchDown)
         v_headerLab.addSubview(rightImageBtn)
        
        
        v_headerView.addSubview(v_headerLab)//将标题v_headerLab添加到创建的视图（v_headerView）中
        
        var view = UIView(frame: CGRect(x: 0,y: addPart+355,width: UIScreen.mainScreen().bounds.size.width,height: 0.3))
        view.backgroundColor = UIColor(red: 0.2, green: 0.4, blue: 0.6, alpha: 0.6)
        v_headerView.addSubview(view)
        
        self.uiTableView.tableHeaderView = v_headerView
        
    }
    
    func goHeJi(){
        self.performSegueWithIdentifier("hejiList", sender: self)
    }
    
    
    func nextImage(sender:AnyObject!){
        var page:Int = self.pageControl!.currentPage;
        if(page == 3){
            page = 0;
        }else{
            ++page;
        }
        let x:CGFloat = CGFloat(page) * scwv!.frame.size.width;
        scwv!.contentOffset = CGPointMake(x, 0);
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let scrollviewW:CGFloat = scwv!.frame.size.width;
        let x:CGFloat = scwv!.contentOffset.x;
        let page:Int = (Int)((x + scrollviewW / 2) / scrollviewW);
        self.pageControl!.currentPage = page;
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.removeTimer();
    }
    
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.addTimer();
    }
    
    
    func addTimer(){
        self.timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "nextImage:", userInfo: nil, repeats: true);
        NSRunLoop.currentRunLoop().addTimer(self.timer, forMode: NSRunLoopCommonModes);
    }
    
    func removeTimer(){
        self.timer.invalidate();
        
    }
    
    func buttonPress(sender:UIButton){
        
        switch sender.tag {
        case 0:
            self.performSegueWithIdentifier("UIKan", sender: self)
            // self.presentViewController(KanViewController(), animated: true, completion: nil)
        case 1:
            self.performSegueWithIdentifier("UIDu", sender: self)
        case 2:
            self.performSegueWithIdentifier("UITing", sender: self)
        case 3:
            self.performSegueWithIdentifier("UIYu", sender: self)
        case 4:
            self.performSegueWithIdentifier("UIWan", sender: self)
        case 5:
            self.performSegueWithIdentifier("UIWen", sender: self)
        case 6:
            self.performSegueWithIdentifier("UIYi", sender: self)
        case 7:
            self.performSegueWithIdentifier("UIYue", sender: self)
        default:
            var bill = 13
           // self.presentViewController(WebiewController(), animated: true, completion: nil)
        }
    }
    
    
    
    
    func setMianZhe(){
        
        
        var userDefaults = NSUserDefaults.standardUserDefaults()
        
        var mianzhe = userDefaults.boolForKey("mianzhe")
        
        if (mianzhe) {
            return
        }
        
        
        
        var alertController = UIAlertController(title: "免责声明", message: "你将开始使用多芒电影的服务，继续使用表明您同意关于多芒电影功能的相关声明。", preferredStyle: UIAlertControllerStyle.Alert)
        
        var okAction = UIAlertAction(title: "同意", style: UIAlertActionStyle.Default) {
            (action: UIAlertAction!) -> Void in
            userDefaults.setBool(true, forKey: "mianzhe")
        }
        
        var seeAction = UIAlertAction(title: "查看声明", style: UIAlertActionStyle.Default) {
            (action: UIAlertAction!) -> Void in
            var loadWebController = LoadWebViewController()
            loadWebController.titleText = "免责声明"
            loadWebController.webAddress  = "mianzhe"
            self.navigationController?.pushViewController(loadWebController, animated: true)
        }
        
        
        var cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
        
        alertController.addAction(cancelAction)
        alertController.addAction(seeAction)
        alertController.addAction(okAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    

    
    /*
    func invoke(index:Int,StringResult result:String){
    switch index
    {
    case 0:
    println(0)
    case 1:
    println(1)
    default :
    println(2)
    }
    
    println(result)
    //  helloWorld.text = result
    }
    
    func invoke(type: String, object: NSObject) {
    //        switch type{
    //        case "a":
    //            println(type)
    //        case "b":
    //            println(type)
    //        default:
    //            break
    //        }
    var gameList:QaskList = object as QaskList
    var str:String = "type:\(type),"
    for item:Qask in gameList.list{
    str += item.NickName + ","
    }
    print(str)
    }
    */
    
}