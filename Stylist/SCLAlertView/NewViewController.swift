//
//  NewViewController.swift
//  Stylist
//
//  Created by Kenty on 2015/07/28.
//  Copyright (c) 2015年 xxx. All rights reserved.
//

import Parse

var posts = [PFObject]()


class NewViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate {

    var parseObject = PFObject(className: "Posts")

    var objectToSend : PFObject?
    
    // Connection to the search bar
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    // Connection to the collection view
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Wire up search bar delegate so that we can react to button selections
        searchBar.delegate = self
        
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
        var query = PFQuery(className:"Posts")
        
        
        // Check to see if there is a search term
        if searchBar.text != "" {
            query.whereKey("imageText", containsString: searchBar.text)
        }
        
        // Fetch data from the parse platform
        query.orderByDescending("createdAt")
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            println("objects: \(objects)")
            println("error\(error)")
            
            // The find succeeded now rocess the found objects into the countries array
            if error == nil {
                
                // Clear existing country data
                posts.removeAll(keepCapacity: false)
                
                // Add country objects to our array
                if let objects = objects as? [PFObject] {
                    posts = Array(objects.generate())
                }
                
                // reload our data into the collection view
                self.collectionView.reloadData()
                
            } else {
                // Log details of the failure
                println("Error: \(error!) \(error!.userInfo!)")
            }
        }
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
        return posts.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("newview", forIndexPath: indexPath) as! NewCollectionViewCell
        //cell.backgroundColor = UIColor.blueColor()
        
        
        // Display the country name
        if let value = posts[indexPath.row]["imageText"] as? String {
            cell.postsLabel.text = value
            println("it should be there")
            
        }
        
        // Display "initial" flag image
        var initialThumbnail = UIImage(named: "question")
        cell.postsImageView.image = initialThumbnail
        
        /*
        var imageWidth = Float (cell.topsImageView.image!.size.width)
        var imageHeight = Float (cell.topsImageView.image!.size.height)
        var imageAspect = imageHeight / imageWidth
        var imageViewHeight = Float (cell.frame.size.width) * imageAspect
        cell.topsImageView.frame = CGRectMake(0, 0, cell.frame.size.width , CGFloat(imageViewHeight))
        */
        
        // Fetch final flag image - if it exists
        if let value = posts[indexPath.row]["imageFile"] as? PFFile {
            
            cell.postsImageView.file = value
            cell.postsImageView.loadInBackground({ (image: UIImage?, error: NSError?) -> Void in
                
                if error != nil {
                    
                    
                }
                
            })
            
            //	let finalImage = tops[indexPath.row]["tops"] as? PFFile
            
        }
        
 
            if let votes = parseObject.objectForKey("votes") as? Int {
                cell.votesLabel?.text = "\(votes) votes"
            }
            else
            {
                cell.votesLabel?.text = "0 votes"
            }
        return cell

        }


    
    /*
    ==========================================================================================
    Segue methods
    ==========================================================================================
    */
    
    // Process collectionView cell selection
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        objectToSend = posts[indexPath.row]
        performSegueWithIdentifier("showImage", sender: self)
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showImage" {
            
            let detailsVc = segue.destinationViewController as! DetailViewController
            detailsVc.currentObject = objectToSend
        }
    }
    
    
    /*
    ==========================================================================================
    Process Search Bar interaction
    ==========================================================================================
    */
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        
        // Dismiss the keyboard
        searchBar.resignFirstResponder()
        
        // Reload of table data
        self.loadCollectionViewData()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        // Dismiss the keyboard
        searchBar.resignFirstResponder()
        
        // Reload of table data
        self.loadCollectionViewData()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        
        // Clear any search criteria
        searchBar.text = ""
        
        // Dismiss the keyboard
        searchBar.resignFirstResponder()
        
        // Reload of table data
        self.loadCollectionViewData()
    }
    
    @IBAction func finishButt() {
        let ud = NSUserDefaults.standardUserDefaults()
        var fromUploadImagePreview = ud.boolForKey("originFromUploadOfImagePreviewVCKey")
        ud.removeObjectForKey("originFromUploadOfImagePreviewVCKey")
        if fromUploadImagePreview == true{
            self.performSegueWithIdentifier("topsVCtoVCnotUnwind", sender: self)
        }else{
            println("finishTapped")
            self.performSegueWithIdentifier("topsVCtoVC", sender: self)
        }
    }
    
    
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