//
//  GetQASKInfo.swift
//  ZdomoApp
//
//  Created by 柴小红 on 15/1/23.
//  Copyright (c) 2015年 柴小红. All rights reserved.
//

import Foundation

// 与 GetQASKList , GetQASKParticipant 共用一个返回处理 （返回数据类型一样） 只需 methodName 传参名称不一样即可。注：params需传相关参数
class GetQASKInfo: BaseAccess {
    var qaskList:Array<Model.QASK> = Array<Model.QASK>()
    var model = Model.QASK()
    var content="",curElementName=""
    var nodeString = ",QASKID,ManagerID,SourceID,Content,SenderID,ReplyID,AddTmie,IS_Editor,IsUsed,AuditID,NickName,iconFace,"
    
    override init(source:DataDelegate,invokeIndex:Int = 0, type:String="",methodName:String,params:[String]){
        super.init(source: source, invokeIndex: invokeIndex,type:type, methodName: methodName, params: params)
    }
    
    
    override func parser(parser: NSXMLParser!, didStartElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!, attributes attributeDict: NSDictionary!) {
        curElementName = elementName
    }
    override func parser(parser: NSXMLParser!, foundCharacters string: String!) {
        //println("foundCharacters in Override:\(string)")
        currentValue = string
        if curElementName=="Content" {
            content = content+currentValue
        }
    }
    
    // override
    override func parser(parser: NSXMLParser!, didEndElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!) {
        if elementName=="QaskWithMember"{
            qaskList.append(model)
            model = Model.QASK()
            content=""
        }
        var compareResult = nodeString.rangeOfString(","+elementName+",")
        if compareResult != nil {
            if elementName=="Content" {
                model.setValue(content, forKey: elementName)
            }else{
                model.setValue(currentValue, forKey: elementName)
            }
            
        }
        
    }
    // override
    override func parserDidEndDocument(parser: NSXMLParser!) {
        dataDelegate.invoke("qaskList",object: qaskList)
    }
}