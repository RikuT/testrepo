//
//  ImageViewController.h
//  Stylist
//
//  Created by 田畑リク on 2015/06/29.
//  Copyright (c) 2015年 xxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "TLTagsControl.h"



@interface ImagePreviewViewController : UIViewController<UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource>{
    NSArray *seasonArray;
    UITextField *seasonTextF;
    UIPickerView *myPickerView;
    UITextView *clothesDesciptionTextView;
    TLTagsControl *brandTag;
    TLTagsControl *miscTag;
    NSString *textViewPlaceHolder;
}

- (instancetype)initWithImage:(UIImage *)image;
@end
