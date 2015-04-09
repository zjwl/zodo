//
//  API.swift
//  ZdomoApp
//
//  Created by 柴小红 on 15/1/23.
//  Copyright (c) 2015年 柴小红. All rights reserved.
//

import Foundation

class API:NSObject{
    func exec(source:DataDelegate,invokeIndex:Int = 0,invokeType:String="", methodName:String,params:String ...)->BaseAccess{
        switch(methodName){
        case "AddMember":
            return AddMember(source: source, invokeIndex: invokeIndex,type: invokeType, methodName: methodName, params: params)
        case "GetGameList":
            return GetGameList(source: source, invokeIndex: invokeIndex,type: invokeType, methodName: methodName, params: params)
        case "AddUser":
            return AddUser(source: source, invokeIndex: invokeIndex,type: invokeType, methodName: methodName, params: params)
        case "CheckEmail":
            return CheckEmail(source: source, invokeIndex: invokeIndex,type:invokeType, methodName: methodName, params: params)
        case "CheckUserName":
            return CheckUserName(source: source, invokeIndex: invokeIndex,type:invokeType, methodName: methodName, params: params)
        case "DeleteCollection":
            return DeleteCollection(source: source, invokeIndex: invokeIndex,type:invokeType, methodName: methodName, params: params)
        case "DeleteVisitHistory":
            return DeleteVisitHistory(source: source, invokeIndex: invokeIndex,type:invokeType, methodName: methodName, params: params)
        case "GetQASKInfo","GetQASKList":
            return GetQASKInfo(source: source, invokeIndex: invokeIndex,type:invokeType, methodName: methodName, params: params)
        case "GetUserID":
            return GetUserID(source: source, invokeIndex: invokeIndex,type:invokeType, methodName: methodName, params: params)
        case "InsertCollection":
            return InsertCollection(source: source, invokeIndex: invokeIndex,type:invokeType, methodName: methodName, params: params)
        case "InsertQASK":
            return InsertQASK(source: source, invokeIndex: invokeIndex,type:invokeType, methodName: methodName, params: params)
        case "Login":
            return Login(source: source, invokeIndex: invokeIndex, type:invokeType,methodName: methodName, params: params)
        case "ReadInfo":
            return ReadInfo(source: source, invokeIndex: invokeIndex,type:invokeType, methodName: methodName, params: params)
        case "SaveFile":
            return SaveFile(source: source, invokeIndex: invokeIndex, type:invokeType,methodName: methodName, params: params)
        case "UpdateUserFaceAndNickName":
            return UpdateUserFaceAndNickName(source: source, invokeIndex: invokeIndex,type:invokeType, methodName: methodName, params: params)
        case "UpdateUserInfo":
            return UpdateUserInfo(source: source, invokeIndex: invokeIndex, type:invokeType,methodName: methodName, params: params)
        case "insertZanInfo":
            return insertZanInfo(source: source, invokeIndex: invokeIndex,type:invokeType, methodName: methodName, params: params)
        case "insertZanQASK":
            return insertZanQASK(source: source, invokeIndex: invokeIndex,type:invokeType, methodName: methodName, params: params)
        case "SendFeedBack":
            return insertZanQASK(source: source, invokeIndex: invokeIndex,type:invokeType, methodName: methodName, params: params)
        default :
            return GetUserID(source: source, invokeIndex: invokeIndex, type:invokeType,methodName: methodName, params: params)
            
        }
    }
    
    
    
}