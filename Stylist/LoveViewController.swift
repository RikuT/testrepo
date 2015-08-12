//
//  LoveViewController.swift
//  
//
//  Created by Kenty on 2015/08/12.
//
//

import Parse

class LoveViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    var objectToSend : PFObject?
    var likes:[NSIndexPath:Int] = [:]
    var votes = [PFObject]()
    // Connection to the search bar
    var collectionViewHeight: CGFloat!
    var tapCheck: Int = 0
    
    // Connection to the collection view
    
    @IBOutlet weak var collectionView: UICollectionView!
    var lastContentOffset: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // collectionView.frame = CGRectMake(0, 29, 320, 519)
        println("collectF \(self.view.frame)")
        
        let query = PFQuery(className: "Posts")
        query.includeKey("uploader")
        query.orderByDescending("votes")

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
        
        collectionViewHeight = self.view.frame.size.height - 44
        
        
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
        println("viewdidappear")
        println("collectF2 \(self.view.frame)")
        tapCheck = 1
        self.view.frame.origin.y = 0
        self.view.frame.size.height = collectionViewHeight
        
    }
    
    override func viewWillAppear(animated: Bool) {
        println("will")
        self.view.frame.origin.y = 0
        self.view.frame.size.height = collectionViewHeight
        
    }
    
    
    /*
    ==========================================================================================
    Fetch data from the Parse platform
    ==========================================================================================
    */
    
    func loadCollectionViewData() {
        // Build a parse query object
        //collectionView.frame = CGRectMake(0, 29, 320, 519)
        
        println("loadscdo")
        let ud = NSUserDefaults.standardUserDefaults()
        var searchKey = ud.objectForKey("searchKeyFromVCKey") as? String
        
        println("searchKey \(searchKey)")
        
        
        
        if ud.objectForKey("searchKeyFromVCKey") != nil{
            
            // Check to see if there is a search term
            var tagQuery: PFQuery!
            var imgTextQuery: PFQuery!
            var clothesExplanationQuery: PFQuery!
            var seasonQuery: PFQuery!
            
            var query: PFQuery!
            
            
            
            
            if searchKey != "" {
                //If a user is searching something...
                tagQuery = PFQuery(className: "Posts")
                tagQuery.whereKey("searchTag", containsString: searchKey)
                
                imgTextQuery = PFQuery(className: "Posts")
                imgTextQuery.whereKey("imageText", containsString: searchKey)
                //query.whereKey("Tags", containsString: searchTextF.text)
                
                clothesExplanationQuery = PFQuery(className: "Posts")
                clothesExplanationQuery.whereKey("clothesExplanation", containsString: searchKey)
                
                seasonQuery = PFQuery(className: "Posts")
                seasonQuery.whereKey("season", containsString: searchKey)
                
                query = PFQuery.orQueryWithSubqueries([tagQuery, imgTextQuery, clothesExplanationQuery, seasonQuery])
                println("searckadjof")
                // Fetch data from the parse platform
                query.findObjectsInBackgroundWithBlock {
                    (objects: [AnyObject]?, error: NSError?) -> Void in
                    println("objects: \(objects)")
                    println("error\(error)")
                    println("searckadjof23")
                    
                    // The find succeeded now rocess the found objects into the countries array
                    if error == nil {
                        
                        // Clear existing country data
                        self.votes.removeAll(keepCapacity: false)
                        
                        // Add country objects to our array
                        if let object = objects as? [PFObject] {
                            self.votes = object
                            println("votesn \(self.votes)")
                            // reload our data into the collection view
                            self.collectionView.reloadData()
                        }
                        
                        //self.hideActivityIndicator(self.view)
                        
                    } else {
                        // Log details of the failure
                        println("Error: \(error!) \(error!.userInfo!)")
                        /*
                        if self.checkAlert == 0{
                        
                        let alert = SCLAlertView()
                        alert.showError("Error", subTitle:"An error occured while retrieving your clothes. Please check the Internet connection.", closeButtonTitle:"Ok")
                        self.hideActivityIndicator(self.view)
                        
                        self.checkAlert = 1*/
                        
                    }
                    
                }}}
        
        ud.removeObjectForKey("searchKeyFromVCKey")
        
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
        println("votesNum\(votes.count)")
        
        return self.votes.count
    }
    
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("loveView", forIndexPath: indexPath) as! LoveCollectionViewCell
        let item = self.votes[indexPath.row]
        
        
        let gesture = UITapGestureRecognizer(target: self, action: Selector("onDoubleTap:"))
        gesture.numberOfTapsRequired = 2
        cell.addGestureRecognizer(gesture)
        
        
        // Display "initial" flag image
        var initialThumbnail = UIImage(named: "question")
        cell.postsImageView.image = initialThumbnail
        
        // Display the country name
        if let user = item["uploader"] as? PFUser{
            item.fetchIfNeeded()
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
    
    func onDoubleTap (recognizer: UIGestureRecognizer)
    {
        println("doubl")
        tapCheck = 2
        let cell = recognizer.view as! NewCollectionViewCell
        cell.onDoubleTap()
        let object = self.votes[self.collectionView.indexPathForCell(cell)!.row]
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
        
        let delay = 0.21 * Double(NSEC_PER_SEC)
        let time  = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue(), {
            self.tapCheck = 1
        })
        
    }
    /*
    ==========================================================================================
    Segue methods
    ==========================================================================================
    */
    
    // Process collectionView cell selection
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let delay = 0.2 * Double(NSEC_PER_SEC)
        let time  = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue(), {
            println("dispatch after!")
            if self.tapCheck == 1{
                
                self.objectToSend = self.votes[indexPath.row]
                var attributes: UICollectionViewLayoutAttributes = self.collectionView.layoutAttributesForItemAtIndexPath(indexPath)!
                var cellRect: CGRect = attributes.frame
                //cellRect.origin.y = cellRect.origin.y - lastContentOffset
                
                if self.lastContentOffset != nil{
                    var originY = cellRect.origin.y - self.lastContentOffset
                    cellRect.origin.y = originY
                }
                
                //Adding for navigation bar and status bar
                cellRect.origin.y = cellRect.origin.y + 44 + 20
                println("cellrect \(cellRect)")
                
                
                let layer = UIApplication.sharedApplication().keyWindow?.layer
                let scale = UIScreen.mainScreen().scale
                UIGraphicsBeginImageContextWithOptions(layer!.frame.size, false, scale);
                
                layer!.renderInContext(UIGraphicsGetCurrentContext())
                let screenshot = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                
                let ud = NSUserDefaults.standardUserDefaults()
                ud.setObject(UIImageJPEGRepresentation(screenshot, 0.6), forKey: "bgBetweenNewVCandTrendDetailVC")
                ud.setValue(NSStringFromCGRect(cellRect), forKey: "cellPositionTopstoTrendDetailKey")
                
                
                /*
                UICollectionViewLayoutAttributes *attributes = [self.collectionView layoutAttributesForItemAtIndexPath:indexPath];
                CGRect cellRect = attributes.frame;
                */
                self.performSegueWithIdentifier("showTrendImage", sender: self)
                
            }  })
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showTrendImage" {
            let detailsVc = segue.destinationViewController as! TrendDetailViewController
            detailsVc.currentObject = objectToSend
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.lastContentOffset = scrollView.contentOffset.y
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