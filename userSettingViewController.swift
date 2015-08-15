//
//  userSettingViewController.swift
//  Stylist
//
//  Created by 田畑リク on 2015/07/25.
//  Copyright (c) 2015年 xxx. All rights reserved.
//

import UIKit
import Parse

//TODO LIST************
//Set max number for height
//Change textfields to something cooler
//Make profile picture button either circular or circular rectangle
//Change buttons


class userSettingViewController: UIViewController {
    
    //For showing activity indicator
    var container: UIView = UIView()
    var loadingView: UIView = UIView()
    var actInd: UIActivityIndicatorView = UIActivityIndicatorView()
    
    
    @IBOutlet weak var profileImgBut: UIButton!
    @IBOutlet weak var sexSelect: UISegmentedControl!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet var ageTextF: MKTextField!
    @IBOutlet var emailTextF: MKTextField!
    @IBOutlet var heightTextF: MKTextField!
    @IBOutlet var passwordChange: UIButton!
    @IBOutlet var logout: UIButton!
    @IBOutlet var update: UIButton!
    @IBOutlet weak var mirrorSegment: UISegmentedControl!
    
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    var profileImgFile = [PFFile]()
    
    var age = 1
    var emailAdd = "xxxxx@xxx.com"
    var userName = "Aristotle"
    var profileImg = [UIImage]()
    var sex = 2
    var height = 170
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        ageTextF.layer.borderColor = UIColor.clearColor().CGColor
        ageTextF.floatingPlaceholderEnabled = true
        ageTextF.placeholder = "Age"
        ageTextF.tintColor = UIColor.MKColor.Blue
        ageTextF.rippleLocation = .Right
        ageTextF.cornerRadius = 0
        ageTextF.bottomBorderEnabled = true
        
        
        emailTextF.layer.borderColor = UIColor.clearColor().CGColor
        emailTextF.floatingPlaceholderEnabled = true
        emailTextF.placeholder = "Email"
        emailTextF.tintColor = UIColor.MKColor.Blue
        emailTextF.rippleLocation = .Right
        emailTextF.cornerRadius = 0
        emailTextF.bottomBorderEnabled = true
        
        heightTextF.layer.borderColor = UIColor.clearColor().CGColor
        heightTextF.floatingPlaceholderEnabled = true
        heightTextF.placeholder = "Height"
        heightTextF.tintColor = UIColor.MKColor.Blue
        heightTextF.rippleLocation = .Right
        heightTextF.cornerRadius = 0
        heightTextF.bottomBorderEnabled = true
        
        let ud = NSUserDefaults.standardUserDefaults()
        if (ud.objectForKey("mirrorPresentKey") == nil){
            mirrorSegment.selectedSegmentIndex = 0
        }else{
            var mirrorInt = ud.integerForKey("mirrorPresentKey")
            mirrorSegment.selectedSegmentIndex = mirrorInt
        }
        /*
        passwordChange.layer.shadowOpacity = 0.55
        passwordChange.layer.shadowRadius = 5.0
        passwordChange.layer.shadowColor = UIColor.clearColor().CGColor
        //passwordChange.layer.shadowOffset = CGSize(width: 0, height: 2.5)
        
        logout.layer.shadowOpacity = 0.55
        logout.layer.shadowRadius = 5.0
        logout.layer.shadowColor = UIColor.clearColor().CGColor
        //logout.layer.shadowOffset = CGSize(width: 0, height: 2.5)
        
        update.layer.shadowOpacity = 0.55
        update.layer.shadowRadius = 5.0
        update.layer.shadowColor = UIColor.clearColor().CGColor
        //update.layer.shadowOffset = CGSize(width: 0, height: 2.5)
        */
        
        passwordChange.layer.borderColor = UIColor.grayColor().CGColor
        passwordChange.layer.borderWidth = 1.0
        passwordChange.layer.cornerRadius = 3.0
        
        logout.layer.borderColor = UIColor.grayColor().CGColor
        logout.layer.borderWidth = 1.0
        logout.layer.cornerRadius = 3.0
        
        update.layer.borderColor = UIColor(red: 0, green: 0.698, blue: 0.792, alpha: 1).CGColor
        update.layer.borderWidth = 1.0
        update.layer.cornerRadius = 3.0
        
        
        
        self.showActivityIndicator(self.view)
        
        //Adding tap gesture to close keyboard when view tapped
        self.view.addGestureRecognizer(tapGesture)
        
        //Retrieve user info from parse
        PFUser.currentUser()!.fetchInBackgroundWithBlock({
            (currentUser: PFObject?, error: NSError?) -> Void in
            
            if error == nil{
                println("error nil")
                // Update your data
                
                if let user = currentUser as? PFUser {
                    
                    self.emailAdd = user.email!
                    println("Mail: \(self.emailAdd)")
                    self.emailTextF.text = self.emailAdd
                    
                    
                    
                    self.userName = user.username!
                    println("Username: \(self.userName)")
                    self.usernameLabel.text = self.userName
                    
                    
                    //Check if there is a value in Parse before putting the value in displayName
                    var ageCheck = user["age"] as? Int
                    var sexCheck = user["sex"] as? Int
                    var heightCheck = user["height"] as? Int
                    if (ageCheck == nil){
                        println("empty")
                        self.ageTextF.placeholder = "Age"
                    }else{
                        self.age = user["age"] as! Int
                        println("age: \(self.age)")
                        self.ageTextF.text = "\(self.age)"
                        
                    }
                    if (sexCheck == nil){
                        println("empty")
                    }else{
                        self.sex = user["sex"] as! Int
                        println("Sex: \(self.sex)")
                        self.sexSelect.selectedSegmentIndex = self.sex
                    }
                    if (heightCheck == nil){
                        println("empty")
                        self.heightTextF.placeholder = "Height"
                    }else{
                        self.height = user["height"] as! Int
                        println("Height: \(self.height)")
                        self.heightTextF.text = "\(self.height)"
                        
                    }
                    
                    let ud = NSUserDefaults.standardUserDefaults()
                    var profilePictObj: AnyObject? = ud.objectForKey("tempProfilePictKey")
                    
                    println("profilePictBool \(profilePictObj)")
                    
                    if profilePictObj == nil {
                        var photoFile = user["profilePicture"] as? PFFile
                        println("PhotoFile: \(photoFile)")
                        if photoFile != nil{
                            println("photo present")
                            
                            //Extracting pictures from PFFile
                            photoFile!.getDataInBackgroundWithBlock{
                                (photoFile: NSData?, error: NSError?) -> Void in
                                if photoFile != nil {
                                    var image = UIImage(data: photoFile!)
                                    self.profileImgBut.setImage(image, forState: .Normal)
                                    ud.removeObjectForKey("tempProfilePictKey")
                                }}}}
                    else{
                        var profileImgData = profilePictObj as! NSData
                        var image = UIImage(data: profileImgData)
                        self.profileImgBut.setImage(image, forState: .Normal)
                        ud.removeObjectForKey("profilePlaceHolder")
                        
                    }}
                
                self.hideActivityIndicator(self.view)
            }
            else{
                
                self.hideActivityIndicator(self.view)
                let alert = SCLAlertView()
                
                
                alert.showError("Error", subTitle:"An error occured while retrieving your information. Please check the Internet connection.", closeButtonTitle:"Ok")
                self.performSegueWithIdentifier("userSettingVCtoVCunwind", sender: self)
                
            }
            
        })
    }
    
    
    @IBAction func updateSetting() {
        self.showActivityIndicator(self.view)
        
        var newAge = ageTextF.text.toInt()
        var newHeight = heightTextF.text.toInt()
        var newEmail = emailTextF.text
        var newSex = sexSelect.selectedSegmentIndex
        var newProfilePict = self.profileImgBut.imageForState(.Normal)
        let user = PFUser.currentUser()
        user!.email = newEmail
        
        //user["displayName"]
        
        var userFileObj = PFObject (withoutDataWithClassName: "_User", objectId: PFUser.currentUser()?.objectId)
        if newAge != nil{
            userFileObj["age"] = newAge
        }
        if newHeight != nil{
            userFileObj["height"] = newHeight
        }
        userFileObj["sex"] = newSex
        
        var imageData = UIImageJPEGRepresentation(newProfilePict, 1.0)
        var parseImageFile = PFFile(name: "uploaded_image.jpg", data: imageData)
        PFUser.currentUser()?.setObject(parseImageFile, forKey: "profilePicture")
        
        
        //Saving user infomation that is necessary in Parse before saving other optional materials
        PFUser.currentUser()!.saveInBackgroundWithBlock({
            (success: Bool, error: NSError?) -> Void in
            
            if error == nil {
                self.hideActivityIndicator(self.view)
                println("success")
                let alert = SCLAlertView()
                alert.showSuccess("Success", subTitle:"Your user information was updated successfully!", closeButtonTitle:"Ok")
                self.performSegueWithIdentifier("userSettingVCtoVCunwind", sender: self)
                /*
                // 「ud」というインスタンスをつくる。
                let ud = NSUserDefaults.standardUserDefaults()
                println("errorshow")
                
                // OKボタンを押した時に、Homeに戻るようにする
                ud.setInteger(4, forKey: "closeAlertKey")
                ud.removeObjectForKey("closeAlertKeyNote")
                println("scla to 1")
                //        SCLAlertView().showError(self, title: kErrorTitle, subTitle: kSubtitle)
                var timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("performSegueToHome"), userInfo: nil, repeats: true)
                
                */
                
                
            }else {
                self.hideActivityIndicator(self.view)
                println("failure")
                var errorMessage:String = error!.userInfo!["error"]as! String
                let alert = SCLAlertView()
                alert.showError("Error", subTitle:"An error occured. \(errorMessage)", closeButtonTitle:"Ok")
                
                
            }
            
        })
        
        let ud = NSUserDefaults.standardUserDefaults()
        ud.setInteger(mirrorSegment.selectedSegmentIndex, forKey: "mirrorPresentKey")
        
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changeProfilePic() {
        println("change profile pic")
        var currentProfileImg = self.profileImgBut.imageForState(.Normal)
        if currentProfileImg != nil{
            let ud = NSUserDefaults.standardUserDefaults()
            ud.setObject(UIImageJPEGRepresentation(self.profileImgBut.imageForState(.Normal), 1.0) , forKey: "currentProfileImgKey")
        }
        
    }
    
    @IBAction func changePassword() {
        var checkOrigin = "fromUserSettingVC"
        let ud = NSUserDefaults.standardUserDefaults()
        ud.setObject(checkOrigin, forKey: "passwordOriginCheckKey")
        
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        
        // キーボードを閉じる
        textField.resignFirstResponder()
        
        return true
    }
    
    @IBAction func tapScreen(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    
    
    func showActivityIndicator(uiView: UIView) {
        
        container.frame = uiView.frame
        container.center = uiView.center
        container.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
        
        loadingView.frame = CGRectMake(0, 0, 100, 100)
        loadingView.center = uiView.center
        //loadingView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.3)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        actInd.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
        actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        actInd.center = CGPointMake(loadingView.frame.size.width / 2,
            loadingView.frame.size.height / 2);
        loadingView.addSubview(actInd)
        container.addSubview(loadingView)
        uiView.addSubview(container)
        actInd.startAnimating()
    }
    
    func hideActivityIndicator(uiView: UIView) {
        actInd.stopAnimating()
        container.removeFromSuperview()
    }
    
    @IBAction func logoutButtonTapped(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "isUserLoggedIn")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        PFUser.logOut()
        self.performSegueWithIdentifier("logIn", sender: self)
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
