//
//  goSegue.swift
//  
//
//  Created by 田畑リク on 2015/08/12.
//
//

import UIKit

class goSegue: UIStoryboardSegue {
    override func perform() {
        // Assign the source and destination views to local variables.
        var firstVCView = self.sourceViewController.view as UIView!
        var secondVCView = self.destinationViewController.view as UIView!
        
        // Get the screen width and height.
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        let screenHeight = UIScreen.mainScreen().bounds.size.height
        
        // Specify the initial position of the destination view.
        secondVCView.frame = CGRectMake(screenWidth, 0, screenWidth, screenHeight)
        
        // Access the app's key window and insert the destination view above the current (source) one.
        let window = UIApplication.sharedApplication().keyWindow
        window?.insertSubview(secondVCView, aboveSubview: firstVCView)
        
        firstVCView.frame = CGRectMake(0, 0, screenWidth, screenHeight)
        
        // Animate the transition.
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            secondVCView.frame = CGRectMake(0, 0, screenWidth, screenHeight)
            firstVCView.frame = CGRectMake(-screenWidth, 0, screenWidth, screenHeight)

            }) { (Finished) -> Void in
                self.sourceViewController.presentViewController(self.destinationViewController as! UIViewController,
                    animated: false,
                    completion: nil)
        }
        
    }
}