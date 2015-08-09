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
#import "VisibleFormViewController.h"



@interface ImagePreviewViewController : VisibleFormViewController<UITextViewDelegate>{
    NSArray *seasonArray;
    UISegmentedControl *seasonSegment;
    UIPickerView *myPickerView;
    UITextView *clothesDesciptionTextView;
    TLTagsControl *brandTag;
    TLTagsControl *miscTag;
    NSString *textViewPlaceHolder;
    NSMutableArray *brandArray;
    UIScrollView *scrollview;
}

- (instancetype)initWithImage:(UIImage *)image;

@end
