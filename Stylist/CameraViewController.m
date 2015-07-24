//
//  CameraViewController.m
//  Stylist
//
//  Created by Kenty on 2015/07/24.
//  Copyright (c) 2015年 xxx. All rights reserved.
//

#import "CameraViewController.h"

#define DegreesToRadians(x) ((x) * M_PI / 180.0)

@interface CameraViewController ()

@end

@implementation CameraViewController

@synthesize imagePreview, captureImage, stillImageOutput, cameraSwitch, clothesImg;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    FrontCamera = NO;
    cameraSwitch.selectedSegmentIndex = 1;
    captureImage.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [self initCamera];
}

- (void)initCamera {
    NSLog(@"initCamera");

    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    session.sessionPreset = AVCaptureSessionPresetPhoto;
    
    AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    [captureVideoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    captureVideoPreviewLayer.frame = self.imagePreview.bounds;
    [self.imagePreview.layer addSublayer:captureVideoPreviewLayer];
    
    UIView *view = [self imagePreview];
    CALayer *viewLayer = [view layer];
    [viewLayer setMasksToBounds:YES];
    
    CGRect bounds = [imagePreview bounds];
    [captureVideoPreviewLayer setFrame:bounds];
    
    NSArray *devices = [AVCaptureDevice devices];
    AVCaptureDevice *frontCamera;
    AVCaptureDevice *backCamera;
    
    for (AVCaptureDevice *device in devices) {
        if ([device hasMediaType:AVMediaTypeVideo]) {
            if ([device position] == AVCaptureDevicePositionBack) {
                backCamera = device;
            }
            if ([device position] == AVCaptureDevicePositionFront) {
                frontCamera = device;
            }
        }
    }
    
    NSError *error = nil;
    if (!FrontCamera) {
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:backCamera error:&error];
        [session addInput:input];
    } else {
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:frontCamera error:&error];
        [session addInput:input];
        
    }
    
    stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [stillImageOutput setOutputSettings:outputSettings];
    
    [session addOutput:stillImageOutput];
    [session startRunning];
}

- (IBAction)snapImage:(id)sender {
    // [capturedImage removeFromSuperview];
    [self capImage];
}

- (void) capImage {
    NSLog(@"capImage");
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in stillImageOutput.connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo]) {
                videoConnection = connection;
                break;
            }
        }
        
        if (videoConnection) {
            break;
        }
    }
    
    [stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
        if (imageSampleBuffer != NULL) {
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
            [self processImage:[UIImage imageWithData:imageData]];
        }
        
    }];
}

- (void) processImage:(UIImage *)image {
    NSLog(@"processImage");

    //ここは必要だかわからないからとりあえず残しておいた。要確認
    // Device is iPad
    if ([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad) {
        UIGraphicsBeginImageContext(CGSizeMake(image.size.width, image.size.height));
        [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
        UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        
        CGRect cropRect = CGRectMake(0, 0, image.size.width, image.size.width);
        CGImageRef imageRef = CGImageCreateWithImageInRect([smallImage CGImage], cropRect);
        
        clothesImg = [UIImage imageWithCGImage:imageRef];
        [captureImage setImage:clothesImg];
        CGImageRelease(imageRef);
        
        captureImage.hidden = NO;
        imagePreview.hidden = YES;
    }
    //ここは必要だかわからないからとりあえず残しておいた。要確認
    // Device is iPhone
    if ([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
        UIGraphicsBeginImageContext(CGSizeMake(image.size.width, image.size.height));
        [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
        UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
  
        CGRect cropRect = CGRectMake(0, 0, image.size.width, image.size.width);
        CGImageRef imageRef = CGImageCreateWithImageInRect([smallImage CGImage], cropRect);
        
        clothesImg = [UIImage imageWithCGImage:imageRef];
        [captureImage setImage:clothesImg];
        CGImageRelease(imageRef);
        
        captureImage.hidden = NO;
        imagePreview.hidden = YES;
    }
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSData *imageData = UIImageJPEGRepresentation(clothesImg, 1.0);
    [ud setObject:imageData forKey:@"imgDataKey"];
    
    [self performSegueWithIdentifier:@"toImgPreview" sender:self];
    
}


- (IBAction)switchCamera:(id)sender {
    if (cameraSwitch.selectedSegmentIndex == 0) {
        FrontCamera = YES;
        [self initCamera];
    } else {
        FrontCamera = NO;
        [self initCamera];
    }
}

@end
