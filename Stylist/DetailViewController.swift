//
//  DetailViewController.swift
//  Stylist
//
//  Created by Kenty on 2015/07/24.
//  Copyright (c) 2015年 xxx. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class DetailViewController: VisibleFormViewController, UINavigationControllerDelegate, UITextFieldDelegate {
    
    // Container to store the view table selected object
    var currentObject : PFObject?
    
    // Some text fields
    var topsLabel: UITextField!
    
    //For showing activity indicator
    var container: UIView = UIView()
    var loadingView: UIView = UIView()
    var actInd: UIActivityIndicatorView = UIActivityIndicatorView()
    var scrollview: UIScrollView = UIScrollView()
    var brandArray: NSMutableArray = NSMutableArray()
    var imageView: PFImageView!
    var clothesDesciptionTextView: UITextView!
    var initialImageFrame: CGRect!
    var quitButton: UIButton!
    var checkButton: UIButton!
    
    var blurView: UIVisualEffectView!
    var whiteView: UIView!
    var spaceInScroll: CGFloat!
    
    var updateObject : PFObject?
    
    var brandTag: TLTagsControl!
    var miscTag: TLTagsControl!
    var seasonSegment: UISegmentedControl!
    
    var currentObjectId: NSString!
    
    var viewDidAppearCheck: Int!
    
    
    // The save button
    /*
    @IBAction func saveButton(sender: AnyObject) {
        
        // Use the sent country object or create a new country PFObject
        if let saveInBackWithBlock = currentObject as PFObject? {
            updateObject = currentObject! as PFObject
        } else {
            updateObject = PFObject(className:"Tops")
        }
        
        // Update the object
        if let updateObject = updateObject {
            
            updateObject["imageText"] = topsLabel.text
            
            // Create a string of text that is used by search capabilites
            var searchText = (topsLabel.text)
            updateObject["searchText"] = searchText
            
            // Update the record ACL such that the new record is only visible to the current user
            updateObject.ACL = PFACL(user: PFUser.currentUser()!)
            
            // Save the data back to the server in a background task
            updateObject.saveInBackgroundWithBlock{
                (success: Bool, error: NSError?) -> Void in
                if (success) {
                    // The object has been saved.
                    
                } else {
                    // There was a problem, check error.description
                }
            }
            
            
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        
        let ud = NSUserDefaults.standardUserDefaults()
        ud.setObject("BRAND", forKey: "brandNameKey")
        viewDidAppearCheck = 1
        var bgPictObj: AnyObject? = ud.objectForKey("bgBetweenTopsVCandDetailVC")
        var bgImgData = bgPictObj as! NSData
        var bgImage = UIImage(data: bgImgData)
        // self.view.setImage(image, forState: .Normal)
        ud.removeObjectForKey("bgBetweenTopsVCandDetailVC")
        var bgImgView = UIImageView(image: bgImage)
        bgImgView.frame = self.view.frame
        
        initialImageFrame = CGRectFromString(ud.stringForKey("cellPositionTopstoDetailKey"))
        ud.removeObjectForKey("cellPositionTopstoDetailKey")
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
        
        //Creating check button
        checkButton = UIButton(frame: CGRectMake(self.view.frame.width - 45, 12, 40, 40))
        checkButton.tintColor = UIColor.whiteColor()
        checkButton.setImage(UIImage(named: "check70"), forState: .Normal)
        checkButton.imageEdgeInsets = UIEdgeInsetsMake(7.5, 7.5, 7.5, 7.5)
        checkButton.addTarget(self, action: "checkButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        
        //Add this number to make menu larger
        spaceInScroll = 80
        
        //Setting initial scrollview location
        scrollview = UIScrollView(frame: CGRectMake(0, (self.view.frame.size.height / 2) + 50 - spaceInScroll, self.view.frame.size.width, (self.view.frame.size.height / 2) + 20 + spaceInScroll))
        scrollview.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height - 55 )
        ud.setObject("BRAND", forKey: "brandNameKey")
        //    brandArray = [NSMutableArray array];
        let screenRect = UIScreen.mainScreen().bounds
        
        
        
        
        //Change textfield design over here
        whiteView = UIView(frame: CGRectMake(0, (self.view.frame.height / 2) + 60 + spaceInScroll, self.view.frame.width, scrollview.contentSize.height - ((self.view.frame.height - 60) / 2) - spaceInScroll))
        whiteView.backgroundColor = UIColor.whiteColor()
        scrollview.addSubview(whiteView)
        
        var swipeUpLabel = UILabel(frame: CGRectMake(0, 0, self.view.frame.width, 20))
        swipeUpLabel.text = "s w i p e  u p"
        swipeUpLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
        swipeUpLabel.textAlignment = NSTextAlignment.Center
        swipeUpLabel.textColor = UIColor.whiteColor()
        swipeUpLabel.backgroundColor = UIColor(red: 0, green: 0.698, blue: 0.792, alpha: 1)
        whiteView.addSubview(swipeUpLabel)
        
        //Add number here to move the contents in whiteView down
        var heightInWhiteView: CGFloat = 15
        
        topsLabel = UITextField(frame: CGRectMake(40, heightInWhiteView + 15, self.view.bounds.size.width - 60, 30))
        //topsLabel.borderStyle = UITextBorderStyle.Bezel
        
        topsLabel.placeholder = "Add clothes name"
        topsLabel.textColor = UIColor.darkGrayColor()
        topsLabel.font = UIFont(name: "HelveticaNeue", size: 16)
        topsLabel.delegate = self
        whiteView.addSubview(topsLabel)
        
        var grayLine = UILabel(frame: CGRectMake(0, heightInWhiteView + 15 + 30 + 5, self.view.frame.width, 0.3))
        grayLine.backgroundColor = UIColor.lightGrayColor()
        whiteView.addSubview(grayLine)
        
        
        //Textview for clothes description
        var textViewPositionHeight: CGFloat = 60
        clothesDesciptionTextView = UITextView(frame: CGRectMake(40, heightInWhiteView + textViewPositionHeight - 7, self.view.frame.size.width - 45, 97))
        clothesDesciptionTextView.font = UIFont(name: "HelveticaNeue", size: 16)
        clothesDesciptionTextView.backgroundColor = UIColor.clearColor()
        //clothesDesciptionTextView.text = textViewPlaceHolder
        clothesDesciptionTextView.textColor = UIColor.darkGrayColor()
        whiteView.addSubview(clothesDesciptionTextView)
        let detailIconImg = UIImage(named: "detailsIcon")
        var detailIconView = UIImageView(frame: CGRectMake(1, heightInWhiteView + textViewPositionHeight, 31, 31))
        detailIconView.image = detailIconImg
        whiteView.addSubview(detailIconView)
        
        var grayLine1 = UILabel(frame: CGRectMake(0, clothesDesciptionTextView.frame.origin.y + clothesDesciptionTextView.frame.height + 5, self.view.frame.width, 0.3))
        grayLine1.backgroundColor = UIColor.lightGrayColor()
        whiteView.addSubview(grayLine1)
        
        //Add brand tags
        var brandTagPositionHeight: CGFloat = 160
        let hashTagLabel = UILabel(frame: CGRectMake(5, heightInWhiteView + brandTagPositionHeight, 60, 40))
        hashTagLabel.text = "Brand"
        hashTagLabel.font = UIFont(name: "HelveticaNeue", size: 16)
        whiteView.addSubview(hashTagLabel)
        
        brandTag = TLTagsControl(frame: CGRectMake(62, heightInWhiteView + brandTagPositionHeight + 5, self.view.bounds.size.width - 100, 30))
        brandTag.mode = TLTagsControlMode.List
        whiteView.addSubview(brandTag)
        var brandAddButt = UIButton(frame: CGRectMake(self.view.bounds.size.width - 45, heightInWhiteView + brandTagPositionHeight + 5, 40, 30))
        brandAddButt.backgroundColor = UIColor.clearColor()
        brandAddButt.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 14)
        brandAddButt.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        brandAddButt.setTitle("Add", forState: .Normal)
        brandAddButt.addTarget(self, action: "brandButtTapped", forControlEvents: UIControlEvents.TouchUpInside)
        whiteView.addSubview(brandAddButt)
        
        var grayLine2 = UILabel(frame: CGRectMake(0, brandTag.frame.origin.y + brandTag.frame.height + 5, self.view.frame.width, 0.3))
        grayLine2.backgroundColor = UIColor.lightGrayColor()
        whiteView.addSubview(grayLine2)
        
        
        //Add tags
        var tagPositionHeight: CGFloat = 203
        var tagLabel = UILabel(frame: CGRectMake(5, heightInWhiteView + tagPositionHeight, 30, 30))
        tagLabel.text = "#"
        tagLabel.font = UIFont(name: "HelveticaNeue", size: 25)
        whiteView.addSubview(tagLabel)
        miscTag = TLTagsControl(frame: CGRectMake(40, heightInWhiteView + tagPositionHeight + 2, self.view.bounds.size.width - 25, 30))
        whiteView.addSubview(miscTag)
        
        var grayLine3 = UILabel(frame: CGRectMake(0, miscTag.frame.origin.y + miscTag.frame.height + 5, self.view.frame.width, 0.3))
        grayLine3.backgroundColor = UIColor.lightGrayColor()
        whiteView.addSubview(grayLine3)
        
        //Season info
        var seasonPositionHeight: CGFloat = 246
        let seasonArray: NSArray = ["Spring", "Summer", "Fall", "Winter"]
        seasonSegment = UISegmentedControl(items: seasonArray as [AnyObject])
        seasonSegment.tintColor = UIColor.lightGrayColor()
        seasonSegment.frame = CGRectMake(45, heightInWhiteView + seasonPositionHeight + 3, self.view.bounds.size.width - 50, 27)
        whiteView.addSubview(seasonSegment)
        /*
        var seasonTextF = UITextField(frame: CGRectMake(40, heightInWhiteView + seasonPositionHeight, self.view.bounds.size.width - 45, 30))
        seasonTextF.font = UIFont(name: "HelveticaNeue", size: 18)
        seasonTextF.delegate = self
        seasonTextF.placeholder = "Enter season"
        //seasonTextF.backgroundColor = UIColor.grayColor()
        whiteView.addSubview(seasonTextF)
        */
        var calendarIconImg = UIImage(named: "calendarIcon")
        var calendarIconView = UIImageView(image: calendarIconImg)
        calendarIconView.frame = CGRectMake(3, heightInWhiteView + seasonPositionHeight - 1, 28, 30)
        whiteView.addSubview(calendarIconView)
        
        var grayLine4 = UILabel(frame: CGRectMake(0, seasonSegment.frame.origin.y + seasonSegment.frame.height + 7, self.view.frame.width, 0.3))
        grayLine4.backgroundColor = UIColor.lightGrayColor()
        whiteView.addSubview(grayLine4)
        
        
        //Add post to public button
        var postToPublicBtn = UIButton(frame: CGRectMake(10, seasonSegment.frame.origin.y + seasonSegment.frame.size.height + 15, self.view.frame.width - 20, 30))
        postToPublicBtn.setTitle("p  o  s  t", forState: .Normal)
        postToPublicBtn.titleLabel!.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 20)
        postToPublicBtn.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        postToPublicBtn.layer.borderColor = UIColor(red: 0, green: 0.698, blue: 0.792, alpha: 1).CGColor
        postToPublicBtn.layer.borderWidth = 1.0
        postToPublicBtn.layer.cornerRadius = 3.0
        postToPublicBtn.addTarget(self, action: "postToPublic", forControlEvents: UIControlEvents.TouchUpInside)
        whiteView.addSubview(postToPublicBtn)
        
        
        //Add delete photo button
        var deleteBtn = UIButton(frame: CGRectMake(10, postToPublicBtn.frame.origin.y + postToPublicBtn.frame.size.height + 10, self.view.frame.width - 20, 30))
        deleteBtn.setTitle("d  e  l  e  t  e", forState: .Normal)
        deleteBtn.titleLabel!.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 20)
        deleteBtn.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        deleteBtn.layer.borderColor = UIColor.redColor().CGColor
        deleteBtn.layer.borderWidth = 1.0
        deleteBtn.layer.cornerRadius = 3.0
        deleteBtn.addTarget(self, action: "deletePhoto", forControlEvents: UIControlEvents.TouchUpInside)
        whiteView.addSubview(deleteBtn)
        
        
        var whiteViewHeightY: CGFloat = deleteBtn.frame.origin.y + deleteBtn.frame.height + 10
        whiteView.frame = CGRectMake(whiteView.frame.origin.x, whiteView.frame.origin.y - grayLine.frame.origin.y - 10, whiteView.frame.size.width, whiteViewHeightY)
        scrollview.contentSize = CGSize (width: scrollview.frame.size.width, height: whiteView.frame.origin.y + whiteView.frame.size.height)
        /*
        var grayLine4 = UILabel(frame: CGRectMake(0, seasonTextF.frame.origin.y + seasonTextF.frame.height + 5, self.view.frame.width, 0.3))
        grayLine4.backgroundColor = UIColor.lightGrayColor()
        whiteView.addSubview(grayLine4)
        */
        
        
        // Unwrap the current object object
        if let object = currentObject {
            if let value = object["imageText"] as? String {
                topsLabel.text = value
                
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
                clothesDesciptionTextView.text = currentClothesDescription
            }
            if let currentBrandTag = object["brandTag"] as? NSArray{
                brandTag.tags = currentBrandTag as? NSMutableArray
                brandTag.reloadTagSubviews()
            }
            if let currentMiscTag = object["Tags"] as? NSArray{
                miscTag.tags = currentMiscTag as? NSMutableArray
                miscTag.reloadTagSubviews()
                
            }
            if let currentSeason = object["season"] as? NSString{
                if currentSeason == "Spring"{
                    seasonSegment.selectedSegmentIndex = 0
                }else if currentSeason == "Summer"{
                    seasonSegment.selectedSegmentIndex = 1
                    
                }else if currentSeason == "Fall"{
                    seasonSegment.selectedSegmentIndex = 2
                    
                }else if currentSeason == "Winter"{
                    seasonSegment.selectedSegmentIndex = 3
                    
                }else{
                    
                }
            }
            if let currentObjectId = object.objectId{
                self.currentObjectId = "\(currentObjectId)"
            }
        }
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.lastVisibleView = scrollview
        self.visibleMargin = 0.0
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
        self.view.addSubview(checkButton)
        
        
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
        
        let ud = NSUserDefaults.standardUserDefaults()
        var addedBrand: NSString = ud.objectForKey("brandNameKey") as! NSString
        if addedBrand == "BRAND"{
            println("no added brand")
        }else{
            var brandArrayContains: Bool = brandTag.tags.containsObject(addedBrand)
            if brandArrayContains == false{
                var currentBrandArray = brandTag.tags
                currentBrandArray.addObject(addedBrand)
                brandTag.tags = currentBrandArray
                brandTag.reloadTagSubviews()
            }
        }
 
    }
    
    func addingScrollView(){
        
        
        self.view.addSubview(scrollview)
        self.view.bringSubviewToFront(quitButton)
        self.view.bringSubviewToFront(checkButton)
    }
    
    func checkButtonPressed(){
        self.view.resignFirstResponder()
        self.showActivityIndicatory(self.view)
        
        var newClothesName = topsLabel.text
        var newClothesDescrption = clothesDesciptionTextView.text
        var newBrandTags = brandTag.tags
        var newMiscTags = miscTag.tags
        
        var aggregateTagArray = (newBrandTags.copy() as! [String]) + (newMiscTags.copy() as! [String])
        
        
        var newSeason: NSString!
        var newSeasonInt = seasonSegment.selectedSegmentIndex
        if newSeasonInt == 0{
            newSeason = "Spring"
        }else if newSeasonInt == 1{
            newSeason = "Summer"
        }else if newSeasonInt == 2{
            newSeason = "Fall"
        }else if newSeasonInt == 3{
            newSeason = "Winter"
        }else{
            newSeason = ""
        }
        
        let user = PFUser.currentUser()
        
        //user["displayName"]
        
        var userFileObj = PFObject (withoutDataWithClassName: "Tops", objectId: "\(currentObjectId)")
        userFileObj["imageText"] = newClothesName
        userFileObj["clothesExplanation"] = newClothesDescrption
        userFileObj["brandTag"] = newBrandTags
        userFileObj["Tags"] = newMiscTags
        userFileObj["season"] = newSeason
        userFileObj["searchTag"] = " ".join(aggregateTagArray)
        
        userFileObj.saveInBackgroundWithBlock({(success: Bool, error: NSError?) -> Void in
            if error == nil{
                println("success")
                self.hideActivityIndicator(self.view)
                self.quitButtonPressed()
                
            }else{
                println("failure")
                var errorMessage:String = error!.userInfo!["error"]as! String
                let alert = SCLAlertView()
                alert.showError("Error", subTitle:"An error occured. \(errorMessage)", closeButtonTitle:"Ok")
                self.hideActivityIndicator(self.view)
                
                
            }
        })
        
        
        
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
                self.checkButton.alpha = 0.0
                
            }, completion: {(Bool) -> Void in
                self.performSegueWithIdentifier("detailVCtoTopsVC", sender: self)
        })
        
        
        
        println("quitbutPressed")
        
    }
    
    
    func postToPublic() {
        let alert = SCLAlertView()
        alert.addButton("Post!", target:self, selector:Selector("postingProcess"))
        alert.showNotice("Confirmation", subTitle:"Do you want to post this photo?", closeButtonTitle:"Cancel")
        
    }
    
    func postingProcess(){
        self.showActivityIndicatory(self.view)
        
        //Posted images are in "Posts" class of parse
        var posts = PFObject(className: "Posts")
        let votesNum: NSNumber = 0
        posts["votes"] = votesNum
        posts["imageText"] = topsLabel.text
        posts["uploader"] = PFUser.currentUser()
        posts.saveInBackgroundWithBlock({
            (success: Bool, error: NSError?) -> Void in
            
            if error == nil {
                
                var imageData = UIImageJPEGRepresentation(self.imageView.image, 1.0)
                var parseImageFile = PFFile(name: "uploaded_image.jpg", data: imageData)
                posts["imageFile"] = parseImageFile
                posts.saveInBackgroundWithBlock({
                    (success: Bool, error: NSError?) -> Void in
                    
                    if error == nil {
                        
                        println("finished")
                        let successAlert = SCLAlertView()
                        successAlert.showSuccess("Posted", subTitle:"The photo was uploaded successfully!", closeButtonTitle:"Close")
                        self.hideActivityIndicator(self.view)
                        
                        
                    }else {
                        
                        println(error)
                        let errorAlert = SCLAlertView()
                        errorAlert.showError("Error", subTitle:"An error occured.", closeButtonTitle:"Close")
                        self.hideActivityIndicator(self.view)
                        
                        
                    }
                    
                    
                })
                
                
            }else {
                println(error)
                let errorAlert = SCLAlertView()
                errorAlert.showError("Error", subTitle:"An error occured.", closeButtonTitle:"Close")
                self.hideActivityIndicator(self.view)
                
            }
            
        })
        
        
        
        
        
    }
    
    func deletePhoto() {
        let alert = SCLAlertView()
        alert.addButton("Delete", target:self, selector:Selector("deletePhotoProcess"))
        alert.showWarning("Confirmation", subTitle:"Are you sure you want to delete the photo?", closeButtonTitle:"Cancel")
        
    }
    
    func deletePhotoProcess(){
        //Choosing which object in Parse to delete
        var selectedObjId = currentObject?.objectId
        var object = PFObject(withoutDataWithClassName: "Tops", objectId: selectedObjId)
        
        self.showActivityIndicatory(self.view)
        
        object.deleteInBackgroundWithBlock({
            (success: Bool, error: NSError?) -> Void in
            
            if error == nil {
                //Hide activity indicator and go back to collection view when done deleting
                self.hideActivityIndicator(self.view)
                self.quitButtonPressed()
                
            }else {
                
                println(error)
                //Show alert that error occured
                let errorAlert = SCLAlertView()
                errorAlert.showError("Error", subTitle:"An error occured.", closeButtonTitle:"Close")
                self.hideActivityIndicator(self.view)
                
            }
            
            
        })
        
        
        
    }
    
    func brandButtTapped(){
        println("brandBtnTapped")
        let ud = NSUserDefaults.standardUserDefaults()
        self.performSegueWithIdentifier("detailVCtoBrandSearchSegue", sender: self)
        
        
        
    }
    
    override func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true;
        
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
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
