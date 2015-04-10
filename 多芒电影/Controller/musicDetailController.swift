//
//  musicDetailController.swift
//  多芒电影
//
//  Created by junjian chen on 15/3/18.
//  Copyright (c) 2015年 珠影网络. All rights reserved.
//

import Foundation

class musicDetailController:  UIViewController, UITableViewDelegate, UITableViewDataSource,DataDelegate {
    @IBOutlet weak var mainContrainer: UIScrollView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var titleLbl: UILabel!

    @IBOutlet weak var movieImageView: UIImageView!

    @IBOutlet weak var collectionIcon: UIImageView!
    @IBOutlet weak var descView: UIView!
    @IBOutlet weak var descTitleLbl: UILabel!
    @IBOutlet weak var uiTableView: UITableView!
    @IBOutlet weak var goodTimsLbl: UILabel!
    @IBOutlet weak var collect_0: UIButton!
    
    var currentInfo:Model.BasicInfo=Model.BasicInfo()
    
    var mainScrollConstraintH:[AnyObject]?
    var webviewConstraintH:[AnyObject]?
    var musicData:Array<Array<String>>=Array<Array<String>>()
    var descHeight:CGFloat=0
    var isZanIng=false,isCollecting=false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setMusicData()
        uiTableView.delegate=self
        uiTableView.dataSource = self
        uiTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        uiTableView.scrollEnabled = false
        uiTableView.backgroundColor = UIColor.blueColor()
        descTitleLbl.text = currentInfo.Introduction
        println("content is :\(currentInfo.Introduction)")
        var content:NSString = descTitleLbl.text!
        descHeight = content.textSizeWithFont(descTitleLbl.font, constrainedToSize: CGSizeMake(screenWidth-16,  CGFloat(MAXFLOAT))).height+30
        
        initConstraint()
        
        
        titleLbl.text = currentInfo.Title
        
        //判断是否已赞，及设置赞次数
        if isBasicInfoZaned(currentInfo.InfoID) {
            goodTimsLbl.text = String(currentInfo.GoodTimes+1)
        }else if currentInfo.GoodTimes>0{
            goodTimsLbl.text = String(currentInfo.GoodTimes)
        }
        //判断是否已收藏，及设置收藏 icon
        if isBasicInfoCollected(currentInfo.InfoID) {
            collect_0.setImage(UIImage(named: "collection_color_1.png"), forState: UIControlState.Normal)
        }
        
        
        movieImageView.layer.masksToBounds = true
        movieImageView.layer.cornerRadius = movieImageView.bounds.size.height / 2
        movieImageView.layer.backgroundColor = UIColor.whiteColor().CGColor
        if currentInfo.PicURL.length()>0 && ((currentInfo.PicURL as NSString).containsString("http")){
            var imgURL = NSURL(string: currentInfo.PicURL)
            PLMImageCache.sharedInstance.imageForUrl(imgURL!, desiredImageSize: CGSizeMake(133, 133), contentMode: UIViewContentMode.Center) { (image) -> Void in
                //use image
                self.movieImageView.image = image
                self.movieImageView.contentMode = UIViewContentMode.ScaleToFill
            }
        }
    }
    
    func setMusicData(){
       var  tempMusicData = currentInfo.Content.componentsSeparatedByString("{}")
        for item in tempMusicData {
            var tempArray = item.componentsSeparatedByString("<>")
            if tempArray.count==2{
                musicData.append(tempArray)
            }
        }
        self.view.bounds = screenBounds
    }
    
    func initConstraint(){
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[mainContrainer(screenWidth)]-0-|", options: nil, metrics: ["screenWidth":screenWidth], views: ["mainContrainer":mainContrainer,"rootview":self.view]))
        mainContrainer.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[bg(screenWidth)]-0-|", options: nil, metrics: ["screenWidth":screenWidth], views: ["bg":headerView]))
        mainContrainer.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[descView(screenWidth)]-0-|", options: nil, metrics: ["screenWidth":screenWidth], views: ["descView":descView]))
        mainContrainer.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[tableView(screenWidth)]-0-|", options: nil, metrics: ["screenWidth":screenWidth], views: ["tableView":uiTableView]))
        
        var tableH = musicData.count*50
        
        //one time do all
        mainContrainer.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[bg(120)]-0-[descView(descHeight)]-0-[uiTableView(tableH)]-70-|", options: nil, metrics: ["descHeight":descHeight,"tableH":tableH], views: ["uiTableView":uiTableView,"descView":descView,"bg":headerView]))
        mainScrollConstraintH=NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[mainContrainer]-0-|", options: nil, metrics: nil, views: ["mainContrainer":mainContrainer])
        
        
        
        self.view.addConstraints(mainScrollConstraintH!)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return musicData.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell = musicPlayItem(frame: CGRectMake(0, 0, screenWidth, 25))
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.configCell(musicData[indexPath.row][0], playUrl: musicData[indexPath.row][1])
        
        var playBtn = cell.playIcon
        
        if (playBtn?.hidden != true) {
            playBtn?.tag = indexPath.row
            playBtn?.addTarget(self, action: "playTarget:", forControlEvents: UIControlEvents.TouchDown)
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 50
    }
    
    func playTarget(sender:UIButton){
        var loadWebController = LoadWebViewController()
        var playUrl = musicData[sender.tag][1]
        var title = musicData[sender.tag][0]

        loadWebController.titleText = title
        loadWebController.webAddress  = playUrl
        
        self.navigationController?.pushViewController(loadWebController, animated: true)
        
    }
    
    
    @IBAction func collectionAction(sender: AnyObject) {
        var dele = UIApplication.sharedApplication().delegate as! AppDelegate
        var user=dele.user
        if user != nil {
            if !isCollecting {
                isCollecting=true
                if isBasicInfoCollected(currentInfo.InfoID) {
                    API().exec(self, invokeIndex: 2, invokeType: "", methodName: "DeleteCollection", params: String(currentInfo.InfoID),user!.MemberID).loadData()
                }else{
                    API().exec(self, invokeIndex: 1, invokeType: "", methodName: "InsertCollection", params: String(currentInfo.InfoID),user!.MemberID).loadData()
                }
            }
        }else{
            showAlert()
        }
    }
    
    func showAlert(message:String="需要登录才能使用此功能"){
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
    
    @IBAction func shareFunc(sender: AnyObject) {
        
        //构造分享内容
        basicShareFunc(currentInfo)
        
    }
    
    @IBAction func goodFunc(sender: AnyObject) {
        println("good")
        
        if isBasicInfoZaned(currentInfo.InfoID) {
            UIAlertView(title: "", message: "已赞", delegate: nil, cancelButtonTitle: "确定").show()
            return
        }
        
        if !isZanIng {
            isZanIng=true
            API().exec(self, invokeIndex: 0, invokeType: "", methodName: "insertZanInfo", params: String(currentInfo.InfoID),"0").loadData()
        }
    }
    
    func invoke(index:Int,StringResult result:String){
        if index==0 {
            goodTimsLbl.text = String(currentInfo.GoodTimes+1)
            saveBasicZanInfoToLocal(currentInfo.InfoID)
        } else if index==1 {
            //添加收藏
            isCollecting = false
            collect_0.setImage(UIImage(named: "collection_color_1.png"), forState: UIControlState.Normal)
            saveBasicCollectionInfoToLocal(currentInfo.InfoID)
        } else if index==2 {
            //取消收藏
            isCollecting = false
            collect_0.setImage(UIImage(named: "collection_color_0.png"), forState: UIControlState.Normal)
            deleteBasicCollectionInfoToLocal(currentInfo.InfoID)
        }
        
    }
    func invoke(type:String,object:NSObject){
        
    }

}