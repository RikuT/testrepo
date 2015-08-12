//
//  ViewController.swift
//  UIScrollView
//
//  Created by Tabata on 2015/7/1.
//  Copyright (c) 2015年 Riku Tabata. All rights reserved.
//


//*******************TODO LIST***************************
//Hide dottedLineView when not touching screen
//Show alert when not connected to the internet or when error

import UIKit
import Parse


class SwipeableClothesTester: UIViewController {
    //var movingCount: Int = 1
    var detailBgImg: UIImage!
    
    //下のscrollviewの大きさが変わったら認知
    
    var topViewHeight: CGFloat? {
        didSet {
            //処理を軽くしたい場合は追加する。半分の処理になる
            /*
            movingCount++
            let remainder = movingCount%2
            if(remainder == 0){
            [self.bottomViewSet()]
            }*/
            if(self.pictNumber == self.imageArray.count || self.pictNumber + 1 == self.imageArray.count){
                self.topViewMoved1()
                
                
            }}
    }
    
    var topViewHeight2: CGFloat? {
        didSet{
            if(self.pictNumber == self.imageArray.count || self.pictNumber + 1 == self.imageArray.count){
                //[self.topViewMoved1()]
                self.topViewMoved2()
                
            }
        }
    }
    
    
    //Create arrays of images from parse
    var imageFiles = [PFFile]()
    var imageText = [String]()
    var imageArray = [UIImage]()
    var imageGlob = [UIImage]()
    var resizedImageArray = [UIImage]()
    var viewDidAppearInt: Int = 0
    var errorNumber: Int = 0
    
    //For showing activity indicator
    var container: UIView = UIView()
    var loadingView: UIView = UIView()
    var actInd: UIActivityIndicatorView = UIActivityIndicatorView()
    
    
    // var topViewHeight: CGFloat = 500
    
    @IBOutlet weak var swipeableView: UIView!
    @IBOutlet weak var goBackButt: UIButton!
    @IBOutlet weak var addLineButt: UIButton!
    
    //洋服の数 -1に設定して、誤作動を防止
    var pictNumber: Int = -1
    
    @IBOutlet weak var dottedLineView: UIImageView!
    @IBOutlet weak var dottedLineView2: UIImageView!
    @IBOutlet weak var menuBar: UIView!
    //@IBOutlet weak var dottedLineView2: UIImageView!
    //UIScrollViewを作成します
    let scrView = UIScrollView()
    let scrView2 = UIScrollView()
    let scrView3 = UIScrollView()
    
    var originCheckInt = 0
    
    
    var checkInt: Int? {
        didSet {
            //すべての画像がParseから読み込まれたか確認。読み込まれたら、scrollViewを入れる。
            if(self.pictNumber == self.imageArray.count){
                println("done")
                println("Image array \(imageArray)")
                println("Count \(imageArray.count)")
                self.setScrView()
            }
            
        }
    }
    
    
    
    
    func retrieveImg() {
        self.checkInt = 1
        // Do any additional setup after loading the view.
        
        //Parseから画像をひっぱってくる
        var query = PFQuery(className: "Tops")
        query.whereKey("uploader", equalTo: PFUser.currentUser()!)
        query.orderByDescending("createdAt")
        query.findObjectsInBackgroundWithBlock{
            (posts: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                for post in posts!{
                    self.imageFiles.append(post["imageFile"]as! PFFile)
                    self.imageText.append(post["imageText"]as! String)
                    
                }
                
                
                //Setting the number of pictures in the folder
                self.pictNumber = self.imageFiles.count
                println("hi\(self.pictNumber)")
                if(self.pictNumber == 0){
                    self.errorNumber = 1
                    self.showError()
                    
                }
                
                
                
                
                
                
                let test = 1
                for var i = 0; i < self.pictNumber; ++i {
                    
                    //Extracting pictures from PFFile
                    self.imageFiles[i].getDataInBackgroundWithBlock{
                        (imageData: NSData?, error: NSError?) -> Void in
                        if imageData != nil {
                            var image = UIImage(data: imageData!)
                            //var tempImageView = UIImageView (image: image)
                            self.imageArray.append(image!)
                            var tempCheck = self.checkInt
                            self.checkInt = self.checkInt! + tempCheck!
                        }else {
                            println(error)
                        }}
                    
                }
            }
            
            println("failure")
            /*
            if(self.errorNumber != 1){
            self.errorNumber = 2
            self.showError()
            }*/
        }
    }
    
    
    func setScrView(){
        
        //UIScrollViewを作成します
        //let scrView = UIScrollView()
        
        let ud = NSUserDefaults.standardUserDefaults()
        if ud.objectForKey("imageShownAtTrendDetailKey") != nil{
            println("objectPresent")
            var detailImgObj: AnyObject? = ud.objectForKey("imageShownAtTrendDetailKey")
            ud.removeObjectForKey("imageShownAtTrendDetailKey")
            var detailImgData = detailImgObj as! NSData
            var detailImg = UIImage(data: detailImgData)
            self.imageArray.insert(detailImg!, atIndex: 0)
            
        }
        
        
        //全体のサイズ
        //let CGwidth = self.view.frame.width
        let width = Int(self.view.frame.width)
        let intPictNumber = Int(self.imageArray.count)
        scrView.contentSize = CGSizeMake(CGFloat(width * intPictNumber), self.swipeableView.frame.height)
        scrView2.contentSize = CGSizeMake(CGFloat(width * intPictNumber), self.swipeableView.frame.height)
        scrView3.contentSize = CGSizeMake(CGFloat(width * intPictNumber), self.swipeableView.frame.height)
        
        
        //topViewHeight = self.swipeableView.frame.height / 2
        //表示位置 + 1ページ分のサイズ
        //Setting scrView3 frame later when add line btn is tapped
        scrView.frame = CGRectMake(0, 0, self.swipeableView.frame.width, self.swipeableView.frame.height / 2)
        scrView2.frame = CGRectMake(0, 0, self.swipeableView.frame.width, self.swipeableView.frame.height)
        
        
        
        
        //  dispatch_async(dispatch_get_main_queue()) {
        self.swipeableView.addSubview(scrView2)
        self.swipeableView.addSubview(scrView)
        self.swipeableView.addSubview(scrView3)
        
        
        /*
        //最初のbottomViewの大きさ指定
        var tempViewHeight1 = Float(self.dottedLineView.frame.origin.y)
        var tempViewHeight2 =  Float(self.dottedLineView.frame.height)/2
        var tempViewHeight = tempViewHeight1 + tempViewHeight2
        self.bottomViewHeight = tempViewHeight
        */
        
        
        for var i = 0; i < intPictNumber; ++i {
            var image = imageArray[i]
            println(image)
            var imageView = UIImageView(image: image)
            imageView.frame = CGRectMake(CGFloat(width * i), 0, self.swipeableView.frame.width, self.swipeableView.frame.height)
            //var imageView2 = imageView
            scrView.addSubview(imageView)
            //scrView2.addSubview(imageView2)
        }
        
        for var i = 0; i < intPictNumber; ++i {
            var image = imageArray[i]
            println(image)
            var imageView = UIImageView(image: image)
            imageView.frame = CGRectMake(CGFloat(width * i), 0, self.swipeableView.frame.width, self.swipeableView.frame.height)
            //var imageView2 = imageView
            scrView2.addSubview(imageView)
            //scrView2.addSubview(imageView2)
        }
        for var i = 0; i < intPictNumber; ++i {
            var image = imageArray[i]
            println(image)
            var imageView = UIImageView(image: image)
            imageView.frame = CGRectMake(CGFloat(width * i), 0, self.swipeableView.frame.width, self.swipeableView.frame.height)
            //var imageView2 = imageView
            scrView3.addSubview(imageView)
            //scrView2.addSubview(imageView2)
        }
        
        
        
        
        // １ページ単位でスクロールさせる
        scrView.pagingEnabled = false
        scrView2.pagingEnabled = false
        scrView3.pagingEnabled = false
        
        scrView3.hidden = true
        //scroll画面の初期位置
        //scrView2.contentOffset = CGPointMake(0, 0);
        
        
        
        //scroll画面の初期位置(ここは後で要変更。NSUserDefaultsで初期位置を保存する)
        scrView.contentOffset = CGPointMake(0, 0);
        
        
        
        //下の洋服のviewに追加します(処理軽減のためbottomViewSetではなく、viewDidLoadで実行)
        //self.swipeableView.addSubview(self.scrView2)
        
        
        //下の洋服の画像処理をここでやります。(処理軽減のため)
        // self.adjustingBottomImagetoFit()
        
        [self.topViewMoved1()]
        
        self.swipeableView.bringSubviewToFront(scrView)
        self.swipeableView.bringSubviewToFront(self.dottedLineView)
        self.swipeableView.bringSubviewToFront(self.dottedLineView2)
        self.swipeableView.bringSubviewToFront(self.goBackButt)
        self.swipeableView.bringSubviewToFront(menuBar)
        
        
        println("done")
        //負荷テスト用
        //var timer = NSTimer.scheduledTimerWithTimeInterval(0.0001, target: self, selector: Selector("bottomViewSet"), userInfo: nil, repeats: true)
        
        self.hideActivityIndicator(self.view)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.retrieveImg()
        self.errorNumber = 0
        // 「ud」というインスタンスをつくる。
        let ud = NSUserDefaults.standardUserDefaults()
        // キーidに「taro」という値を格納。（idは任意の文字列でok）
        ud.removeObjectForKey("closeAlertKeyNote")
        ud.removeObjectForKey("closeAlertKey")
        topViewHeight = self.swipeableView.frame.height / 2
        
        let blurEffect: UIBlurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        var blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = menuBar.frame
        blurView.frame.origin = CGPointZero
        self.menuBar.addSubview(blurView)
        
        var blackView = UIView(frame: menuBar.frame)
        blackView.frame.origin = CGPointZero
        blackView.backgroundColor = UIColor(white: 0.4, alpha: 0.3)
        self.goBackButt.addTarget(self, action: "goBackPressed", forControlEvents: UIControlEvents.TouchUpInside)
        blurView.addSubview(blackView)
        blackView.addSubview(goBackButt)
        blackView.addSubview(addLineButt)
        addLineButt.addTarget(self, action: "addLineBtnTapped", forControlEvents: UIControlEvents.TouchUpInside)
        dottedLineView2.hidden = true
        
        
        
        if ud.objectForKey("bgBetweenDetailVCandFittingKey") != nil{
            var bgPictObj: AnyObject? = ud.objectForKey("bgBetweenDetailVCandFittingKey")
            ud.removeObjectForKey("bgBetweenDetailVCandFittingKey")
            var bgImgData = bgPictObj as! NSData
            detailBgImg = UIImage(data: bgImgData)
        }
        ud.removeObjectForKey("bgBetweenDetailVCandFittingKey")
        /*
        //For hiding dottedline when not touching
        var dottedLineBtn = UIButton(frame: CGRectMake(0, 0, dottedLineView.frame.width, dottedLineView.frame.height))
        var dottedLineBtn2 = UIButton(frame: CGRectMake(0, 0, dottedLineView.frame.width, dottedLineView.frame.height))
        dottedLineView.addSubview(dottedLineBtn)
        dottedLineView2.addSubview(dottedLineBtn2)
        dottedLineBtn.addTarget(self, action: "dottedLineViewAppear1", forControlEvents: UIControlEvents.TouchDown)
        dottedLineBtn2.addTarget(self, action: "dottedLineViewAppear2", forControlEvents: UIControlEvents.TouchDown)
        dottedLineBtn.addTarget(self, action: "dottedLineViewDisappear1", forControlEvents: UIControlEvents.TouchUpInside)
        dottedLineBtn.addTarget(self, action: "dottedLineViewDisappear2", forControlEvents: UIControlEvents.TouchUpInside)
        */
        
        self.view.backgroundColor = UIColor(red: 0, green: 0.698, blue: 0.792, alpha: 1)
        
        self.showActivityIndicatory(self.view)
        println("ViewDidLoad appearInt = \(viewDidAppearInt)")
    }
    
    
    
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    
    @IBAction func handlePan(recognizer:UIPanGestureRecognizer) {
        let translation = recognizer.translationInView(self.swipeableView)
        if let dotView = recognizer.view {
            dotView.center = CGPoint(x: self.swipeableView.bounds.width/2,
                y:dotView.center.y + translation.y)
            if recognizer.view == dottedLineView{
                topViewHeight = dotView.center.y + translation.y
                println("one \(topViewHeight)")
                
            }
            if recognizer.view == dottedLineView2{
                topViewHeight2 = dotView.center.y + translation.y
                println("two \(topViewHeight2)")
                
            }
        }
        recognizer.setTranslation(CGPointZero, inView: self.swipeableView)
        
    }
    
    
    /*
    func adjustingBottomImagetoFit(){
    //resizing bottom image to fit the screen
    //ここで下の洋服のすべての画像処理をやらないとだめ。
    
    let intPictNumber = Int(self.imageArray.count)
    let width = Int(self.view.frame.width)
    
    for var i = 0; i < intPictNumber; ++i {
    //新しい画像のサイズを定義する
    let resizedSize = CGSizeMake(self.view.bounds.width, self.view.bounds.height);
    UIGraphicsBeginImageContext(resizedSize);
    //もともとの画像のarrayから一枚づつ画像を取り出す
    var originalImage = imageArray[i]
    println(originalImage)
    originalImage.drawInRect(CGRectMake(0, 0, resizedSize.width, resizedSize.height))
    var resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    println(resizedImage)
    //画面の大きさに合わせた画像を新しいArrayに追加する
    self.resizedImageArray.append(resizedImage)
    }
    
    }
    */
    
    //これは下の洋服のscrollViewの大きさが変わるごとに実行されるので、autoReleasePoolを使って軽くしたい
    func topViewMoved1(){
        scrView.frame = CGRectMake(0, 0, self.swipeableView.frame.width, topViewHeight!)
        var cgPictNum = CGFloat (self.imageArray.count)
        scrView.contentSize = CGSizeMake(self.swipeableView.frame.width * cgPictNum, topViewHeight!)
        
    }
    
    func topViewMoved2(){
        scrView3.frame = CGRectMake(0, 0, self.swipeableView.frame.width, topViewHeight2!)
        var cgPictNum = CGFloat (self.imageArray.count)
        scrView3.contentSize = CGSizeMake(self.swipeableView.frame.width * cgPictNum, topViewHeight2!)
    }
    
    func addLineBtnTapped(){
        println("add line btn tapped")
        
        //Adding another line
        if dottedLineView2.hidden == true{
            addLineButt.setTitle("remove line", forState: .Normal)
            dottedLineView2.hidden = false
            scrView3.frame = CGRectMake(0, 0, self.swipeableView.frame.width, self.dottedLineView.center.y / 2)
            dottedLineView2.center = CGPointMake(self.swipeableView.frame.width / 2, self.dottedLineView.center.y / 2)
            //self.topViewMoved2()
            var initialPosi = scrView.contentOffset
            println("initialPosi \(initialPosi)")
            scrView3.contentOffset = initialPosi
            var cgPictNum = CGFloat (self.imageArray.count)
            scrView3.contentSize = CGSizeMake(self.swipeableView.frame.width * cgPictNum, self.dottedLineView.center.y / 2)
            scrView3.hidden = false
            self.swipeableView.bringSubviewToFront(scrView3)
            self.swipeableView.bringSubviewToFront(dottedLineView2)
            
        }else{
            addLineButt.setTitle("add line", forState: .Normal)
            dottedLineView2.hidden = true
            scrView3.hidden = true
            
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
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func showError() {
        self.swipeableView.bringSubviewToFront(self.goBackButt)
        self.swipeableView.bringSubviewToFront(menuBar)
        println("Error number is \(self.errorNumber)")
        if (self.errorNumber == 1){
            SCLAlertView().showError("Error", subTitle:"You have not put in any photos in your library.", closeButtonTitle:"OK")
        }
        else if (self.errorNumber == 2){
            SCLAlertView().showError("Error", subTitle:"An error occured. Please check your internet connection.", closeButtonTitle:"OK")
        }
        else{
            SCLAlertView().showError("Error", subTitle:"An error occured.", closeButtonTitle:"OK")
        }
        
        // 「ud」というインスタンスをつくる。
        let ud = NSUserDefaults.standardUserDefaults()
        println("errorshow")
        
        // OKボタンを押した時に、Homeに戻るようにする
        ud.setInteger(1, forKey: "closeAlertKey")
        ud.removeObjectForKey("closeAlertKeyNote")
        println("scla to 1")
        //        SCLAlertView().showError(self, title: kErrorTitle, subTitle: kSubtitle)
        var timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("performSegueToHome"), userInfo: nil, repeats: true)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        println("viewDidAppear!!")
        viewDidAppearInt = 1
    }
    
    func performSegueToHome(){
        //Go home when error occurs
        if(viewDidAppearInt == 1){
            
            let ud = NSUserDefaults.standardUserDefaults()
            var udId : Int! = ud.integerForKey("closeAlertKeyNote")
            if(udId == 1){
                ud.removeObjectForKey("closeAlertKeyNote")
                ud.removeObjectForKey("closeAlertKey")
                
                self.dismissViewControllerAnimated(false, completion: nil)
                
                println("self to 0")
            }}
    }
    
    func goBackPressed(){
        
        
        let layer = UIApplication.sharedApplication().keyWindow?.layer
        let scale = UIScreen.mainScreen().scale
        UIGraphicsBeginImageContextWithOptions(layer!.frame.size, false, scale);
        
        layer!.renderInContext(UIGraphicsGetCurrentContext())
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let screenImgView = UIImageView(image: screenshot)
        screenImgView.frame = self.view.frame
        self.view.addSubview(screenImgView)
        
        
        
        
        
        goBackButt.enabled = false
        var detailBgView = UIImageView()
        
        detailBgView = UIImageView(image: detailBgImg)
        detailBgView.frame = CGRectMake(-self.view.frame.width, 0, self.view.frame.width, self.view.frame.height)
        self.view.addSubview(detailBgView)
        
        let ud = NSUserDefaults.standardUserDefaults()
        
        var originFromTrendDetail = ud.integerForKey("OriginToTryThemOnVC")
        ud.removeObjectForKey("OriginToTryThemOnVC")
            if originFromTrendDetail == 2{
                let blurEffect: UIBlurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
                var blurView = UIVisualEffectView(effect: blurEffect)
                blurView.frame = self.view.frame
                let darkView = UIView(frame: blurView.frame)
                darkView.backgroundColor = UIColor(white: 0, alpha: 0.5)
                blurView.alpha = 0.9
                blurView.addSubview(darkView)
                detailBgView.addSubview(blurView)
            }
        
        
        // アニメーション処理
        UIView.animateWithDuration(NSTimeInterval(CGFloat(0.3)),
            animations: {() -> Void in
                detailBgView.frame.origin.x = 0
                screenImgView.frame.origin.x = self.view.frame.size.width
                
            }, completion: {(Bool) -> Void in
                
                self.dismissViewControllerAnimated(false, completion: nil)
                
                
        })
        
        
    }
    
    
    
    
    override func viewDidDisappear(animated: Bool) {
        /*
        imageArray = []
        resizedImageArray = []
        autoreleasepool{
        imageArray = []
        resizedImageArray = []
        }
        }*/}
}

