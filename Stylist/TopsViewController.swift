//
//  TopsViewController.swift
//  Stylist
//
//  Created by 勝又健登  on 2015/06/29.
//  Copyright (c) 2015年 xxx. All rights reserved.
//

import UIKit
import Parse

var tops = [PFObject]()

class TopsViewController: VisibleFormViewController, UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate {
	
	var container: UIView = UIView()
	var loadingView: UIView = UIView()
	var actInd: UIActivityIndicatorView = UIActivityIndicatorView()
	
	
	var overallNav: UIVisualEffectView!
	var appearentNav: UIView!
	var buttonLayoutView: UIView!
	var searchButton: UIButton!
	
	var blackBlurBtn: UIButton!
	
	var searchTextF: UITextField!
	
	var gobackButton: UIButton!
	
	var overallHeight: CGFloat = 110
	var appearentNavHeight: CGFloat = 30
	var upPosition = CGRectMake(0, 0, 0, 0)
	
	var searchText: NSString!
	
	var checkAlert: Int!
	
	
	
	@IBAction func unwindToTops(segue: UIStoryboardSegue) {
	}
	
	var objectToSend : PFObject?
	
	
	
	@IBOutlet weak var collectionView: UICollectionView!
	var lastContentOffset: CGFloat!
	//コレクションビューが表示されるたびにデータを再度取得
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.setupMenuBar()
		
		
		loadCollectionViewData()
		checkAlert = 0
		
	}
	
	
	func setupMenuBar(){
		appearentNav = UIView(frame: CGRectMake(0, 0, self.view.frame.width, appearentNavHeight))
		appearentNav.backgroundColor = UIColor(red: 0, green: 0.698, blue: 0.792, alpha: 0.92)
		
	
		
		let blurEffect: UIBlurEffect = UIBlurEffect(style: UIBlurEffectStyle.ExtraLight)
		overallNav = UIVisualEffectView(effect: blurEffect)
		overallNav.frame = CGRectMake(0, self.view.frame.height - appearentNavHeight, self.view.frame.width, overallHeight)
		
		
		blackBlurBtn = UIButton(frame: self.view.frame)
		blackBlurBtn.backgroundColor = UIColor(white: 0, alpha: 0)
		self.view.addSubview(self.blackBlurBtn)
		blackBlurBtn.hidden = true
		blackBlurBtn.addTarget(self, action: "blackBlurTapped", forControlEvents: UIControlEvents.TouchDown)
		
		
		var actualMenuHeight = overallHeight - appearentNavHeight
		buttonLayoutView = UIView(frame: CGRectMake(0, appearentNavHeight, self.view.frame.width, actualMenuHeight))
		buttonLayoutView.backgroundColor = UIColor.clearColor()
		self.view.addSubview(overallNav)
		overallNav.addSubview(appearentNav)
		overallNav.addSubview(buttonLayoutView)
		
		
		
		let menuImg = UIImage(named: "GoBackArrow") as UIImage?
		gobackButton   = UIButton.buttonWithType(UIButtonType.System) as! UIButton
		gobackButton.frame = CGRectMake(0, appearentNav.frame.origin.y, appearentNavHeight + 40, appearentNavHeight)
		gobackButton.imageEdgeInsets = UIEdgeInsetsMake(2, 5, 3, 40)
		gobackButton.setImage(menuImg, forState: .Normal)
		gobackButton.tintColor = UIColor.whiteColor()
		
		
		gobackButton.addTarget(self, action: "gobackBtnTapped", forControlEvents: .TouchUpInside)
		appearentNav.addSubview(gobackButton)
		
		
		searchButton = UIButton(frame: CGRectMake(self.view.frame.width - appearentNavHeight, 0, appearentNavHeight, appearentNavHeight))
		let searchIconImg = UIImage(named: "search-50")
		searchButton.setImage(searchIconImg, forState: UIControlState.Normal)
		searchButton.imageEdgeInsets = UIEdgeInsetsMake(3.5, 3.5, 3.5, 3.5)
		searchButton.addTarget(self, action: "searchButtonTapped", forControlEvents: .TouchUpInside)
		appearentNav.addSubview(searchButton)
		
		searchTextF = UITextField(frame: CGRectMake(15, 10, self.view.frame.width - 30, actualMenuHeight - 50))
		searchTextF.placeholder = "Search clothes"
		searchTextF.backgroundColor = UIColor(white: 0.7, alpha: 0.4)
		searchTextF.layer.cornerRadius = 5.0
		searchTextF.textAlignment = NSTextAlignment.Center
		searchTextF.textColor = UIColor.darkGrayColor()
		searchTextF.delegate = self
		buttonLayoutView.addSubview(searchTextF)
		
		
		
		overallHeight = overallNav.frame.height
		appearentNavHeight = appearentNav.frame.height
		upPosition = CGRectMake(0, self.view.frame.height - overallHeight, self.view.frame.width, overallHeight)
		
		
		self.lastVisibleView = overallNav
		self.visibleMargin = 0
		
	}
	
	func searchButtonTapped(){
		let navDifference = overallHeight - appearentNavHeight
		var currentNavPosition = overallNav.frame
		
		println("currentNavPos \(currentNavPosition)")
		println("upPosition \(upPosition)")
		
		
		if (currentNavPosition == upPosition){
			self.closeMenu()
			
		}else{
			self.openMenu()
		}
		
		
	}
	
	func gobackBtnTapped() {
		self.performSegueWithIdentifier("topsVCtoVCsegue", sender: self)
		
	}
	
	func closeMenu(){
		println("already up")
		searchTextF.resignFirstResponder()
		// アニメーション処理
		UIView.animateWithDuration(NSTimeInterval(CGFloat(0.3)),
			animations: {() -> Void in
				
				// 移動先の座標を指定する.
				self.overallNav.frame = CGRectMake(0, self.view.frame.height - self.appearentNavHeight, self.view.frame.width, self.overallHeight)
				self.blackBlurBtn.hidden = true
			}, completion: {(Bool) -> Void in
		})
		
		
		
		
		
		
	}
	
	func openMenu(){
		
		// アニメーション処理
		UIView.animateWithDuration(NSTimeInterval(CGFloat(0.3)),
			animations: {() -> Void in
				
				// 移動先の座標を指定する.
				self.overallNav.frame = CGRectMake(0, self.view.frame.height - self.overallHeight, self.view.frame.width, self.overallHeight)
				self.blackBlurBtn.hidden = false
				
			}, completion: {(Bool) -> Void in
		})
		
		self.view.bringSubviewToFront(overallNav)
		
		
	}
	
	override func textFieldShouldReturn(textField: UITextField) -> Bool {
		searchText = searchTextF.text
		self.loadCollectionViewData()
		
		self.closeMenu()
		self.view.endEditing(true)
		
		return true
	}
	
	
	//コレクションビューが表示されるたびにデータを再度取得

	override func viewDidAppear(animated: Bool) {
		loadCollectionViewData()
		
	}
	
	//データを再度

	func loadCollectionViewData() {

		println("searchText = \(searchTextF.text)")
		//サーチバーの中に何も入ってないのを確認

		var tagQuery: PFQuery!
		var imgTextQuery: PFQuery!
		var clothesExplanationQuery: PFQuery!
		var seasonQuery: PFQuery!
		
		var query: PFQuery!
		
		query = PFQuery(className: "Tops")
		
		if searchTextF.text != "" {
			//If a user is searching something...
			tagQuery = PFQuery(className: "Tops")
			tagQuery.whereKey("searchTag", containsString: searchTextF.text.lowercaseString)
			
			imgTextQuery = PFQuery(className: "Tops")
			imgTextQuery.whereKey("imageText", containsString: searchTextF.text)
			
			clothesExplanationQuery = PFQuery(className: "Tops")
			clothesExplanationQuery.whereKey("clothesExplanation", containsString: searchTextF.text)
			
			seasonQuery = PFQuery(className: "Tops")
			seasonQuery.whereKey("season", containsString: searchTextF.text)
			
			query = PFQuery.orQueryWithSubqueries([tagQuery, imgTextQuery, clothesExplanationQuery, seasonQuery])
		}
		
		query.whereKey("uploader", equalTo: PFUser.currentUser()!)
		
		query.findObjectsInBackgroundWithBlock {
			(objects: [AnyObject]?, error: NSError?) -> Void in
			println("objects: \(objects)")
			println("error\(error)")
			
			if error == nil {
				
				tops.removeAll(keepCapacity: false)
				
				if let objects = objects as? [PFObject] {
					tops = Array(objects.generate())
				}
				
				self.collectionView.reloadData()
				self.hideActivityIndicator(self.view)
				
			} else {
				println("Error: \(error!) \(error!.userInfo!)")
				if self.checkAlert == 0{
					
					let alert = SCLAlertView()
					alert.showError("Error", subTitle:"An error occured while retrieving your clothes. Please check the Internet connection.", closeButtonTitle:"Ok")
					self.hideActivityIndicator(self.view)
					
					self.checkAlert = 1
					
				}
				
			}
			
		}
	}
	
	//コレクションビュー導入のためのコード

	
	func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return tops.count
	}
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		
		
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier("mySingleCell", forIndexPath: indexPath) as! SingleRowCell
		
		
		if let value = tops[indexPath.row]["imageText"] as? String {
			cell.topsLabel.text = value
			println("it should be there")
			
		}
		
		if let datelabeltext = tops[indexPath.row].createdAt{
			println("get date")
			let dateFormatter = NSDateFormatter()
			dateFormatter.locale = NSLocale(localeIdentifier: "en_US") // ロケールの設定
			dateFormatter.dateFormat = "yyyy/MM/dd" // 日付フォーマットの設定
			
			cell.dateLabel.text = dateFormatter.stringFromDate(datelabeltext)
		}
		
		var initialThumbnail = UIImage(named: "question")
		cell.topsImageView.image = initialThumbnail
		

		if let value = tops[indexPath.row]["imageFile"] as? PFFile {
			
			cell.topsImageView.file = value
			cell.topsImageView.loadInBackground({ (image: UIImage?, error: NSError?) -> Void in
				
				if error != nil {
					
					
				}
				
			})
			
			
		}
		
		return cell
	}
	

	
	// Process collectionView cell selection
	func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		objectToSend = tops[indexPath.row]
		var attributes: UICollectionViewLayoutAttributes = self.collectionView.layoutAttributesForItemAtIndexPath(indexPath)!
		var cellRect: CGRect = attributes.frame
		//cellRect.origin.y = cellRect.origin.y - lastContentOffset
		
		if lastContentOffset != nil{
			var originY = cellRect.origin.y - lastContentOffset
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
		ud.setObject(UIImageJPEGRepresentation(screenshot, 0.6), forKey: "bgBetweenTopsVCandDetailVC")
		ud.setValue(NSStringFromCGRect(cellRect), forKey: "cellPositionTopstoDetailKey")
		
		

		performSegueWithIdentifier("showImage", sender: self)
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		
		if segue.identifier == "showImage" {
			
			let detailsVc = segue.destinationViewController as! DetailViewController
			detailsVc.currentObject = objectToSend
		}
	}
	
	func scrollViewDidScroll(scrollView: UIScrollView) {
		self.lastContentOffset = scrollView.contentOffset.y
	}
	
	
	func blackBlurTapped(){
		println("blackblur")
		self.closeMenu()
	}
 
	
	
	func showActivityIndicator(uiView: UIView) {
		
		container.frame = uiView.frame
		container.center = uiView.center
		container.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
		
		loadingView.frame = CGRectMake(0, 0, 100, 100)
		loadingView.center = uiView.center
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
	
	
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}
