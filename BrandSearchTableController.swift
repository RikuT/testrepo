//
//  BrandSearchTableController.swift
//  Stylist
//
//  Created by 田畑リク on 2015/08/10.
//  Copyright (c) 2015年 xxx. All rights reserved.
//

import Foundation
import UIKit

typealias NameAndScoreTuple = (name:String, score:Double)

var currentView = 0

class BrandSearchTableController : UIViewController, UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var navBar: UINavigationBar!
    
    //ブランド一覧を撮ってきて、スコア別にソートできるようにする
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
    
    var checkInt: Int = 0
    var checkUpdate = 0
    
    func commonInit(){
        self.title = "Search"
        self.tabBarItem = UITabBarItem(title: self.title, image: BrandScoreStyleKit.imageOf(string: "A"), tag: 0)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        commonInit()
    }
    
    override func viewWillAppear(animated: Bool) {
        currentView = 0;
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    //戻るボタンの設定
    @IBAction func brandBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkUpdate = 0
        //バックグラウンドを、スキューバブルーに設定
        navBar.backgroundColor = UIColor(red: 0, green: 0.698, blue: 0.792, alpha: 1)
        resultsTableController = ResultsTableController()
        
        // We want to be the delegate for our filtered table so didSelectRowAtIndexPath(_:) is called for both tables.
        resultsTableController.tableView.delegate = self
        
        
        searchController = UISearchController(searchResultsController: resultsTableController)
        searchController.searchResultsUpdater = self
        searchController.searchBar.sizeToFit()
        tableView.tableHeaderView = searchController.searchBar
        
        searchController.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        
        
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
        checkInt = 2
        
    }
    
    func willDismissSearchController(searchController: UISearchController) {
        //NSLog(__FUNCTION__)
        
        checkInt = 0
        
    }
    
    func didDismissSearchController(searchController: UISearchController) {
        //NSLog(__FUNCTION__)
        
    }
    
    // MARK: UISearchResultsUpdating
    
    //検索キーワードが変更された場合
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
        
        // 検索結果をtableviewcontrollerに引き渡す。
        let resultsController = searchController.searchResultsController as! ResultsTableController
        resultsController.searchResultArray = resultArray
        
        if checkInt == 2{
            
            var colorView = UIView(frame: CGRectMake(0, 0, self.view.frame.width, 45))
            colorView.backgroundColor = UIColor(red: 0, green: 0.698, blue: 0.792, alpha: 1)
            var brandLabel = UILabel(frame: CGRectMake(0, 10, self.view.frame.width, 44))
            brandLabel.text = "b r a n d"
            brandLabel.textColor = UIColor.whiteColor()
            brandLabel.font = UIFont(name: "AppleSDGothicNeo-Light", size: 26)
            brandLabel.textAlignment = NSTextAlignment.Center
            colorView.addSubview(brandLabel)
            resultsController.tableView.superview!.addSubview(colorView)
        }
        resultsController.tableView.reloadData()
        
        println("checkInt1\(checkInt)")
        
        
    }
    
    // Cell が選択された場合
    func tableView(table: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath) {
        //タップされたブランド名をuserdefaultsを使って引き渡す
        var tapResult: NSString = "BRAND"
        if(checkUpdate == 0){
            tapResult = dataSourceArray[indexPath.row]
            println("results \(tapResult)")
            
        }
        if(checkUpdate == 1){
            let resultsController = searchController.searchResultsController as! ResultsTableController
            var tapResultTuple = resultsController.searchResultArray[indexPath.row]
            tapResult = tapResultTuple.name
            println("results \(tapResult)")
        }
        
        let ud = NSUserDefaults.standardUserDefaults()
        ud.removeObjectForKey("brandNameKey")
        ud.setObject(tapResult, forKey: "brandNameKey")
        if (currentView == 0){
            self.dismissViewControllerAnimated(true, completion: nil)
        }else{
            self.dismissViewControllerAnimated(true, completion: nil)
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }
        
    }
    
    
}


class ResultsTableController : UITableViewController, UISearchControllerDelegate {
    
    var searchResultArray:[NameAndScoreTuple]!
    
    let defaultCellReuseIdentifier = "CellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: defaultCellReuseIdentifier)
        let ud = NSUserDefaults.standardUserDefaults()
        ud.setObject("BRAND", forKey: "brandNameKey")
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        currentView = 1;
        
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
        
        let maxBlackProportion:CGFloat = 0.7
        cell.textLabel?.textColor = UIColor(white: maxBlackProportion * CGFloat(1 - t.score), alpha: 1.0)
        
        return cell
    }
    
    
}