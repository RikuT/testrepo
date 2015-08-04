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
    var blurView: UIVisualEffectView!
    var whiteView: UIView!
    
    
    var updateObject : PFObject?
    
    
    // The save button
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        
        let ud = NSUserDefaults.standardUserDefaults()
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



        
        scrollview = UIScrollView(frame: CGRectMake(0, self.view.frame.size.height / 2, self.view.frame.size.width, self.view.frame.size.height / 2))
        scrollview.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height - 55 )
        ud.setObject("BRAND", forKey: "brandNameKey")
        //    brandArray = [NSMutableArray array];
        let screenRect = UIScreen.mainScreen().bounds
        

        
        
        //Change textfield design over here
        whiteView = UIView(frame: CGRectMake(0, self.view.frame.height / 2, self.view.frame.width, scrollview.contentSize.height - ((self.view.frame.height - 60) / 2)))
        whiteView.backgroundColor = UIColor.whiteColor()
        scrollview.addSubview(whiteView)
        
        
        
        
        var heightInWhiteView: CGFloat = -5

        topsLabel = UITextField(frame: CGRectMake(40, heightInWhiteView + 15, self.view.bounds.size.width - 60, 30))
        //topsLabel.borderStyle = UITextBorderStyle.Bezel
    
        topsLabel.placeholder = "Add clothes name"
        topsLabel.font = UIFont(name: "HelveticaNeue", size: 16)
        topsLabel.delegate = self
        whiteView.addSubview(topsLabel)
        
        var grayLine = UILabel(frame: CGRectMake(0, heightInWhiteView + 15 + 30 + 5, self.view.frame.width, 0.3))
        grayLine.backgroundColor = UIColor.lightGrayColor()
        whiteView.addSubview(grayLine)

        
        //Textview for clothes description
        var textViewPositionHeight: CGFloat = 60
        clothesDesciptionTextView = UITextView(frame: CGRectMake(40, heightInWhiteView + textViewPositionHeight, self.view.frame.size.width - 45, 90))
        clothesDesciptionTextView.font = UIFont(name: "HelveticaNeue", size: 18)
        clothesDesciptionTextView.backgroundColor = UIColor.clearColor()
        //clothesDesciptionTextView.text = textViewPlaceHolder
        clothesDesciptionTextView.textColor = UIColor.lightGrayColor()
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
        
        var brandTag = TLTagsControl(frame: CGRectMake(65, heightInWhiteView + brandTagPositionHeight + 5, self.view.bounds.size.width - 150, 30))
        brandTag.mode = TLTagsControlMode.List
        whiteView.addSubview(brandTag)
        var brandAddButt = UIButton(frame: CGRectMake(self.view.bounds.size.width - 90, heightInWhiteView + brandTagPositionHeight + 5, 90, 30))
        brandAddButt.backgroundColor = UIColor.clearColor()
        brandAddButt.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 14)
        brandAddButt.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        brandAddButt.setTitle("Add brand", forState: .Normal)
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
        var miscTag = TLTagsControl(frame: CGRectMake(40, heightInWhiteView + tagPositionHeight + 2, self.view.bounds.size.width - 25, 30))
        whiteView.addSubview(miscTag)
        
        var grayLine3 = UILabel(frame: CGRectMake(0, miscTag.frame.origin.y + miscTag.frame.height + 5, self.view.frame.width, 0.3))
        grayLine3.backgroundColor = UIColor.lightGrayColor()
        whiteView.addSubview(grayLine3)
        
        //Season info
        var seasonPositionHeight: CGFloat = 246
        var seasonTextF = UITextField(frame: CGRectMake(40, heightInWhiteView + seasonPositionHeight, self.view.bounds.size.width - 45, 30))
        seasonTextF.font = UIFont(name: "HelveticaNeue", size: 18)
        seasonTextF.delegate = self
        seasonTextF.placeholder = "Enter season"
        //seasonTextF.backgroundColor = UIColor.grayColor()
        whiteView.addSubview(seasonTextF)
        var calendarIconImg = UIImage(named: "calendarIcon")
        var calendarIconView = UIImageView(image: calendarIconImg)
        calendarIconView.frame = CGRectMake(3, heightInWhiteView + seasonPositionHeight - 1, 28, 30)
        whiteView.addSubview(calendarIconView)
        
        var whiteViewHeightY: CGFloat = seasonTextF.frame.origin.y + seasonTextF.frame.height + 10
        whiteView.frame = CGRectMake(whiteView.frame.origin.x, whiteView.frame.origin.y - grayLine.frame.origin.y - 10, whiteView.frame.size.width, whiteViewHeightY)
        
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
        }
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.lastVisibleView = scrollview
    }
    
    override func viewDidAppear(animated: Bool) {
        let blurEffect: UIBlurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        blurView = UIVisualEffectView(effect: blurEffect)
        blurView.alpha = 0
        blurView.frame = self.view.frame
        self.view.addSubview(blurView)
        self.view.addSubview(imageView)
        self.view.addSubview(quitButton)


        // アニメーション処理
        UIView.animateWithDuration(NSTimeInterval(CGFloat(0.4)),
            animations: {() -> Void in
                
                // 移動先の座標を指定する.
                self.blurView.alpha = 0.8
                self.imageView.frame = CGRectMake(30, 0, self.view.frame.width - 60, self.view.frame.height - 30)
            }, completion: {(Bool) -> Void in
                self.addingScrollView()
        })
        

    }
    
    func addingScrollView(){
        
        
        self.view.addSubview(scrollview)
        self.view.bringSubviewToFront(quitButton)
    }
    
    func quitButtonPressed(){
        // アニメーション処理
        UIView.animateWithDuration(NSTimeInterval(CGFloat(0.3)),
            animations: {() -> Void in
                
                self.blurView.alpha = 0.00
                self.imageView.alpha = 0.0
                self.quitButton.alpha = 0.0
                self.scrollview.alpha = 0.0
                
            }, completion: {(Bool) -> Void in
                self.performSegueWithIdentifier("detailVCtoTopsVC", sender: self)
        })
        
        
        
        println("quitbutPressed")
        
    }
    
    
    /*
    self.uploadButton = [UIButton buttonWithType:UIButtonTypeSystem];
    int uploadButtonHeight = 50;
    int uploadButtonWidth = self.view.bounds.size.width;
    [self.uploadButton setFrame:CGRectMake(0, self.view.bounds.size.height-0-uploadButtonHeight, uploadButtonWidth, uploadButtonHeight)];
    
    [self.uploadButton setTitle:@"UPLOAD" forState:UIControlStateNormal];
    [self.uploadButton addTarget:self action:@selector(uploadImage:)forControlEvents:UIControlEventTouchDown];
    UIColor *btnColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5];
    self.uploadButton.backgroundColor = btnColor;
    [scrollview addSubview:self.uploadButton];
    
    [self.view addSubview:scrollview];
    
    UITapGestureRecognizer* tapBackground = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    [tapBackground setNumberOfTapsRequired:1];
    [self.view addGestureRecognizer:tapBackground];
    
    
    */
    
    @IBAction func postToPublic() {
        let alert = SCLAlertView()
        alert.addButton("Post!", target:self, selector:Selector("postingProcess"))
        alert.showNotice("Confirmation", subTitle:"Do you want to post this photo?", closeButtonTitle:"Cancel")
        
    }
    
    func postingProcess(){
        self.showActivityIndicatory(self.view)
        
        //Posted images are in "Posts" class of parse
        var posts = PFObject(className: "Posts")
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
    
    @IBAction func deletePhoto() {
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
                self.performSegueWithIdentifier("detailVCtoTopsVC", sender: self)
                
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
