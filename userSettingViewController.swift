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
    @IBOutlet weak var passwordTextF: UITextField!
    @IBOutlet weak var profileImgBut: UIButton!
    @IBOutlet weak var sexSelect: UISegmentedControl!
    @IBOutlet weak var heightTextF: UITextField!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    var profileImgFile = [PFFile]()

    var displayName = "platoLove132"
    var emailAdd = "xxxxx@xxx.com"
    var userName = "Aristotle"
    var password = [NSString]()
    var profileImg = [UIImage]()
    var sex = 2
    var height = 170
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Adding tap gesture to close keyboard when view tapped
        self.view.addGestureRecognizer(tapGesture)
        
        //Retrieve user info from parse
        
        var query = PFQuery(className: "_User");
        
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
    
/*
    @IBAction func updateSetting() {
        var newDisplayName = displaynameTextF.text
        var newEmail = emailTextF.text
        var posts = PFObject(className: "Tops");
        var user = PFUser.currentUser()
        user!.email = newEmail
        //user["displayName"]
        //posts["displayName"] = newDisplayName
        
        var testDeleteObj = PFObject(withoutDataWithClassName: "Tops", objectId: "doOOGuKUIi")
        testDeleteObj.delete()
        
        
        
        PFUser.currentUser()!.saveInBackgroundWithBlock({
            (success: Bool, error: NSError?) -> Void in
            
            if error == nil {
            
                println("success")
                
            }else {
                println("failure")
                
                
            }
            
        })
        
        
        
        
    }
*/
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changeProfilePic() {
        println("change profile pic")
                
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
