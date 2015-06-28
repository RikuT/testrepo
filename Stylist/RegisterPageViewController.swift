//
//  RegisterPageViewController.swift
//  Stylist
//
//  Created by Kento Katsumata on 2015/06/28.
//  Copyright (c) 2015年 xxx. All rights reserved.
//

import UIKit

class RegisterPageViewController: UIViewController {

    @IBOutlet weak var userUserNameTextField: UITextField!
    @IBOutlet weak var userIdTextField: UITextField!
    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func registerButtonTapped(sender: AnyObject) {
        
        let userUserName = userUserNameTextField.text
        let userID = userIdTextField.text
        let userEmail = userEmailTextField.text
        let userPasword = userPasswordTextField.text
        let userRepeatPassword = userPasswordTextField.text
        
        //空白欄がないかチェックするコードでもケンティーは書くかな
        if (userUserName.isEmpty || userID.isEmpty || userEmail.isEmpty || userPasword.isEmpty || userRepeatPassword.isEmpty){
            //ケンティー怒るからアラート表示
            //ここではアラートをファンクションから引っ張ってくる
            displayMyAlertMessage ("All Field are required")
            return
        }
        //パスワードが一致するか確認して見るケンティー
        
        if (userPasword != userRepeatPassword){
         //またしてもケンティー怒るからアラート表示
         //またしてもケンティーはアラートを下のファンクションから取り出す
            displayMyAlertMessage ("Password does not match")
            return
        }
        
    
        
        //アラートでもつけるか
        
    }
    
    func displayMyAlertMessage(userMessage: String ){
        var myAlert = UIAlertController(title:"Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction (title:"OK" , style: UIAlertActionStyle.Default, handler: nil)
        myAlert.addAction(okAction)
        self.presentViewController(myAlert, animated:true, completion:nil)
        
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