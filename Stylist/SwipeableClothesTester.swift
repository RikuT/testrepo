//
//  ViewController.swift
//  UIScrollView
//
//  Created by Tabata on 2015/7/1.
//  Copyright (c) 2015年 Riku Tabata. All rights reserved.
//


//*******************TODO LIST***************************
//Stop activity indicator when no photo in user's file(show alert to add photos)
//Hide dottedLineView when not touching screen
//Show alert when not connected to the internet or when error

import UIKit
import Parse


class SwipeableClothesTester: UIViewController {
    //var movingCount: Int = 1
    
    
    //下のscrollviewの大きさが変わったら認知
    var bottomViewHeight: Float? {
        didSet {
            //処理を軽くしたい場合は追加する。半分の処理になる
            /*
            movingCount++
            let remainder = movingCount%2
            if(remainder == 0){
            [self.bottomViewSet()]
            }*/
            if(self.pictNumber == self.imageArray.count){
                [self.bottomViewSet()]
                
                println("didSet occured")
                
            }}
    }
    
    //Create arrays of images from parse
    var imageFiles = [PFFile]()
    var imageText = [String]()
    var imageArray = [UIImage]()
    var imageGlob = [UIImage]()
    var resizedImageArray = [UIImage]()
    var viewDidAppearInt: Int = 0
    var errorNumber: Int = 0
    
    @IBOutlet weak var goBackButt: UIButton!
    
    //洋服の数 -1に設定して、誤作動を防止
    var pictNumber: Int = -1
    
    @IBOutlet weak var dottedLineView: UIImageView!
    //UIScrollViewを作成します
    let scrView2 = UIScrollView()
    
    
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
        let scrView = UIScrollView()
        
        //全体のサイズ
        //let CGwidth = self.view.frame.width
        let width = Int(self.view.frame.width)
        let intPictNumber = Int(self.imageArray.count)
        scrView.contentSize = CGSizeMake(CGFloat(width * intPictNumber), self.view.frame.height)
        
        //表示位置 + 1ページ分のサイズ
        scrView.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        
        
        
        
        //  dispatch_async(dispatch_get_main_queue()) {
        
        self.view.addSubview(scrView)
        
        //最初のbottomViewの大きさ指定
        var tempViewHeight1 = Float(self.dottedLineView.frame.origin.y)
        var tempViewHeight2 =  Float(self.dottedLineView.frame.height)/2
        var tempViewHeight = tempViewHeight1 + tempViewHeight2
        self.bottomViewHeight = tempViewHeight
        
        
        
        for var i = 0; i < intPictNumber; ++i {
            var image = imageArray[i]
            println(image)
            var imageView = UIImageView(image: image)
            imageView.frame = CGRectMake(CGFloat(width * i), 0, self.view.frame.width, self.view.frame.height)
            scrView.addSubview(imageView)
        }
        
        
        // １ページ単位でスクロールさせる
        scrView.pagingEnabled = true
        
        //scroll画面の初期位置(ここは後で要変更。NSUserDefaultsで初期位置を保存する)
        scrView.contentOffset = CGPointMake(0, 0);
        
        
        
        //下の洋服のviewに追加します(処理軽減のためbottomViewSetではなく、viewDidLoadで実行)
        self.view.addSubview(self.scrView2)
        
        
        //下の洋服の画像処理をここでやります。(処理軽減のため)
        self.adjustingBottomImagetoFit()
        
        [self.bottomViewSet()]
        
        self.view.bringSubviewToFront(self.dottedLineView)
        self.view.bringSubviewToFront(self.goBackButt)
        
        println("done")
        //負荷テスト用
        //var timer = NSTimer.scheduledTimerWithTimeInterval(0.0001, target: self, selector: Selector("bottomViewSet"), userInfo: nil, repeats: true)
        
        
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
        
        self.showActivityIndicatory(self.view)
        println("ViewDidLoad appearInt = \(viewDidAppearInt)")
    }
    
    
    
    @IBAction func handlePan(recognizer:UIPanGestureRecognizer) {
        let translation = recognizer.translationInView(self.view)
        if let dotView = recognizer.view {
            dotView.center = CGPoint(x: self.view.bounds.width/2,
                y:dotView.center.y + translation.y)
            bottomViewHeight = Float(dotView.center.y + translation.y)
            println(bottomViewHeight)
        }
        recognizer.setTranslation(CGPointZero, inView: self.view)
        
    }
    
    
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
    
    //これは下の洋服のscrollViewの大きさが変わるごとに実行されるので、autoReleasePoolを使って軽くしたい
    func bottomViewSet(){
        
        //下の服の処理
        //////////////////////////////////////////////////////////
        
        let viewHeight = Float(self.view.bounds.height)
        let bottomViewDifference = 0 - bottomViewHeight!
        
        ///////////////////////////
        let intPictNumber = Int(self.resizedImageArray.count)
        let width = Int(self.view.frame.width)
        
        let bottomViewLocationH = viewHeight - bottomViewHeight!
        
        //scrollviewの表示位置
        scrView2.frame = CGRectMake(0, CGFloat( bottomViewHeight!), self.view.frame.width, CGFloat(bottomViewLocationH))
        
        //scrollview のcontent の全体のサイズ
        scrView2.contentSize = CGSizeMake(CGFloat(width * intPictNumber), CGFloat(bottomViewLocationH))
        
        //画像をscrollviewに位置を合わせて入れる。これにより、viewに対しての画像の位置が変わらない。
        for var i = 0; i < intPictNumber; ++i {
            var image = resizedImageArray[i]
            println(image)
            var imageView = UIImageView(image: image)
            //左右に並べる
            imageView.frame = CGRectMake(CGFloat(width * i), CGFloat(bottomViewDifference), self.view.frame.width, self.view.frame.height)
            
            //ImageViewをscrollViewに追加(メモリ圧迫??)
            scrView2.addSubview(imageView)
            
        }
        
        
        /*
        
        //UIImageViewにUIIimageを追加
        let imgView1 = UIImageView(image:resizedImagetest)
        //let imgView2 = UIImageView(image:imgBot2)
        //let imgView3 = UIImageView(image:imgBot3)
        
        
        
        
        
        //UIImageViewのサイズと位置を決めます
        //左右に並べる
        imgView1.frame = CGRectMake(0, CGFloat(bottomViewDifference), self.view.frame.width, self.view.frame.height)
        //   imgView2.frame = CGRectMake(width, 0, self.view.frame.width, self.view.frame.height)
        //  imgView3.frame = CGRectMake(width*2, 0, self.view.frame.width, self.view.frame.height)
        
        
        //ImageViewをscrollViewに追加(メモリ圧迫??)
        scrView2.addSubview(imgView1)
        //  scrView2.addSubview(imgView2)
        //  scrView2.addSubview(imgView3)ƒ
        */
        
        // １ページ単位でスクロールさせる
        scrView2.pagingEnabled = true
        
        
        //scroll画面の初期位置
        //scrView2.contentOffset = CGPointMake(0, 0);
        
        self.view.bringSubviewToFront(dottedLineView)
        println("bottomViewSet")
        
    }
    
    func showActivityIndicatory(uiView: UIView) {
        
        var container: UIView = UIView()
        container.frame = uiView.frame
        container.center = uiView.center
        container.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
        
        var loadingView: UIView = UIView()
        loadingView.frame = CGRectMake(0, 0, 100, 100)
        loadingView.center = uiView.center
        //loadingView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.3)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        var actInd: UIActivityIndicatorView = UIActivityIndicatorView()
        actInd.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
        actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        actInd.center = CGPointMake(loadingView.frame.size.width / 2,
            loadingView.frame.size.height / 2);
        loadingView.addSubview(actInd)
        container.addSubview(loadingView)
        uiView.addSubview(container)
        actInd.startAnimating()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func showError() {
        self.view.bringSubviewToFront(self.goBackButt)
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
        if(viewDidAppearInt == 1){
            
            let ud = NSUserDefaults.standardUserDefaults()
            var udId : Int! = ud.integerForKey("closeAlertKeyNote")
            if(udId == 1){
                ud.removeObjectForKey("closeAlertKeyNote")
                ud.removeObjectForKey("closeAlertKey")
                performSegueWithIdentifier("swipeableToHome",sender: nil)
                
                println("self to 0")
            }}
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

