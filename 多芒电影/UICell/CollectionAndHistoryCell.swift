//
//  CollectionAndHistoryCell.swift
//  多芒电影
//
//  Created by junjian chen on 15/3/12.
//  Copyright (c) 2015年 珠影网络. All rights reserved.
//

import Foundation

class CollectionAndHistoryCell:UITableViewCell {
    var title:String?
    var time:String?
    
    var titlelbl:UILabel?
    var timelbl:UILabel?
    
    override func layoutSubviews() {
        self.titlelbl!.text = title
        self.timelbl!.text = time!
        
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.frame =  CGRectMake(0, 0, screenWidth, 60)
        self.titlelbl = UILabel(frame: CGRectMake(10, 10, self.frame.width-20, 20))
        self.timelbl = UILabel(frame: CGRectMake(10, 35, self.frame.width-20, 15))
        self.timelbl?.textColor = UIColor.grayColor()
        self.timelbl?.font = UIFont(name: "ArialUnicodeMS", size: 13)
        self.addSubview(self.titlelbl!)
        self.addSubview(self.timelbl!)
    }
    

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}