//
//  DataDelegate.swift
//  ZdomoApp
//
//  Created by 柴小红 on 15/1/12.
//  Copyright (c) 2015年 柴小红. All rights reserved.
//

protocol DataDelegate : NSObjectProtocol {
    func invoke(index:Int,StringResult result:String)
    //type:方法的标识（一个页面可能有多个方法回调，以此参数作为标识区分） object:返回的数据
    func invoke(type:String,object:NSObject)
}
