//
//  LoginViewController.swift
//  Stylist
//
//  Created by Kenty on 2015/06/28.
//  Copyright (c) 2015年 xxx. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var usernameField: MKTextField!
    @IBOutlet var passwordField: MKTextField!
    @IBOutlet var flatButton2: MKButton!
    @IBOutlet var loginBtn: MKButton!
    @IBOutlet var signupBtn: MKButton!



    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameField.layer.borderColor = UIColor.clearColor().CGColor
        usernameField.floatingPlaceholderEnabled = true
        usernameField.placeholder = "UserName"
        usernameField.tintColor = UIColor.MKColor.Blue
        usernameField.rippleLocation = .Right
        usernameField.cornerRadius = 0
        usernameField.bottomBorderEnabled = true
        
        passwordField.layer.borderColor = UIColor.clearColor().CGColor
        passwordField.floatingPlaceholderEnabled = true
        passwordField.placeholder = "Password"
        passwordField.tintColor = UIColor.MKColor.Red
        passwordField.rippleLocation = .Right
        passwordField.cornerRadius = 0
        passwordField.bottomBorderEnabled = true
        
        flatButton2.maskEnabled = false
        flatButton2.ripplePercent = 0.5
        flatButton2.backgroundAniEnabled = false
        flatButton2.rippleLocation = .Center
        
        loginBtn.layer.shadowOpacity = 0.55
        loginBtn.layer.shadowRadius = 5.0
        loginBtn.layer.shadowColor = UIColor.grayColor().CGColor
        loginBtn.layer.shadowOffset = CGSize(width: 0, height: 2.5)
        
        signupBtn.layer.shadowOpacity = 0.55
        signupBtn.layer.shadowRadius = 5.0
        signupBtn.layer.shadowColor = UIColor.grayColor().CGColor
        signupBtn.layer.shadowOffset = CGSize(width: 0, height: 2.5)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true;
        
    }
    
    @IBAction func loginButtonTapped(sender: AnyObject) {
        let userUserName = usernameField.text
        let userPassword = passwordField.text
        
        
        PFUser.logInWithUsernameInBackground(usernameField.text, password: passwordField.text) {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil{
                //ログインできた！！
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isUserLoggedIn")
                NSUserDefaults.standardUserDefaults().synchronize()
                self.performSegueWithIdentifier("loginVCtoVC", sender: self)
                //self.dismissViewControllerAnimated(true, completion: nil)
                
            }
            else{
                //Parse がユーザーが何も返さない場合はケンティー怒る
                println("User Name or Password is not correct")
                var myAlert = UIAlertController(title:"Alert", message: "User Name or Password is not Correct", preferredStyle:UIAlertControllerStyle.Alert)
                
                let okAction = UIAlertAction (title:"OK" , style: UIAlertActionStyle.Default){
                    action in                }
                myAlert.addAction(okAction)
                self.presentViewController(myAlert, animated:true, completion:nil)
                
            }
            
            
        }
        
        /*
        // MARK: - Navigation
        
        // In a storyboard-based application, you will often want to do a little preparation before navigation
        override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        }
        */
        
    }}
