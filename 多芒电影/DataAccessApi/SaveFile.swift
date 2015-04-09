//
//  SaveFile.swift
//  ZdomoApp
//
//  Created by 柴小红 on 15/1/23.
//  Copyright (c) 2015年 柴小红. All rights reserved.
//

import Foundation

class SaveFile: BaseAccess {
    override init(source: DataDelegate, invokeIndex: Int = 0 ,type:String="", methodName: String, params: [String]) {
        super.init(source: source, invokeIndex: invokeIndex,type:type, methodName: methodName, params: params)
    }
    
    override func loadData()->String{
        
        var path:String = NSBundle.mainBundle().pathForResource("fashion", ofType: "png")!
        var imageData = NSData(contentsOfFile: path)!
        var imageLength = String(imageData.length)
        var imageName = "fashiona.png"
        var imageString = imageData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        
        var soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><SaveFile xmlns='http://apk.zdomo.com/'><FileByteArray>\(imageString)</FileByteArray><FileLength>\(imageLength)</FileLength><fileName>\(imageName)</fileName></SaveFile></soap:Body></soap:Envelope>"
        
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
    
    
    // NSXMLParserDelegate
    
    // override
    override func parser(parser: NSXMLParser!, didEndElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!) {
        if elementName=="SaveFileResult"{
            singleResult = currentValue
        }
    }
}