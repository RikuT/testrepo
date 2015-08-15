//
//  ProfilePicViewController.swift
//
//
//  Created by 田畑リク on 2015/07/27.
//
//

import UIKit
import Parse

//TODO LIST************
//Change buttons

class ProfilePicViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    
    // ImageView that will show the picked image (from Camera or Photo library)
    @IBOutlet weak var imagePicked: UIImageView!
    @IBOutlet weak var cameraBtn: UIButton!
    @IBOutlet weak var libraryBtn: UIButton!
    @IBOutlet weak var updateBtn: UIButton!
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ud = NSUserDefaults.standardUserDefaults()
        var currentImgObj: AnyObject? = ud.objectForKey("currentProfileImgKey")
        var currentImgData = currentImgObj as! NSData
        var currentImage = UIImage(data: currentImgData)
        imagePicked.image = currentImage
        ud.removeObjectForKey("currentProfileImgKey")
        
        cameraBtn.layer.cornerRadius = 5.0
        libraryBtn.layer.cornerRadius = 5.0
        updateBtn.layer.cornerRadius = 5.0

    }
    
    
    // OPEN CAMERA BUTTON
    @IBAction func openCameraButton(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            var imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera;
            imagePicker.allowsEditing = true
            
            
            
            /*
            
            //Create camera overlay for square photo
            let pickerFrame = CGRectMake(0, UIApplication.sharedApplication().statusBarFrame.size.height, imagePicker.view.bounds.width, imagePicker.view.bounds.height - imagePicker.navigationBar.bounds.size.height - imagePicker.toolbar.bounds.size.height)
            
            //For changing the location and the size of the camera
            var cameraBezel: CGFloat = 20
            var cameraFrame = self.view.bounds.width - cameraBezel
            //May have to change this for different device
            var cameraPosition = pickerFrame.height //- 30
            let squareFrame = CGRectMake(cameraBezel/2, cameraPosition / 2 - cameraFrame/2, cameraFrame, cameraFrame)
            UIGraphicsBeginImageContext(pickerFrame.size)
            
            let context = UIGraphicsGetCurrentContext()
            CGContextSaveGState(context)
            CGContextAddRect(context, CGContextGetClipBoundingBox(context))
            CGContextMoveToPoint(context, squareFrame.origin.x, squareFrame.origin.y)
            CGContextAddLineToPoint(context, squareFrame.origin.x + squareFrame.width, squareFrame.origin.y)
            CGContextAddLineToPoint(context, squareFrame.origin.x + squareFrame.width, squareFrame.origin.y + squareFrame.size.height)
            CGContextAddLineToPoint(context, squareFrame.origin.x, squareFrame.origin.y + squareFrame.size.height)
            CGContextAddLineToPoint(context, squareFrame.origin.x, squareFrame.origin.y)
            CGContextEOClip(context)
            CGContextMoveToPoint(context, pickerFrame.origin.x, pickerFrame.origin.y)
            CGContextSetRGBFillColor(context, 0, 0, 0, 1)
            CGContextFillRect(context, pickerFrame)
            CGContextRestoreGState(context)
            
            let overlayImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext();
            
            let overlayView = UIImageView(frame: pickerFrame)
            overlayView.image = overlayImage
            imagePicker.cameraOverlayView = overlayView
            
            */
            
            
            
            
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
        
        
        
        
    }
    
    
    // OPEN PHOTO LIBRARY BUTTON
    @IBAction func openPhotoLibraryButton(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            var imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
            imagePicker.allowsEditing = true
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    // IMAGE PICKER DELEGATE
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        imagePicked.image = image
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    //ALERT ADD　注意
    @IBAction func uploadProfilePic() {
        println("saveButt")
        let ud = NSUserDefaults.standardUserDefaults()
        var tempProfilePict = self.imagePicked.image
        ud.setObject(UIImageJPEGRepresentation(tempProfilePict, 0.6), forKey: "tempProfilePictKey")
        self.performSegueWithIdentifier("updateProfilePicVCtoUserSettingVC", sender: self)
        
        /*
        if imagePicked.image == nil {
        //image is not included alert user
        println("Image not uploaded")
        }else {
        var imageData = UIImageJPEGRepresentation(self.imagePicked.image, 0.6)
        var parseImageFile = PFFile(name: "uploaded_image.jpg", data: imageData)
        PFUser.currentUser()?.setObject(parseImageFile, forKey: "profilePicture")
        
        PFUser.currentUser()!.saveInBackgroundWithBlock({
        (success: Bool, error: NSError?) -> Void in
        
        if error == nil {
        println("Uploaded successfully")
        self.performSegueWithIdentifier("updateProfilePicVCtoUserSettingVC", sender: self)
        
        }
        else {
        println(error)
        }
        })
        
        }
        */
    }
    
    @IBAction func goBackButt() {
        self.performSegueWithIdentifier("updateProfilePicVCtoUserSettingVC", sender: self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}






