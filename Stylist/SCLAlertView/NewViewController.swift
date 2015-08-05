//
//  NewViewController.swift
//  Stylist
//
//  Created by Kenty on 2015/07/28.
//  Copyright (c) 2015年 xxx. All rights reserved.
//

import Parse

class NewViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    var objectToSend : PFObject?
    var likes:[NSIndexPath:Int] = [:]
    var votes = [PFObject]()
    // Connection to the search bar
    
    
    // Connection to the collection view
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()


        
        let query = PFQuery(className: "Posts")
        query.includeKey("uploader")
        query.findObjectsInBackgroundWithBlock{(question:[AnyObject]?,error:NSError?) -> Void in
            
            if error == nil
            {
                if let allQuestion = question as? [PFObject]
                {
                    self.votes = allQuestion
                    self.collectionView.reloadData()
                }
            }
        }
        
        
        // Wire up search bar delegate so that we can react to button selections
        
        // Resize size of collection view items in grid so that we achieve 3 boxes across
        
        loadCollectionViewData()
    }
    
    /*
    ==========================================================================================
    Ensure data within the collection view is updated when ever it is displayed
    ==========================================================================================
    */
    
    // Load data into the collectionView when the view appears
    override func viewDidAppear(animated: Bool) {
        loadCollectionViewData()
    }
    
    /*
    ==========================================================================================
    Fetch data from the Parse platform
    ==========================================================================================
    */
    
    func loadCollectionViewData() {
        // Build a parse query object
    }
    
    /*
    ==========================================================================================
    UICollectionView protocol required methods
    ==========================================================================================
    */
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.votes.count
    }
    
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("newview", forIndexPath: indexPath) as! NewCollectionViewCell
        let item = self.votes[indexPath.row]

        
        
        
        
        // Display "initial" flag image
        var initialThumbnail = UIImage(named: "question")
        cell.postsImageView.image = initialThumbnail
        
        // Display the country name
        if let user = item["uploader"] as? PFUser{
            println(user)
            item.fetchIfNeeded()
            println(user.username)
            cell.userName!.text = user.username
            
            var profileImgFile = user["profilePicture"] as! PFFile
            cell.profileImageView.file = profileImgFile
            cell.profileImageView.loadInBackground { image, error in
                if error == nil {
                    cell.profileImageView.image = image
                }
            }
            
            var sexInt = user["sex"] as! Int
            var sex: NSString!
            if sexInt == 0 {
                sex = "M"
            }else if sexInt == 1{
                sex = "F"
            }
            
            var height = user["height"] as! Int
            cell.heightSexLabel.text = "\(sex) \(height)cm"
        
            
            
        }

/*
        if let profile = item["uploader"] as? PFObject,
            profileImageFile = profile["profilePicture"] as? PFFile {
                cell.profileImageView.file = profileImageFile
                cell.profileImageView.loadInBackground { image, error in
                    if error == nil {
                        cell.profileImageView.image = image
                    }
                }
        }
        */
        if let votesValue = item["votes"] as? Int
        {
            cell.votesLabel?.text = "\(votesValue)"
        }
        
        // Fetch final flag image - if it exists
        if let value = item["imageFile"] as? PFFile {
            println("Value \(value)") 
            cell.postsImageView.file = value
            cell.postsImageView.loadInBackground({ (image: UIImage?, error: NSError?) -> Void in
                if error != nil {
                    cell.postsImageView.image = image
                }
            })
        }
        
        return cell
    }
    
    /*
    ==========================================================================================
    Segue methods
    ==========================================================================================
    */
    
    func likeButton(indexPath:NSIndexPath)
    {
        let cell = self.collectionView.cellForItemAtIndexPath(indexPath) as! NewCollectionViewCell
        
        let object = self.votes[indexPath.row]
        
        if let likes = object["votes"] as? Int
        {
            object["votes"] = likes + 1
            object.saveInBackgroundWithBlock{ (success:Bool,error:NSError?) -> Void in
                println("Data saved")
                
            }
            cell.votesLabel?.text = "\(likes + 1)"
                    }
        else
        {
            object["votes"] = 1
            object.saveInBackgroundWithBlock{ (success:Bool,error:NSError?) -> Void in
                println("Data saved")
            }
            cell.votesLabel?.text = "1"
        }
     
    }
    
    
    // Process collectionView cell selection
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        objectToSend = votes[indexPath.section]
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
 
    
    
       /*
    ==========================================================================================
    Process memory issues
    To be completed
    ==========================================================================================
    */
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}