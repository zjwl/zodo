//
//  SendFeedBack.swift
//  多芒电影
//
//  Created by 柴小红 on 15/4/8.
//  Copyright (c) 2015年 珠影网络. All rights reserved.
//

import Foundation
class SendFeedBack: BaseAccess {
    override init(source: DataDelegate, invokeIndex: Int = 0 ,type:String="", methodName: String, params: [String]) {
        super.init(source: source, invokeIndex: invokeIndex,type:type, methodName: methodName, params: params)
    }
    
    // NSXMLParserDelegate
    
    // override
    override func parser(parser: NSXMLParser!, didEndElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!) {
        if elementName=="SendFeedBackResult"{
            singleResult = currentValue
        }
    }
}