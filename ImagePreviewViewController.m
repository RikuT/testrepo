//
//  ImageViewController.m
//  Stylist
//
//  Created by 田畑リク on 2015/06/29.
//  Copyright (c) 2015年 xxx. All rights reserved.
//
#import "ImagePreviewViewController.h"
#import "ViewUtils.h"
//#import "UIImage+Crop.h"

@interface ImagePreviewViewController ()
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIButton *quitButton;
@property (strong, nonatomic) UIButton *uploadButton;
@property (strong, nonatomic) UITextField *clothesNameTextField;

@end

@implementation ImagePreviewViewController

- (instancetype)initWithImage:(UIImage *)image {
    self = [super initWithNibName:nil bundle:nil];
    if(self) {
        _image = image;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageView.backgroundColor = [UIColor blackColor];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenRect.size.width, screenRect.size.height)];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.backgroundColor = [UIColor clearColor];
    
    //この画像を直接Parseに入れられるはず
    self.imageView.image = self.image;
    [self.view addSubview:self.imageView];
    

    
    // button to quit taking photos
    self.quitButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.quitButton.frame = CGRectMake(10, 10, 21.0f + 20.0f, 21.0f + 20.0f);
    self.quitButton.tintColor = [UIColor whiteColor];
    [self.quitButton setImage:[UIImage imageNamed:@"whiteCancel.png"] forState:UIControlStateNormal];
    self.quitButton.imageEdgeInsets = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
    [self.quitButton addTarget:self action:@selector(quitButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.quitButton];
    
    //Change textfield design over here
    self.clothesNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(75, 15, self.view.bounds.size.width-90, 30)];
    self.clothesNameTextField.borderStyle = UITextBorderStyleBezel;
    self.clothesNameTextField.textColor = [UIColor blackColor];
    self.clothesNameTextField.placeholder = @"Clothes name";
    [self.view addSubview:self.clothesNameTextField];
    self.clothesNameTextField.delegate = self;
    
    
    self.uploadButton = [UIButton buttonWithType:UIButtonTypeSystem];
    int uploadButtonHeight = 50;
    int uploadButtonWidth = self.view.bounds.size.width;
    [self.uploadButton setFrame:CGRectMake(0, self.view.bounds.size.height-0-uploadButtonHeight, uploadButtonWidth, uploadButtonHeight)];
                                                                  
    [self.uploadButton setTitle:@"UPLOAD" forState:UIControlStateNormal];
    [self.uploadButton addTarget:self action:@selector(uploadImage:)forControlEvents:UIControlEventTouchDown];
    UIColor *btnColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5];
    self.uploadButton.backgroundColor = btnColor;
    [self.view addSubview:self.uploadButton];
}

-(void)uploadImage:(UIButton*)button{
    NSString *clothesName = self.clothesNameTextField.text;
    // ここでimageをparseにアップロードする
    NSLog(@"upload");
    NSLog(@"%@,and %@", clothesName, self.image);
    
    if (self.imageView.image == NULL) {
        NSLog(@"error");
    }else{
        NSData *imageData = UIImageJPEGRepresentation(self.image, 1.0);
        PFFile *parseImageFile = [PFFile fileWithName:@"uploaded_image.jpg" data:imageData];
        [parseImageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                if (succeeded) {
                    //Putting the photo in Parse
                    PFObject* posts = [PFObject objectWithClassName:@"Tops"];
                    posts[@"imageText"] = clothesName;
                    posts[@"uploader"] = [PFUser currentUser];
                    posts[@"imageFile"] = parseImageFile;
                    [posts saveInBackground];
                    NSLog(@"success!!");
                    
                    [self dismissViewControllerAnimated:NO completion:nil];
                    // NSUserDefaultsの取得
                    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                    [ud setBool:YES forKey:@"photoVCtoVCKey"];
                }
            } else {
                // Handle error
                NSLog(@"ERROR");
            }        
        }];
    }
    


}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.clothesNameTextField) {
        [textField resignFirstResponder];
    }
    return YES;
}


- (void)quitButtonPressed:(UIButton *)button {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.imageView.frame = self.view.contentBounds;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
