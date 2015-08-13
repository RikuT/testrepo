//
//  TagViewController.swift
//  Stylist
//
//  Created by 田畑リク on 2015/08/10.
//  Copyright (c) 2015年 xxx. All rights reserved.
//

import Parse

class TagViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    
    var objectToSend : PFObject?
    var object = [PFObject]()
    var pictObject = [PFObject]()
    
    // Connection to the search bar
    
    
    // Connection to the collection view
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let query = PFQuery(className: "TagTrend")
        
        //Getting 10 popular tags
        
        query.orderByDescending("NumberOfPosts")
        query.limit = 10
        
        query.findObjectsInBackgroundWithBlock{(question:[AnyObject]?,error:NSError?) -> Void in
            var tagArray = NSMutableArray()
            if error == nil
            {
                if let allQuestion = question as? [PFObject]
                {
                    self.object = allQuestion
                    self.collectionView.reloadData()
                    
                    if self.object.count < 10{
                        println("no enough post")
                    }else{
                    for var i = 0; i < 10; ++i{
                        var tagObj = self.object[i]
                        if let tagName = tagObj["TagName"] as? String{
                            tagArray.addObject(tagName)
                        }
                        }
                        
                        
                    }
                    
                    var pictQuery = PFQuery(className: "Posts")
                    pictQuery.orderByDescending("votes")
                    let pictQuery1 = PFQuery(className: "Posts")
                    let pictQuery2 = PFQuery(className: "Posts")
                    let pictQuery3 = PFQuery(className: "Posts")
                    let pictQuery4 = PFQuery(className: "Posts")
                    let pictQuery5 = PFQuery(className: "Posts")
                    let pictQuery6 = PFQuery(className: "Posts")
                    let pictQuery7 = PFQuery(className: "Posts")
                    let pictQuery8 = PFQuery(className: "Posts")
                    let pictQuery9 = PFQuery(className: "Posts")
                    let pictQuery10 = PFQuery(className: "Posts")
                    /*
                    pictQuery1.limit = 2
                    pictQuery2.limit = 2
                    pictQuery3.limit = 2
                    pictQuery4.limit = 2
                    pictQuery5.limit = 2
                    pictQuery6.limit = 2
                    pictQuery7.limit = 2
                    pictQuery8.limit = 2
                    pictQuery9.limit = 2
                    pictQuery10.limit = 2
                    
                    */
                    
                    pictQuery1.whereKey("Tags", equalTo: tagArray[0])
                    pictQuery2.whereKey("Tags", equalTo: tagArray[1])
                    pictQuery3.whereKey("Tags", equalTo: tagArray[2])
                    pictQuery4.whereKey("Tags", equalTo: tagArray[3])
                    pictQuery5.whereKey("Tags", equalTo: tagArray[4])
                    pictQuery6.whereKey("Tags", equalTo: tagArray[5])
                    pictQuery7.whereKey("Tags", equalTo: tagArray[6])
                    pictQuery8.whereKey("Tags", equalTo: tagArray[7])
                    pictQuery9.whereKey("Tags", equalTo: tagArray[8])
                    pictQuery10.whereKey("Tags", equalTo: tagArray[9])
                    
                    pictQuery = PFQuery.orQueryWithSubqueries([pictQuery1, pictQuery2, pictQuery3, pictQuery4, pictQuery5, pictQuery6, pictQuery7, pictQuery8, pictQuery9, pictQuery10])
                    
                    pictQuery.findObjectsInBackgroundWithBlock{(picture:[AnyObject]?,error:NSError?) -> Void in
                        if error == nil
                        {
                            if let allPictures = picture as? [PFObject]{
                                self.pictObject = allPictures
                                self.collectionView.reloadData()
                            }
                            
                        }}
                    
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
        println("objNum\(object.count)")
        
        return self.object.count
    }
    
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("tagview", forIndexPath: indexPath) as! TagCollectionViewCell
        let item = self.object[indexPath.row]
        
        // Display "initial" flag image
        var initialThumbnail = UIImage(named: "question")
        cell.tagImageView.image = initialThumbnail
        cell.tagImageView2.image = initialThumbnail
        
        
        var tempPictObj = self.pictObject
        if let tagName = item["TagName"] as? String
        {
            cell.tagNameLabel?.text = "\(tagName)"

            var checkBool = false
            for var i = 0; !checkBool && i < pictObject.count; ++i{
                let pictItem = tempPictObj[i]

                if let pictTags = pictItem["Tags"] as? NSArray{
                var containTag = pictTags.containsObject(tagName)
                    if containTag == true{
                        //Stopping the for-loop
                        checkBool = true

                        if let value = pictItem["imageFile"] as? PFFile {
                            value.getDataInBackgroundWithBlock{
                                (imageData: NSData?, error: NSError?) -> Void in
                                if imageData != nil {
                                    var image = UIImage(data: imageData!)
                                    cell.tagImageView.image = image

                                    
                                
                                }else {
                                    println(error)
                                }}
                            
                        }
                        
                        //Searching the second picture
                        tempPictObj.removeAtIndex(i)
                        var checkBool2 = false
                        for var i = 0; !checkBool2 && i < tempPictObj.count; ++i{
                            let pictItem = tempPictObj[i]
                            
                            if let pictTags = pictItem["Tags"] as? NSArray{
                                var containTag = pictTags.containsObject(tagName)
                                if containTag == true{
                                    //Stopping the for-loop
                                    checkBool2 = true
                                    
                                    if let value = pictItem["imageFile"] as? PFFile {
                                        value.getDataInBackgroundWithBlock{
                                            (imageData: NSData?, error: NSError?) -> Void in
                                            if imageData != nil {
                                                var image = UIImage(data: imageData!)
                                                cell.tagImageView2.image = image
                                                
                                                
                                                
                                            }else {
                                                println(error)
                                            }}
                                        
                                    }
                                    
                                    //Searching the second picture
                                    tempPictObj.removeAtIndex(i)
                                    
                                }
                            }
                        }
                    }
                }
            }
            
            //Retrieving image that contains that certain tag
            /*
            let postsQuery = PFQuery(className: "Posts")
            println("tagname\(tagName)")
            postsQuery.whereKey("Tags", equalTo: "\(tagName)")
            //postsQuery.orderByDescending("votes")
            postsQuery.limit = 2
            
            postsQuery.findObjectsInBackgroundWithBlock{(post:[AnyObject]?,error:NSError?) -> Void in
            if error == nil
            {
            var numOfPosts = postsQuery.countObjects()
            
            if numOfPosts == 2{
            println("two posts")
            if let twoPosts = post as? [PFObject]
            {
            let post1 = twoPosts[0]
            if let value = post1["imageFile"] as? PFFile {
            println("Value \(value)")
            cell.tagImageView.file = value
            cell.tagImageView.loadInBackground({ (image: UIImage?, error: NSError?) -> Void in
            if error != nil {
            cell.tagImageView.image = image
            }
            })
            }
            
            let post2 = twoPosts[1]
            if let value2 = post2["imageFile"] as? PFFile {
            println("Value \(value2)")
            cell.tagImageView2.file = value2
            cell.tagImageView2.loadInBackground({ (image2: UIImage?, error: NSError?) -> Void in
            if error != nil {
            cell.tagImageView2.image = image2
            }
            })
            }
            
            }}
            else if numOfPosts == 1{
            println("one post")
            if let twoPosts = post as? [PFObject]
            {
            let post1 = twoPosts[0]
            if let value = post1["imageFile"] as? PFFile {
            value.getDataInBackgroundWithBlock{
            (imageData: NSData?, error: NSError?) -> Void in
            if imageData != nil {
            var image = UIImage(data: imageData!)
            cell.tagImageView.image = image
            }else {
            println(error)
            }}
            
            }
            
            }}
            else{
            println("no post")
            }
            
            
            }
            }
            
            */
            
            
            
            
        }
        
        
        
        
        /*
        // Fetch final flag image - if it exists
        if let value = item["imageFile"] as? PFFile {
        println("Value \(value)")
        cell.postsImageView.file = value
        cell.postsImageView.loadInBackground({ (image: UIImage?, error: NSError?) -> Void in
        if error != nil {
        cell.postsImageView.image = image
        }
        })
        }*/
        
        return cell
    }
    
    /*
    ==========================================================================================
    Segue methods
    ==========================================================================================
    */
    
    
    // Process collectionView cell selection
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        objectToSend = object[indexPath.section]
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

