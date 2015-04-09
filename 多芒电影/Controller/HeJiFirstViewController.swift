//
//  HeJiFirstViewController.swift
//  多芒电影
//
//  Created by 柴小红 on 15/2/13.
//  Copyright (c) 2015年 珠影网络. All rights reserved.
//

import UIKit

class HeJiFirstViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate {
    var hejiID=0
    var basicList:Array<Model.FilmAlbum> = [] //影片信息列表
    var currentInfo:Model.FilmAlbum=Model.FilmAlbum(),curPageIndex=0
    var _loadingMore=false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle=UITableViewCellSeparatorStyle.None
        // Do any additional setup after loading the view.
        
        
        //load data
        basicList = UTIL.getFilmAlbum(每页数量: 10, 当前页码: curPageIndex++)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return basicList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var identifier="hejiFirstItem"
        var cell: HeJiFirstCell? = tableView.dequeueReusableCellWithIdentifier(identifier) as HeJiFirstCell?
        if cell==nil {
            cell = HeJiFirstCell(style: UITableViewCellStyle.Default, reuseIdentifier: identifier)
        }
        
        cell?.titleLbl?.text=basicList[indexPath.row].Title
        var photo = basicList[indexPath.row].ThePhoto
        var webSite=""
        if photo.has("ueditor") {
            webSite =  "http://apk.zdomo.com"
        }else {
            webSite = "http://apk.zdomo.com/ueditor/net/"
        }
        
        var url = (webSite + photo).stringByReplacingOccurrencesOfString(".jpg", withString: "_133.jpg", options: NSStringCompareOptions.CaseInsensitiveSearch)
        url = url.stringByReplacingOccurrencesOfString(".png", withString: "_133.png", options: NSStringCompareOptions.CaseInsensitiveSearch)
        
        
        var imgURL = NSURL(string: url)
        PLMImageCache.sharedInstance.imageForUrl(imgURL!, desiredImageSize: CGSizeMake(133, 133), contentMode: UIViewContentMode.Center) { (image) -> Void in
            //use image
            var theImage:UIImage? = image
            cell?.imgView?.image=theImage
        }
        
        cell?.selectionStyle = UITableViewCellSelectionStyle.None
        var gesture=UITapGestureRecognizer(target: self, action: "goHeJiDetail:")
        
        cell?.tag=indexPath.row//basicList[indexPath.row]
        cell?.addGestureRecognizer(gesture)
        return cell!
    }
    
    
    func goHeJiDetail(tap:UITapGestureRecognizer){
        currentInfo=basicList[tap.view!.tag]
        self.performSegueWithIdentifier("HeJiDetail", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var theSegue = segue.destinationViewController as HeJiSecondViewController
        theSegue.hejiID=currentInfo.FilmAlbumID
        theSegue.titleString=currentInfo.Title
        theSegue.descString=currentInfo.Description
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 200
    }
    
    override func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool){
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
            self.tableView.addSubview(tableFooterActivityIndicator)
            
            basicList.extend(UTIL.getFilmAlbum(每页数量: 10, 当前页码: curPageIndex++))
            createTableFooter()
            self.tableView.reloadData()
        }
    }
    
    // 创建表格底部
    func createTableFooter(){
        self.tableView.tableFooterView = nil
        var tableFooterView = UIView(frame: CGRectMake(0.0, 0.0, self.tableView.bounds.size.width, 40.0))
        var loadMoreText = UILabel(frame: CGRectMake(0, 0, 116, 40))
        loadMoreText.text = "上拉显示更多数据"
        loadMoreText.font = UIFont(name: "Helvetica Neue", size: 14)
        tableFooterView.addSubview(loadMoreText)
        self.tableView.tableFooterView = tableFooterView
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
