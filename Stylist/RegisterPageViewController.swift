//
//  RegisterPageViewController.swift
//  Stylist
//
//  Created by 勝又健登 on 2015/06/28.
//  Copyright (c) 2015年 xxx. All rights reserved.
//

import UIKit
import Parse



class RegisterPageViewController: UIViewController, UITextFieldDelegate {
    

    @IBOutlet weak var userUserNameTextField: MKTextField!
    @IBOutlet weak var userEmailTextField: MKTextField!
    @IBOutlet weak var userPasswordTextField: MKTextField!
    @IBOutlet weak var repeatPasswordTextField: MKTextField!
    
    //For showing activity indicator
    var container: UIView = UIView()
    var loadingView: UIView = UIView()
    var actInd: UIActivityIndicatorView = UIActivityIndicatorView()


    override func viewDidLoad() {
        super.viewDidLoad()
        userUserNameTextField.layer.borderColor = UIColor.clearColor().CGColor
        userUserNameTextField.floatingPlaceholderEnabled = true
        userUserNameTextField.placeholder = "UserName"
        userUserNameTextField.tintColor = UIColor.MKColor.Blue
        userUserNameTextField.rippleLocation = .Right
        userUserNameTextField.cornerRadius = 0
        userUserNameTextField.bottomBorderEnabled = true
        
        userEmailTextField.layer.borderColor = UIColor.clearColor().CGColor
        userEmailTextField.floatingPlaceholderEnabled = true
        userEmailTextField.placeholder = "Email Adress"
        userEmailTextField.tintColor = UIColor.MKColor.Blue
        userEmailTextField.rippleLocation = .Right
        userEmailTextField.cornerRadius = 0
        userEmailTextField.bottomBorderEnabled = true
        
        userPasswordTextField.layer.borderColor = UIColor.clearColor().CGColor
        userPasswordTextField.floatingPlaceholderEnabled = true
        userPasswordTextField.placeholder = "Password"
        userPasswordTextField.tintColor = UIColor.MKColor.Red
        userPasswordTextField.rippleLocation = .Right
        userPasswordTextField.cornerRadius = 0
        userPasswordTextField.bottomBorderEnabled = true
        
        repeatPasswordTextField.layer.borderColor = UIColor.clearColor().CGColor
        repeatPasswordTextField.floatingPlaceholderEnabled = true
        repeatPasswordTextField.placeholder = "Repeat Password"
        repeatPasswordTextField.tintColor = UIColor.MKColor.Red
        repeatPasswordTextField.rippleLocation = .Right
        repeatPasswordTextField.cornerRadius = 0
        repeatPasswordTextField.bottomBorderEnabled = true
        
        
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
//登録ボタンが押された時のためのコードが書いてあります.
    @IBAction func registerButtonTapped(sender: AnyObject) {
        
        let userUserName = userUserNameTextField.text
        let userEmail = userEmailTextField.text
        let userPasword = userPasswordTextField.text
        let userRepeatPassword = repeatPasswordTextField.text
        

        //空白欄がないかチェックするコードです。
        if (userUserName.isEmpty || userEmail.isEmpty || userPasword.isEmpty || userRepeatPassword.isEmpty){
            //空白欄があった場合はアラートを表示させます。
            let alert = SCLAlertView()
            alert.showError("Error", subTitle:"All fields are required.", closeButtonTitle:"Ok")
            
            return
        }
        //ユーザーネームを四文字以上に設定するコードです。
        if (count(userUserName.utf16) <= 4){
           // 四文字以下の場合はアラートを表示させます。
            let alert = SCLAlertView()
            alert.showError("Error", subTitle:"Username has to be longer than 4 letters.", closeButtonTitle:"Ok")
            
            return
        }
        //パスワードを五文字以上に設定するコードです
        if (count(userPasword.utf16) <= 5){
           //五文字以下の場合はアラートを表示させます。
            let alert = SCLAlertView()
            alert.showError("Error", subTitle:"Password has to be longer than 5 letters.", closeButtonTitle:"Ok")
            
            return
        }
        
        //パスワードが一致するか確認するコードです。
        
        if (userPasword != userRepeatPassword){
           //一致しない場合はアラートを表示させます
            let alert = SCLAlertView()
            alert.showError("Error", subTitle:"Password does not match.", closeButtonTitle:"Ok")
            
            return
        }
        
        self.showActivityIndicatory(self.view)
        
        //以下のコードでパースに保存させます。
        let myUser:PFUser = PFUser()
        myUser.username = userUserName
        myUser.password = userPasword
        myUser.email = userEmail
        let tempProfilePict = UIImage(named: "profilePlaceHolder")
        var imageData = UIImageJPEGRepresentation(tempProfilePict, 1.0)
        var parseImageFile = PFFile(name: "uploaded_image.jpg", data: imageData)
        myUser["profilePicture"] = parseImageFile
        
        
        myUser.signUpInBackgroundWithBlock { (succeeded, error) -> Void in
            if error == nil {
                println("User Successfully Registered")
                self.hideActivityIndicator(self.view)

                let alert = SCLAlertView()
                alert.showSuccess("Success", subTitle:"Registration is successfully completed. Thank You!", closeButtonTitle:"Finish")

                // 「ud」というインスタンスをつくる。
                let ud = NSUserDefaults.standardUserDefaults()
                
                // OKボタンを押した時に、Homeに戻るようにする
                ud.setInteger(3, forKey: "closeAlertKey")
                ud.removeObjectForKey("closeAlertKeyNote")
                var timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("performSegueToHome"), userInfo: nil, repeats: true)

                
            }
            else {
                println("\(error)");
                var errorMessage:String = error!.userInfo!["error"]as! String
                
                let errorAlert = SCLAlertView()
                errorAlert.showError("Error", subTitle:errorMessage, closeButtonTitle:"Close")
                self.hideActivityIndicator(self.view)
                
            }
            
            
            
            
        }
        
        
    }
    

    //自動的にホームへ戻ります。
    func performSegueToHome(){
            let ud = NSUserDefaults.standardUserDefaults()
            var udId : Int! = ud.integerForKey("closeAlertKeyNote")
            if(udId == 1){
                ud.removeObjectForKey("closeAlertKeyNote")
                ud.removeObjectForKey("closeAlertKey")
                self.dismissViewControllerAnimated(true, completion: nil)
                
                println("self to 0")
            }
    }

    
    func showActivityIndicatory(uiView: UIView) {
        
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

    
}






/*
// MARK: - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
// Get the new view controller using segue.destinationViewController.
// Pass the selected object to the new view controller.
}
*/


    