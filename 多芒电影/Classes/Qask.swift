//
//  Qask.swift
//  ZdomoApp
//
//  Created by 柴小红 on 15/1/23.
//  Copyright (c) 2015年 柴小红. All rights reserved.
//

import Foundation
class Qask :NSObject {
    var QASKID:String = ""
    var ManagerID:String = ""
    var SourceID:String = ""
    var Content:String = ""
    var SenderID:String = ""
    var ReplyID:String = ""
    var AddTmie:String = ""
    var IS_Editor:String = ""
    var IsUsed:String = ""
    var AuditID:String = ""
    var NickName:String = ""
    var iconFace:String = ""
}

class QaskList:NSObject {
    var list = Array<Qask>()
}