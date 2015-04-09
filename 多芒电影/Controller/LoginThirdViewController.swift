//
//  LoginThirdViewController.swift
//  多芒电影
//
//  Created by 柴小红 on 15/2/13.
//  Copyright (c) 2015年 珠影网络. All rights reserved.
//

import UIKit

class LoginThirdViewController: UIViewController,DataDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var btnFace: UIButton!
    @IBOutlet weak var lblNickname: UILabel!
    var user:Model.LoginModel?
    var imageView:UIImageView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var dele = UIApplication.sharedApplication().delegate as AppDelegate
        user = dele.user

       self.setBasicValue()
       self.checkLogin()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func checkLogin(){
        if user != nil  && user?.MemberID == "" {
            API().exec(self, invokeIndex: 0, invokeType: "", methodName: "GetUserID", params: user!.Identity,user!.NickName.trim()).loadData()
        } else if user != nil && user?.MemberID != "" {
            btnFace.addTarget(self, action: Selector("addPicEvent"), forControlEvents: UIControlEvents.TouchDown)
        }
    }
    
    
    @IBAction func logoutTapped(sender: AnyObject) {
        var dele = UIApplication.sharedApplication().delegate as AppDelegate
        user = Model.LoginModel()
        user?.MemberID=""
        dele.user = nil
        dele.isLogin = false
        ShareSDK.cancelAuthWithType(ShareTypeSinaWeibo)
        ShareSDK.cancelAuthWithType(ShareTypeQQSpace)
        
        var userDeFaults = NSUserDefaults.standardUserDefaults()
        userDeFaults.setValue(NSKeyedArchiver.archivedDataWithRootObject(user!), forKey: "myUser")
        
        self.tabBarItem.image = UIImage(named: "login")
        self.tabBarController!.selectedViewController?.tabBarItem.title  = "登录"
        self.navigationController?.popToRootViewControllerAnimated(true)
       
    }
    
    
    
    
    func addPicEvent(){
        var sourceType = UIImagePickerControllerSourceType.Camera
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        }
        
        var picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = sourceType
        
        
        self.presentViewController(picker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        var image:UIImage
        for item in info {
            if item.0 == UIImagePickerControllerOriginalImage {
                image = item.1 as UIImage
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                
                var timage = UTIL.squareImageFromImage(image, scaledToSize: 70, isScale: true)
                self.imageView!.image = timage
                self.btnFace.addSubview(self.imageView!)
                //self.navigationController?.navigationBar.items[2].imageView!?.image = timage
                self.dismissViewControllerAnimated(true, completion: nil)
                self.tabBarItem.image = timage
                var Imgdata = UIImagePNGRepresentation(timage)
                API().exec(self, invokeIndex: 0, methodName: "SaveFile", params:Imgdata.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength),String(Imgdata.length),"\(user!.MemberID).jpg").loadData()
            }
        }
    }
    
    func openPicLibrary(){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary){
            var picker = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = true
            
            picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.presentViewController(picker, animated: true, completion: nil)
        } else {
            let alert = UIAlertView(title: "出错信息", message: "您没有摄像头", delegate: nil, cancelButtonTitle: "Drat！")
            
            alert.show()
        }
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        var timage = UTIL.squareImageFromImage(image!, scaledToSize: 70, isScale: true)
        self.imageView!.image = timage
        self.tabBarItem.image = timage
        self.btnFace.addSubview(self.imageView!)
        self.dismissViewControllerAnimated(true, completion: nil)
        var Imgdata = UIImagePNGRepresentation(timage)
        API().exec(self, invokeIndex: 0, methodName: "SaveFile", params:Imgdata.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength),String(Imgdata.length),"\(user!.MemberID).jpg").loadData()      
        
    }
    
    
    func invoke(index:Int,StringResult result:String){

        switch index {
        case 0:
            var memberID = result
            user?.MemberID = memberID
             API().exec(self, invokeIndex:1, invokeType: "", methodName: "UpdateUserInfo", params: user!.MemberID,user!.NickName,user!.UserName,user!.Password,user!.WhereFrom,user!.Mail,user!.Identity,user!.HeadPhotoURL,user!.IsUsed,user!.IsActivation,user!.registrationTime,user!.LastVisitTime).loadData()
        default:
            println("i am here")
        }
        
       

    }
    
    //type:方法的标识（一个页面可能有多个方法回调，以此参数作为标识区分） object:返回的数据
    func invoke(type: String, object: NSObject) {
       
    }
    

    
    func setBasicValue() {
      
        self.lblNickname.text = user!.NickName
        var icon = user!.HeadPhotoURL.trim().length()>10 ? user!.HeadPhotoURL : "http://apk.zdomo.com/ueditor/net/upload/face/0.jpg"
        var imgURL = NSURL(string: icon)
        imageView = UIImageView(frame: btnFace.bounds)
        btnFace.layer.masksToBounds = true
        btnFace.layer.cornerRadius = btnFace.bounds.size.height / 2
        btnFace.layer.backgroundColor = UIColor.whiteColor().CGColor

        
        PLMImageCache.sharedInstance.imageForUrl(imgURL!, desiredImageSize: CGSize(width: 80, height: 80), contentMode: UIViewContentMode.ScaleToFill) { (image) -> Void in
            //use image
            if !(image == nil) {
                var timage = UTIL.squareImageFromImage(image!, scaledToSize: 70, isScale: true)
                self.imageView!.image = timage
                self.btnFace.addSubview(self.imageView!)
                /*var img = UTIL.reSizeImage(timage, toSize: CGSize(width: 30,height: 30))
                
                self.saveImage(img)
                
                var userDeFaults = NSUserDefaults.standardUserDefaults()
                var obj:NSData = userDeFaults.dataForKey("face")!
                var img1 = UIImage(data: obj)

                var imgData = UIImagePNGRepresentation(image)
                self.tabBarController!.selectedViewController?.tabBarItem.image = UIImage(data: imgData)
                self.tabBarController!.selectedViewController?.tabBarItem.selectedImage = UIImage(data: imgData)*/
                self.tabBarController!.selectedViewController?.tabBarItem.title = self.lblNickname.text
            }
            
        }

    }
    /*
    func saveImage(img:UIImage){
        var imageData = UIImagePNGRepresentation(img)
        var userDeFaults = NSUserDefaults.standardUserDefaults()
        userDeFaults.setObject(imageData, forKey: "face")
        userDeFaults.synchronize()
        
    }*/
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
