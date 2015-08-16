//
//  PasswordRecoverViewController.swift
//  Stylist
//
//  Created by 勝又健登 on 2015/06/29.
//  Copyright (c) 2015年 xxx. All rights reserved.
//

import UIKit
import Parse

class PasswordRecoverViewController: UIViewController {
    
    @IBOutlet weak var passBtn: UIButton!
    @IBOutlet weak var userEmailTextField: MKTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        passBtn.layer.cornerRadius = 5.0
        
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
    //パスワード取得のためのバタン
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
    //エラー
    func displayErrorMessage(theMessage:String)
    {
        let errorAlert = SCLAlertView()
        errorAlert.showSuccess("Alert", subTitle:"\(theMessage)", closeButtonTitle:"Ok")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true;
        
    }
    
    //ユーザーがキャンセルした場合
    @IBAction func cancelButtonTapped(sender: AnyObject) {
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
