//
//  UploadViewController.swift
//  Stylist
//
//  Created by Kento Katsumata on 2015/06/29.
//  Copyright (c) 2015年 xxx. All rights reserved.
//

import UIKit
import Parse

class UploadViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//まずは繋げるで～
    @IBOutlet weak var uploadPreviewImageView: UIImageView!
    @IBOutlet weak var uploadMessage: UITextField!
    @IBOutlet weak var uploadImageText: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func uploadImageFromSource(sender: AnyObject) {
        
        var imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        imagePicker.allowsEditing = false
        self.presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        uploadPreviewImageView.image = image
        self.dismissViewControllerAnimated(true, completion: nil)
        
        uploadImageText.titleLabel?.text = "Retake Photo"
    }
            //ImageViewに入ってるものをパースに飛んでけー！
    @IBAction func uploadButton(sender: AnyObject) {
        var imageText = uploadMessage.text
        
        if uploadPreviewImageView.image == nil {
            //image is not included alert user
            println("Image not uploaded")
        }else {
            
            var posts = PFObject(className: "Posts")
            posts["imageText"] = imageText
            posts["uploader"] = PFUser.currentUser()
            posts.saveInBackgroundWithBlock({
                (success: Bool, error: NSError?) -> Void in
                
                if error == nil {
                  //保存するざます
                    
                    var imageData = UIImagePNGRepresentation(self.uploadPreviewImageView.image)
                    //パースファイルを作る
                    var parseImageFile = PFFile(name: "uploaded_image.png", data: imageData)
                    posts["imageFile"] = parseImageFile
                    posts.saveInBackgroundWithBlock({
                        (success: Bool, error: NSError?) -> Void in
                        
                        if error == nil {
                            //よし終わりだからホームへ帰宅
                            println("データ飛んでったぞー　byケンティーの守り神")
                            self.performSegueWithIdentifier("goHomeFromUpload", sender: self)
                            
                        }else {
                            
                            println(error)
                        }
                        
                        
                    })
                    
                    
                }else {
                    println(error)
                    
                }
                
            })
            
            
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
