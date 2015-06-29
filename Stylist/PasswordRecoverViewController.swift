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

    @IBOutlet weak var userEmailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func recoverButtonTapped(sender: AnyObject) {
        let userEmail = userEmailTextField.text
        PFUser.requestPasswordResetForEmailInBackground(userEmail){(success:Bool,error:NSError?)-> Void in
            if(success){
                let successMessage = " Email Message was sent to you at \(userEmail)"
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
    
    
    
    
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
