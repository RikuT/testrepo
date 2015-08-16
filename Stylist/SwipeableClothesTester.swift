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
    
    //飛び出るアニメーション用の画像
    var detailBgImg: UIImage!
    
    //下のscrollviewの大きさが変わったら認知
    var topViewHeight: CGFloat? {
        didSet {
            //画像がすべてロードされたのを確認してから、点線を動かせるようにする
            if(self.pictNumber == self.imageArray.count || self.pictNumber + 1 == self.imageArray.count){
                self.topViewMoved1()
            }
        }
    }
    
    var topViewHeight2: CGFloat? {
        didSet{
            //画像がすべてロードされたのを確認してから、点線を動かせるようにする
            if(self.pictNumber == self.imageArray.count || self.pictNumber + 1 == self.imageArray.count){
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
    
    @IBOutlet weak var swipeableView: UIView!
    @IBOutlet weak var goBackButt: UIButton!
    @IBOutlet weak var addLineButt: UIButton!
    
    //洋服の数 -1に設定して、誤作動を防止
    var pictNumber: Int = -1
    
    @IBOutlet weak var dottedLineView: UIImageView!
    @IBOutlet weak var dottedLineView2: UIImageView!
    @IBOutlet weak var menuBar: UIView!
    
    //UIScrollViewを作成します
    let scrView = UIScrollView()
    let scrView2 = UIScrollView()
    let scrView3 = UIScrollView()
    
    var upButton = UIButton()
    var downButton = UIButton()
    
    var originCheckInt = 0
    
    
    var checkInt: Int? {
        didSet {
            //すべての画像がParseから読み込まれたか確認。読み込まれたら、scrollViewを入れる。
            if(self.pictNumber == self.imageArray.count){
                println("done")
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
                    //自分のすべての写真をfileとして保存
                    self.imageFiles.append(post["imageFile"]as! PFFile)
                    self.imageText.append(post["imageText"]as! String)
                }
                
                
                //Setting the number of pictures in the folder
                self.pictNumber = self.imageFiles.count
                
                //写真が自分のライブラリに入ってなかったら、エラーを表示する
                if(self.pictNumber == 0){
                    self.errorNumber = 1
                    self.showError()
                }
                
                
                for var i = 0; i < self.pictNumber; ++i {
                    
                    //Extracting pictures from PFFile
                    //写真の入ったファイルから、画像のarrayを作成する
                    self.imageFiles[i].getDataInBackgroundWithBlock{
                        (imageData: NSData?, error: NSError?) -> Void in
                        if imageData != nil {
                            var image = UIImage(data: imageData!)
                            self.imageArray.append(image!)
                            var tempCheck = self.checkInt
                            self.checkInt = self.checkInt! + tempCheck!
                        }else {
                            println(error)
                        }
                    }
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
        
        //トレンドからスワイプして来た場合、直前に見ていた画像をarrayの先頭に入れる。
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
        //服の画像を表示するscrollViewの大きさを決める
        let width = Int(self.view.frame.width)
        let intPictNumber = Int(self.imageArray.count)
        scrView.contentSize = CGSizeMake(CGFloat(width * intPictNumber), self.swipeableView.frame.height)
        scrView2.contentSize = CGSizeMake(CGFloat(width * intPictNumber), self.swipeableView.frame.height)
        scrView3.contentSize = CGSizeMake(CGFloat(width * intPictNumber), self.swipeableView.frame.height)
        
        
        //表示位置 + 1ページ分のサイズ
        //Setting scrView3 frame later when add line btn is tapped
        scrView.frame = CGRectMake(0, 0, self.swipeableView.frame.width, self.swipeableView.frame.height / 2)
        scrView2.frame = CGRectMake(0, 0, self.swipeableView.frame.width, self.swipeableView.frame.height)
        
        
        //ScrollViewの中に画像を追加していく
        for var i = 0; i < intPictNumber; ++i {
            var image = imageArray[i]
            println(image)
            var imageView = UIImageView(image: image)
            imageView.frame = CGRectMake(CGFloat(width * i), 0, self.swipeableView.frame.width, self.swipeableView.frame.height)
            scrView.addSubview(imageView)
        }
        
        for var i = 0; i < intPictNumber; ++i {
            var image = imageArray[i]
            println(image)
            var imageView = UIImageView(image: image)
            imageView.frame = CGRectMake(CGFloat(width * i), 0, self.swipeableView.frame.width, self.swipeableView.frame.height)
            scrView2.addSubview(imageView)
        }
        for var i = 0; i < intPictNumber; ++i {
            var image = imageArray[i]
            println(image)
            var imageView = UIImageView(image: image)
            imageView.frame = CGRectMake(CGFloat(width * i), 0, self.swipeableView.frame.width, self.swipeableView.frame.height)
            scrView3.addSubview(imageView)
        }
        
        
        
        //すべての洋服が入ったscrollviewを表示する
        self.swipeableView.addSubview(scrView2)
        self.swipeableView.addSubview(scrView)
        self.swipeableView.addSubview(scrView3)
        
        
        // １ページ単位でスクロールさせない
        scrView.pagingEnabled = false
        scrView2.pagingEnabled = false
        scrView3.pagingEnabled = false
        
        //点線を追加するボタンをタップするまで、一番上のscrollviewは表示しない
        scrView3.hidden = true
        
        //scroll画面の初期位置
        //scrView.contentOffset = CGPointMake(0, 0);
        
        
        [self.topViewMoved1()]
        
        //要素の順番を決める
        self.swipeableView.bringSubviewToFront(scrView)
        self.swipeableView.bringSubviewToFront(self.dottedLineView)
        self.swipeableView.bringSubviewToFront(self.dottedLineView2)
        self.swipeableView.bringSubviewToFront(self.goBackButt)
        self.swipeableView.bringSubviewToFront(menuBar)
        self.view.bringSubviewToFront(upButton)
        self.view.bringSubviewToFront(downButton)
        
        //負荷テスト用
        //var timer = NSTimer.scheduledTimerWithTimeInterval(0.0001, target: self, selector: Selector("bottomViewSet"), userInfo: nil, repeats: true)
        
        //くるくるを消す
        self.hideActivityIndicator(self.view)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //画像をサーバーから読み取る
        self.retrieveImg()
        
        //初期のエラー番号を設定。ご作動を防ぐ
        self.errorNumber = 0
        
        let ud = NSUserDefaults.standardUserDefaults()
        ud.removeObjectForKey("closeAlertKeyNote")
        ud.removeObjectForKey("closeAlertKey")
        
        //最初のscrollviewの大きさを画面の半分に設定する
        topViewHeight = self.swipeableView.frame.height / 2
        
        //下のバーに、ぼかしを設定する
        let blurEffect: UIBlurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        var blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = menuBar.frame
        blurView.frame.origin = CGPointZero
        self.menuBar.addSubview(blurView)
        
        //下のバーを黒くする。UIBlurEffectStyle.Darkを使わないことで、より細かい、黒さの指定が可能
        var blackView = UIView(frame: menuBar.frame)
        blackView.frame.origin = CGPointZero
        blackView.backgroundColor = UIColor(white: 0.4, alpha: 0.3)
        
        //下のバーに表示する戻るボダンの設定をする
        self.goBackButt.addTarget(self, action: "goBackPressed", forControlEvents: UIControlEvents.TouchUpInside)
        blurView.addSubview(blackView)
        blackView.addSubview(goBackButt)
        
        //点線を追加するためのボタンを追加する
        addLineButt.addTarget(self, action: "addLineBtnTapped", forControlEvents: UIControlEvents.TouchUpInside)
        blackView.addSubview(addLineButt)
        
        //追加されるまで、２番目の点線は隠しておく
        dottedLineView2.hidden = true
        
        //下の服の位置を微調節するためのボタン(上)
        upButton = UIButton(frame: CGRectMake(0, 0, 40, 40))
        upButton.layer.cornerRadius = 20.0
        var blurUpBtn = UIVisualEffectView(effect: blurEffect)
        blurUpBtn.frame = CGRectMake(self.view.frame.width - 50, self.view.frame.height - 145, 40, 40)
        blurUpBtn.layer.cornerRadius = 20
        blurUpBtn.clipsToBounds = true
        var upImg = UIImage(named: "Collapse Arrow-100")
        var upImgView = UIImageView(image: upImg)
        upImgView.frame = CGRectMake(3, 2, blurUpBtn.frame.width - 6, blurUpBtn.frame.height - 6)
        blurUpBtn.addSubview(upImgView)
        upButton.addTarget(self, action: "upBtnTapped", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(blurUpBtn)
        blurUpBtn.addSubview(upButton)
        
        //下の服の位置を微調節するためのボタン(下)
        downButton = UIButton(frame: CGRectMake(0, 0, 40, 40))
        downButton.layer.cornerRadius = 20.0
        var blurDownBtn = UIVisualEffectView(effect: blurEffect)
        blurDownBtn.frame = CGRectMake(self.view.frame.width - 50, self.view.frame.height - 90, 40, 40)
        blurDownBtn.layer.cornerRadius = 20
        blurDownBtn.clipsToBounds = true
        var downImg = UIImage(CGImage: upImg?.CGImage, scale: 1.0, orientation: UIImageOrientation.Down)
        var downImgView = UIImageView(image: downImg)
        downImgView.frame = CGRectMake(3, 4, blurUpBtn.frame.width - 6, blurUpBtn.frame.height - 6)
        blurDownBtn.addSubview(downImgView)
        downButton.addTarget(self, action: "downBtnTapped", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(blurDownBtn)
        blurDownBtn.addSubview(downButton)
        
        //セグエの時のアニメーションに使用するためのスクリーンショットを受け取る
        if ud.objectForKey("bgBetweenDetailVCandFittingKey") != nil{
            var bgPictObj: AnyObject? = ud.objectForKey("bgBetweenDetailVCandFittingKey")
            ud.removeObjectForKey("bgBetweenDetailVCandFittingKey")
            var bgImgData = bgPictObj as! NSData
            detailBgImg = UIImage(data: bgImgData)
        }
        ud.removeObjectForKey("bgBetweenDetailVCandFittingKey")
        
        
        self.view.backgroundColor = UIColor(red: 0, green: 0.698, blue: 0.792, alpha: 1)
        
        //服の画像を取り込む前に、くるくるを表示する
        self.showActivityIndicatory(self.view)
    }
    
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    //下に微調節するためのボタンがタップされたら画像の位置を下げる。ウエストを合わせることにより自然な試着体験が可能になる。
    func downBtnTapped(){
        println("down")
        scrView2.frame.origin.y = scrView2.frame.origin.y + 3
    }
    //上に微調節するためのボタンがタップされたら画像の位置を上げる。ウエストを合わせることにより自然な試着体験が可能になる。
    func upBtnTapped(){
        println("up")
        scrView2.frame.origin.y = scrView2.frame.origin.y - 3
    }
    
    
    //点線を上下させるためのジェスチャーを認識する
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
    
    
    
    
    //点線が動かされるごとに実行される。scrollViewの大きさを調節する。
    func topViewMoved1(){
        scrView.frame = CGRectMake(0, 0, self.swipeableView.frame.width, topViewHeight!)
        var cgPictNum = CGFloat (self.imageArray.count)
        scrView.contentSize = CGSizeMake(self.swipeableView.frame.width * cgPictNum, topViewHeight!)
        
    }
    //点線が動かされるごとに実行される。scrollViewの大きさを調節する。
    func topViewMoved2(){
        scrView3.frame = CGRectMake(0, 0, self.swipeableView.frame.width, topViewHeight2!)
        var cgPictNum = CGFloat (self.imageArray.count)
        scrView3.contentSize = CGSizeMake(self.swipeableView.frame.width * cgPictNum, topViewHeight2!)
    }
    
    func addLineBtnTapped(){
        println("add line btn tapped")
        
        //Adding another line
        //２番目の点線が画面に表示されていない場合は、表示する
        if dottedLineView2.hidden == true{
            addLineButt.setTitle("remove line", forState: .Normal)
            dottedLineView2.hidden = false
            //上に表示するscrollviewの場所を調節する
            scrView3.frame = CGRectMake(0, 0, self.swipeableView.frame.width, self.dottedLineView.center.y / 2)
            dottedLineView2.center = CGPointMake(self.swipeableView.frame.width / 2, self.dottedLineView.center.y / 2)
            var initialPosi = scrView.contentOffset
            scrView3.contentOffset = initialPosi
            var cgPictNum = CGFloat (self.imageArray.count)
            scrView3.contentSize = CGSizeMake(self.swipeableView.frame.width * cgPictNum, self.dottedLineView.center.y / 2)
            scrView3.hidden = false
            self.swipeableView.bringSubviewToFront(scrView3)
            self.swipeableView.bringSubviewToFront(dottedLineView2)
            
        }else{
            //もうすでに2つ点線が表示されている場合は、2番目の点線を取り除く
            addLineButt.setTitle("add line", forState: .Normal)
            dottedLineView2.hidden = true
            scrView3.hidden = true
            
        }
    }
    
    //くるくるを表示するため
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
        var timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("performSegueToHome"), userInfo: nil, repeats: true)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        viewDidAppearInt = 1
    }
    
    func performSegueToHome(){
        //Go home when error occurs
        //エラーが起こったさいは自動的にホームに戻る。
        //この時、OKボタンを押した際のアクションが、別のクラスに定義されているので、userdefaultsを使用して、そのクラスに、アクションを実行するということを伝える。
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
        
        //戻るボタンを押した際の、アニメーションを追加する。Dismissviewcontrollerを使っているので、goBackSegue.swiftで定義されたアニメーションを使用することができたい。
        //前の画面のスクリーンショットと今の画面のスクリーンショットを組み合わせることにより、アニメーションを実施する。
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
        
        //trendから来ていた場合、スクリーンショットにぼかしをいれる。
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
        
        //アニメーションを実行する
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

