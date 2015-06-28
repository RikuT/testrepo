//
//  ViewController.swift
//  Stylist
//
//  Created by Kenty on 2015/06/28.
//  Copyright (c) 2015年 xxx. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        self.performSegueWithIdentifier("loginView", sender: self)
    }

}
