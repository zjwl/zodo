//
//  UpdateUserInfo.swift
//  ZdomoApp
//
//  Created by 柴小红 on 15/1/23.
//  Copyright (c) 2015年 柴小红. All rights reserved.
//

import Foundation
class UpdateUserInfo: BaseAccess {
    override init(source: DataDelegate, invokeIndex: Int = 0 ,type:String="", methodName: String, params: [String]) {
        super.init(source: source, invokeIndex: invokeIndex,type:type, methodName: methodName, params: params)
    }
    
    // NSXMLParserDelegate
    
    // override
    override func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String!, qualifiedName qName: String!) {
        if elementName=="UpdateUserInfoResult"{
            singleResult = currentValue as String
        }
    }
}