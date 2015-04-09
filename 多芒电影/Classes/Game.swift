//
//  Game.swift
//  ZdomoApp
//
//  Created by 柴小红 on 15/1/23.
//  Copyright (c) 2015年 柴小红. All rights reserved.
//

import Foundation

class Game :NSObject {
    var GameID:String = ""
    var ManagerID:String = ""
    var GameName:String = ""
    var GameAddress:String = ""
    var Description:String = ""
    var ClassName:String = ""
    var PackageName:String = ""
    var GamePhoto:String = ""
    var IsUsed:String = ""
}

class GameList:NSObject {
    var list = Array<Game>()
}

