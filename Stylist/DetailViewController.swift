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

class DetailViewController: UIViewController, UINavigationControllerDelegate {
    
    // Container to store the view table selected object
    var currentObject : PFObject?
    
    // Some text fields
    @IBOutlet weak var topsLabel: UITextField!
    @IBOutlet weak var topsImageView: PFImageView!
    
    //For showing activity indicator
    var container: UIView = UIView()
    var loadingView: UIView = UIView()
    var actInd: UIActivityIndicatorView = UIActivityIndicatorView()


    var updateObject : PFObject?
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true;
        
    }
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

            print("saved")
            self.navigationController?.popViewControllerAnimated(true)

        }
      //  self.navigationController?.popViewControllerAnimated(true)

            }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        
        // Unwrap the current object object
        if let object = currentObject {
            if let value = object["imageText"] as? String {
                topsLabel.text = value

            
            // Display standard question image
            var initialThumbnail = UIImage(named: "question")
            topsImageView.image = initialThumbnail
            
            // Replace question image if an image exists on the parse platform
            if let thumbnail = object["imageFile"] as? PFFile {
                topsImageView.file = thumbnail
                topsImageView.loadInBackground { (image: UIImage?, error: NSError?) -> Void in
                    println("test")
                }
            }
        }
    }
}
    
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
                
                var imageData = UIImageJPEGRepresentation(self.topsImageView.image, 1.0)
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
