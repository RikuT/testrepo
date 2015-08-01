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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
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
    
    
    
    @IBAction func logoutButtonTapped(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "isUserLoggedIn")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        PFUser.logOut()
        self.performSegueWithIdentifier("loginView", sender: self)
    }
    
    
    
    
    
}