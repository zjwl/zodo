//
//  ReadInfo.swift
//  ZdomoApp
//
//  Created by 柴小红 on 15/1/23.
//  Copyright (c) 2015年 柴小红. All rights reserved.
//

import Foundation
class ReadInfo: BaseAccess {
    override init(source: DataDelegate, invokeIndex: Int = 0 ,type:String="", methodName: String, params: [String]) {
        super.init(source: source, invokeIndex: invokeIndex,type:type, methodName: methodName, params: params)
    }
    
    // override
    override func parserDidEndDocument(parser: NSXMLParser!) {
    }
}