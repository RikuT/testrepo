//
//  LoveViewController.swift
//  
//
//  Created by 勝又健登 on 2015/08/12.
//
//

import Parse

class LoveViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    var objectToSend : PFObject?
    var likes:[NSIndexPath:Int] = [:]
    var votes = [PFObject]()
    var collectionViewHeight: CGFloat!
    var tapCheck: Int = 0
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    var lastContentOffset: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        loadCollectionViewData()
        
        let ud = NSUserDefaults.standardUserDefaults()
        ud.removeObjectForKey("forceClosetKey")
    }
    
//コレクションビューが表示されるたびにデータを再度取得
        override func viewDidAppear(animated: Bool) {
        loadCollectionViewData()
        println("viewdidappear")
        println("collectF2 \(self.view.frame)")
        tapCheck = 1
        self.view.frame.origin.y = 0
        self.view.frame.size.height = collectionViewHeight
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.view.frame.origin.y = 0
        self.view.frame.size.height = collectionViewHeight
        println("loveCalled")
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadPagesFore", name: UIApplicationWillEnterForegroundNotification, object: nil)
        
    }
    
    //Reloading all pages
    func loadPagesFore(){
        println("loadPages")
        //These methods are only conducted when the pages are not loaded
        /*
        let ud = NSUserDefaults.standardUserDefaults()
        ud.setBool(true, forKey: "forceLoadPagesKey") //currently disabled
        
        
        swiftPagesView.loadPage(0)
        swiftPagesView.loadPage(1)
        swiftPagesView.loadPage(2)
        */
        let ud = NSUserDefaults.standardUserDefaults()
        ud.setBool(true, forKey: "forceClosetKey")
        self.performSegueWithIdentifier("likeVCtoClosetVC", sender: self)
        
    }

    
    
//データを再度
    
    func loadCollectionViewData() {

        
        println("loadscdo")
        let ud = NSUserDefaults.standardUserDefaults()
        var searchKey = ud.objectForKey("searchKeyFromVCKey") as? String
        
        println("searchKey \(searchKey)")
        
        
        
        if ud.objectForKey("searchKeyFromVCKey") != nil{
            
            //サーチバーの中に何も入ってないのを確認
            var tagQuery: PFQuery!
            var imgTextQuery: PFQuery!
            var clothesExplanationQuery: PFQuery!
            var seasonQuery: PFQuery!
            
            var query: PFQuery!
            
            
            
            
            if searchKey != "" {
                tagQuery = PFQuery(className: "Posts")
                tagQuery.whereKey("searchTag", containsString: searchKey)
                
                imgTextQuery = PFQuery(className: "Posts")
                imgTextQuery.whereKey("imageText", containsString: searchKey)
                
                clothesExplanationQuery = PFQuery(className: "Posts")
                clothesExplanationQuery.whereKey("clothesExplanation", containsString: searchKey)
                
                seasonQuery = PFQuery(className: "Posts")
                seasonQuery.whereKey("season", containsString: searchKey)
                
                query = PFQuery.orQueryWithSubqueries([tagQuery, imgTextQuery, clothesExplanationQuery, seasonQuery])
                println("searckadjof")
                query.findObjectsInBackgroundWithBlock {
                    (objects: [AnyObject]?, error: NSError?) -> Void in
                    println("objects: \(objects)")
                    println("error\(error)")
                    println("searckadjof23")
                    
                    if error == nil {
                        
                        self.votes.removeAll(keepCapacity: false)
                        
                        if let object = objects as? [PFObject] {
                            self.votes = object
                            println("votesn \(self.votes)")
                            self.collectionView.reloadData()
                        }
                        
                        
                    } else {
                        println("Error: \(error!) \(error!.userInfo!)")
                        
                    }
                    
                }}}
        
        ud.removeObjectForKey("searchKeyFromVCKey")
        
    }
    
    
    
    
//コレクションビュー導入のためのコード
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        
        return self.votes.count
    }
    
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("loveView", forIndexPath: indexPath) as! LoveCollectionViewCell
        let item = self.votes[indexPath.row]
        
        
        let gesture = UITapGestureRecognizer(target: self, action: Selector("onDoubleTap:"))
        gesture.numberOfTapsRequired = 2
        cell.addGestureRecognizer(gesture)
        
        
        //ロード中のための画像
        var initialThumbnail = UIImage(named: "question")
        cell.postsImageView.image = initialThumbnail
        
        // ユーザーの名前を表示する
        if let user = item["uploader"] as? PFUser{
            item.fetchIfNeededInBackgroundWithBlock { (result, error) -> Void in
            cell.userName!.text = user.username
            }
            
            
            var profileImgFile = user["profilePicture"] as! PFFile
            cell.profileImageView.file = profileImgFile
            cell.profileImageView.loadInBackground { image, error in
                if error == nil {
                    cell.profileImageView.image = image
                }
            }
            
            var sexInt = user["sex"] as? Int
            var sex: NSString!
            if sexInt == 0 {
                sex = "M"
            }else if sexInt == 1{
                sex = "F"
            }else{
                sex = " "
            }
            
            var height = user["height"] as? Int
            if height == nil{
                cell.heightSexLabel.text = " "
            }else{
                var nonOpHeight = height as Int!
                cell.heightSexLabel.text = "\(sex) \(nonOpHeight)cm"
            }
        
            
        }
        
        if let votesValue = item["votes"] as? Int
        {
            cell.votesLabel?.text = "\(votesValue)"
        }
        
        // 画像を呼ぶコード
        if let value = item["imageFile"] as? PFFile {
            println("Value \(value)")
            cell.postsImageView.file = value
            cell.postsImageView.loadInBackground({ (image: UIImage?, error: NSError?) -> Void in
                if error != nil {
                    cell.postsImageView.image = image
                }
            })
        }
        
        //♡の位置
        cell.votesLabel!.sizeToFit()
        cell.votesLabel!.center = CGPointMake(cell.bottomBlurView.center.x - (cell.heartImage.frame.width / 2)-1.5, cell.bottomBlurView.frame.size.height / 2)
        cell.heartImage.frame.origin.x = cell.votesLabel!.frame.origin.x + cell.votesLabel!.frame.width + 1.5


        
        return cell
    }
    
    
    func onDoubleTap (recognizer: UIGestureRecognizer)
    {
        println("doubl")
        tapCheck = 2
        let cell = recognizer.view as! LoveCollectionViewCell
        cell.onDoubleTap()
        let object = self.votes[self.collectionView.indexPathForCell(cell)!.row]
        if let likes = object["votes"] as? Int
        {
            object["votes"] = likes + 1
            object.saveInBackgroundWithBlock{ (success:Bool,error:NSError?) -> Void in
                println("Data saved")
                
            }
            cell.votesLabel?.text = "\(likes + 1)"
            
            cell.votesLabel!.sizeToFit()
            cell.votesLabel!.center = CGPointMake(cell.bottomBlurView.center.x - (cell.heartImage.frame.width / 2)-1.5, cell.bottomBlurView.frame.size.height / 2)
            cell.heartImage.frame.origin.x = cell.votesLabel!.frame.origin.x + cell.votesLabel!.frame.width + 1.5
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

    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let delay = 0.2 * Double(NSEC_PER_SEC)
        let time  = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue(), {
            println("dispatch after!")
            if self.tapCheck == 1{
                
                self.objectToSend = self.votes[indexPath.row]
                var attributes: UICollectionViewLayoutAttributes = self.collectionView.layoutAttributesForItemAtIndexPath(indexPath)!
                var cellRect: CGRect = attributes.frame
                
                if self.lastContentOffset != nil{
                    var originY = cellRect.origin.y - self.lastContentOffset
                    cellRect.origin.y = originY
                }
                
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
                
                
 
                self.performSegueWithIdentifier("showTrendImage", sender: self)
                
            }  })
    }
    
//Detailビューに表示させるためのセグエの
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showTrendImage" {
            let detailsVc = segue.destinationViewController as! TrendDetailViewController
            detailsVc.currentObject = objectToSend
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.lastContentOffset = scrollView.contentOffset.y
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}