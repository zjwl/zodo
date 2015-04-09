//
//  BlurBackground.swift
//  多芒电影
//
//  Created by junjian chen on 15/4/7.
//  Copyright (c) 2015年 珠影网络. All rights reserved.
//

import Foundation

class BlurBackground: UIView {
    var BlurContentView : UIView?
    var cellTitleLabel: UILabel?
    var blurView : UIVisualEffectView!
    var blurStyle : UIBlurEffectStyle!
    
    
    // returns simple Blur cell of specified blur type
    func setUpCell(#frame : CGRect,#blurStyle : UIBlurEffectStyle)
    {
        if (self.blurView == nil)
        {
            var blurView : UIVisualEffectView = blurEffectViewWithBlurSTyle(blurStyle)
            self.BlurContentView = UIView(frame: CGRectMake(0,0,frame.width,frame.height))
            blurView.frame = self.BlurContentView!.bounds
            self.BlurContentView!.addSubview(blurView);
            self.BlurContentView!.clipsToBounds = true;
            self.blurView = blurView;
        }
    }
    
    
    // returns blur cell of specified blur type with Vibrancyview for displaying label on top of blurView
    func setUpCellWithVibrancy(#frame : CGRect,#blurStyle : UIBlurEffectStyle)
    {
        if (self.blurView == nil)
        {
            var blurView : UIVisualEffectView = blurEffectViewWithBlurSTyle(blurStyle)
            self.BlurContentView = UIView(frame: CGRectMake(0,0,frame.width,frame.height))
            blurView.frame = self.BlurContentView!.bounds
            self.BlurContentView!.addSubview(blurView);
            self.BlurContentView!.clipsToBounds = true;
            self.addSubview(BlurContentView!)
            
            let vibrancy = UIVibrancyEffect(forBlurEffect: blurView.effect as UIBlurEffect)
            let vibrancyView = UIVisualEffectView(effect: vibrancy)
            vibrancyView.frame = blurView.bounds
            vibrancyView.autoresizingMask = .FlexibleWidth | .FlexibleHeight
            blurView.contentView.addSubview(vibrancyView)
            
            self.blurView = blurView;
        }
    }
    
    //Private
    func blurEffectViewWithBlurSTyle(blurStyle: UIBlurEffectStyle) -> UIVisualEffectView!
    {
        let blurEffect = UIBlurEffect(style:blurStyle)
        let blurView : UIVisualEffectView = UIVisualEffectView(effect: blurEffect)
        blurView.autoresizingMask = UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleTopMargin | UIViewAutoresizing.FlexibleBottomMargin
        return blurView
    }
    
}