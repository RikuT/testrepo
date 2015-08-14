//
//  PasswordRecoverViewController.swift
//  Stylist
//
//  Created by Kento Katsumata on 2015/06/29.
//  Copyright (c) 2015年 xxx. All rights reserved.
//

import UIKit
import Parse

class PasswordRecoverViewController: UIViewController {
    
    @IBOutlet weak var userEmailTextField: MKTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        userEmailTextField.layer.borderColor = UIColor.clearColor().CGColor
        userEmailTextField.floatingPlaceholderEnabled = true
        userEmailTextField.placeholder = "Email Adress"
        userEmailTextField.tintColor = UIColor.MKColor.Blue
        userEmailTextField.rippleLocation = .Right
        userEmailTextField.cornerRadius = 0
        userEmailTextField.bottomBorderEnabled = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func recoverButtonTapped(sender: AnyObject) {
        let userEmail = userEmailTextField.text
        PFUser.requestPasswordResetForEmailInBackground(userEmail){(success:Bool,error:NSError?)-> Void in
            if(success){
                let successMessage = " Password Recovery Message was sent to you at \(userEmail)"
                self.displayErrorMessage(successMessage)
                return
            }
            if(error != nil)
            {
                let errorMessage:String = error!.userInfo!["error"]as! String
                self.displayErrorMessage(errorMessage)
            }
            
        }}
    
    func displayErrorMessage(theMessage:String)
    {
        var myAlert = UIAlertController(title:"Alert", message: theMessage,
            preferredStyle:UIAlertControllerStyle.Alert)
        
        let okAction = UIAlertAction (title:"OK" , style: UIAlertActionStyle.Default){
            action in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        myAlert.addAction(okAction)
        self.presentViewController(myAlert, animated:true, completion:nil)
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true;
        
    }

    
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        //Looking up in userDefaults to detect where the user came from
        let ud = NSUserDefaults.standardUserDefaults()
        var checkOriginObject: AnyObject? = ud.objectForKey("passwordOriginCheckKey")
        var checkOrigin: NSString = "\(checkOriginObject)"
        if checkOrigin == "fromUserSettingVC"{
        performSegueWithIdentifier("changePassToUserSetting", sender: self)
        }else{
        self.dismissViewControllerAnimated(true, completion: nil)
        }
        ud.removeObjectForKey("passwordOriginCheckKey")
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
