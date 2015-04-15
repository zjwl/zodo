//
//  CommonAccess.swift
//  多芒电影
//
//  Created by junjian chen on 15/4/13.
//  Copyright (c) 2015年 珠影网络. All rights reserved.
//

import Foundation

class CommonAccess: NSObject, NSURLConnectionDataDelegate {
    let webJsonUrl = "http://apk.zdomo.com/api/"
    let domain = "http://apk.zdomo.com"
    var flag="",methodName="getLlatestUpdate"
    var delegate:CommonAccessDelegate
    var mutableData:NSMutableData  = NSMutableData.alloc()
    var isCache=false
    var cacheKey=""
    
    internal init(delegate:CommonAccessDelegate,flag:String) {
        self.delegate = delegate
        self.flag = flag
    }
    
    
    func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse){
    }
    
    func connection(connection: NSURLConnection, didReceiveData data: NSData){
        mutableData.appendData(data)
    }
    
    func setBasicList(arrayData:NSArray){
        var basicList:Array<Model.BasicInfo> = []
        for item in arrayData{
            var dict = item as!  NSDictionary
            var basic = Model.BasicInfo()
            
            basic.ColumnID = dict["ColumnID"] as! Int
            basic.InfoID = dict["InfoID"] as! Int
            basic.PicURL =  domain+(dict["PicURL"] as! String).stringByReplacingOccurrencesOfString(" ", withString: "")
            basic.Title = (dict["Title"] as! String).stringByReplacingOccurrencesOfString(" ", withString: "")
            basic.LinkUrl = (dict["LinkUrl"] as! String).stringByReplacingOccurrencesOfString(" ", withString: "")
            basic.Introduction = (dict["Introduction"] as! String).stringByReplacingOccurrencesOfString(" ", withString: "")
            basic.SpecilLabelIDS = (dict["SpecilLabelIDS"] as! String).stringByReplacingOccurrencesOfString(" ", withString: "")
            basic.GoodTimes = dict["GoodTimes"] as! Int
            basic.Content = dict["Content"] as! String
            basic.AddTime = (dict["AddTime"] as! String).stringByReplacingOccurrencesOfString(" ", withString: "")
            basic.LabelIDS = (dict["LabelIDS"] as! String).stringByReplacingOccurrencesOfString(" ", withString: "")
            
            if var auditID :AnyObject = dict["AuditID"] {
                basic.AuditID =  auditID as! Int
            }
            
            if var isused :AnyObject = dict["IsUsed"] {
                basic.IsUsed =  isused as! Bool
            }
            
            if var auditState :AnyObject = dict["AuditID"] {
                basic.AuditState =  auditState as! Bool
            }
            basicList.append(basic)
        }
        self.delegate.setCallbackObject(flag, object: basicList)
    }
    
    func setADlist(arrayData:NSArray){
        var adList:Array<Model.AD> = []
        for item in arrayData{
            var dict = item as!  NSDictionary
            
            var ad = Model.AD()
            
            ad.AD_ID = dict["AD_ID"] as! Int
            ad.Ad_Name =  (dict["Ad_Name"] as! String).stringByReplacingOccurrencesOfString(" ", withString: "")
            ad.Photo_URL = (dict["Photo_URL"] as! String).stringByReplacingOccurrencesOfString(" ", withString: "")
            ad.Ad_Type = (dict["Ad_Type"] as! String).stringByReplacingOccurrencesOfString(" ", withString: "")
            ad.AD_PLACE_ID = dict["AD_ID"] as! Int
            ad.ManagerID = dict["AD_ID"] as! Int
            ad.Descripton = dict["AD_ID"] as! Int
            ad.IsUsed = dict["IsUsed"] as! Bool
            ad.AD_TargetAddr = (dict["AD_TargetAddr"] as! String).stringByReplacingOccurrencesOfString(" ", withString: "")
            ad.StartTime = (dict["StartTime"] as! String).stringByReplacingOccurrencesOfString(" ", withString: "")
            ad.EndTime = (dict["EndTime"] as! String).stringByReplacingOccurrencesOfString(" ", withString: "")
            
            adList.append(ad)
        }
        self.delegate.setCallbackObject(flag, object: adList)
    }
    
    func setBasicInfo(dict:NSDictionary){
        var basic = Model.BasicInfo()
        basic.ColumnID = dict["ColumnID"] as! Int
        basic.InfoID = dict["InfoID"] as! Int
        basic.PicURL =  (dict["PicURL"] as! String).stringByReplacingOccurrencesOfString(" ", withString: "")
        basic.Title = (dict["Title"] as! String).stringByReplacingOccurrencesOfString(" ", withString: "")
        basic.LinkUrl = (dict["LinkUrl"] as! String).stringByReplacingOccurrencesOfString(" ", withString: "")
        basic.Introduction = (dict["Introduction"] as! String).stringByReplacingOccurrencesOfString(" ", withString: "")
        basic.SpecilLabelIDS = (dict["SpecilLabelIDS"] as! String).stringByReplacingOccurrencesOfString(" ", withString: "")
        basic.GoodTimes = dict["GoodTimes"] as! Int
        basic.AuditID = dict["AuditID"] as! Int
        basic.IsUsed = dict["IsUsed"] as! Bool
        basic.AuditState = dict["AuditState"] as! Bool
        basic.Content = (dict["Content"] as! String).stringByReplacingOccurrencesOfString(" ", withString: "")
        basic.AddTime = (dict["AddTime"] as! String).stringByReplacingOccurrencesOfString(" ", withString: "")
        basic.LabelIDS = (dict["LabelIDS"] as! String).stringByReplacingOccurrencesOfString(" ", withString: "")
        
        self.delegate.setCallbackObject(flag, object: basic)
    }
    
    func setCollectionList(arrayData:NSArray){
        var basicList:Array<Model.Collection> = []
        for item in arrayData{
            var dict = item as!  NSDictionary
            
            var basic = Model.Collection()
            
            basic.ColumnID = dict["ColumnID"] as! Int
            basic.InfoID = dict["InfoID"] as! Int
            basic.PicURL =  domain+(dict["PicURL"] as! String).stringByReplacingOccurrencesOfString(" ", withString: "")
            basic.Title = (dict["Title"] as! String).stringByReplacingOccurrencesOfString(" ", withString: "")
            basic.LinkUrl = (dict["LinkUrl"] as! String).stringByReplacingOccurrencesOfString(" ", withString: "")
            basic.Introduction = (dict["Introduction"] as! String).stringByReplacingOccurrencesOfString(" ", withString: "")
            basic.SpecilLabelIDS = (dict["SpecilLabelIDS"] as! String).stringByReplacingOccurrencesOfString(" ", withString: "")
            basic.GoodTimes = dict["GoodTimes"] as! Int
            //basic.AuditID = dict["AuditID"] as Int
            //basic.IsUsed = dict["IsUsed"] as Bool
            //basic.AuditState = dict["AuditState"] as Bool
            basic.Content = (dict["Content"] as! String)
            basic.AddTime = (dict["AddTime"] as! String).stringByReplacingOccurrencesOfString(" ", withString: "")
            basic.LabelIDS = (dict["LabelIDS"] as! String).stringByReplacingOccurrencesOfString(" ", withString: "")
            basic.CollectID = dict["CollectID"] as! Int
            var tempTime = dict["CollectTime"] as! String
            
            var timeFormat = NSDateFormatter()
            timeFormat.dateFormat = "yyyy-MM-dd\'T\'HH:mm:ss"
            var theday = timeFormat.dateFromString(tempTime)
            timeFormat.dateFormat = "yyyy-MM-dd HH:mm:ss"
            basic.CollectTime = timeFormat.stringFromDate(theday!)
            
            basicList.append(basic)
            
        }
        self.delegate.setCallbackObject(flag, object: basicList)
    }
    
    func setFilmAlbum(arrayData:NSArray){
        var faList:Array<Model.FilmAlbum> = []
        for item in arrayData{
            var dict = item as!  NSDictionary
            
            var filmAlbum = Model.FilmAlbum()
            filmAlbum.FilmAlbumID = dict["FilmAlbumID"] as! Int
            filmAlbum.ManagerID = dict["ManagerID"] as! Int
            filmAlbum.ThePhoto = (dict["ThePhoto"] as! String).stringByReplacingOccurrencesOfString(" ", withString: "")
            filmAlbum.Title = (dict["Title"] as! String).stringByReplacingOccurrencesOfString(" ", withString: "")
            filmAlbum.Description = (dict["Description"] as! String).stringByReplacingOccurrencesOfString(" ", withString: "")
            filmAlbum.InfoIDS = (dict["InfoIDS"] as! String).stringByReplacingOccurrencesOfString(" ", withString: "")
            
            filmAlbum.IsUsed = dict["IsUsed"] as! Bool
            filmAlbum.AddTime = (dict["AddTime"] as! String).stringByReplacingOccurrencesOfString(" ", withString: "")
            filmAlbum.LabelIDS = (dict["LabelIDS"] as! String).stringByReplacingOccurrencesOfString(" ", withString: "")
            
            faList.append(filmAlbum)
        }
        self.delegate.setCallbackObject(flag, object: faList)
    }
    
    func setFilmAlbumDetail(arrayData:NSArray){
        var basicList:Array<Model.BasicInfo> = []
        for item in arrayData{
            var dict = item as!  NSDictionary
            
            var basic = Model.BasicInfo()
            
            basic.ColumnID = dict["ColumnID"] as! Int
            basic.InfoID = dict["InfoID"] as! Int
            basic.PicURL =  domain+(dict["PicURL"] as! String).stringByReplacingOccurrencesOfString(" ", withString: "")
            basic.Title = (dict["Title"] as! String).stringByReplacingOccurrencesOfString(" ", withString: "")
            basic.LinkUrl = (dict["LinkUrl"] as! String).stringByReplacingOccurrencesOfString(" ", withString: "")
            basic.Introduction = (dict["Introduction"] as! String).stringByReplacingOccurrencesOfString(" ", withString: "")
            basic.SpecilLabelIDS = (dict["SpecilLabelIDS"] as! String).stringByReplacingOccurrencesOfString(" ", withString: "")
            basic.GoodTimes = dict["GoodTimes"] as! Int
            //basic.AuditID = dict["AuditID"] as Int
            //basic.IsUsed = dict["IsUsed"] as Bool
            //basic.AuditState = dict["AuditState"] as Bool
            basic.Content = (dict["Content"] as! String).stringByReplacingOccurrencesOfString(" ", withString: "")
            basic.AddTime = (dict["AddTime"] as! String).stringByReplacingOccurrencesOfString(" ", withString: "")
            basic.LabelIDS = (dict["LabelIDS"] as! String).stringByReplacingOccurrencesOfString(" ", withString: "")
            
            basicList.append(basic)
            
        }
        self.delegate.setCallbackObject(flag, object: basicList)
    }
    
    func setGameList(arrayData:NSArray){
        var gameList:Array<Model.Game> = []
        for item in arrayData{
            var dict = item as!  NSDictionary
            
            var game = Model.Game()
            game.GameID = dict["GameID"] as! Int
            game.ManagerID = dict["ManagerID"] as! Int
            game.GameName = (dict["GameName"] as! String).stringByReplacingOccurrencesOfString(" ", withString: "")
            game.GameAddress = (dict["GameAddress"] as! String).stringByReplacingOccurrencesOfString(" ", withString: "")
            game.Description = (dict["Description"] as! String).stringByReplacingOccurrencesOfString(" ", withString: "")
            game.IsUsed = dict["IsUsed"] as! Bool
            game.ClassName = (dict["ClassName"] as! String).stringByReplacingOccurrencesOfString(" ", withString: "")
            game.PackageName = (dict["PackageName"] as! String).stringByReplacingOccurrencesOfString(" ", withString: "")
            game.GamePhoto = (dict["GamePhoto"] as! String).stringByReplacingOccurrencesOfString(" ", withString: "")
            
            gameList.append(game)
            
        }
        self.delegate.setCallbackObject(flag, object: gameList)
    }
    
    func setHistory(arrayData:NSArray){
        var histroyList:Array<Model.History> = []
        for item in arrayData{
            var dict = item as!  NSDictionary
            
            var history = Model.History()
            
            history.ColumnID = dict["ColumnID"] as! Int
            history.InfoID = dict["InfoID"] as! Int
            history.PicURL =  domain+(dict["PicURL"] as! String).stringByReplacingOccurrencesOfString(" ", withString: "")
            history.Title = (dict["Title"] as! String).stringByReplacingOccurrencesOfString(" ", withString: "")
            history.LinkUrl = (dict["LinkUrl"] as! String).stringByReplacingOccurrencesOfString(" ", withString: "")
            history.Introduction = (dict["Introduction"] as! String).stringByReplacingOccurrencesOfString(" ", withString: "")
            history.SpecilLabelIDS = (dict["SpecilLabelIDS"] as! String).stringByReplacingOccurrencesOfString(" ", withString: "")
            history.GoodTimes = dict["GoodTimes"] as! Int
            //            history.AuditID = dict["AuditID"] as Int
            //            history.IsUsed = dict["IsUsed"] as Bool
            //            history.AuditState = dict["AuditState"] as Bool
            history.Content = (dict["Content"] as! String).stringByReplacingOccurrencesOfString(" ", withString: "")
            history.AddTime = (dict["AddTime"] as! String).stringByReplacingOccurrencesOfString(" ", withString: "")
            history.LabelIDS = (dict["LabelIDS"] as! String).stringByReplacingOccurrencesOfString(" ", withString: "")
            history.HistoryID = dict["HistoryID"] as! Int
            
            
            var tempTime = dict["HistoryTime"] as! String
            
            var timeFormat = NSDateFormatter()
            timeFormat.dateFormat = "yyyy-MM-dd\'T\'HH:mm:ss"
            var theday = timeFormat.dateFromString(tempTime)
            timeFormat.dateFormat = "yyyy-MM-dd HH:mm:ss"
            history.HistoryTime = timeFormat.stringFromDate(theday!)
            
            histroyList.append(history)
            
        }
        self.delegate.setCallbackObject(flag, object: histroyList)
    }
    
    func setSpecilLabel(arrayData:NSArray){
        var slabelList:Array<Model.SpecilLabel> = []
        for item in arrayData{
            var dict = item as!  NSDictionary
            
            var slabel = Model.SpecilLabel()
            slabel.LabelID = dict["LabelID"] as! Int
            slabel.Sort = dict["Sort"] as! Int
            slabel.LabelName = (dict["LabelName"] as! String).stringByReplacingOccurrencesOfString(" ", withString: "")
            slabel.Description = (dict["Description"] as! String).stringByReplacingOccurrencesOfString(" ", withString: "")
            slabelList.append(slabel)
        }
        self.delegate.setCallbackObject(flag, object: slabelList)
    }
    
    func setEveryoneSayList(arrayData:NSArray){
        var qaskList:Array<Model.QASK> = []
        for item in arrayData{
            var dict = item as!  NSDictionary
            var qask = Model.QASK()
            
            qask.QASKID = dict["QASKID"] as! Int
            qask.ManagerID = dict["ManagerID"] as! Int
            qask.SourceID = dict["SourceID"] as! Int
            qask.SenderID = dict["SenderID"] as! Int
            qask.ReplyID = dict["ReplyID"] as! Int
            qask.AuditID = dict["AuditID"] as! Int
            qask.IS_Editor = dict["IS_Editor"] as! Bool
            qask.IsUsed = dict["IsUsed"] as! Bool
            qask.Content = (dict["Content"] as!  String).stringByReplacingOccurrencesOfString(" ", withString: "")
            qask.NickName = (dict["NickName"] as!  String).stringByReplacingOccurrencesOfString(" ", withString: "")
            qask.iconFace = (dict["iconFace"] as!  String).stringByReplacingOccurrencesOfString(" ", withString: "")
            
            var tempTime = dict["AddTmie"] as!  String
            
            var timeFormat = NSDateFormatter()
            timeFormat.dateFormat = "yyyy-MM-dd\'T\'HH:mm:ss"
            var theday = timeFormat.dateFromString(tempTime)
            timeFormat.dateFormat = "yyyy-MM-dd HH:mm"
            qask.AddTmie = timeFormat.stringFromDate(theday!)
            
            qaskList.append(qask)
        }
        self.delegate.setCallbackObject(flag, object: qaskList)
    }
    func setQASKList(arrayData:NSArray){
        var qaskList:Array<Model.QASK> = []
        for item in arrayData{
            var dict = item as!  NSDictionary
            var qask = Model.QASK()
            
            qask.QASKID = dict["QASKID"] as! Int
            qask.ManagerID = dict["ManagerID"] as! Int
            qask.SourceID = dict["SourceID"] as! Int
            qask.SenderID = dict["SenderID"] as! Int
            qask.ReplyID = dict["ReplyID"] as! Int
            qask.AuditID = dict["AuditID"] as! Int
            qask.IS_Editor = dict["IS_Editor"] as! Bool
            qask.IsUsed = dict["IsUsed"] as! Bool
            qask.Content = (dict["Content"] as!  String).stringByReplacingOccurrencesOfString(" ", withString: "")
            qask.AddTmie = (dict["AddTmie"] as!  String).stringByReplacingOccurrencesOfString(" ", withString: "")
            qask.NickName = (dict["NickName"] as!  String).stringByReplacingOccurrencesOfString(" ", withString: "")
            qask.iconFace = (dict["iconFace"] as!  String).stringByReplacingOccurrencesOfString(" ", withString: "")
            
            qaskList.append(qask)
            
        }
        self.delegate.setCallbackObject(flag, object: qaskList)
    }
    
    func setQASKInfo(arrayData:NSArray){
        var qaskList:Array<Model.QASK> = []
        for item in arrayData{
            var dict = item as!  NSDictionary
            var qask = Model.QASK()
            
            qask.QASKID = dict["QASKID"] as! Int
            qask.ManagerID = dict["ManagerID"] as! Int
            qask.SourceID = dict["SourceID"] as! Int
            qask.SenderID = dict["SenderID"] as! Int
            qask.ReplyID = dict["ReplyID"] as! Int
            qask.AuditID = dict["AuditID"] as! Int
            qask.IS_Editor = dict["IS_Editor"] as! Bool
            qask.IsUsed = dict["IsUsed"] as! Bool
            qask.Content = (dict["Content"] as!  String).stringByReplacingOccurrencesOfString(" ", withString: "")
            qask.NickName = (dict["NickName"] as!  String).stringByReplacingOccurrencesOfString(" ", withString: "")
            qask.iconFace = (dict["iconFace"] as!  String).stringByReplacingOccurrencesOfString(" ", withString: "")
            
            var tempTime = dict["AddTmie"] as!  String
            
            var timeFormat = NSDateFormatter()
            timeFormat.dateFormat = "yyyy-MM-dd\'T\'HH:mm:ss"
            var theday = timeFormat.dateFromString(tempTime)
            timeFormat.dateFormat = "yyyy年MM月dd日 HH:mm"
            qask.AddTmie = timeFormat.stringFromDate(theday!)
            
            qaskList.append(qask)
            
        }
        self.delegate.setCallbackObject(flag, object: qaskList)
    }
    
    func setQASKParticipant(arrayData:NSArray){
        var qaskList:Array<Model.QASK> = []
        for item in arrayData{
            var dict = item as!  NSDictionary
            var qask = Model.QASK()
            
            qask.QASKID = dict["QASKID"] as! Int
            qask.ManagerID = dict["ManagerID"] as! Int
            qask.SourceID = dict["SourceID"] as! Int
            qask.SenderID = dict["SenderID"] as! Int
            qask.ReplyID = dict["ReplyID"] as! Int
            qask.AuditID = dict["AuditID"] as! Int
            qask.IS_Editor = dict["IS_Editor"] as! Bool
            qask.IsUsed = dict["IsUsed"] as! Bool
            qask.Content = (dict["Content"] as!  String).stringByReplacingOccurrencesOfString(" ", withString: "")
            qask.AddTmie = (dict["AddTmie"] as!  String).stringByReplacingOccurrencesOfString(" ", withString: "")
            qask.NickName = (dict["NickName"] as!  String).stringByReplacingOccurrencesOfString(" ", withString: "")
            qask.iconFace = (dict["iconFace"] as!  String).stringByReplacingOccurrencesOfString(" ", withString: "")
            
            qaskList.append(qask)
            
        }
        self.delegate.setCallbackObject(flag, object: qaskList)
    }
    
    func setObjectByCache(value data:AnyObject?){
        if data == nil{
            return
        }else {
            setValueByMethodName(value: data as! NSMutableData)
        }
    }
    
    private func setValueByMethodName(value data:NSMutableData){
        switch methodName {
        case "getLlatestUpdate":
            var json:AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil)!
            var arrayData = json as! NSArray
            setBasicList(arrayData)
        case "getApiAD":
            var json:AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil)!
            var arrayData = json as! NSArray
            setADlist(arrayData)
        case "getBasicInfo":
            var json:AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil)!
            var jsonData = json as! NSDictionary
            setBasicInfo(jsonData)
        case "getUpdateCount","getCollectionIDS":
            var json:AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil)!
            self.delegate.setCallbackObject(flag, object: json as! NSObject)
        case "getCollection":
            var json:AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil)!
            var arrayData = json as! NSArray
            setCollectionList(arrayData)
        case "getFilmAlbum":
            var json:AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil)!
            var arrayData = json as! NSArray
            setFilmAlbum(arrayData)
        case "getFilmAlbumDetail":
            var json:AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil)!
            var arrayData = json as! NSArray
            setFilmAlbumDetail(arrayData)
        case "getGameList":
            var json:AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil)!
            var arrayData = json as! NSArray
            setGameList(arrayData)
        case "getHistory":
            var json:AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil)!
            var arrayData = json as! NSArray
            setHistory(arrayData)
        case "getSpecilLabel":
            var json:AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil)!
            var arrayData = json as! NSArray
            setSpecilLabel(arrayData)
        case "getEveryoneSayList":
            var json:AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil)!
            var arrayData = json as! NSArray
            setEveryoneSayList(arrayData)
        case "getQASKList":
            var json:AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil)!
            var arrayData = json as! NSArray
            setQASKList(arrayData)
        case "getQASKInfo":
            var json:AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil)!
            var arrayData = json as! NSArray
            setQASKInfo(arrayData)
        case "getQASKParticipant":
            var json:AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil)!
            var arrayData = json as! NSArray
            setQASKParticipant(arrayData)
        default:
            var json:AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil)!
            var arrayData = json as! NSArray
            setBasicList(arrayData)
        }
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection) {
        if isCache {
            var ud = NSUserDefaults.standardUserDefaults()
            ud.setValue(mutableData, forKey: cacheKey)
        }
        setValueByMethodName(value: mutableData)
    }
    
    func setConnectionWithUrl(url:String){
        var theUrl = NSURL(string: url)
        var theRequest = NSMutableURLRequest(URL: theUrl!)
        theRequest.addValue("text/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        theRequest.HTTPMethod = "GET"
        
        var connection = NSURLConnection(request: theRequest, delegate: self, startImmediately: true)
        connection!.start()
        
        if (connection == true) {
            var mutableData : Void = NSMutableData.initialize()
        }

    }
    
    //获取最新更新
    func getLlatestUpdate(栏目id columnid:Int,特殊标签id sid:Int, 每页数量 pageSize:Int,当前页码 pageNum:Int){
        var url = webJsonUrl + "apibasic?columnid=\(columnid)&pageSize=\(pageSize)&pageNum=\(pageNum)&sid=\(sid)"
        methodName = "getLlatestUpdate"
        if pageNum==0{
            cacheKey="basic_c_\(columnid)_s_\(sid)_p_0"
            isCache=true
        }
        setConnectionWithUrl(url)
    }
    
    //广告接口
    func getApiAD(广告位id adplaceid:Int,每页数量 pageSize:Int,当前页码 pageNum:Int) {
        var url = webJsonUrl + "apiad/getAd?adplaceid=\(adplaceid)&pageSize=\(pageSize)&pageNum=\(pageNum)"
        methodName = "getApiAD"
        if pageNum==0{
            cacheKey="ad_0"
            isCache=true
        }
        setConnectionWithUrl(url)
    }
    
    //获取具体信息
    func getBasicInfo(信息id infoid:Int) {
        var url = webJsonUrl + "apibasic?id=\(infoid)"
        methodName = "getBasicInfo"
        setConnectionWithUrl(url)
    }
    
    //获取各版本更新数量
    func getUpdateCount(栏目时间与id组合 s:String) {
        var url = webJsonUrl + "apibasic?s=\(s)"
        methodName = "getUpdateCount"
        setConnectionWithUrl(url)
    }
    
    //获取收藏列表
    func getCollection(客户id memberid:Int,每页数量 pageSize:Int,当前页码 pageNum:Int){
        var url = webJsonUrl + "apiCollection?memberid=\(memberid)&pageSize=\(pageSize)&pageNum=\(pageNum)"
        methodName = "getCollection"
        if pageNum==0{
            cacheKey="collection_0"
            isCache=true
        }
        setConnectionWithUrl(url)
    }
    
    //获取特定用户所有收藏的信息id集合
    func getCollectionIDS(客户id userid:Int){
        var url = webJsonUrl + "apiCollection?memberid=\(userid)"
        methodName = "getCollectionIDS"
        setConnectionWithUrl(url)
    }
    
    //获取电影合辑
    
    //获取电影合辑栏目板块
    func getFilmAlbum(每页数量 pageSize:Int,当前页码 pageNum:Int){
        var url = webJsonUrl + "apiFilmAlbum?pageSize=\(pageSize)&pageNum=\(pageNum)"
        methodName = "getFilmAlbum"
        if pageNum==0{
            cacheKey="filmalbum_0"
            isCache=true
        }
        setConnectionWithUrl(url)
    }
    
    //获取电影合辑具体板块明细
    func getFilmAlbumDetail(电影合辑板块id id:Int) {
        var url = webJsonUrl + "apiFilmAlbum?id=\(id)"
        methodName = "getFilmAlbumDetail"
        cacheKey="filmalbum_\(id)"
        isCache=true
        setConnectionWithUrl(url)
    }
    
    //获取游戏列表
    func getGameList(每页数量 pageSize:Int,当前页码 pageNum:Int) {
        var url = webJsonUrl + "apiGame/?pageSize=\(pageSize)&pageNum=\(pageNum)&type=ios"
        methodName = "getGameList"
        if pageNum==0{
            cacheKey="game_0"
            isCache=true
        }
        setConnectionWithUrl(url)
    }
    
    
    
    //获取访问历史
    func getHistory(客户id memberid:Int,每页数量 pageSize:Int,当前页码 pageNum:Int) {
        var url = webJsonUrl + "apiHistory?memberid=\(memberid)&pageSize=\(pageSize)&pageNum=\(pageNum)"
        methodName = "getHistory"
        if pageNum==0{
            cacheKey="history_0"
            isCache=true
        }
        setConnectionWithUrl(url)
    }
    
    //获取会员数据
    func getMember(客户id memberid:Int) {
        var url = webJsonUrl + "apiMember/getOne?id=\(memberid)"
        methodName = "getMember"
        setConnectionWithUrl(url)
    }
    
    //获取会员数据
    func getMember(用户名 username:String,密码 password:String) {
        var url = webJsonUrl + "apiMember/getOne?userName=\(username)&password＝\(password)"
        methodName = "getMember"
        setConnectionWithUrl(url)
    }
    
    //获取电影各板块，以标签分化
     func getSpecilLabel()  {
        var url = webJsonUrl + "apiSpecilLabel?1=1"
        methodName = "getSpecilLabel"
        setConnectionWithUrl(url)
    }
    
    //获取大家说内容
     func getEveryoneSayList(id:Int, 每页数量 pageSize:Int,当前页码 pageNum:Int,发送者id senderid:Int){
        var url = webJsonUrl + "apiQASK?pageSize=\(pageSize)&pageNum=\(pageNum)&id=\(id)&senderid=\(senderid)"
        methodName = "getEveryoneSayList"
        setConnectionWithUrl(url)
    }
    
    //获取最新问题
     func getQASKList(是否小编主题 isEditor:Bool,主题下显示条数 subSize:Int,每页数量 pageSize:Int,当前页码 pageNum:Int,发送者id senderid:Int) {
        var url = webJsonUrl + "apiQASK?isEditor=\(isEditor)&subSize=\(subSize)&pageSize=\(pageSize)&pageNum=\(pageNum)&senderid=\(senderid)"
        methodName = "getQASKList"
        setConnectionWithUrl(url)
    }
    
    //获取参与问题
     func getQASKParticipant(主题下显示条数 subSize:Int,每页数量 pageSize:Int,当前页码 pageNum:Int,发送者id senderid:Int){
        //var url = webJsonUrl + "apiQASK/?senderid=\(senderid)&subSize＝\(subSize)&pageSize=\(pageSize)&pageNum=\(pageNum)"
        var url = webJsonUrl + "apiQASK/?senderid=\(senderid)&subSize=\(subSize)&pageSize=\(pageSize)&pageNum=\(pageNum)"
        methodName = "getQASKParticipant"
        setConnectionWithUrl(url)
    }
    
    //获取问题
     func getQASKInfo(问题id id:Int,每页数量 pageSize:Int,当前页码 pageNum:Int,发送者id senderid:Int){
        var url = webJsonUrl + "apiQASK/getQASKInfo?senderid=\(senderid)&pageSize=\(pageSize)&pageNum=\(pageNum)&id=\(id)"
        methodName = "getQASKInfo"
        setConnectionWithUrl(url)
    }

    
}