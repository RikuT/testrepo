//
//  BrandSearchTableController.swift
//  StringScoreBrand
//
//  Created by Yichi on 6/03/2015.
//  Copyright (c) 2015 YICHI ZHANG. All rights reserved.
//

import Foundation
import UIKit

typealias NameAndScoreTuple = (name:String, score:Double)

class BrandSearchTableController : UIViewController, UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    
	lazy var dataSourceArray:[String] = {
		if let path = NSBundle.mainBundle().pathForResource("name_list", ofType: "txt") {
			if let data = NSData(contentsOfFile: path) {
				if let string = NSString(data: data, encoding: NSUTF8StringEncoding) as? String {
					var arr = string.componentsSeparatedByString("\n")
					
					arr.sort { (a, b) -> Bool in
						return a < b
					}
					return arr
				}
			}
		}
		return []
	}()
	
	let defaultCellReuseIdentifier = "CellId"
	
	var searchController: UISearchController!
	var resultsTableController: ResultsTableController!
	
    var checkUpdate = 0
    
	func commonInit(){
		self.title = "Search"
		self.tabBarItem = UITabBarItem(title: self.title, image: BrandScoreStyleKit.imageOf(string: "A"), tag: 0)
	}
	
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		
		commonInit()
	}
	
	required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}
	
    @IBAction func brandBack(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    /*
	override init() {
		super.init()
		commonInit()
	}*/

	override func viewDidLoad() {
		super.viewDidLoad()
        checkUpdate = 0
		
		resultsTableController = ResultsTableController()
		
		// We want to be the delegate for our filtered table so didSelectRowAtIndexPath(_:) is called for both tables.
		resultsTableController.tableView.delegate = self
		
		
		searchController = UISearchController(searchResultsController: resultsTableController)
		searchController.searchResultsUpdater = self
		searchController.searchBar.sizeToFit()
		tableView.tableHeaderView = searchController.searchBar
		
		searchController.delegate = self
		searchController.dimsBackgroundDuringPresentation = false // default is YES
		searchController.searchBar.delegate = self    // so we can monitor text changes + others
		
		// Search is now just presenting a view controller. As such, normal view controller
		// presentation semantics apply. Namely that presentation will walk up the view controller
		// hierarchy until it finds the root view controller or one that defines a presentation context.
		definesPresentationContext = true
		
		
		
		tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: defaultCellReuseIdentifier)
	}
	
	// MARK: Table View Data Source and Delegate methods
	 func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	 func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return dataSourceArray.count
	}
	
	 func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: defaultCellReuseIdentifier)
		
		cell.textLabel?.text = dataSourceArray[indexPath.row]
		cell.detailTextLabel?.text = ""
		
		return cell
	}
	
	// MARK: UISearchBarDelegate
	func searchBarSearchButtonClicked(searchBar: UISearchBar) {
		searchBar.resignFirstResponder()
	}
	
	// MARK: UISearchControllerDelegate
	func presentSearchController(searchController: UISearchController) {
		//NSLog(__FUNCTION__)
	}
	
	func willPresentSearchController(searchController: UISearchController) {
		//NSLog(__FUNCTION__)
	}
	
	func didPresentSearchController(searchController: UISearchController) {
		//NSLog(__FUNCTION__)
	}
	
	func willDismissSearchController(searchController: UISearchController) {
		//NSLog(__FUNCTION__)
	}
	
	func didDismissSearchController(searchController: UISearchController) {
		//NSLog(__FUNCTION__)
	}

	// MARK: UISearchResultsUpdating
	
	func updateSearchResultsForSearchController(searchController: UISearchController) {
		checkUpdate = 1
		let searchText = searchController.searchBar.text
		var resultArray: Array<NameAndScoreTuple> = Array()
		for name in dataSourceArray {
			let score = name.score(word: searchText)
			
			let t = (name: name, score: score)
			resultArray.append(t)
		}
		
		resultArray.sort { (a, b) -> Bool in
			a.score > b.score
		}
		
		// Hand over the filtered results to our search results table.
		let resultsController = searchController.searchResultsController as! ResultsTableController
		resultsController.searchResultArray = resultArray
		resultsController.tableView.reloadData()
	}
    
    // Cell が選択された場合
     func tableView(table: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath) {
        // [indexPath.row] から画像名を探し、UImage を設定
        //selectedImage = UIImage(named:"\(imgArray[indexPath.row])")
        // SubViewController へ遷移するために Segue を呼び出す
        //performSegueWithIdentifier("toSubViewController",sender: nil)
        if(checkUpdate == 0){
            var tapResult = dataSourceArray[indexPath.row]
            println("results \(tapResult)")


        }
        if(checkUpdate == 1){
        let resultsController = searchController.searchResultsController as! ResultsTableController
        var tapResultTuple = resultsController.searchResultArray[indexPath.row]
        var tapResult = tapResultTuple.name
        println("results \(tapResult)")
        }
    }

}


class ResultsTableController : UITableViewController, UISearchControllerDelegate {
	
	var searchResultArray:[NameAndScoreTuple]!
	
	let defaultCellReuseIdentifier = "CellId"
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: defaultCellReuseIdentifier)
	}
	
	// MARK: Table View Data Source and Delegate methods
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return searchResultArray.count
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: defaultCellReuseIdentifier)
		
		let t = searchResultArray[indexPath.row]
		
		cell.textLabel?.text = t.name
		//cell.detailTextLabel?.text = t.score.yz_toString()
		
		let maxBlackProportion:CGFloat = 0.7
		cell.textLabel?.textColor = UIColor(white: maxBlackProportion * CGFloat(1 - t.score), alpha: 1.0)
		
		return cell
	}
}