//
//  BaseAccess.swift
//  ZdomoApp
//
//  Created by 柴小红 on 15/1/23.
//  Copyright (c) 2015年 柴小红. All rights reserved.
//

import Foundation

class BaseAccess : NSObject, NSURLConnectionDelegate, NSXMLParserDelegate{
    var dataDelegate:DataDelegate
    var index :Int = 0
    var methodName = ""
    var invokeType = ""
    var urlString  = "http://apk.zdomo.com/ws/zdomows.asmx"
    var ps:[String] = []
    var mutableData:NSMutableData  = NSMutableData.alloc()
    var currentElementName:NSString = ""
    var currentValue:NSString = ""
    var singleResult = ""
        
    internal init(source:DataDelegate,invokeIndex:Int = 0,type:String="", methodName:String,params:[String]){
        dataDelegate = source
        index = invokeIndex
        invokeType = type
        self.methodName = methodName
        for p in params
        {
            ps.append(p)
        }
        
    }
    
    func loadData()->String{
        
        
        var soapMessage = getMethodString(self.methodName)
        println("soapMessage is:\(soapMessage)")
        var url = NSURL(string: urlString)
        
        var theRequest = NSMutableURLRequest(URL: url!)
        
        var msgLength = String(countElements(soapMessage))
        
        theRequest.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        theRequest.addValue(msgLength, forHTTPHeaderField: "Content-Length")
        theRequest.HTTPMethod = "POST"
        theRequest.HTTPBody = soapMessage.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) // or false
        
        var connection = NSURLConnection(request: theRequest, delegate: self, startImmediately: true)
        connection!.start()
        
        if (connection == true) {
            var mutableData : Void = NSMutableData.initialize()
        }
        
        return ""
    }
    
    func getMethodString(mechodName:String)->String{
        
        switch mechodName{
        case "AddMember":
            return "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><AddMember xmlns='http://apk.zdomo.com/'><user><MemberID>\(ps[0])</MemberID><NickName>\(ps[1])</NickName><UserName>\(ps[2])</UserName><Password>\(ps[3])</Password><WhereFrom>\(ps[4])</WhereFrom><Mail>\(ps[5])</Mail><Identity>\(ps[6])</Identity><HeadPhotoURL>\(ps[7])</HeadPhotoURL><IsUsed>\(ps[8])</IsUsed><IsActivation>\(ps[9])</IsActivation><registrationTime>\(ps[10])</registrationTime><LastVisitTime>\(ps[11])</LastVisitTime></user></AddMember></soap:Body></soap:Envelope>"
        case "AddUser":
            return "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><AddUser xmlns='http://apk.zdomo.com/'><username>\(ps[0])</username><password>\(ps[1])</password><email>\(ps[2])</email><usericon>\(ps[3])</usericon><identity>\(ps[4])</identity></AddUser></soap:Body></soap:Envelope>"
        case "CheckEmail":
            return "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><CheckEmail xmlns='http://apk.zdomo.com/'><email>\(ps[0])</email></CheckEmail></soap:Body></soap:Envelope>"
        case "CheckUserName":
            return "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><CheckUserName xmlns='http://apk.zdomo.com/'><username>\(ps[0])</username></CheckUserName></soap:Body></soap:Envelope>"
        case "DeleteCollection":
            return "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><DeleteCollection xmlns='http://apk.zdomo.com/'><infoIDS>\(ps[0])</infoIDS><memberid>\(ps[1])</memberid></DeleteCollection></soap:Body></soap:Envelope>"
        case "DeleteVisitHistory":
            return "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><DeleteVisitHistory xmlns='http://apk.zdomo.com/'><infoIDS>\(ps[0])</infoIDS><memberid>\(ps[1])</memberid></DeleteVisitHistory></soap:Body></soap:Envelope>"
        case "GetGameList":
            return "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><GetGameList xmlns='http://apk.zdomo.com/'><pageSize>\(ps[0])</pageSize><pageNum>\(ps[1])</pageNum></GetGameList></soap:Body></soap:Envelope>"
        case "GetQASKInfo":
            return "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><GetQASKInfo xmlns='http://apk.zdomo.com/'><id>\(ps[0])</id><pageSize>\(ps[1])</pageSize><pageNum>\(ps[2])</pageNum><senderid>\(ps[3])</senderid></GetQASKInfo></soap:Body></soap:Envelope>"
        case "GetQASKList":
            return "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><GetQASKList xmlns='http://apk.zdomo.com/'><isEditor>\(ps[0])</isEditor><subSize>\(ps[1])</subSize><pageSize>\(ps[2])</pageSize><pageNum>\(ps[3])</pageNum><senderid>\(ps[4])</senderid></GetQASKList></soap:Body></soap:Envelope>"
        case "GetQASKParticipant":
            return "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><GetQASKParticipant xmlns='http://apk.zdomo.com/'><senderid>\(ps[0])</senderid><subSize>\(ps[1])</subSize><pageSize>\(ps[2])</pageSize><pageNum>\(ps[3])</pageNum></GetQASKParticipant></soap:Body></soap:Envelope>"
        case "GetUserID":
            return "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><GetUserID xmlns='http://apk.zdomo.com/'><Identity>\(ps[0])</Identity><nickname>\(ps[1])</nickname></GetUserID></soap:Body></soap:Envelope>"
        case "InsertCollection":
            return "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><InsertCollection xmlns='http://apk.zdomo.com/'><infoID>\(ps[0])</infoID><memberid>\(ps[1])</memberid></InsertCollection></soap:Body></soap:Envelope>"
        case "InsertQASK":
            return "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><InsertQASK xmlns='http://apk.zdomo.com/'><content>\(ps[0])</content><senderid>\(ps[1])</senderid><replyid>\(ps[2])</replyid><SourceID>\(ps[3])</SourceID></InsertQASK></soap:Body></soap:Envelope>"
        case "Login":
            return "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><Login xmlns='http://apk.zdomo.com/'><username>\(ps[0])</username><password>\(ps[1])</password><identity>\(ps[2])</identity><usericon>\(ps[3])</usericon></Login></soap:Body></soap:Envelope>"
        case "ReadInfo":
            return "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><ReadInfo xmlns='http://apk.zdomo.com/'><infoID>\(ps[0])</infoID><memberid>\(ps[1])</memberid></ReadInfo></soap:Body></soap:Envelope>"
        case "SaveFile":
            return "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><SaveFile xmlns='http://apk.zdomo.com/'><FileByteArray>\(ps[0])</FileByteArray><FileLength>\(ps[1])</FileLength><fileName>\(ps[2])</fileName></SaveFile></soap:Body></soap:Envelope>"
        case "UpdateUserFaceAndNickName":
            return "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><UpdateUserFaceAndNickName xmlns='http://apk.zdomo.com/'><uid>\(ps[0])</uid><headphoto>\(ps[1)</headphoto><nickname>\(ps[2])</nickname></UpdateUserFaceAndNickName></soap:Body></soap:Envelope>"
        case "UpdateUserInfo":
            return "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><UpdateUserInfo xmlns='http://apk.zdomo.com/'><user><MemberID>\(ps[0])</MemberID><NickName>\(ps[1])</NickName><UserName>\(ps[2])</UserName><Password>\(ps[3])</Password><WhereFrom>\(ps[4])</WhereFrom><Mail>\(ps[5])</Mail><Identity>\(ps[6])</Identity><HeadPhotoURL>\(ps[7])</HeadPhotoURL><IsUsed>\(ps[8])</IsUsed><IsActivation>\(ps[9])</IsActivation><registrationTime>\(ps[10])</registrationTime><LastVisitTime>\(ps[11])</LastVisitTime></user></UpdateUserInfo></soap:Body></soap:Envelope>"
        case "insertZanInfo":
            return "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><insertZanInfo xmlns='http://apk.zdomo.com/'><infoID>\(ps[0])</infoID><memberid>\(ps[1])</memberid></insertZanInfo></soap:Body></soap:Envelope>"
        case "insertZanQASK":
            return "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><insertZanQASK xmlns='http://apk.zdomo.com/'><qaskID>\(ps[0])</qaskID><senderid>\(ps[1])</senderid></insertZanQASK></soap:Body></soap:Envelope>"
        case "SendFeedBack":
            return "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><SendFeedBack xmlns='http://apk.zdomo.com/'><content>\(ps[0])</content></SendFeedBack></soap:Body></soap:Envelope>"
        default :
            return ""
        }
    }
    
    
    func connection(connection: NSURLConnection!, didReceiveResponse response: NSURLResponse!) {
        mutableData.length = 0;
    }
    
    func connection(connection: NSURLConnection!, didReceiveData data: NSData!) {
        mutableData.appendData(data)
    }
    
    
    func connectionDidFinishLoading(connection: NSURLConnection!) {
        var xmlParser = NSXMLParser(data: mutableData)
        xmlParser.delegate = self
        xmlParser.parse()
        xmlParser.shouldResolveExternalEntities = true
        
    }
    
    
    // NSXMLParserDelegate
    
    //not use for now
    func parser(parser: NSXMLParser!, didStartElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!, attributes attributeDict: NSDictionary!) {
        //println("elementName:"+elementName)
    }
    
    //all the same
    func parser(parser: NSXMLParser!, foundCharacters string: String!) {
        println("foundCharacters:\(string)")
        currentValue = string
    }
    //to be override
    func parser(parser: NSXMLParser!, didEndElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!) {
    }
    
    func parserDidStartDocument(parser: NSXMLParser!) {
        println("Beginnnn....")
    }
    
    //can be override
    func parserDidEndDocument(parser: NSXMLParser!) {
        println("Endding...")
        dataDelegate.invoke(index, StringResult: singleResult)
        
    }
    //all the same
    func parser(parser: NSXMLParser!, parseErrorOccurred parseError: NSError!) {
        println(parseError.description)
    }
}