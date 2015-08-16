//
//  ViewController.swift
//  Stylist
//
//  Created by Kenty on 2015/06/28.
//  Copyright (c) 2015年 xxx. All rights reserved.
//

import UIKit
import Parse





class ViewController: UIViewController{ //VisibleFormViewController, UITextFieldDelegate {
    @IBAction func unwindToTrend(segue: UIStoryboardSegue) {
    }
    @IBOutlet var swiftPagesView: SwiftPages!

    
    @IBOutlet  var navigationBar: UINavigationBar!
    var overallNav: UIVisualEffectView!
    var appearentNav: UIView!
    var buttonLayoutView: UIView!
    var searchButton: UIButton!
    //var trendButton: UIButton!
    var closetButton: UIButton!
    //var fittingButton: UIButton!
    var cameraButton: UIButton!
    var accountButton: UIButton!
    var helpButton: UIButton!
    
    var blackBlurBtn: UIButton!
    var fittingBtn: UIButton!
    
   // var searchTextF: UITextField!

    var menuButton: UIButton!

    var overallHeight: CGFloat = 200
    var appearentNavHeight: CGFloat = 30
    var upPosition = CGRectMake(0, 0, 0, 0)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.backgroundColor = UIColor(red: 0, green: 0.698, blue: 0.792, alpha: 1)
        // Do any additional setup after loading the view.
        self.setupMenuBar()
        


        
        // 「ud」というインスタンスをつくる。
        let ud = NSUserDefaults.standardUserDefaults()
        // キーidに「taro」という値を格納。（idは任意の文字列でok）
        ud.removeObjectForKey("closeAlertKeyNote")
        ud.removeObjectForKey("closeAlertKey")
        ud.removeObjectForKey("forceLoadPagesKey")
        ud.setBool(false, forKey: "forceLoadPagesKey")
        
        //self.initializePageView()
        self.initializePageView()

    }
    
    func setupMenuBar(){
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
        menuButton.frame = CGRectMake(0, appearentNav.frame.origin.y, appearentNavHeight + 30, appearentNavHeight)
        menuButton.imageEdgeInsets = UIEdgeInsets(top: 2, left: 5, bottom: 0, right: 30)
        //menuButton.center = appearentNav.center
        menuButton.setImage(menuImg, forState: .Normal)
        menuButton.tintColor = UIColor.whiteColor()
        println("menuFrame \(menuButton.frame)")
        

        menuButton.addTarget(self, action: "menuBtnTapped", forControlEvents: .TouchUpInside)
        appearentNav.addSubview(menuButton)
        
        fittingBtn = UIButton(frame: CGRectMake(self.view.frame.width / 2, 3, 130, appearentNavHeight - 7))
        fittingBtn.center = appearentNav.center
        fittingBtn.setTitle("F   I   T", forState: .Normal)
        fittingBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        fittingBtn.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 20)
        fittingBtn.addTarget(self, action: "fittingBtnTapped", forControlEvents: UIControlEvents.TouchUpInside)
        appearentNav.addSubview(fittingBtn)
        
        
        /*
        searchButton = UIButton(frame: CGRectMake(self.view.frame.width - appearentNavHeight, 0, appearentNavHeight, appearentNavHeight))
        searchButton.setTitle("虫", forState: .Normal)
        searchButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        //searchButton.backgroundColor = UIColor.blueColor()
        searchButton.addTarget(self, action: "searchButtonTapped", forControlEvents: .TouchUpInside)
        // appearentNav.addSubview(searchButton)
        
        searchTextF = UITextField(frame: CGRectMake(15, 6, self.view.frame.width - 30, (actualMenuHeight / 5) - 12))
        searchTextF.placeholder = "Search clothes"
        searchTextF.backgroundColor = UIColor(white: 0.7, alpha: 0.4)
        searchTextF.layer.cornerRadius = 5.0
        searchTextF.textAlignment = NSTextAlignment.Center
        searchTextF.textColor = UIColor.darkGrayColor()
        searchTextF.delegate = self
        buttonLayoutView.addSubview(searchTextF)
        
        var grayLine4 = UILabel(frame: CGRectMake(0, searchTextF.frame.origin.y + searchTextF.frame.size.height + 6, self.view.frame.width, 0.3))
        grayLine4.backgroundColor = UIColor.lightGrayColor()
        buttonLayoutView.addSubview(grayLine4)
   */
     

        
        /*
        //Setting up trend button
        trendButton = UIButton(frame: CGRectMake(0, 0, self.view.frame.width / 2, actualMenuHeight / 3))
        trendButton.setTitle("trend", forState: .Normal)
        trendButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        trendButton.addTarget(self, action: "trendBtnTapped", forControlEvents: .TouchUpInside)
        buttonLayoutView.addSubview(trendButton)
        */
        
        //Setting up closet button
        closetButton = UIButton(frame: CGRectMake(0, 0, self.view.frame.width, actualMenuHeight / 4))
        closetButton.setTitle("closet", forState: .Normal)
        closetButton.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
        closetButton.addTarget(self, action: "closetBtnTapped", forControlEvents: .TouchUpInside)
        closetButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Light", size: 23)
        buttonLayoutView.addSubview(closetButton)
        
        var grayLine = UILabel(frame: CGRectMake(0, closetButton.frame.origin.y + closetButton.frame.size.height, self.view.frame.width, 0.3))
        grayLine.backgroundColor = UIColor.lightGrayColor()
        buttonLayoutView.addSubview(grayLine)
        
        /*
        //Setting up fitting button
        fittingButton = UIButton(frame: CGRectMake(0, actualMenuHeight / 3, self.view.frame.width / 2, actualMenuHeight / 3))
        fittingButton.setTitle("fitting", forState: .Normal)
        fittingButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        fittingButton.addTarget(self, action: "fittingBtnTapped", forControlEvents: .TouchUpInside)
        buttonLayoutView.addSubview(fittingButton)
        */
        
        //Setting up camera button
        cameraButton = UIButton(frame: CGRectMake(0, actualMenuHeight / 4, self.view.frame.width, actualMenuHeight / 4))
        cameraButton.setTitle("camera", forState: .Normal)
        cameraButton.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
        cameraButton.addTarget(self, action: "cameraBtnTapped", forControlEvents: .TouchUpInside)
        cameraButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Light", size: 23)
        buttonLayoutView.addSubview(cameraButton)
        
        var grayLine2 = UILabel(frame: CGRectMake(0, cameraButton.frame.origin.y + cameraButton.frame.size.height, self.view.frame.width, 0.3))
        grayLine2.backgroundColor = UIColor.lightGrayColor()
        buttonLayoutView.addSubview(grayLine2)
        
        
        //Setting up account button
        accountButton = UIButton(frame: CGRectMake(0, actualMenuHeight * 2 / 4, self.view.frame.width, actualMenuHeight / 4))
        accountButton.setTitle("account", forState: .Normal)
        accountButton.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
        accountButton.addTarget(self, action: "accountBtnTapped", forControlEvents: .TouchUpInside)
        accountButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Light", size: 23)
        buttonLayoutView.addSubview(accountButton)
        
        var grayLine1 = UILabel(frame: CGRectMake(0, accountButton.frame.origin.y + accountButton.frame.size.height, self.view.frame.width, 0.3))
        grayLine1.backgroundColor = UIColor.lightGrayColor()
        buttonLayoutView.addSubview(grayLine1)
        
        
        //Setting up help button
        helpButton = UIButton(frame: CGRectMake(0, actualMenuHeight * 3 / 4, self.view.frame.width, actualMenuHeight / 4))
        helpButton.setTitle("help", forState: .Normal)
        helpButton.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
        helpButton.addTarget(self, action: "helpBtnTapped", forControlEvents: .TouchUpInside)
        helpButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Light", size: 23)
        buttonLayoutView.addSubview(helpButton)
        
        var grayLine3 = UILabel(frame: CGRectMake(0, helpButton.frame.origin.y + helpButton.frame.size.height, self.view.frame.width, 0.3))
        grayLine3.backgroundColor = UIColor.lightGrayColor()
        buttonLayoutView.addSubview(grayLine3)
        
        
        
        //Setting CGRect to detect whether the menu is shown
        overallHeight = overallNav.frame.height
        appearentNavHeight = appearentNav.frame.height
        upPosition = CGRectMake(0, self.view.frame.height - overallHeight, self.view.frame.width, overallHeight)
        
        //self.lastVisibleView = overallNav
        //self.visibleMargin = (-actualMenuHeight*4/5) + 40
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    override func viewWillAppear(animated: Bool) {

        let isUserLoggedIn =
        NSUserDefaults.standardUserDefaults().boolForKey("isUserLoggedIn")
        
        if(!isUserLoggedIn){
            self.performSegueWithIdentifier("loginView", sender: self)
        }
        
        self.initializePageView()
        
        //Setting notification which will reload pages when application enters foreground
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadPagesFore", name: UIApplicationWillEnterForegroundNotification, object: nil)
        
    }
    
    //Reloading all pages
    func loadPagesFore(){
        println("loadPages")
        //These methods are only conducted when the pages are not loaded
        /*
        let ud = NSUserDefaults.standardUserDefaults()
        ud.setBool(true, forKey: "forceLoadPagesKey") //currently disabled

        
        swiftPagesView.loadPage(0)
        swiftPagesView.loadPage(1)
        swiftPagesView.loadPage(2)
*/

    }
    
    
    func initializePageView(){
        
        //Initiation
        var VCIDs : [String] = ["LikeVC", "NewVC", "TagVC"]
        var buttonTitles : [String] = ["like", "latest", "tag"]
        
        //Sample customization
        swiftPagesView.setOriginY(0.0)
        swiftPagesView.enableAeroEffectInTopBar(true)
        swiftPagesView.initializeWithVCIDsArrayAndButtonTitlesArray(VCIDs, buttonTitlesArray: buttonTitles)
        
    }
    
    func menuBtnTapped() {
        
        
        let navDifference = overallHeight - appearentNavHeight
        var currentNavPosition = overallNav.frame
        

        //overallNav.layer.position = CGPointMake(0, -navDifference)
       
        
        if (currentNavPosition == upPosition){
            self.closeMenu()
            
        }else{
            self.openMenu()
        }
        
        
        
    }
    
    func closeMenu(){
        println("already up")
        //searchTextF.resignFirstResponder()
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
    
    /*
    override func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        let ud = NSUserDefaults.standardUserDefaults()
        ud.removeObjectForKey("searchKeyFromVCKey")
        ud.setObject(searchTextF.text, forKey: "searchKeyFromVCKey")


        self.closeMenu()
        self.view.endEditing(true)
        let searchView = NewViewController()
        searchView.loadCollectionViewData()
        return true
    }
*/
    func trendBtnTapped(){
        println("trendBtn")
    }
    func closetBtnTapped(){
        println("closet")
        self.performSegueWithIdentifier("VCtoClosetVC", sender: self)
    }
    
    func fittingBtnTapped(){
        println("fitting")
        let ud = NSUserDefaults.standardUserDefaults()
        
        let layer = UIApplication.sharedApplication().keyWindow?.layer
        let scale = UIScreen.mainScreen().scale
        UIGraphicsBeginImageContextWithOptions(layer!.frame.size, false, scale);
        
        layer!.renderInContext(UIGraphicsGetCurrentContext())
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        ud.setObject(UIImageJPEGRepresentation(screenshot, 0.6), forKey: "bgBetweenDetailVCandFittingKey")
        
        ud.setInteger(3, forKey: "OriginToTryThemOnVC")
        self.performSegueWithIdentifier("VCtoFittingVCSegue", sender: self)
        //self.performSegueWithIdentifier("VCtoFittingVC", sender: self)
    }

    func cameraBtnTapped(){
        println("camera")
        self.performSegueWithIdentifier("VCtoPhotoVC", sender: self)
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