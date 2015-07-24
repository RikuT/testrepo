//
//  TopsViewController.swift
//  Stylist
//
//  Created by Kenty on 2015/06/29.
//  Copyright (c) 2015年 xxx. All rights reserved.
//

import UIKit
import Parse


class TopsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{
	
    @IBOutlet weak var topsCollectionView: UICollectionView!
	//Create arrays of images from parse
	var imageFiles = [PFFile]()
	var imageText = [String]()
	var ImageArray = [UIImage]()
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		var query = PFQuery(className: "Tops")
		query.whereKey("uploader", equalTo: PFUser.currentUser()!)
		query.orderByDescending("createdAt")
		query.findObjectsInBackgroundWithBlock{
			(posts: [AnyObject]?, error: NSError?) -> Void in
			if error == nil {
				for post in posts!{
					self.imageFiles.append(post["imageFile"]as! PFFile)
					self.imageText.append(post["imageText"]as! String)
				}
				
				
				println(self.imageFiles.count)
				self.topsCollectionView.reloadData()
				
			} else {
				println(error)
			}}}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}



	 func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let singleCell: SingleRowCell = collectionView.dequeueReusableCellWithReuseIdentifier("mySingleCell", forIndexPath: indexPath) as! SingleRowCell
		singleCell.topsLabel.text = imageText [indexPath.row]
		imageFiles[indexPath.row].getDataInBackgroundWithBlock{
			(imageData: NSData?, error: NSError?) -> Void in
			if imageData != nil {
				let image = UIImage(data: imageData!)
				singleCell.topsImageView.image = image
			}else {
				println(error)
			}}
		
		return singleCell
	}
	func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		return 1
	}
 	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 20;
	}
	
	func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
	{
		self.performSegueWithIdentifier("showImage", sender: self)
	}

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
	{
		if segue.identifier == "showImage"
		{
			let indexPaths = self.collectionView!.indexPathsForSelectedItems()!
			let indexPath = indexPaths[0] as NSIndexPath
			let vc = segue.destinationViewController as! NewViewController
			vc.image = self.imageArray[indexPath.row]!
			vc.title = self.appleProducts[indexPath.row]
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

