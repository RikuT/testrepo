//
//  TopsViewController.swift
//  Stylist
//
//  Created by Kenty on 2015/06/29.
//  Copyright (c) 2015年 xxx. All rights reserved.
//

import UIKit
import Parse

var tops = [PFObject]()

class TopsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate {
	
	// Connection to the search bar
	@IBOutlet weak var searchBar: UISearchBar!
	
	// Connection to the collection view
	@IBOutlet weak var collectionView: UICollectionView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Wire up search bar delegate so that we can react to button selections
		searchBar.delegate = self
		
		// Resize size of collection view items in grid so that we achieve 3 boxes across
		let cellWidth = ((UIScreen.mainScreen().bounds.width) - 32 - 30 ) / 3
		let cellLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
		cellLayout.itemSize = CGSize(width: cellWidth, height: cellWidth)
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
		var query = PFQuery(className:"Tops")
		
		// Check to see if there is a search term
		if searchBar.text != "" {
			query.whereKey("uploader", containsString: searchBar.text.lowercaseString)
		}
		
		// Fetch data from the parse platform
		query.findObjectsInBackgroundWithBlock {
			(objects: [AnyObject]?, error: NSError?) -> Void in
			
			// The find succeeded now rocess the found objects into the countries array
			if error == nil {
				
				// Clear existing country data
				tops.removeAll(keepCapacity: true)
				
				// Add country objects to our array
				if let objects = objects as? [PFObject] {
					tops = Array(objects.generate())
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
		return tops.count
	}
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier("mySingleCell", forIndexPath: indexPath) as! SingleRowCell
	
		
		// Display the country name
		if let value = tops[indexPath.row]["topsLabel"] as? String {
			cell.topsLabel.text = value
		}
		
		// Display "initial" flag image
		var initialThumbnail = UIImage(named: "question")
			cell.topsImageView.image = initialThumbnail
		
		// Fetch final flag image - if it exists
		if let value = tops[indexPath.row]["tops"] as? PFFile {
			let finalImage = tops[indexPath.row]["tops"] as? PFFile
			finalImage!.getDataInBackgroundWithBlock {
				(imageData: NSData?, error: NSError?) -> Void in
				if error == nil {
					if let imageData = imageData {
						cell.topsImageView.image = UIImage(data:imageData)
					}
				}
			}
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
		let currentObject = tops[indexPath.row]
		performSegueWithIdentifier("CollectionViewToDetailView", sender: self)
	}
	
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		
		// If a cell has been selected within the colleciton view - set currentObjact to selected
		var currentObject : PFObject?
		if let country = sender as? PFObject{
			currentObject = sender as? PFObject
		} else {
			// No cell selected in collectionView - must be a new country record being created
			currentObject = PFObject(className:"Tops")
		}
		
		// Get a handle on the next story board controller and set the currentObject ready for the viewDidLoad method
		var detailScene = segue.destinationViewController as! DetailViewController
		detailScene.currentObject = (currentObject)
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
