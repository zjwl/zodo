//
//  YueViewController.swift
//  多芒电影
//
//  Created by 柴小红 on 15/2/13.
//  Copyright (c) 2015年 珠影网络. All rights reserved.
//

import UIKit

let waterfallViewCellIdentify = "waterfallViewCellIdentify"



class YueViewController:UICollectionViewController,CHTCollectionViewDelegateWaterfallLayout, NTTransitionProtocol, NTWaterFallViewControllerProtocol,CommonAccessDelegate{
    //    class var sharedInstance: NSInteger = 0 Are u kidding me?
    //var imageNameList : Array <NSString> = []
    
    var basicList:Array<Model.BasicInfo> = []
    var refreshControl = UIRefreshControl()
    var currentPage = 0
    var isScroll = false
    var activityIndicator:UIActivityIndicatorView!
   // let delegateHolder = NavigationControllerDelegate()
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl.attributedTitle = NSAttributedString(string: "松开更新信息")
        refreshControl.addTarget(self, action: "refreshData", forControlEvents: UIControlEvents.ValueChanged)
        collectionView?.addSubview(refreshControl)
        // Do any additional setup after loading the view, typically from a nib.
        //self.navigationController!.delegate = delegateHolder
        self.view.backgroundColor = UIColor.yellowColor()
        //collectionView?.backgroundColor = UIColor.yellowColor()
        
        let collection :UICollectionView = collectionView!;
        collection.frame = CGRectMake(5, 5, screenWidth-10, screenHeight)
        collection.setCollectionViewLayout(CHTCollectionViewWaterfallLayout(), animated: false)
        collection.backgroundColor = UIColor.yellowColor()
        collection.registerClass(NTWaterfallViewCell.self, forCellWithReuseIdentifier: waterfallViewCellIdentify)
        //collection.reloadData()
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0,y: 0,width: 32,height: 32))
        activityIndicator.center = view.center
        activityIndicator.activityIndicatorViewStyle =  UIActivityIndicatorViewStyle.Gray
        view.addSubview(activityIndicator)
    }
    
    
    
    func refreshData() {
        activityIndicator.startAnimating()
        println("refreshData里加载的数据，page:：\(currentPage)")
        currentPage = 0
        if IJReachability.isConnectedToNetwork(){
            CommonAccess(delegate: self,flag:"").getLlatestUpdate(栏目id: 3, 特殊标签id: 0, 每页数量: 180, 当前页码: currentPage)
        }else{
            CommonAccess(delegate: self,flag:"").setObjectByCache(value: readObjectFromUD("basic_c_3_s_0_p_0"))
        }
        
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
//        let image:UIImage! = UIImage(named: self.imageNameList[indexPath.row] as NSString)
//        let imageHeight = image.size.height*gridWidth/image.size.width
        return CGSizeMake(gridWidth, gridWidth*5/3)
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        var collectionCell: NTWaterfallViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(waterfallViewCellIdentify, forIndexPath: indexPath) as! NTWaterfallViewCell
        //var collectionCell2: NTWaterfallViewCell = NTWaterfallViewCell(frame: CGRectMake(0, 0, screenWidth/3, screenWidth/3+30))
        var url =  self.basicList[indexPath.row].PicURL.stringByReplacingOccurrencesOfString(".jpg", withString: "_133.jpg", options: NSStringCompareOptions.CaseInsensitiveSearch)
        
        
        url = url.stringByReplacingOccurrencesOfString(".png", withString: "_133.png", options: NSStringCompareOptions.CaseInsensitiveSearch)
        
        //println("1加载图地址：\(url)")
        collectionCell.imageName = url
        collectionCell.titleLbl.text = self.basicList[indexPath.row].Title
        collectionCell.configCell()
        return collectionCell;
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return basicList.count;
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        let pageViewController =
        NTHorizontalPageViewController(collectionViewLayout: pageViewControllerLayout(), currentIndexPath:indexPath)
        pageViewController.basicList = self.basicList
        collectionView.setToIndexPath(indexPath)
        navigationController!.pushViewController(pageViewController, animated: true)
    }
    
    func pageViewControllerLayout () -> UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        let itemSize  = self.navigationController!.navigationBarHidden ?
            CGSizeMake(screenWidth, screenHeight) : CGSizeMake(screenWidth, screenHeight-navigationHeaderAndStatusbarHeight)
        println("itemSize is:\(itemSize)")
        flowLayout.itemSize = itemSize
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.scrollDirection = .Horizontal
        return flowLayout
    }
    
    func viewWillAppearWithPageIndex(pageIndex : NSInteger) {
        var position : UICollectionViewScrollPosition =
        .CenteredHorizontally & .CenteredVertically
        
        var url =  self.basicList[pageIndex].PicURL.stringByReplacingOccurrencesOfString(".jpg", withString: "_133.jpg", options: NSStringCompareOptions.CaseInsensitiveSearch)
        
        
        url = url.stringByReplacingOccurrencesOfString(".png", withString: "_133.png", options: NSStringCompareOptions.CaseInsensitiveSearch)
        var imgURL = NSURL(string: url)
        println("2加载图地址：\(url)")
        //var imgURL = NSURL(string: self.basicList[pageIndex].PicURL)
        
        
        PLMImageCache.sharedInstance.imageForUrl(imgURL!, desiredImageSize: CGSizeMake(133, 133), contentMode: UIViewContentMode.Center) { (image) -> Void in
            //use image
            let imageHeight = image!.size.height*gridWidth/image!.size.width
            if imageHeight > 400 {//whatever you like, it's the max value for height of image
                position = .Top
            }
            let currentIndexPath = NSIndexPath(forRow: pageIndex, inSection: 0)
            let collectionView = self.collectionView!;
            collectionView.setToIndexPath(currentIndexPath)
            if pageIndex<2{
                collectionView.setContentOffset(CGPointZero, animated: false)
            }else{
                collectionView.scrollToItemAtIndexPath(currentIndexPath, atScrollPosition: position, animated: false)
            }
        }
        
        
        
    }
    
    func transitionCollectionView() -> UICollectionView!{
        return collectionView
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        if isScroll {
            return
        }
        
        if scrollView.contentOffset.y + scrollView.frame.size.height > scrollView.contentSize.height * 0.8 {
            isScroll = true
            //var  basicList1 = UTIL.getLlatestUpdate(栏目id: 3, 特殊标签id: 0, 每页数量: 20, 当前页码: currentPage)
            activityIndicator.startAnimating()
            // println("scroll里加载的数据，page:：\(currentPage)")
            if IJReachability.isConnectedToNetwork(){
                CommonAccess(delegate: self, flag: "").getLlatestUpdate(栏目id: 3, 特殊标签id: 0, 每页数量: 180, 当前页码: currentPage++)
            }else {
                refreshData()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setCallbackObject(flag: String, object: NSObject) {
        
       refreshControl.endRefreshing()
       activityIndicator.stopAnimating()
 
        
        var  basicList1 = object as! Array<Model.BasicInfo>
        
        if basicList1.count < 1 {
            return
        }
        
       // println("basicList1.count:\(basicList1.count)")
        if currentPage == 0 {
            basicList = basicList1
        }else {
            basicList.extend(basicList1)
            isScroll = false
        }
        
        collectionView!.reloadData()
    }
    
}
