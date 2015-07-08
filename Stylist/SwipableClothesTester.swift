//
//  ViewController.swift
//  UIScrollView
//
//  Created by Tabata on 2015/7/1.
//  Copyright (c) 2015年 Riku Tabata. All rights reserved.
//

import UIKit

class SwipableClothesTester: UIViewController {
    //var movingCount: Int = 1
    
    var bottomViewHeight: Float? {
        didSet {
            /*
            movingCount++
            let remainder = movingCount%50
            if(remainder == 0){
                    [self.bottomViewSet()]
            }*/
            [self.bottomViewSet()]
            println("didSet occured")

        }
    }
    @IBOutlet weak var goBackButt: UIButton!
    
    //洋服の数
    var pictNumber: Int = 0
    
    //とりあえずテスト用に一つだけUIImageをいれた
    var resizedImage = UIImage()
    
    @IBOutlet weak var dottedLineView: UIImageView!
    //UIScrollViewを作成します
    let scrView2 = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //最初のbottomViewの大きさ指定
        var tempViewHeight1 = Float(dottedLineView.frame.origin.y)
        var tempViewHeight2 =  Float(dottedLineView.frame.height)/2
        var tempViewHeight = tempViewHeight1 + tempViewHeight2
        bottomViewHeight = tempViewHeight
        
        //Setting random initial numbers to # of pictures
        pictNumber = 3
        
    //上の服の処理
        //UIImageに画像の名前を指定します
        //仮の画像を入れる。
        //実際にやる場合はarrayを使って画像の名前を引っ張ってきてやるらしい。だからParse上の画像ファイル名をまとめたarrayが必要。
        let img1 = UIImage(named:"Img1.jpg");
        let img2 = UIImage(named:"Img2.jpg");
        let img3 = UIImage(named:"Img3.jpg");
        
        //UIImageViewにUIIimageを追加
        let imageView1 = UIImageView(image:img1)
        let imageView2 = UIImageView(image:img2)
        let imageView3 = UIImageView(image:img3)
        
        //UIScrollViewを作成します
        let scrView = UIScrollView()
        
        //表示位置 + 1ページ分のサイズ
        scrView.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        
        //全体のサイズ
        scrView.contentSize = CGSizeMake(self.view.frame.width*3, self.view.frame.height)
        
        //UIImageViewのサイズと位置を決めます
        //左右に並べる
        let width = self.view.frame.width
        imageView1.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        imageView2.frame = CGRectMake(width, 0, self.view.frame.width, self.view.frame.height)
        imageView3.frame = CGRectMake(width*2, 0, self.view.frame.width, self.view.frame.height)
        
        //UIImageViewのサイズと位置を決めます

        //viewに追加します
        self.view.addSubview(scrView)
        scrView.addSubview(imageView1)
        scrView.addSubview(imageView2)
        scrView.addSubview(imageView3)
        
        // １ページ単位でスクロールさせる
        scrView.pagingEnabled = true
        
        //scroll画面の初期位置(ここは後で要変更。NSUserDefaultsで初期位置を保存する)
        scrView.contentOffset = CGPointMake(0, 0);

        

        //下の洋服のviewに追加します(処理軽減のためbottomViewSetではなく、viewDidLoadで実行)
        self.view.addSubview(scrView2)
        
        //下の洋服の画像処理をここでやります。(処理軽減のため)
        self.adjustingBottomImagetoFit()
        
        [self.bottomViewSet()]

        self.view.bringSubviewToFront(self.dottedLineView)
        self.view.bringSubviewToFront(self.goBackButt)
        
        //負荷テスト用
        //var timer = NSTimer.scheduledTimerWithTimeInterval(0.0001, target: self, selector: Selector("bottomViewSet"), userInfo: nil, repeats: true)

        
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
        
        let orgImg = UIImage(named: "Img2.jpg")
        let resizedSize = CGSizeMake(self.view.bounds.width, self.view.bounds.height);
        UIGraphicsBeginImageContext(resizedSize);
        orgImg?.drawInRect(CGRectMake(0, 0, resizedSize.width, resizedSize.height))
        resizedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

    }
 
    //これは下の洋服のscrollViewの大きさが変わるごとに実行されるので、autoReleasePoolを使って軽くしたい
    func bottomViewSet(){

        //下の服の処理
        //////////////////////////////////////////////////////////
        
        let viewHeight = Float(self.view.bounds.height)
        let bottomViewDifference = 0 - bottomViewHeight!
        
        ///////////////////////////
      
        
        //UIImageViewにUIIimageを追加
       let imgView1 = UIImageView(image:resizedImage)
        //let imgView2 = UIImageView(image:imgBot2)
        //let imgView3 = UIImageView(image:imgBot3)
        
        
        
        let bottomViewLocationH = viewHeight - bottomViewHeight!
       
        //scrollviewの表示位置
        scrView2.frame = CGRectMake(0, CGFloat( bottomViewHeight!), self.view.frame.width, CGFloat(bottomViewLocationH))
        
        
        //scrollview のcontent の全体のサイズ
        scrView2.contentSize = CGSizeMake(self.view.frame.width*3, CGFloat(bottomViewLocationH))
        
        //UIImageViewのサイズと位置を決めます
        //左右に並べる
        imgView1.frame = CGRectMake(0, CGFloat(bottomViewDifference), self.view.frame.width, self.view.frame.height)
        //   imgView2.frame = CGRectMake(width, 0, self.view.frame.width, self.view.frame.height)
        //  imgView3.frame = CGRectMake(width*2, 0, self.view.frame.width, self.view.frame.height)
        

        //ImageViewをscrollViewに追加(メモリ圧迫??)
         scrView2.addSubview(imgView1)
        //  scrView2.addSubview(imgView2)
        //  scrView2.addSubview(imgView3)
       
        
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
}

