//
//  ImageViewController.h
//  Stylist
//
//  Created by 田畑リク on 2015/06/29.
//  Copyright (c) 2015年 xxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>


@interface ImagePreviewViewController : UIViewController{
    NSMutableArray *seasonArray;
}

- (instancetype)initWithImage:(UIImage *)image;
@end
