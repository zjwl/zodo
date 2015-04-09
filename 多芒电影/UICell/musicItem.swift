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
    let colors:Array<UIColor> = []
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        colors.append(UIColor(red: 51/255, green: 170/255, blue: 138/255, alpha: 1))
        colors.append(UIColor(red: 72/255, green: 147/255, blue: 205/255, alpha: 1))
        colors.append(UIColor(red: 237/255, green: 126/255, blue: 1107/255, alpha: 1))
        colors.append(UIColor(red: 230/255, green: 171/255, blue: 41/255, alpha: 1))
        colors.append(UIColor(red: 161/255, green: 88/255, blue: 205/255, alpha: 1))
        colors.append(UIColor(red: 116/255, green: 170/255, blue: 24/255, alpha: 1))
        colors.append(UIColor(red: 126/255, green: 114/255, blue: 100/255, alpha: 1))
        colors.append(UIColor(red: 246/255, green: 89/255, blue: 58/255, alpha: 1))
        
        var bg:UIView = UIView(frame: CGRectMake(0, 0, frame.width-30, frame.width-30))
        image = UIImageView(frame: CGRectMake(0, 0, bg.frame.width, bg.frame.width))
        bg.addSubview(image!)
        lbl = UILabel(frame: CGRectMake(0, bg.frame.width+5, bg.frame.width, 20))
        lbl?.textAlignment = NSTextAlignment.Center
        
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
