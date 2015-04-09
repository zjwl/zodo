//
//  GameListAccess.swift
//  ZdomoApp
//
//  Created by 柴小红 on 15/1/23.
//  Copyright (c) 2015年 柴小红. All rights reserved.
//

import Foundation

class GetGameList : BaseAccess{
    var gameList = GameList()
    var game = Game()
    //var node = ["GameID","ManagerID","GameName","GameAddress",]
    var nodeString = ",GameID,ManagerID,GameName,GameAddress,Description,IsUsed,ClassName,PackageName,PackageName,"
    
    override init(source:DataDelegate,invokeIndex:Int = 0,type:String="", methodName:String,params:[String]){
        super.init(source: source, invokeIndex: invokeIndex, type:type,methodName: methodName, params: params)
    }
    
    
    // override
    override func parser(parser: NSXMLParser!, didEndElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!) {
        if elementName=="Game"{
            gameList.list.append(game)
            game = Game()
        }
        var compareResult = nodeString.rangeOfString(","+elementName+",")
        if compareResult != nil {
            game.setValue(currentValue, forKey: elementName)
        }
        
    }
    // override
    override func parserDidEndDocument(parser: NSXMLParser!) {
        dataDelegate.invoke(invokeType,object: gameList)
    }
}