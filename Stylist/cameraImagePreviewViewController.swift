//
//  cameraImagePreviewViewController.swift
//  CameraTest
//
//  Created by 田畑リク on 2015/07/24.
//  Copyright (c) 2015年 Riku Tabata. All rights reserved.
//

import UIKit

class cameraImagePreviewViewController: UIViewController {

    var clothesImageView = UIImageView()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let ud = NSUserDefaults.standardUserDefaults()
        var imageData: NSData? = ud.dataForKey("imgDataKey")
        var clothesImage = UIImage (data: imageData!)
        println("image \(clothesImage)")
        self.clothesImageView = UIImageView(image: clothesImage)
        
        //ここで写真の縦:横を設定する　適当に変えといてください
        clothesImageView.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height-100)
        self.view.addSubview(clothesImageView)
        //println("imageData \(imageData)")
        //var clothesImage = UIImage(data: imageData)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
