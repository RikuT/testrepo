//
//  ViewController.swift
//  UIScrollView
//
//  Created by Tabata on 2015/7/1.
//  Copyright (c) 2015年 Riku Tabata. All rights reserved.
//

import UIKit
import Parse


class SwipeableClothesTester: UIViewController {
    //var movingCount: Int = 1
    
    
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
    
    @IBOutlet weak var goBackButt: UIButton!
    
    //洋服の数 -1に設定して、誤作動を防止
    var pictNumber: Int = -1
    
    //とりあえずテスト用に一つだけUIImageをいれた
    var resizedImagetest = UIImage()
    
    @IBOutlet weak var dottedLineView: UIImageView!
    //UIScrollViewを作成します
    let scrView2 = UIScrollView()
    
    
    var checkInt: Int? {
        didSet {
            //処理を軽くしたい場合は追加する。半分の処理になる
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
                println(self.pictNumber)
                
                
                
                
                //  dispatch_async(dispatch_get_main_queue()) {
                
                
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
            }}}
    
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
            let resizedSize = CGSizeMake(self.view.bounds.width, self.view.bounds.height);
            UIGraphicsBeginImageContext(resizedSize);
            
            var originalImage = imageArray[i]
            println(originalImage)
            originalImage.drawInRect(CGRectMake(0, 0, resizedSize.width, resizedSize.height))
            var resizedImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            println(resizedImage)
            self.resizedImageArray.append(resizedImage)
        }
        
        
        
        
        
        
        
        
        let resizedSize = CGSizeMake(self.view.bounds.width, self.view.bounds.height);
        UIGraphicsBeginImageContext(resizedSize);
        let orgImg = UIImage(named: "Img2.jpg")
        UIGraphicsBeginImageContext(resizedSize);
        orgImg?.drawInRect(CGRectMake(0, 0, resizedSize.width, resizedSize.height))
        resizedImagetest = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
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
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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

