//
//  GetJson.swift
//  多芒电影
//
//  Created by 柴小红 on 15/1/30.
//  Copyright (c) 2015年 珠影网络. All rights reserved.
//

import Foundation

struct UTIL {
    
    static let  webJsonUrl = "http://apk.zdomo.com/api/"

    static func getJsonData(link:String) -> AnyObject {
        var tmpL = link + "&witch=\(arc4random_uniform(1000))"
        var  tmplink = tmpL.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        var url = NSURL(string: tmplink!)

       // println(tmplink!)
      //  var data = NSData(contentsOfURL: url!)
        var data = NSData(contentsOfURL: url!, options: NSDataReadingOptions.DataReadingMappedIfSafe, error: nil)
        var json:AnyObject = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: nil)!
        return json
    }
    
    //广告接口
   static func getApiAD(广告位id adplaceid:Int,每页数量 pageSize:Int,当前页码 pageNum:Int) ->Array<Model.AD> {
        var postStrig = webJsonUrl + "apiad/getAd?adplaceid=\(adplaceid)&pageSize=\(pageSize)&pageNum=\(pageNum)"
    var arrayData = getJsonData(postStrig) as NSArray
    var adList:Array<Model.AD> = []
    for item in arrayData{
        var dict = item as  NSDictionary
        
        var ad = Model.AD()
        
        ad.AD_ID = dict["AD_ID"] as Int
        ad.Ad_Name =  (dict["Ad_Name"] as String!).stringByReplacingOccurrencesOfString(" ", withString: "")
        ad.Photo_URL = (dict["Photo_URL"] as String!).stringByReplacingOccurrencesOfString(" ", withString: "")
        ad.Ad_Type = (dict["Ad_Type"] as String!).stringByReplacingOccurrencesOfString(" ", withString: "")
        ad.AD_PLACE_ID = dict["AD_ID"] as Int
        ad.ManagerID = dict["AD_ID"] as Int
        ad.Descripton = dict["AD_ID"] as Int
        ad.IsUsed = dict["IsUsed"] as Bool
        ad.AD_TargetAddr = (dict["AD_TargetAddr"] as String!).stringByReplacingOccurrencesOfString(" ", withString: "")
        ad.StartTime = (dict["StartTime"] as String!).stringByReplacingOccurrencesOfString(" ", withString: "")
        ad.EndTime = (dict["EndTime"] as String!).stringByReplacingOccurrencesOfString(" ", withString: "")

        
        adList.append(ad)
        
    }
    
    
    return adList

    }
    
    
    
    //基本信息接口
    
    //获取最新更新
    static func getLlatestUpdate(栏目id columnid:Int,特殊标签id sid:Int, 每页数量 pageSize:Int,当前页码 pageNum:Int) -> Array<Model.BasicInfo> {
        var postStrig = webJsonUrl + "apibasic?columnid=\(columnid)&pageSize=\(pageSize)&pageNum=\(pageNum)&sid=\(sid)"
        //println(postStrig)
        var arrayData = getJsonData(postStrig) as NSArray
        var basicList:Array<Model.BasicInfo> = []
        for item in arrayData{
            var dict = item as  NSDictionary
            
            var basic = Model.BasicInfo()
            
            basic.ColumnID = dict["ColumnID"] as Int
            basic.InfoID = dict["InfoID"] as Int
            basic.PicURL =  "http://apk.zdomo.com"+(dict["PicURL"] as String!).stringByReplacingOccurrencesOfString(" ", withString: "")
            basic.Title = (dict["Title"] as String!).stringByReplacingOccurrencesOfString(" ", withString: "")
            basic.LinkUrl = (dict["LinkUrl"] as String!).stringByReplacingOccurrencesOfString(" ", withString: "")
            basic.Introduction = (dict["Introduction"] as String!).stringByReplacingOccurrencesOfString(" ", withString: "")
            basic.SpecilLabelIDS = (dict["SpecilLabelIDS"] as String!).stringByReplacingOccurrencesOfString(" ", withString: "")
            basic.GoodTimes = dict["GoodTimes"] as Int
            basic.Content = dict["Content"] as String!
            basic.AddTime = (dict["AddTime"] as String!).stringByReplacingOccurrencesOfString(" ", withString: "")
            basic.LabelIDS = (dict["LabelIDS"] as String!).stringByReplacingOccurrencesOfString(" ", withString: "")
            

            
            if var auditID :AnyObject = dict["AuditID"] {
                basic.AuditID =  auditID as Int
            }
            
            if var isused :AnyObject = dict["IsUsed"] {
                basic.IsUsed =  isused as Bool
            }

            if var auditState :AnyObject = dict["AuditID"] {
                basic.AuditState =  auditState as Bool
            }

            
            
            basicList.append(basic)

        }
        
        return basicList


    }
    
    //获取具体信息
   static func getBasicInfo(信息id infoid:Int)->Model.BasicInfo {
        var postStrig = webJsonUrl + "apibasic?id=\(infoid)"
    
        var dict = getJsonData(postStrig) as NSDictionary
        var basic = Model.BasicInfo()
        
        basic.ColumnID = dict["ColumnID"] as Int
        basic.InfoID = dict["InfoID"] as Int
        basic.PicURL =  (dict["PicURL"] as String!).stringByReplacingOccurrencesOfString(" ", withString: "")
        basic.Title = (dict["Title"] as String!).stringByReplacingOccurrencesOfString(" ", withString: "")
        basic.LinkUrl = (dict["LinkUrl"] as String!).stringByReplacingOccurrencesOfString(" ", withString: "")
        basic.Introduction = (dict["Introduction"] as String!).stringByReplacingOccurrencesOfString(" ", withString: "")
        basic.SpecilLabelIDS = (dict["SpecilLabelIDS"] as String!).stringByReplacingOccurrencesOfString(" ", withString: "")
        basic.GoodTimes = dict["GoodTimes"] as Int
        basic.AuditID = dict["AuditID"] as Int
        basic.IsUsed = dict["IsUsed"] as Bool
        basic.AuditState = dict["AuditState"] as Bool
        basic.Content = (dict["Content"] as String!).stringByReplacingOccurrencesOfString(" ", withString: "")
        basic.AddTime = (dict["AddTime"] as String!).stringByReplacingOccurrencesOfString(" ", withString: "")
        basic.LabelIDS = (dict["LabelIDS"] as String!).stringByReplacingOccurrencesOfString(" ", withString: "")
    
        return basic

    }
    
    
    //获取各版本更新数量
    static func getUpdateCount(栏目时间与id组合 s:String) ->AnyObject {
        var postStrig = webJsonUrl + "apibasic?s=\(s)"
        return getJsonData(postStrig)
    }
    
    //获取收藏列表
    static func getCollection(客户id memberid:Int,每页数量 pageSize:Int,当前页码 pageNum:Int) ->Array<Model.Collection>{
        var postStrig = webJsonUrl + "apiCollection?memberid=\(memberid)&pageSize=\(pageSize)&pageNum=\(pageNum)"
        var arrayData = getJsonData(postStrig) as NSArray
        var basicList:Array<Model.Collection> = []
        for item in arrayData{
            var dict = item as  NSDictionary
            
            var basic = Model.Collection()
            
            basic.ColumnID = dict["ColumnID"] as Int
            basic.InfoID = dict["InfoID"] as Int
            basic.PicURL =  (dict["PicURL"] as String!).stringByReplacingOccurrencesOfString(" ", withString: "")
            basic.Title = (dict["Title"] as String!).stringByReplacingOccurrencesOfString(" ", withString: "")
            basic.LinkUrl = (dict["LinkUrl"] as String!).stringByReplacingOccurrencesOfString(" ", withString: "")
            basic.Introduction = (dict["Introduction"] as String!).stringByReplacingOccurrencesOfString(" ", withString: "")
            basic.SpecilLabelIDS = (dict["SpecilLabelIDS"] as String!).stringByReplacingOccurrencesOfString(" ", withString: "")
            basic.GoodTimes = dict["GoodTimes"] as Int
            //basic.AuditID = dict["AuditID"] as Int
            //basic.IsUsed = dict["IsUsed"] as Bool
            //basic.AuditState = dict["AuditState"] as Bool
            basic.Content = (dict["Content"] as String!)
            basic.AddTime = (dict["AddTime"] as String!).stringByReplacingOccurrencesOfString(" ", withString: "")
            basic.LabelIDS = (dict["LabelIDS"] as String!).stringByReplacingOccurrencesOfString(" ", withString: "")
            basic.CollectID = dict["CollectID"] as Int
            var tempTime = dict["CollectTime"] as String!
            
            var timeFormat = NSDateFormatter()
            timeFormat.dateFormat = "yyyy-MM-dd\'T\'HH:mm:ss"
            var theday = timeFormat.dateFromString(tempTime)
            timeFormat.dateFormat = "yyyy-MM-dd HH:mm:ss"
            basic.CollectTime = timeFormat.stringFromDate(theday!)
            
            basicList.append(basic)
            
        }
    
    return basicList

    }
    
    //获取特定用户所有收藏的信息id集合
   static func getCollectionIDS(客户id userid:Int)-> AnyObject{
        var postStrig = webJsonUrl + "apiCollection?memberid=\(userid)"
        return getJsonData(postStrig)

    }
   
    //获取电影合集
    
    //获取电影合集栏目板块
    static func getFilmAlbum(每页数量 pageSize:Int,当前页码 pageNum:Int)->Array<Model.FilmAlbum>{
        var postStrig = webJsonUrl + "apiFilmAlbum?pageSize=\(pageSize)&pageNum=\(pageNum)"
        var arrayData = getJsonData(postStrig) as NSArray
        var faList:Array<Model.FilmAlbum> = []
        for item in arrayData{
            var dict = item as  NSDictionary
            
            var filmAlbum = Model.FilmAlbum()
            filmAlbum.FilmAlbumID = dict["FilmAlbumID"] as Int
            filmAlbum.ManagerID = dict["ManagerID"] as Int
            filmAlbum.ThePhoto = (dict["ThePhoto"] as String!).stringByReplacingOccurrencesOfString(" ", withString: "")
            filmAlbum.Title = (dict["Title"] as String!).stringByReplacingOccurrencesOfString(" ", withString: "")
            filmAlbum.Description = (dict["Description"] as String!).stringByReplacingOccurrencesOfString(" ", withString: "")
            filmAlbum.InfoIDS = (dict["InfoIDS"] as String!).stringByReplacingOccurrencesOfString(" ", withString: "")
            
            filmAlbum.IsUsed = dict["IsUsed"] as Bool
            filmAlbum.AddTime = (dict["AddTime"] as String!).stringByReplacingOccurrencesOfString(" ", withString: "")
            filmAlbum.LabelIDS = (dict["LabelIDS"] as String!).stringByReplacingOccurrencesOfString(" ", withString: "")
            
            faList.append(filmAlbum)
            
        }
        
        return faList

    }
    
    //获取电影合集具体板块明细
   static  func getFilmAlbumDetail(电影合集板块id id:Int)->Array<Model.BasicInfo> {
        var postStrig = webJsonUrl + "apiFilmAlbum?id=\(id)"
    var arrayData = getJsonData(postStrig) as NSArray
    var basicList:Array<Model.BasicInfo> = []
    for item in arrayData{
        var dict = item as  NSDictionary
        
        var basic = Model.BasicInfo()
        
        basic.ColumnID = dict["ColumnID"] as Int
        basic.InfoID = dict["InfoID"] as Int
        basic.PicURL =  "http://apk.zdomo.com"+(dict["PicURL"] as String!).stringByReplacingOccurrencesOfString(" ", withString: "")
        basic.Title = (dict["Title"] as String!).stringByReplacingOccurrencesOfString(" ", withString: "")
        basic.LinkUrl = (dict["LinkUrl"] as String!).stringByReplacingOccurrencesOfString(" ", withString: "")
        basic.Introduction = (dict["Introduction"] as String!).stringByReplacingOccurrencesOfString(" ", withString: "")
        basic.SpecilLabelIDS = (dict["SpecilLabelIDS"] as String!).stringByReplacingOccurrencesOfString(" ", withString: "")
        basic.GoodTimes = dict["GoodTimes"] as Int
        //basic.AuditID = dict["AuditID"] as Int
        //basic.IsUsed = dict["IsUsed"] as Bool
        //basic.AuditState = dict["AuditState"] as Bool
        basic.Content = (dict["Content"] as String!).stringByReplacingOccurrencesOfString(" ", withString: "")
        basic.AddTime = (dict["AddTime"] as String!).stringByReplacingOccurrencesOfString(" ", withString: "")
        basic.LabelIDS = (dict["LabelIDS"] as String!).stringByReplacingOccurrencesOfString(" ", withString: "")
        
        basicList.append(basic)
        
    }
    
    return basicList
    }
    
    //获取游戏列表
    static func getGameList(每页数量 pageSize:Int,当前页码 pageNum:Int) -> Array<Model.Game> {
        var postStrig = webJsonUrl + "apiGame/?pageSize=\(pageSize)&pageNum=\(pageNum)&type=ios"
        var arrayData = getJsonData(postStrig) as NSArray
        var gameList:Array<Model.Game> = []
        for item in arrayData{
            var dict = item as  NSDictionary
            
            var game = Model.Game()
            game.GameID = dict["GameID"] as Int
            game.ManagerID = dict["ManagerID"] as Int
            game.GameName = (dict["GameName"] as String!).stringByReplacingOccurrencesOfString(" ", withString: "")
            game.GameAddress = (dict["GameAddress"] as String!).stringByReplacingOccurrencesOfString(" ", withString: "")
            game.Description = (dict["Description"] as String!).stringByReplacingOccurrencesOfString(" ", withString: "")
            game.IsUsed = dict["IsUsed"] as Bool
            game.ClassName = (dict["ClassName"] as String!).stringByReplacingOccurrencesOfString(" ", withString: "")
            game.PackageName = (dict["PackageName"] as String!).stringByReplacingOccurrencesOfString(" ", withString: "")
            game.GamePhoto = (dict["GamePhoto"] as String!).stringByReplacingOccurrencesOfString(" ", withString: "")
      
            gameList.append(game)
            
        }
        

        return gameList
        
        
    }
    
    
    
    //获取访问历史
    static func getHistory(客户id memberid:Int,每页数量 pageSize:Int,当前页码 pageNum:Int)->Array<Model.History> {
        var postStrig = webJsonUrl + "apiHistory?memberid=\(memberid)&pageSize=\(pageSize)&pageNum=\(pageNum)"
        
        var arrayData = getJsonData(postStrig) as NSArray
        var histroyList:Array<Model.History> = []
        for item in arrayData{
            var dict = item as  NSDictionary
            
            var history = Model.History()
            
            history.ColumnID = dict["ColumnID"] as Int
            history.InfoID = dict["InfoID"] as Int
            history.PicURL =  (dict["PicURL"] as String!).stringByReplacingOccurrencesOfString(" ", withString: "")
            history.Title = (dict["Title"] as String!).stringByReplacingOccurrencesOfString(" ", withString: "")
            history.LinkUrl = (dict["LinkUrl"] as String!).stringByReplacingOccurrencesOfString(" ", withString: "")
            history.Introduction = (dict["Introduction"] as String!).stringByReplacingOccurrencesOfString(" ", withString: "")
            history.SpecilLabelIDS = (dict["SpecilLabelIDS"] as String!).stringByReplacingOccurrencesOfString(" ", withString: "")
            history.GoodTimes = dict["GoodTimes"] as Int
//            history.AuditID = dict["AuditID"] as Int
//            history.IsUsed = dict["IsUsed"] as Bool
//            history.AuditState = dict["AuditState"] as Bool
            history.Content = (dict["Content"] as String!).stringByReplacingOccurrencesOfString(" ", withString: "")
            history.AddTime = (dict["AddTime"] as String!).stringByReplacingOccurrencesOfString(" ", withString: "")
            history.LabelIDS = (dict["LabelIDS"] as String!).stringByReplacingOccurrencesOfString(" ", withString: "")
            history.HistoryID = dict["HistoryID"] as Int
            
            
            var tempTime = dict["HistoryTime"] as String!
            
            var timeFormat = NSDateFormatter()
            timeFormat.dateFormat = "yyyy-MM-dd\'T\'HH:mm:ss"
            var theday = timeFormat.dateFromString(tempTime)
            timeFormat.dateFormat = "yyyy-MM-dd HH:mm:ss"
            history.HistoryTime = timeFormat.stringFromDate(theday!)
            
            histroyList.append(history)
            
        }
        
        return histroyList
        
        
    }
    
    //获取会员数据
    static func getMember(客户id memberid:Int)->AnyObject {
        var postStrig = webJsonUrl + "apiMember/getOne?id=\(memberid)"
        return getJsonData(postStrig)
    }
    
    //获取会员数据
    static func getMember(用户名 username:String,密码 password:String)->AnyObject {
        var postStrig = webJsonUrl + "apiMember/getOne?userName=\(username)&password＝\(password)"
        return getJsonData(postStrig)
    }
    
    //获取电影各板块，以标签分化
    static func getSpecilLabel() ->Array<Model.SpecilLabel> {
        var postStrig = webJsonUrl + "apiSpecilLabel?1=1"
        
        var arrayData = getJsonData(postStrig) as NSArray
        var slabelList:Array<Model.SpecilLabel> = []
        for item in arrayData{
            var dict = item as  NSDictionary
            
            var slabel = Model.SpecilLabel()
            slabel.LabelID = dict["LabelID"] as Int
            slabel.Sort = dict["Sort"] as Int
            slabel.LabelName = (dict["LabelName"] as String!).stringByReplacingOccurrencesOfString(" ", withString: "")
            slabel.Description = (dict["Description"] as String!).stringByReplacingOccurrencesOfString(" ", withString: "")
            
            slabelList.append(slabel)
            
        }

        return slabelList


    }
    
    //获取电影合集栏目板块明细
   static func getLLatestUpdate(特殊标签id sid:Int, 每页数量 pageSize:Int,当前页码 pageNum:Int)->Array<Model.BasicInfo> {
        var postStrig = webJsonUrl + "apiSpecilLabel?sid＝\(sid)&pageSize=\(pageSize)&pageNum=\(pageNum)"
    var arrayData = getJsonData(postStrig) as NSArray
    var basicList:Array<Model.BasicInfo> = []
    for item in arrayData{
        var dict = item as  NSDictionary
        var basic = Model.BasicInfo()
        
        basic.ColumnID = dict["ColumnID"] as Int
        basic.ReadCount = dict["ReadCount"] as Int
        basic.InfoID = dict["InfoID"] as Int
        basic.PicURL =  (dict["PicURL"] as String!).stringByReplacingOccurrencesOfString(" ", withString: "")
        basic.Title = (dict["Title"] as String!).stringByReplacingOccurrencesOfString(" ", withString: "")
        basic.LinkUrl = (dict["LinkUrl"] as String!).stringByReplacingOccurrencesOfString(" ", withString: "")
        basic.Introduction = (dict["Introduction"] as String!).stringByReplacingOccurrencesOfString(" ", withString: "")
        basic.SpecilLabelIDS = (dict["SpecilLabelIDS"] as String!).stringByReplacingOccurrencesOfString(" ", withString: "")
        basic.GoodTimes = dict["GoodTimes"] as Int
        basic.AuditID = dict["AuditID"] as Int
        basic.IsUsed = dict["IsUsed"] as Bool
        basic.AuditState = dict["AuditState"] as Bool
        basic.Content = (dict["Content"] as String!).stringByReplacingOccurrencesOfString(" ", withString: "")
        basic.AddTime = (dict["AddTime"] as String!).stringByReplacingOccurrencesOfString(" ", withString: "")
        basic.LabelIDS = (dict["LabelIDS"] as String!).stringByReplacingOccurrencesOfString(" ", withString: "")
        
        basicList.append(basic)
        
    }
    
    return basicList


    }
    
    //获取大家说内容
    static func getEveryoneSayList(id:Int, 每页数量 pageSize:Int,当前页码 pageNum:Int,发送者id senderid:Int) ->Array<Model.QASK>{
        var postStrig = webJsonUrl + "apiQASK?pageSize=\(pageSize)&pageNum=\(pageNum)&id=\(id)&senderid=\(senderid)"
        var arrayData = getJsonData(postStrig) as NSArray
        var qaskList:Array<Model.QASK> = []
        for item in arrayData{
            var dict = item as  NSDictionary
            var qask = Model.QASK()
            
            qask.QASKID = dict["QASKID"] as Int
            qask.ManagerID = dict["ManagerID"] as Int
            qask.SourceID = dict["SourceID"] as Int
            qask.SenderID = dict["SenderID"] as Int
            qask.ReplyID = dict["ReplyID"] as Int
            qask.AuditID = dict["AuditID"] as Int
            qask.IS_Editor = dict["IS_Editor"] as Bool
            qask.IsUsed = dict["IsUsed"] as Bool
            qask.Content = (dict["Content"] as String!).stringByReplacingOccurrencesOfString(" ", withString: "")
            qask.NickName = (dict["NickName"] as String!).stringByReplacingOccurrencesOfString(" ", withString: "")
            qask.iconFace = (dict["iconFace"] as String!).stringByReplacingOccurrencesOfString(" ", withString: "")
            
            var tempTime = dict["AddTmie"] as String!
            
            var timeFormat = NSDateFormatter()
            timeFormat.dateFormat = "yyyy-MM-dd\'T\'HH:mm:ss"
            var theday = timeFormat.dateFromString(tempTime)
            timeFormat.dateFormat = "yyyy-MM-dd HH:mm"
            qask.AddTmie = timeFormat.stringFromDate(theday!)
            
            qaskList.append(qask)
            
        }
        
        return qaskList
    }
    
    //获取最新问题
   static func getQASKList(是否小编主题 isEditor:Bool,主题下显示条数 subSize:Int,每页数量 pageSize:Int,当前页码 pageNum:Int,发送者id senderid:Int) ->Array<Model.QASK>{
        var postStrig = webJsonUrl + "apiQASK?isEditor=\(isEditor)&subSize=\(subSize)&pageSize=\(pageSize)&pageNum=\(pageNum)&senderid=\(senderid)"
        var arrayData = getJsonData(postStrig) as NSArray
        var qaskList:Array<Model.QASK> = []
        for item in arrayData{
            var dict = item as  NSDictionary
            var qask = Model.QASK()
        
            qask.QASKID = dict["QASKID"] as Int
            qask.ManagerID = dict["ManagerID"] as Int
            qask.SourceID = dict["SourceID"] as Int
            qask.SenderID = dict["SenderID"] as Int
            qask.ReplyID = dict["ReplyID"] as Int
            qask.AuditID = dict["AuditID"] as Int
            qask.IS_Editor = dict["IS_Editor"] as Bool
            qask.IsUsed = dict["IsUsed"] as Bool
            qask.Content = (dict["Content"] as String!).stringByReplacingOccurrencesOfString(" ", withString: "")
            qask.NickName = (dict["NickName"] as String!).stringByReplacingOccurrencesOfString(" ", withString: "")
            qask.iconFace = (dict["iconFace"] as String!).stringByReplacingOccurrencesOfString(" ", withString: "")
        
            var tempTime = dict["AddTmie"] as String!
            
            var timeFormat = NSDateFormatter()
            timeFormat.dateFormat = "yyyy-MM-dd\'T\'HH:mm:ss"
            var theday = timeFormat.dateFromString(tempTime)
            timeFormat.dateFormat = "yyyy-MM-dd HH:mm"
            qask.AddTmie = timeFormat.stringFromDate(theday!)
            
            qaskList.append(qask)
        
        }
    
        return qaskList
    }
    
    //获取参与问题
   static func getQASKParticipant(主题下显示条数 subSize:Int,每页数量 pageSize:Int,当前页码 pageNum:Int,发送者id senderid:Int)->Array<Model.QASK>{
        var postStrig = webJsonUrl + "apiQASK/?senderid=\(senderid)&subSize＝\(subSize)&pageSize=\(pageSize)&pageNum=\(pageNum)"
    var arrayData = getJsonData(postStrig) as NSArray
    var qaskList:Array<Model.QASK> = []
    for item in arrayData{
        var dict = item as  NSDictionary
        var qask = Model.QASK()
        
        qask.QASKID = dict["QASKID"] as Int
        qask.ManagerID = dict["ManagerID"] as Int
        qask.SourceID = dict["SourceID"] as Int
        qask.SenderID = dict["SenderID"] as Int
        qask.ReplyID = dict["ReplyID"] as Int
        qask.AuditID = dict["AuditID"] as Int
        qask.IS_Editor = dict["IS_Editor"] as Bool
        qask.IsUsed = dict["IsUsed"] as Bool
        qask.Content = (dict["Content"] as String!).stringByReplacingOccurrencesOfString(" ", withString: "")
        qask.AddTmie = (dict["AddTmie"] as String!).stringByReplacingOccurrencesOfString(" ", withString: "")
        qask.NickName = (dict["NickName"] as String!).stringByReplacingOccurrencesOfString(" ", withString: "")
        qask.iconFace = (dict["iconFace"] as String!).stringByReplacingOccurrencesOfString(" ", withString: "")
        
        qaskList.append(qask)
        
    }
    
    return qaskList

    }
    
    //获取问题
   static func getQASKInfo(问题id id:Int,每页数量 pageSize:Int,当前页码 pageNum:Int,发送者id senderid:Int)->Array<Model.QASK>{
        var postStrig = webJsonUrl + "apiQASK/getQASKInfo?senderid=\(senderid)&pageSize=\(pageSize)&pageNum=\(pageNum)&id=\(id)"
        var arrayData = getJsonData(postStrig) as NSArray
        var qaskList:Array<Model.QASK> = []
        for item in arrayData{
            var dict = item as  NSDictionary
            var qask = Model.QASK()
        
            qask.QASKID = dict["QASKID"] as Int
            qask.ManagerID = dict["ManagerID"] as Int
            qask.SourceID = dict["SourceID"] as Int
            qask.SenderID = dict["SenderID"] as Int
            qask.ReplyID = dict["ReplyID"] as Int
            qask.AuditID = dict["AuditID"] as Int
            qask.IS_Editor = dict["IS_Editor"] as Bool
            qask.IsUsed = dict["IsUsed"] as Bool
            qask.Content = (dict["Content"] as String!).stringByReplacingOccurrencesOfString(" ", withString: "")
            qask.NickName = (dict["NickName"] as String!).stringByReplacingOccurrencesOfString(" ", withString: "")
            qask.iconFace = (dict["iconFace"] as String!).stringByReplacingOccurrencesOfString(" ", withString: "")
        
            var tempTime = dict["AddTmie"] as String!
            
            var timeFormat = NSDateFormatter()
            timeFormat.dateFormat = "yyyy-MM-dd\'T\'HH:mm:ss"
            var theday = timeFormat.dateFromString(tempTime)
            timeFormat.dateFormat = "yyyy年MM月dd日 HH:mm"
            qask.AddTmie = timeFormat.stringFromDate(theday!)
            
            qaskList.append(qask)
        
        }
    
    return qaskList

    }
 
    /**
    *  剪切图片为正方形
    *
    *  @param image   原始图片比如size大小为(400x200)pixels
    *  @param newSize 正方形的size比如400pixels
    *
    *  @return 返回正方形图片(400x400)pixels
    */
    
    static func squareImageFromImage(image:UIImage,scaledToSize newSize:CGFloat,isScale:Bool) ->UIImage{
        var scaleTransform : CGAffineTransform
        var origin:CGPoint
        
        if image.size.width > image.size.height {
            //image原始高度为200，缩放image的高度为400pixels，所以缩放比率为2
            var scaleRatio = newSize / image.size.height
            scaleTransform = CGAffineTransformMakeScale(scaleRatio, scaleRatio)
            //设置绘制原始图片的画笔坐标为CGPoint(-100, 0)pixels
            origin = CGPoint(x: -(image.size.width - image.size.height) / 2.0, y: 0)
        } else {
            var scaleRatio = newSize / image.size.width;
            scaleTransform = CGAffineTransformMakeScale(scaleRatio, scaleRatio)
            
            origin = CGPoint(x: 0, y: -(image.size.height - image.size.width) / 2.0);
        }
        
        var size = CGSize(width: newSize, height: newSize);
        
        UIGraphicsBeginImageContext(size)
        
        //创建画板为(400x400)pixels
        if isScale{
            UIGraphicsBeginImageContextWithOptions(size, true, 0)
        }        else {
            UIGraphicsBeginImageContext(size)
        }
        
        var context = UIGraphicsGetCurrentContext()
        
        //将image原始图片(400x200)pixels缩放为(800x400)pixels
        CGContextConcatCTM(context, scaleTransform)
        //origin也会从原始(-100, 0)缩放到(-200, 0)
        
        image.drawAtPoint(origin)
        
        //获取缩放后剪切的image图片
       var returnImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext();
        
        return returnImage

        
    }
    
    static func checkEmail(email:String)->Bool {
        
        var exp = "^[\\w-_\\.+]*[\\w-_\\.]\\@([\\w]+\\.)+[\\w]+[\\w]$"
        var regextestemail = NSPredicate(format: "SELF MATCHES %@",exp)
        if regextestemail?.evaluateWithObject(email) == true {
            return true
        } else {
            return false
        }
        
    }
    
    static func reSizeImage(image:UIImage,toSize:CGSize) -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: toSize.width, height: toSize.height))
        image.drawInRect(CGRect(x: 0,y: 0,width: toSize.width,height: toSize.height))
        var img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
    
    
}

