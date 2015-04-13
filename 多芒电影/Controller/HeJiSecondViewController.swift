//
//  HeJiSecondViewController.swift
//  多芒电影
//
//  Created by 柴小红 on 15/2/13.
//  Copyright (c) 2015年 珠影网络. All rights reserved.
//

import UIKit

class HeJiSecondViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate, DataDelegate, CommonAccessDelegate {
    

    @IBOutlet weak var uiTableView: UITableView!
    var colors:Array<UIColor> = []
    var hejiID:Int=0
    var basicList:Array<Model.BasicInfo> = [] //影片信息列表
    var currentInfo:Model.BasicInfo=Model.BasicInfo()
    var titleString:String?,descString:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        colors.append(UIColor(red: 51/255, green: 170/255, blue: 138/255, alpha: 1))
        colors.append(UIColor(red: 72/255, green: 147/255, blue: 205/255, alpha: 1))
        colors.append(UIColor(red: 237/255, green: 126/255, blue: 1107/255, alpha: 1))
        colors.append(UIColor(red: 230/255, green: 171/255, blue: 41/255, alpha: 1))
        colors.append(UIColor(red: 161/255, green: 88/255, blue: 205/255, alpha: 1))
        colors.append(UIColor(red: 116/255, green: 170/255, blue: 24/255, alpha: 1))
        colors.append(UIColor(red: 126/255, green: 114/255, blue: 100/255, alpha: 1))
        colors.append(UIColor(red: 246/255, green: 89/255, blue: 58/255, alpha: 1))
        self.uiTableView.delegate=self
        self.uiTableView.dataSource=self
        
        
        
        var titleLbl:UILabel = UILabel(frame:CGRectMake(20, 15, uiTableView.frame.width-30, 30))
        
        var title_size:CGSize = titleString!.textSizeWithFont(titleLbl.font, constrainedToSize: CGSizeMake(titleLbl.frame.width,  CGFloat(MAXFLOAT)))
        var departV = UIView(frame: CGRectMake(10, 10, 2, title_size.height+10))
        titleLbl.frame.size =  title_size
        titleLbl.numberOfLines=0
        departV.backgroundColor=UIColor.whiteColor()
        titleLbl.textColor=UIColor.whiteColor()
        
        var colorIndex = random() % colors.count
        
        
        //根据字 自动调整高度
        var descLbl = UILabel(frame: CGRectMake(10, departV.frame.origin.y+departV.frame.height+10, uiTableView.frame.width-20, 80))
        var content_size:CGSize = descString!.textSizeWithFont(descLbl.font, constrainedToSize: CGSizeMake(descLbl.frame.width,  CGFloat(MAXFLOAT)))
        descLbl.frame.size = content_size
        descLbl.textAlignment=NSTextAlignment.Center
        descLbl.numberOfLines=0
        titleLbl.text = self.titleString
        descLbl.text = self.descString
        descLbl.textAlignment = NSTextAlignment.Left
        descLbl.textColor=UIColor.whiteColor()
        descLbl.font = UIFont(name: "ArialUnicodeMS", size: 15)
        
        var headerView=UIView(frame: CGRectMake(0, 0, uiTableView.frame.width, departV.frame.height+descLbl.frame.height+30))
        headerView.backgroundColor = colors[colorIndex]
        headerView.addSubview(departV)
        headerView.addSubview(titleLbl)
        headerView.addSubview(descLbl)
        
        self.uiTableView.tableHeaderView = headerView
        
        
        //load data
       // basicList = UTIL.getFilmAlbumDetail(电影合集板块id: hejiID)
        CommonAccess(delegate: self, flag: "").getFilmAlbumDetail(电影合集板块id:hejiID)
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return basicList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
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
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 100
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        currentInfo = basicList[indexPath.row]
        self.performSegueWithIdentifier("hj2dy", sender: self)
        //println(cell.infoID)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var theSegue = segue.destinationViewController as! movieDetailController
        theSegue.currentInfo = currentInfo
    }
    
    func invoke(index:Int,StringResult result:String){
    
    }
    func invoke(type:String,object:NSObject){
    
    }
    
    func setCallbackObject(flag: String, object: NSObject) {
        basicList = object as! Array<Model.BasicInfo>
        self.tableView.reloadData()
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
