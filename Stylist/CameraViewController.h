//
//  CameraViewController.h
//  Stylist
//
//  Created by Kenty on 2015/07/24.
//  Copyright (c) 2015年 xxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface CameraViewController : UIViewController {
BOOL FrontCamera;

}

@property(nonatomic, retain) AVCaptureStillImageOutput *stillImageOutput;
@property (strong, nonatomic) IBOutlet UIView *imagePreview;
@property (strong, nonatomic) IBOutlet UIImageView *captureImage;
@property (strong, nonatomic) IBOutlet UISegmentedControl *cameraSwitch;
@property (strong, nonatomic) UIImage *clothesImg;

- (IBAction)snapImage:(id)sender;
- (IBAction)switchCamera:(id)sender;

@end

