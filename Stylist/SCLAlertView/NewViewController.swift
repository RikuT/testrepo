//
//  NewViewController.swift
//  Stylist
//
//  Created by Kenty on 2015/07/28.
//  Copyright (c) 2015年 xxx. All rights reserved.
//

import Parse

class NewViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate {
    
    
    var objectToSend : PFObject?
    var likes:[NSIndexPath:Int] = [:]
    var votes = [PFObject]()
    // Connection to the search bar
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    // Connection to the collection view
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let query = PFQuery(className: "Posts")
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
        // Display the country name
        
        if let value = item["imageText"] as? String {
            cell.postsLabel.text = value
        }
        
        // Display "initial" flag image
        var initialThumbnail = UIImage(named: "question")
        cell.postsImageView.image = initialThumbnail
        
        cell.complition = {
            self.likeButton(indexPath)
        }
        
        if let votesValue = item["votes"] as? Int
        {
            cell.votesLabel?.text = "\(votesValue)"
        }
        
        // Fetch final flag image - if it exists
        if let value = item["imageFile"] as? PFFile {
            
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
    /*
    
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
*/
    
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