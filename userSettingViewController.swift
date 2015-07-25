//
//  userSettingViewController.swift
//  Stylist
//
//  Created by 田畑リク on 2015/07/25.
//  Copyright (c) 2015年 xxx. All rights reserved.
//

import UIKit
import Parse

class userSettingViewController: UIViewController {

    @IBOutlet weak var displaynameTextF: UITextField!
    @IBOutlet weak var emailTextF: UITextField!
    @IBOutlet weak var profileImgBut: UIButton!
    @IBOutlet weak var sexSelect: UISegmentedControl!
    @IBOutlet weak var heightTextF: UITextField!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    var profileImgFile = [PFFile]()

    var displayName = "platoLove132"
    var emailAdd = "xxxxx@xxx.com"
    var userName = "Aristotle"
    var profileImg = [UIImage]()
    var sex = 2
    var height = 170
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Adding tap gesture to close keyboard when view tapped
        self.view.addGestureRecognizer(tapGesture)
        
        //Retrieve user info from parse
        PFUser.currentUser()!.fetchInBackgroundWithBlock({
            (currentUser: PFObject?, error: NSError?) -> Void in
            
            // Update your data
            
            if let user = currentUser as? PFUser {
                
                self.emailAdd = user.email!
                println("Mail: \(self.emailAdd)")
                self.emailTextF.text = self.emailAdd
                
                //ここ変える
                var photoFile = user["profilePicture"] as? PFFile
                println("PhotoFile: \(photoFile)")
                
                self.userName = user.username!
                println("Username: \(self.userName)")
                self.usernameLabel.text = self.userName
                
                
                //Check if there is a value in Parse before putting the value in displayName
                var displayNameCheck = user["displayName"] as? String
                var sexCheck = user["sex"] as? Int
                var heightCheck = user["height"] as? Int
                if (displayNameCheck == nil){
                    println("empty")
                    self.displaynameTextF.placeholder = self.displayName
                }else{
                    self.displayName = user["displayName"] as! String
                    println("Display name: \(self.displayName)")
                    self.displaynameTextF.text = self.displayName
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
                    self.heightTextF.placeholder = "\(self.height)"
                }else{
                    self.height = user["height"] as! Int
                    println("Height: \(self.height)")
                    self.heightTextF.text = "\(self.height)"

                }
                ///////////////////////////
                

            }
        })
    }
    

    @IBAction func updateSetting() {
        var newDisplayName = displaynameTextF.text
        var newHeight = heightTextF.text.toInt()
        var newEmail = emailTextF.text
        var newSex = sexSelect.selectedSegmentIndex
        let user = PFUser.currentUser()
        user!.email = newEmail
        
        //user["displayName"]

        var userFileObj = PFObject (withoutDataWithClassName: "_User", objectId: PFUser.currentUser()?.objectId)
        userFileObj["displayName"] = newDisplayName
        userFileObj["height"] = newHeight
        userFileObj["sex"] = newSex
        
        //Saving user infomation that is necessary in Parse before saving other optional materials
        PFUser.currentUser()!.saveInBackgroundWithBlock({
            (success: Bool, error: NSError?) -> Void in
            
            if error == nil {
            
                println("success")
                
                userFileObj.saveInBackgroundWithBlock({
                    (success: Bool, error: NSError?) -> Void in
                    
                    if error == nil {
                        
                        println("success")
                        
                    }else {
                        
                        println("failure")
                        
                        
                    }
                    
                })

                
            }else {
                println("failure")
                
                
            }
            
        })
        
        
        
        
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changeProfilePic() {
        println("change profile pic")
                
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
