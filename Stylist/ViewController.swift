//
//  ViewController.swift
//  Stylist
//
//  Created by Kenty on 2015/06/28.
//  Copyright (c) 2015年 xxx. All rights reserved.
//

import UIKit
import Parse





class ViewController: UIViewController {
    @IBAction func unwindToTrend(segue: UIStoryboardSegue) {
    }
    @IBOutlet var swiftPagesView: SwiftPages!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var overallNav: UIView!
    @IBOutlet weak var appearentNav: UIView!
    var overallHeight: CGFloat = 0
    var appearentNavHeight: CGFloat = 0
    var upPosition = CGRectMake(0, 0, 0, 0)


    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        navigationBar.backgroundColor = UIColor(red: 0, green: 0.698, blue: 0.792, alpha: 1)
        appearentNav.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
        appearentNav.layer.borderColor = UIColor(red: 0, green: 0.698, blue: 0.792, alpha: 1).CGColor
        appearentNav.layer.borderWidth = 1.5
      //  self.navigationBar.frame =
        
        //Setting CGRect to detect whether the menu is shown
        overallHeight = overallNav.frame.height
        appearentNavHeight = appearentNav.frame.height
        upPosition = CGRectMake(0, self.view.frame.height - overallHeight, self.view.frame.width, overallHeight)

        
        // 「ud」というインスタンスをつくる。
        let ud = NSUserDefaults.standardUserDefaults()
        // キーidに「taro」という値を格納。（idは任意の文字列でok）
        ud.removeObjectForKey("closeAlertKeyNote")
        ud.removeObjectForKey("closeAlertKey")
        
        self.initializePageView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        let isUserLoggedIn =
        NSUserDefaults.standardUserDefaults().boolForKey("isUserLoggedIn")
        
        if(!isUserLoggedIn){
            self.performSegueWithIdentifier("loginView", sender: self)
        }
        
        self.initializePageView()
    }
    
    
    func initializePageView(){
        //Initiation
        var VCIDs : [String] = ["LikeVC", "NewVC", "TagVC","NaviVC"]
        var buttonTitles : [String] = ["Like", "New", "Tags","Navi"]
        
        //Sample customization
        swiftPagesView.setOriginY(0.0)
        swiftPagesView.enableAeroEffectInTopBar(true)
        swiftPagesView.initializeWithVCIDsArrayAndButtonTitlesArray(VCIDs, buttonTitlesArray: buttonTitles)
        
    }
    
    @IBAction func menuBtnTapped() {
                let navDifference = overallHeight - appearentNavHeight
        var currentNavPosition = self.overallNav.frame
        println("currentNavPos \(currentNavPosition)")
        println("upPosition \(upPosition)")
        //overallNav.layer.position = CGPointMake(0, -navDifference)
        if (currentNavPosition == upPosition){
            println("already up")
            // アニメーション処理
            UIView.animateWithDuration(NSTimeInterval(CGFloat(0.3)),
                animations: {() -> Void in
                    
                    // 移動先の座標を指定する.
                    self.overallNav.frame = CGRectMake(0, self.view.frame.height - self.appearentNavHeight, self.view.frame.width, self.appearentNavHeight)
                    
                }, completion: {(Bool) -> Void in
            })

        }else{
        
        
        // アニメーション処理
        UIView.animateWithDuration(NSTimeInterval(CGFloat(0.3)),
            animations: {() -> Void in
                
                // 移動先の座標を指定する.
                self.overallNav.frame = CGRectMake(0, self.view.frame.height - self.overallHeight, self.view.frame.width, self.overallHeight)
                
            }, completion: {(Bool) -> Void in
        })
        }
        
        
        
    }
    
    
    @IBAction func logoutButtonTapped(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "isUserLoggedIn")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        PFUser.logOut()
        self.performSegueWithIdentifier("loginView", sender: self)
    }
    
    
    
    
    
}