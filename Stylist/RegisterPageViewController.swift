//
//  RegisterPageViewController.swift
//  Stylist
//
//  Created by Kento Katsumata on 2015/06/28.
//  Copyright (c) 2015年 xxx. All rights reserved.
//

import UIKit
import Parse



class RegisterPageViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var userUserNameTextField: UITextField!
    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    
    //For showing activity indicator
    var container: UIView = UIView()
    var loadingView: UIView = UIView()
    var actInd: UIActivityIndicatorView = UIActivityIndicatorView()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    @IBAction func registerButtonTapped(sender: AnyObject) {
        
        let userUserName = userUserNameTextField.text
        let userEmail = userEmailTextField.text
        let userPasword = userPasswordTextField.text
        let userRepeatPassword = repeatPasswordTextField.text
        
        //まずはアラートのファンクション
        
        /*
        func displayMyAlertMessage (userMessage: String ){
            var myAlert = UIAlertController(title:"Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction (title:"OK" , style: UIAlertActionStyle.Default, handler: nil)
            myAlert.addAction(okAction)
            self.presentViewController(myAlert, animated:true, completion:nil)
            
        }
*/
        
        //空白欄がないかチェックするコードでもケンティーは書くかな
        if (userUserName.isEmpty || userEmail.isEmpty || userPasword.isEmpty || userRepeatPassword.isEmpty){
            //ケンティー怒るからアラート表示
            //ここではアラートをファンクションから引っ張ってくる
            let alert = SCLAlertView()
            alert.showError("Error", subTitle:"All fields are required.", closeButtonTitle:"Ok")
            
            return
        }
        //ケンティー悪質ユーザー排除だぁぁぁぁああああああ
        if (count(userUserName.utf16) <= 4){
            //ケンティー怒るからアラート表示
            //ここではアラートをファンクションから引っ張ってくる
            let alert = SCLAlertView()
            alert.showError("Error", subTitle:"Username has to be longer than 4 letters.", closeButtonTitle:"Ok")
            
            return
        }
        //ケンティーパスワード問題の対策を考えるざます
        if (count(userPasword.utf16) <= 5){
            //ケンティー怒るからアラート表示
            //ここではアラートをファンクションから引っ張ってくる
            let alert = SCLAlertView()
            alert.showError("Error", subTitle:"Password has to be longer than 5 letters.", closeButtonTitle:"Ok")
            
            return
        }
        
        //パスワードが一致するか確認して見るケンティー
        
        if (userPasword != userRepeatPassword){
            //一致しなかったらケンティー怒るからアラート表示
            //アラート表示するには上に書いてあるファンクションを呼ぶでー　おーい！　はいつまんないね　すいません　というかトシキ並のつまんなさ
            let alert = SCLAlertView()
            alert.showError("Error", subTitle:"Password does not match.", closeButtonTitle:"Ok")
            
            return
        }
        
        self.showActivityIndicatory(self.view)
        
        //ここでPARSE に保存させるでよ　緊張の瞬間ですぜぃ
        
        let myUser:PFUser = PFUser()
        myUser.username = userUserName
        myUser.password = userPasword
        myUser.email = userEmail
        
        
        myUser.signUpInBackgroundWithBlock { (succeeded, error) -> Void in
            if error == nil {
                println("User Successfully Registered by ケンティーの守り神")
                self.hideActivityIndicator(self.view)

                let alert = SCLAlertView()
                alert.showSuccess("Success", subTitle:"Registration is successfully completed. Thank You!", closeButtonTitle:"Finish")
                /*
                
                var myAlert = UIAlertController(title:"Alert", message: "Registeration is Successful. Thank you!", preferredStyle:UIAlertControllerStyle.Alert)
                
                let okAction = UIAlertAction (title:"OK" , style: UIAlertActionStyle.Default){
                action in
                self.dismissViewControllerAnimated(true, completion: nil)
                }
                myAlert.addAction(okAction)
                self.presentViewController(myAlert, animated:true, completion:nil)
                */
                
                // 「ud」というインスタンスをつくる。
                let ud = NSUserDefaults.standardUserDefaults()
                
                // OKボタンを押した時に、Homeに戻るようにする
                ud.setInteger(3, forKey: "closeAlertKey")
                ud.removeObjectForKey("closeAlertKeyNote")
                //        SCLAlertView().showError(self, title: kErrorTitle, subTitle: kSubtitle)
                var timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("performSegueToHome"), userInfo: nil, repeats: true)

                
            }
            else {
                println("\(error)");
                // Show the errorString somewhere and let the user try again.
                //Show alert that error occured
                var errorMessage:String = error!.userInfo!["error"]as! String
                
                let errorAlert = SCLAlertView()
                errorAlert.showError("Error", subTitle:errorMessage, closeButtonTitle:"Close")
                self.hideActivityIndicator(self.view)
                
            }
            
            
            //できた！のアラート表示　（修正済み6/29）
            
            
        }
        
        
    }
    

    
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


    