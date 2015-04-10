//
//  musicItem.swift
//  多芒电影
//
//  Created by junjian chen on 15/3/5.
//  Copyright (c) 2015年 珠影网络. All rights reserved.
//

class musicItem: UIView{
    var image:UIImageView?
    var lbl:UILabel?
    var colors:Array<UIColor> = []
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        
        colors.append(UIColor(red: 51.0 / 255.0, green: 170 / 255.0, blue: 138 / 255.0, alpha: 1.0))
        colors.append(UIColor(red: 72.0 / 255.0, green: 147 / 255.0, blue: 205 / 255.0, alpha: 1.0))
        colors.append(UIColor(red: 237.0 / 255.0, green: 126 / 255.0, blue: 1107 / 255.0, alpha: 1.0))
        colors.append(UIColor(red: 230.0 / 255.0, green: 171 / 255.0, blue: 41 / 255.0, alpha: 1.0))
        colors.append(UIColor(red: 161.0 / 255.0, green: 88 / 255.0, blue: 205 / 255.0, alpha: 1.0))
        colors.append(UIColor(red: 116.0 / 255.0, green: 170 / 255.0, blue: 24 / 255.0, alpha: 1.0))
        colors.append(UIColor(red: 126.0 / 255.0, green: 114 / 255.0, blue: 100 / 255.0, alpha: 1.0))
        colors.append(UIColor(red: 246.0 / 255.0, green: 89 / 255.0, blue: 58 / 255.0, alpha: 1.0))
        
        
        var bg:UIView = UIView(frame: CGRectMake(0, 0, frame.width-7.5, frame.width-7.5))
        image = UIImageView(frame: CGRectMake(0, 0, bg.frame.width, bg.frame.width))
        bg.addSubview(image!)
        lbl = UILabel(frame: CGRectMake(0, bg.frame.width, bg.frame.width, 25))
        lbl?.textAlignment = NSTextAlignment.Center
        lbl?.font=UIFont(name: "ArialUnicodeMS", size: 13)
        image!.layer.masksToBounds = true
        image!.layer.cornerRadius = image!.bounds.size.height / 2
        
        var colorIndex = random() % colors.count
        bg.backgroundColor = colors[colorIndex]
        
        self.addSubview(bg)
        self.addSubview(lbl!)
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
