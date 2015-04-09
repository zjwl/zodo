//
//  model.swift
//  多芒电影
//
//  Created by 柴小红 on 15/2/3.
//  Copyright (c) 2015年 珠影网络. All rights reserved.
//

import Foundation
class Model {
    
}
extension Model{
    
    class AD :NSObject{
        var AD_ID:Int = 0
        var Ad_Name:String = ""
        var Photo_URL:String = ""
        var Ad_Type:String = ""
        var AD_PLACE_ID:Int = 0
        var ManagerID:Int = 0
        var Descripton:Int = 0
        var IsUsed:Bool = false
        var AD_TargetAddr:String = ""
        var StartTime:String = ""
        var EndTime:String = ""
    }
    
    class BasicInfo:NSObject{
        var ColumnID:Int = 0
        var ReadCount:Int = 0
        var InfoID:Int = 0
        var PicURL:String = ""
        var Title:String = ""
        var LinkUrl:String = ""
        var Introduction:String = ""
        var SpecilLabelIDS:String = ""
        var Content:String = ""
        var AddTime:String = ""
        var GoodTimes:Int = 0
        var LabelIDS:String = ""
        var AuditID:Int = 0
        var IsUsed:Bool = false
        var AuditState:Bool = false
    }
    
    class Collection:BasicInfo{
        var CollectID:Int = 0
        var CollectTime:String = ""
    }
    
    class History:BasicInfo{
        var HistoryID:Int = 0
        var HistoryTime:String = ""
    }
    
    class FilmAlbum :NSObject{
        var FilmAlbumID:Int = 0
        var ManagerID:Int = 0
        var Title:String = ""
        var Description:String = ""
        var AddTime:String = ""
        var ThePhoto:String = ""
        var InfoIDS:String = ""
        var IsUsed:Bool = false
        var LabelIDS:String = ""
    }
    
    class Game :NSObject{
        var GameID:Int = 0
        var ManagerID:Int = 0
        var GameName:String = ""
        var GameAddress:String = ""
        var Description:String = ""
        var IsUsed:Bool = false
        var ClassName:String = ""
        var PackageName:String = ""
        var GamePhoto:String = ""
        
    }
    
    class QASK :NSObject{
        var QASKID:Int = 0
        var ManagerID:Int = 0
        var SourceID:Int = 0
        var Content:String = ""
        var SenderID:Int = 0
        var ReplyID:Int = 0
        var AddTmie:String = ""
        var IS_Editor:Bool = false
        var IsUsed:Bool = false
        var AuditID:Int = 0
        var NickName:String = ""
        var iconFace:String = ""
    }
    
    class SpecilLabel :NSObject{
        var LabelID:Int = 0
        var LabelName:String = ""
        var Sort:Int = 0
        var Description:String = ""
    }
    
    class LoginModel: NSObject,NSCoding {
        var MemberID:String = ""
        var NickName:String = ""
        var UserName:String = ""
        var Password:String = ""
        var WhereFrom:String = ""
        var Mail:String = ""
        var Identity:String = ""
        var HeadPhotoURL:String = ""
        var IsUsed:String = ""
        var IsActivation:String = ""
        var registrationTime:String = ""
        var LastVisitTime:String = ""
        
        func encodeWithCoder(aCoder: NSCoder){
            aCoder.encodeObject(self.MemberID, forKey: "MemberID")
            aCoder.encodeObject(self.NickName, forKey: "NickName")
            aCoder.encodeObject(self.UserName, forKey: "UserName")
            aCoder.encodeObject(self.Password, forKey: "Password")
            aCoder.encodeObject(self.WhereFrom, forKey: "WhereFrom")
            aCoder.encodeObject(self.Mail, forKey: "Mail")
            aCoder.encodeObject(self.Identity, forKey: "Identity")
            aCoder.encodeObject(self.HeadPhotoURL, forKey: "HeadPhotoURL")
            aCoder.encodeObject(self.IsUsed, forKey: "IsUsed")
            aCoder.encodeObject(self.IsActivation, forKey: "IsActivation")
            aCoder.encodeObject(self.registrationTime, forKey: "registrationTime")
            aCoder.encodeObject(self.LastVisitTime, forKey: "LastVisitTime")
        }
        
        override init(){
            
        }
        
        required init(coder aDecoder: NSCoder){
            self.NickName = aDecoder.decodeObjectForKey("NickName") as String
            self.MemberID = aDecoder.decodeObjectForKey("MemberID") as String
            self.UserName = aDecoder.decodeObjectForKey("UserName") as String
            self.Password = aDecoder.decodeObjectForKey("Password") as String
            self.WhereFrom = aDecoder.decodeObjectForKey("WhereFrom") as String
            self.Mail = aDecoder.decodeObjectForKey("Mail") as String
            self.Identity = aDecoder.decodeObjectForKey("Identity") as String
            self.HeadPhotoURL = aDecoder.decodeObjectForKey("HeadPhotoURL") as String
            self.IsUsed = aDecoder.decodeObjectForKey("IsUsed") as String
            self.IsActivation = aDecoder.decodeObjectForKey("IsActivation") as String
            self.registrationTime = aDecoder.decodeObjectForKey("registrationTime") as String
            self.LastVisitTime = aDecoder.decodeObjectForKey("LastVisitTime") as String
            
        }
    }
    
}
