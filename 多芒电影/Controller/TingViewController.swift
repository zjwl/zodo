//
//  TingViewController.swift
//  多芒电影
//
//  Created by 柴小红 on 15/2/13.
//  Copyright (c) 2015年 珠影网络. All rights reserved.
//

import UIKit

class TingViewController:  UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate  {
    
    var collectionView : UICollectionView?  // Optional
    var screenSize : CGRect!
    var screenWidth : CGFloat!
    var screenHeight : CGFloat!
    
    var basicList:Array<Model.BasicInfo> = []
    var refreshControl = UIRefreshControl()
    var currentPage = 0
    var isScroll = false
    
    var currentInfo:Model.BasicInfo=Model.BasicInfo()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl.attributedTitle = NSAttributedString(string: "松开更新信息")
        refreshControl.addTarget(self, action: "refreshData", forControlEvents: UIControlEvents.ValueChanged)
        
        
        //    screenSize = UIScreen.mainScreen().bounds
        screenSize = self.view.frame
        
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        
        // Do any additional setup after loading the view, typically from a nib.
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 64, left: 0, bottom: 48, right: 0)
        layout.itemSize = CGSize(width: screenWidth/2, height: screenWidth/2+20)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView?.addSubview(refreshControl)
        
        println(collectionView?.frame.width)
        collectionView!.dataSource = self
        collectionView!.delegate = self
        collectionView!.registerClass(musicCollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
        self.view.addSubview(collectionView!)
        self.collectionView?.backgroundColor = UIColor.whiteColor()
        refreshData()
    }
    
    func refreshData() {
        refreshControl.endRefreshing()
        basicList = UTIL.getLlatestUpdate(栏目id: 4, 特殊标签id: 0, 每页数量: 20, 当前页码: currentPage)
        collectionView!.reloadData()
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return basicList.count
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSize(width: screenWidth/2, height: screenWidth/2+20);
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        
        let TAG_CELL_LABEL = 1
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionViewCell", forIndexPath: indexPath) as musicCollectionViewCell
        
        var item:musicItem? = cell.contentView.viewWithTag(TAG_CELL_LABEL) as? musicItem
        if item == nil {
            item = musicItem(frame: CGRectMake(0, 0, screenWidth/2, screenWidth/2+20))
            item!.tag = TAG_CELL_LABEL
            cell.contentView.addSubview(item!)
        }
        var xx:CGFloat = 0
        if indexPath.row % 2 == 0 {
            xx=20
        }else {
            xx=10
        }
        item?.frame.origin = CGPointMake(xx, 0)
        
        //cell.layer.borderColor = UIColor.whiteColor().CGColor
        //cell.layer.borderWidth = 20
        
        //    println(cell.frame.size.width)
        
        item?.lbl?.text = basicList[indexPath.row].Title
        var picurl = basicList[indexPath.row].PicURL
        var imgURL = NSURL(string: picurl)
        PLMImageCache.sharedInstance.imageForUrl(imgURL!, desiredImageSize: CGSizeMake(133, 133), contentMode: UIViewContentMode.Center) { (image) -> Void in
            //use image
            //item?.image?.image = image
            var imgesss:UIImage? = image
            item?.image?.image = imgesss
            
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        currentInfo = basicList[indexPath.row]
        self.performSegueWithIdentifier("musicDetailSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var theSegue = segue.destinationViewController as musicDetailController
        //
        
        theSegue.currentInfo = currentInfo
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if isScroll {
            return
        }
        
        if scrollView.contentOffset.y + scrollView.frame.size.height > scrollView.contentSize.height * 0.8 {
            isScroll = true
            currentPage = currentPage + 1
            var  basicList1 = UTIL.getLlatestUpdate(栏目id: 4, 特殊标签id: 0, 每页数量: 20, 当前页码: currentPage)
            basicList.extend(basicList1)
            collectionView?.reloadData()
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
