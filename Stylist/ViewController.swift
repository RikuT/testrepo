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

    
    @IBOutlet  var navigationBar: UINavigationBar!
    var overallNav: UIVisualEffectView!
    var appearentNav: UIView!
    var buttonLayoutView: UIView!
    var menuButton: UIButton!
    var searchButton: UIButton!
    //var trendButton: UIButton!
    var closetButton: UIButton!
    //var fittingButton: UIButton!
    var cameraButton: UIButton!
    var accountButton: UIButton!
    var helpButton: UIButton!
    
    var blackBlurBtn: UIButton!
    var fittingBtn: UIButton!

    
    var overallHeight: CGFloat = 200
    var appearentNavHeight: CGFloat = 30
    var upPosition = CGRectMake(0, 0, 0, 0)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.backgroundColor = UIColor(red: 0, green: 0.698, blue: 0.792, alpha: 1)
        // Do any additional setup after loading the view.
        appearentNav = UIView(frame: CGRectMake(0, 0, self.view.frame.width, appearentNavHeight))
        appearentNav.backgroundColor = UIColor(red: 0, green: 0.698, blue: 0.792, alpha: 0.92)
        
        /*
        var appearentNavLine: UIView = UIView(frame: CGRectMake(0, 0, self.view.frame.width - 30, 3))
        appearentNavLine.backgroundColor = UIColor(red: 0, green: 0.698, blue: 0.792, alpha: 0.75)
        appearentNavLine.center.x = appearentNav.center.x
        appearentNav.addSubview(appearentNavLine)
        //appearentNav.layer.borderColor = UIColor(red: 0, green: 0.698, blue: 0.792, alpha: 1).CGColor
        //appearentNav.layer.borderWidth = 2.5
*/
        
        let blurEffect: UIBlurEffect = UIBlurEffect(style: UIBlurEffectStyle.ExtraLight)
        overallNav = UIVisualEffectView(effect: blurEffect)
        overallNav.frame = CGRectMake(0, self.view.frame.height - appearentNavHeight, self.view.frame.width, overallHeight)
        
        
        blackBlurBtn = UIButton(frame: self.view.frame)
        blackBlurBtn.backgroundColor = UIColor(white: 0, alpha: 0)
        self.view.addSubview(self.blackBlurBtn)
        blackBlurBtn.hidden = true
        blackBlurBtn.addTarget(self, action: "blackBlurTapped", forControlEvents: UIControlEvents.TouchDown)

        
        var actualMenuHeight = overallHeight - appearentNavHeight
        buttonLayoutView = UIView(frame: CGRectMake(0, appearentNavHeight, self.view.frame.width, actualMenuHeight))
        buttonLayoutView.backgroundColor = UIColor.clearColor()
        self.view.addSubview(overallNav)
        overallNav.addSubview(appearentNav)
        overallNav.addSubview(buttonLayoutView)
        
        
        
        let menuImg = UIImage(named: "Collapse Arrow-50") as UIImage?
        menuButton   = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        menuButton.frame = CGRectMake(5, appearentNav.frame.origin.y + 2, appearentNavHeight - 4, appearentNavHeight)
        //menuButton.center = appearentNav.center
        menuButton.setImage(menuImg, forState: .Normal)
        menuButton.tintColor = UIColor.whiteColor()
        
        
        /*
        //Bar style menu btn
        menuButton = UIButton(frame: CGRectMake(self.view.frame.width / 2, 0, 35, 4))
        menuButton.center = appearentNav.center
        menuButton.layer.cornerRadius = 2
        //menuButton.backgroundColor = UIColor.blueColor()
        menuButton.backgroundColor = UIColor(red: 0, green: 0.698, blue: 0.792, alpha: 1)
*/
        
        /*
        menuButton = UIButton(frame: CGRectMake(self.view.frame.width / 2, 0, 130, appearentNavHeight - 7))
        menuButton.center = appearentNav.center
        menuButton.center.y = menuButton.center.y + 1.5
        //menuButton.backgroundColor = UIColor.blueColor()
        menuButton.setTitle("Menu", forState: .Normal)
        menuButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        menuButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        var temp = appearentNavHeight - 7
        menuButton.layer.cornerRadius = temp / 2
        menuButton.layer.borderColor = UIColor(red: 0, green: 0.698, blue: 0.792, alpha: 1).CGColor
        menuButton.layer.borderWidth = 1.5
*/
        menuButton.addTarget(self, action: "menuBtnTapped", forControlEvents: .TouchUpInside)
        appearentNav.addSubview(menuButton)
        
        fittingBtn = UIButton(frame: CGRectMake(self.view.frame.width / 2, 3, 130, appearentNavHeight - 7))
        fittingBtn.center = appearentNav.center
        fittingBtn.setTitle("F   I   T", forState: .Normal)
        fittingBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        fittingBtn.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 20)
        fittingBtn.addTarget(self, action: "fittingBtnTapped", forControlEvents: UIControlEvents.TouchUpInside)
        appearentNav.addSubview(fittingBtn)
        
        
        searchButton = UIButton(frame: CGRectMake(self.view.frame.width - appearentNavHeight, 0, appearentNavHeight, appearentNavHeight))
        searchButton.setTitle("虫", forState: .Normal)
        searchButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        //searchButton.backgroundColor = UIColor.blueColor()
        searchButton.addTarget(self, action: "searchButtonTapped", forControlEvents: .TouchUpInside)
        appearentNav.addSubview(searchButton)
        
        
        /*
        //Setting up trend button
        trendButton = UIButton(frame: CGRectMake(0, 0, self.view.frame.width / 2, actualMenuHeight / 3))
        trendButton.setTitle("trend", forState: .Normal)
        trendButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        trendButton.addTarget(self, action: "trendBtnTapped", forControlEvents: .TouchUpInside)
        buttonLayoutView.addSubview(trendButton)
*/
        
        //Setting up closet button
        closetButton = UIButton(frame: CGRectMake(0, 0, self.view.frame.width / 2, actualMenuHeight / 2))
        closetButton.setTitle("closet", forState: .Normal)
        closetButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        closetButton.addTarget(self, action: "closetBtnTapped", forControlEvents: .TouchUpInside)
        buttonLayoutView.addSubview(closetButton)
        
        /*
        //Setting up fitting button
        fittingButton = UIButton(frame: CGRectMake(0, actualMenuHeight / 3, self.view.frame.width / 2, actualMenuHeight / 3))
        fittingButton.setTitle("fitting", forState: .Normal)
        fittingButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        fittingButton.addTarget(self, action: "fittingBtnTapped", forControlEvents: .TouchUpInside)
        buttonLayoutView.addSubview(fittingButton)
*/
        
        //Setting up camera button
        cameraButton = UIButton(frame: CGRectMake(self.view.frame.width / 2, 0, self.view.frame.width / 2, actualMenuHeight / 2))
        cameraButton.setTitle("camera", forState: .Normal)
        cameraButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        cameraButton.addTarget(self, action: "cameraBtnTapped", forControlEvents: .TouchUpInside)
        buttonLayoutView.addSubview(cameraButton)
        
        //Setting up account button
        accountButton = UIButton(frame: CGRectMake(0, actualMenuHeight / 2, self.view.frame.width / 2, actualMenuHeight / 2))
        accountButton.setTitle("account", forState: .Normal)
        accountButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        accountButton.addTarget(self, action: "accountBtnTapped", forControlEvents: .TouchUpInside)
        buttonLayoutView.addSubview(accountButton)
        
        //Setting up help button
        helpButton = UIButton(frame: CGRectMake(self.view.frame.width / 2, actualMenuHeight / 2, self.view.frame.width / 2, actualMenuHeight / 2))
        helpButton.setTitle("help", forState: .Normal)
        helpButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        helpButton.addTarget(self, action: "helpBtnTapped", forControlEvents: .TouchUpInside)
        buttonLayoutView.addSubview(helpButton)
        
        
        
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
        var VCIDs : [String] = ["LikeVC", "NewVC", "TagVC"]
        var buttonTitles : [String] = ["Like", "Latest", "Tag"]
        
        //Sample customization
        swiftPagesView.setOriginY(0.0)
        swiftPagesView.enableAeroEffectInTopBar(true)
        swiftPagesView.initializeWithVCIDsArrayAndButtonTitlesArray(VCIDs, buttonTitlesArray: buttonTitles)
        
    }
    
    func menuBtnTapped() {
        
        
        let navDifference = overallHeight - appearentNavHeight
        var currentNavPosition = overallNav.frame
        
        println("currentNavPos \(currentNavPosition)")
        println("upPosition \(upPosition)")
        //overallNav.layer.position = CGPointMake(0, -navDifference)
       
        
        if (currentNavPosition == upPosition){
            self.closeMenu()
        }else{
            self.openMenu()
        }
        
        
        
    }
    
    func closeMenu(){
        println("already up")
        // アニメーション処理
        UIView.animateWithDuration(NSTimeInterval(CGFloat(0.3)),
            animations: {() -> Void in
                
                // 移動先の座標を指定する.
                self.overallNav.frame = CGRectMake(0, self.view.frame.height - self.appearentNavHeight, self.view.frame.width, self.overallHeight)
                self.blackBlurBtn.hidden = true
            }, completion: {(Bool) -> Void in
        })
        
        
        
        
        

    }
    
    func openMenu(){
        
        // アニメーション処理
        UIView.animateWithDuration(NSTimeInterval(CGFloat(0.3)),
            animations: {() -> Void in
                
                // 移動先の座標を指定する.
                self.overallNav.frame = CGRectMake(0, self.view.frame.height - self.overallHeight, self.view.frame.width, self.overallHeight)
                self.blackBlurBtn.hidden = false

            }, completion: {(Bool) -> Void in
        })
        
        self.view.bringSubviewToFront(overallNav)

        
    }
    
    func trendBtnTapped(){
        println("trendBtn")
    }
    func closetBtnTapped(){
        println("closet")
        self.performSegueWithIdentifier("VCtoClosetVC", sender: self)
    }
    
    func fittingBtnTapped(){
        println("fitting")
        self.performSegueWithIdentifier("VCtoFittingVCSegue", sender: self)
        //self.performSegueWithIdentifier("VCtoFittingVC", sender: self)
    }

    func cameraBtnTapped(){
        println("camera")
    }
    func accountBtnTapped(){
        println("account")
        self.performSegueWithIdentifier("VCtoAccountVC", sender: self)
    }
    func helpBtnTapped(){
        println("help")
    }
    
    
    func blackBlurTapped(){
        println("blackblur")
        self.closeMenu()
    }
 

    
    
}