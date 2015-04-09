//
//  MyUIView.swift
//  多芒电影
//
//  Created by 柴小红 on 15/3/10.
//  Copyright (c) 2015年 珠影网络. All rights reserved.
//

import UIKit

class MyUIView:UIView {
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        var result = super.hitTest(point, withEvent: event)
        self.endEditing(true)
        return result
    }
}
