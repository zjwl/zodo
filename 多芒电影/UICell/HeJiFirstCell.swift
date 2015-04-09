//
//  HeJiFirstCell.swift
//  多芒电影
//
//  Created by junjian chen on 15/3/30.
//  Copyright (c) 2015年 珠影网络. All rights reserved.
//

import Foundation

class HeJiFirstCell: UITableViewCell {
    var container:UIView?, cell:UIView?,imgView:UIImageView?,icon:UIImageView?,titleLbl:UILabel?,titleView:UIView?,imgLeft:UIImageView?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        container=UIView(frame:CGRectMake(0,0,screenWidth,200))
        cell=UIView(frame:CGRectMake(5,5,screenWidth-10,190))
        cell?.backgroundColor=UIColor.grayColor()
        titleView=UIView(frame: CGRectMake(0, 150, cell!.frame.width, 40))
        imgLeft=UIImageView(frame: CGRectMake(10, 10, 35, 20))
        imgLeft?.image=UIImage(named: "album.png")
        titleLbl=UILabel(frame: CGRectMake(50, 0, cell!.frame.width-50, 40))
        titleView?.backgroundColor=UIColor.greenColor()
        imgView=UIImageView()
        imgView?.frame=CGRectMake(0, 0, cell!.frame.width, 150)
        imgView?.contentMode=UIViewContentMode.ScaleAspectFill
        imgView?.clipsToBounds=true
        
        titleView?.addSubview(imgLeft!)
        titleView?.addSubview(titleLbl!)
        cell!.addSubview(imgView!)
        
        
        cell!.addSubview(titleView!)
        container!.addSubview(cell!)
        self.addSubview(container!)
        
    }
    
    

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}