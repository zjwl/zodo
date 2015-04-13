//
//  CommonAccessDelegate.swift
//  多芒电影
//
//  Created by junjian chen on 15/4/13.
//  Copyright (c) 2015年 珠影网络. All rights reserved.
//

import Foundation

protocol CommonAccessDelegate : NSObjectProtocol {
    func setCallbackObject(flag:String,object:NSObject)
}