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
    
    var updateObject : PFObject?
    
    // The save button
    @IBAction func saveButton(sender: AnyObject) {
        
        // Use the sent country object or create a new country PFObject
        if let updateObjectTest = currentObject as PFObject? {
            updateObject = currentObject! as PFObject
        } else {
            updateObject = PFObject(className:"Tops")
        }
        
        // Update the object
        if let updateObject = updateObject {
            
            updateObject["imageText"] = topsLabel.text
            
            // Create a string of text that is used by search capabilites
            var searchText = (topsLabel.text).lowercaseString
            updateObject["searchText"] = searchText
            
            // Update the record ACL such that the new record is only visible to the current user
            updateObject.ACL = PFACL(user: PFUser.currentUser()!)
            
            // Save the data back to the server in a background task
            updateObject.save()
        }
        
        // Return to table view
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
