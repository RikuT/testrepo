//
//  TrendDetailViewController.swift
//  Stylist
//
//  Created by Kenty on 2015/07/24.
//  Copyright (c) 2015年 xxx. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class TrendDetailViewController: UIViewController, UINavigationControllerDelegate {
    
    // Container to store the view table selected object
    var currentObject : PFObject?
    
    // Some text fields
    var topsLabel: UILabel!
    
    //For showing activity indicator
    var actInd: UIActivityIndicatorView = UIActivityIndicatorView()
    var scrollview: UIScrollView = UIScrollView()
    var imageView: PFImageView!
    var clothesDesLabel: UILabel!
    var initialImageFrame: CGRect!
    var quitButton: UIButton!
    var viewDidAppearCheck = 1
    
    
    var blurView: UIVisualEffectView!
    var whiteView: UIView!
    var spaceInScroll: CGFloat!
    
    var brandTag: TLTagsControl!
    var miscTag: TLTagsControl!
    
    var clothesName = ""
    var clothesDescription = ""
    var brandArray: NSArray = [""]
    var tagArray: NSArray = [""]
    var seasonInfo = ""
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        
        let ud = NSUserDefaults.standardUserDefaults()
        viewDidAppearCheck = 1
        
        var bgPictObj: AnyObject? = ud.objectForKey("bgBetweenNewVCandTrendDetailVC")
        var bgImgData = bgPictObj as! NSData
        var bgImage = UIImage(data: bgImgData)
        // self.view.setImage(image, forState: .Normal)
        ud.removeObjectForKey("bgBetweenNewVCandTrendDetailVC")
        var bgImgView = UIImageView(image: bgImage)
        bgImgView.frame = self.view.frame
        
        initialImageFrame = CGRectFromString(ud.stringForKey("cellPositionTopstoTrendDetailKey"))
        ud.removeObjectForKey("cellPositionTopstoTrendDetailKey")
        imageView = PFImageView(frame: initialImageFrame)
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        
        //bgImgView.alpha = 0.0
        self.view.addSubview(bgImgView)
        
        //Creating quit button
        quitButton = UIButton(frame: CGRectMake(5, 10, 40, 40))
        quitButton.tintColor = UIColor.whiteColor()
        //quitButton.buttonType = UIButtonType.System
        quitButton.setImage(UIImage(named: "whiteCancel.png"), forState: .Normal)
        quitButton.imageEdgeInsets = UIEdgeInsetsMake(12, 12, 12, 12)
        quitButton.addTarget(self, action: "quitButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        //Add this number to make menu larger
        spaceInScroll = 80
        
        //Setting initial scrollview location
        scrollview = UIScrollView(frame: CGRectMake(0, (self.view.frame.size.height / 2) + 50 - spaceInScroll, self.view.frame.size.width, (self.view.frame.size.height / 2) + 20 + spaceInScroll))
        scrollview.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height - 55 )
        
        //    brandArray = [NSMutableArray array];
        let screenRect = UIScreen.mainScreen().bounds
        
        
        
        // Unwrap the current object object
        if let object = currentObject {
            if let value = object["imageText"] as? String {
                self.clothesName = value
                
                // Display standard question image
                var initialThumbnail = UIImage(named: "question")
                imageView.image = initialThumbnail
                
                // Replace question image if an image exists on the parse platform
                if let thumbnail = object["imageFile"] as? PFFile {
                    imageView.file = thumbnail
                    imageView.loadInBackground { (image: UIImage?, error: NSError?) -> Void in
                        println("test")
                    }
                }
            }
            if let currentClothesDescription = object["clothesExplanation"] as? String{
                clothesDescription = currentClothesDescription
            }
            if let currentBrandTag = object["BrandTags"] as? NSArray{
                brandArray = currentBrandTag
            }
            if let currentMiscTag = object["Tags"] as? NSArray{
                tagArray = currentMiscTag
                
                
            }
            if let currentSeason = object["season"] as? String{
                seasonInfo = currentSeason
                
            }
            
        }
        
        ///Add username ・　uploaded at　・　trybut　・　savebut
        
        
        
        //Change textfield design over here
        whiteView = UIView(frame: CGRectMake(0, (self.view.frame.height / 2) + 60 + spaceInScroll, self.view.frame.width, scrollview.contentSize.height - ((self.view.frame.height - 60) / 2) - spaceInScroll))
        whiteView.backgroundColor = UIColor.whiteColor()
        scrollview.addSubview(whiteView)
        
        var swipeUpLabel = UILabel(frame: CGRectMake(0, 0, self.view.frame.width, 20))
        swipeUpLabel.text = "d e t a i l s"
        swipeUpLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
        swipeUpLabel.textAlignment = NSTextAlignment.Center
        swipeUpLabel.textColor = UIColor.whiteColor()
        swipeUpLabel.backgroundColor = UIColor(red: 0, green: 0.698, blue: 0.792, alpha: 1)
        whiteView.addSubview(swipeUpLabel)
        
        //Add number here to move the contents in whiteView down
        var heightInWhiteView: CGFloat = 15
        var grayLine = UILabel()
        
    
            topsLabel = UILabel(frame: CGRectMake(40, heightInWhiteView + 15, self.view.bounds.size.width - 60, 30))
            //topsLabel.borderStyle = UITextBorderStyle.Bezel
            
            topsLabel.textColor = UIColor.darkGrayColor()
            topsLabel.font = UIFont(name: "HelveticaNeue", size: 16)
            topsLabel.textAlignment = NSTextAlignment.Center
            topsLabel.text = clothesName
            
            grayLine.frame = CGRectMake(0, heightInWhiteView + 15 + 30 + 5, self.view.frame.width, 0.3)
            grayLine.backgroundColor = UIColor.lightGrayColor()
            whiteView.addSubview(grayLine)

        whiteView.addSubview(topsLabel)
        
        
        
        
        //Textview for clothes description
        var textViewPositionHeight: CGFloat = grayLine.frame.origin.y + 5
        if clothesDescription != ""{
            clothesDesLabel = UILabel(frame: CGRectMake(40, heightInWhiteView + textViewPositionHeight - 7, self.view.frame.size.width - 45, CGFloat.max))
            clothesDesLabel.text = clothesDescription
            println("clothesdes\(clothesDescription)")
            clothesDesLabel.font = UIFont(name: "HelveticaNeue", size: 16)
            clothesDesLabel.numberOfLines = 0
            clothesDesLabel.textColor = UIColor.darkGrayColor()
            clothesDesLabel.sizeToFit()
            clothesDesLabel.frame.origin = CGPointMake(40, heightInWhiteView + textViewPositionHeight - 7)
            whiteView.addSubview(clothesDesLabel)
            let detailIconImg = UIImage(named: "detailsIcon")
            var detailIconView = UIImageView(frame: CGRectMake(1, heightInWhiteView + textViewPositionHeight, 31, 31))
            detailIconView.image = detailIconImg
            whiteView.addSubview(detailIconView)
            
            var grayLine1 = UILabel(frame: CGRectMake(0, clothesDesLabel.frame.origin.y + clothesDesLabel.frame.height + 5, self.view.frame.width, 0.3))
            grayLine1.backgroundColor = UIColor.lightGrayColor()
            whiteView.addSubview(grayLine1)
        }else{
            clothesDesLabel = UILabel(frame: CGRectMake(40, textViewPositionHeight - 9 , self.view.frame.size.width - 45, 0))
        }
        
        
        
        //Add brand tags
        var brandTagPositionHeight: CGFloat = clothesDesLabel.frame.origin.y + clothesDesLabel.frame.size.height + 5
        if brandArray.count != 0{
            
            let hashTagLabel = UILabel(frame: CGRectMake(5, brandTagPositionHeight, 60, 40))
            hashTagLabel.text = "Brand"
            hashTagLabel.font = UIFont(name: "HelveticaNeue", size: 16)
            whiteView.addSubview(hashTagLabel)
            
            brandTag = TLTagsControl(frame: CGRectMake(62, brandTagPositionHeight + 5, self.view.bounds.size.width - 67, 30))
            brandTag.mode = TLTagsControlMode.Normal
            brandTag.tags = brandArray as? NSMutableArray
            brandTag.reloadTagSubviews()
            whiteView.addSubview(brandTag)
            
            var grayLine2 = UILabel(frame: CGRectMake(0, brandTag.frame.origin.y + brandTag.frame.height + 5, self.view.frame.width, 0.3))
            grayLine2.backgroundColor = UIColor.lightGrayColor()
            whiteView.addSubview(grayLine2)
        }else{
            brandTagPositionHeight = brandTagPositionHeight - 43
        }
        
        //Add tags
        var tagPositionHeight: CGFloat!
        if tagArray.count != 0 {
            tagPositionHeight = brandTagPositionHeight + 43
            
            var tagLabel = UILabel(frame: CGRectMake(5, tagPositionHeight, 30, 30))
            tagLabel.text = "#"
            tagLabel.font = UIFont(name: "HelveticaNeue", size: 25)
            whiteView.addSubview(tagLabel)
            
            miscTag = TLTagsControl(frame: CGRectMake(40, tagPositionHeight + 2, self.view.bounds.size.width - 25, 30))
            miscTag.mode = TLTagsControlMode.Normal
            miscTag.tags = tagArray as? NSMutableArray
            miscTag.reloadTagSubviews()
            whiteView.addSubview(miscTag)
            
            var grayLine3 = UILabel(frame: CGRectMake(0, miscTag.frame.origin.y + miscTag.frame.height + 5, self.view.frame.width, 0.3))
            grayLine3.backgroundColor = UIColor.lightGrayColor()
            whiteView.addSubview(grayLine3)
        }else{
            tagPositionHeight = brandTagPositionHeight
        }
        
        //Season info
        var seasonPositionHeight: CGFloat = tagPositionHeight + 43
        var seasonLabel = UILabel(frame: CGRectMake(60, seasonPositionHeight + 3, self.view.bounds.size.width - 80, 27))
        seasonLabel.text = seasonInfo
        seasonLabel.textColor = UIColor.darkGrayColor()
        seasonLabel.font = UIFont(name: "HelveticaNeue", size: 16)
        seasonLabel.textAlignment = NSTextAlignment.Left
        whiteView.addSubview(seasonLabel)
        
        
        var calendarIconImg = UIImage(named: "calendarIcon")
        var calendarIconView = UIImageView(image: calendarIconImg)
        calendarIconView.frame = CGRectMake(3, seasonPositionHeight - 1, 28, 30)
        whiteView.addSubview(calendarIconView)
        
        
        var whiteViewHeightY: CGFloat = calendarIconView.frame.origin.y + calendarIconView.frame.height + 10
        whiteView.frame = CGRectMake(whiteView.frame.origin.x, whiteView.frame.origin.y - grayLine.frame.origin.y - 10, whiteView.frame.size.width, whiteViewHeightY)
        scrollview.contentSize = CGSize (width: scrollview.frame.size.width, height: whiteView.frame.origin.y + whiteView.frame.size.height)
        /*
        var grayLine4 = UILabel(frame: CGRectMake(0, seasonTextF.frame.origin.y + seasonTextF.frame.height + 5, self.view.frame.width, 0.3))
        grayLine4.backgroundColor = UIColor.lightGrayColor()
        whiteView.addSubview(grayLine4)
        */
        
        
        self.view.backgroundColor = UIColor.whiteColor()
    }
    
    override func viewDidAppear(animated: Bool) {
        
        if viewDidAppearCheck == 1{
            let blurEffect: UIBlurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
            blurView = UIVisualEffectView(effect: blurEffect)
            blurView.alpha = 0
            blurView.frame = self.view.frame
            self.view.addSubview(blurView)
            self.view.addSubview(imageView)
            self.view.addSubview(quitButton)
            
            
            // アニメーション処理
            UIView.animateWithDuration(NSTimeInterval(CGFloat(0.35)),
                animations: {() -> Void in
                    
                    // 移動先の座標を指定する.
                    self.blurView.alpha = 0.8
                    self.imageView.frame = CGRectMake(30, 15, self.view.frame.width - 60, self.view.frame.height - 30)
                    
                    
                    
                }, completion: {(Bool) -> Void in
                    self.addingScrollView()
                    
                    UIView.animateWithDuration(NSTimeInterval(CGFloat(0.2)),
                        animations: {() -> Void in
                            
                            self.scrollview.frame =  CGRectMake(0, (self.view.frame.size.height / 2) - 20 - self.spaceInScroll, self.view.frame.size.width, (self.view.frame.size.height / 2) + 20 + self.spaceInScroll)
                            
                            
                        }, completion: {(Bool) -> Void in
                            self.addingScrollView()
                    })
            })
            
            viewDidAppearCheck = 2
        }
        
        
        
    }
    
    func addingScrollView(){
        
        
        self.view.addSubview(scrollview)
        self.view.bringSubviewToFront(quitButton)
    }
    
    
    func quitButtonPressed(){
        //Adding for navigation bar and status bar
        /*
        var lastScrollPosition: Float = Float(initialImageFrame.origin.y - 44 - 20)
        let ud = NSUserDefaults.standardUserDefaults()
        ud.setFloat(lastScrollPosition, forKey: "lastScrollPositionKey")
        ud.setBool(true, forKey: "fromDetailVCtoTopsVCKey")
        */
        
        // アニメーション処理
        UIView.animateWithDuration(NSTimeInterval(CGFloat(0.3)),
            animations: {() -> Void in
                
                self.blurView.alpha = 0.00
                self.imageView.alpha = 0.0
                self.quitButton.alpha = 0.0
                self.scrollview.alpha = 0.0
                
            }, completion: {(Bool) -> Void in
                self.dismissViewControllerAnimated(false, completion: nil)
                //self.performSegueWithIdentifier("trendDetailVCtoVC", sender: self)
        })
        
        
        
        println("quitbutPressed")
        
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
