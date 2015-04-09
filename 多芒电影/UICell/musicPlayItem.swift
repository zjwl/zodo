//
//  musicPlayItem.swift
//  多芒电影
//
//  Created by junjian chen on 15/3/18.
//  Copyright (c) 2015年 珠影网络. All rights reserved.
//

import Foundation

class musicPlayItem: UITableViewCell {
    var titlelbl:UILabel?
    var playIcon:UIButton?
    var hr:UILabel?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    override init(frame: CGRect) {
        super.init(frame:frame)
        titlelbl = UILabel(frame:CGRectMake(10,10,screenWidth-60,20))
        playIcon = UIButton(frame:CGRectMake(titlelbl!.frame.width+10,10,20,20))
        playIcon?.setImage(UIImage(named: "music_listen.png"), forState: UIControlState.Normal)
        hr = UILabel(frame:CGRectMake(15,self.frame.height,screenWidth-30,1))
        hr!.backgroundColor = UIColor.lightGrayColor()
        self.addSubview(titlelbl!)
        self.addSubview(playIcon!)
        self.addSubview(hr!)
    }
    
    func configCell(title:String,playUrl:String){
        titlelbl?.text = title
        
    }
        

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}