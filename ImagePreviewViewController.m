//
//  ImageViewController.m
//  Stylist
//
//  Created by 田畑リク on 2015/06/29.
//  Copyright (c) 2015年 xxx. All rights reserved.
//
#import "ImagePreviewViewController.h"
#import "ViewUtils.h"
#import "SCLAlertView.h"
#import "TLTagsControl.h"
//#import "UIImage+Crop.h"

@interface ImagePreviewViewController ()
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIButton *quitButton;
@property (strong, nonatomic) UIButton *uploadButton;
@property (strong, nonatomic) UITextField *clothesNameTextField;
//@property (strong, nonatomic) NSMutableArray *tagArray;

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
    UIScrollView *scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    scrollview.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height *2);
    
    
    
    
    self.imageView.backgroundColor = [UIColor blackColor];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenRect.size.width, screenRect.size.height)];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.backgroundColor = [UIColor clearColor];
    
    //この画像を直接Parseに入れられるはず
    self.imageView.image = self.image;
    [scrollview addSubview:self.imageView];
    scrollview.backgroundColor = [UIColor whiteColor];
    
    
    
    // button to quit taking photos
    self.quitButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.quitButton.frame = CGRectMake(10, 10, 21.0f + 20.0f, 21.0f + 20.0f);
    self.quitButton.tintColor = [UIColor whiteColor];
    [self.quitButton setImage:[UIImage imageNamed:@"whiteCancel.png"] forState:UIControlStateNormal];
    self.quitButton.imageEdgeInsets = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
    [self.quitButton addTarget:self action:@selector(quitButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [scrollview addSubview:self.quitButton];
    
    //Change textfield design over here
    self.clothesNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(75, self.imageView.height+10, self.view.bounds.size.width-90, 30)];
    self.clothesNameTextField.borderStyle = UITextBorderStyleBezel;
    self.clothesNameTextField.textColor = [UIColor blackColor];
    self.clothesNameTextField.placeholder = @"Clothes name";
    [scrollview addSubview:self.clothesNameTextField];
    [self.clothesNameTextField setDelegate:self];
    
    //Add brand tags
    int brandTagPositionHeight = 60;
    UILabel *hashTagLabel = [[UILabel alloc]initWithFrame: CGRectMake(5, self.imageView.height + brandTagPositionHeight, 60, 40)];
    hashTagLabel.text = @"Brand";
    hashTagLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
    [scrollview addSubview:hashTagLabel];
    
    TLTagsControl *brandTag = [[TLTagsControl alloc]initWithFrame:CGRectMake(65, self.imageView.height + brandTagPositionHeight + 5, self.view.bounds.size.width - 70, 30)];
    [scrollview addSubview:brandTag];
    
    //Add Tags
    //
    int tagPositionHeight = 100;
    UILabel *tagLabel = [[UILabel alloc]initWithFrame: CGRectMake(5, self.imageView.height + tagPositionHeight, 30, 30)];
    tagLabel.text = @"#";
    tagLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:25];
    [scrollview addSubview:tagLabel];
    
    TLTagsControl *tag = [[TLTagsControl alloc]initWithFrame:CGRectMake(40, self.imageView.height + tagPositionHeight + 2, self.view.bounds.size.width - 25, 30)];
    [scrollview addSubview:tag];
    
    
    //Season information
    
    self.uploadButton = [UIButton buttonWithType:UIButtonTypeSystem];
    int uploadButtonHeight = 50;
    int uploadButtonWidth = self.view.bounds.size.width;
    [self.uploadButton setFrame:CGRectMake(0, self.view.bounds.size.height-0-uploadButtonHeight, uploadButtonWidth, uploadButtonHeight)];
    
    [self.uploadButton setTitle:@"UPLOAD" forState:UIControlStateNormal];
    [self.uploadButton addTarget:self action:@selector(uploadImage:)forControlEvents:UIControlEventTouchDown];
    UIColor *btnColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5];
    self.uploadButton.backgroundColor = btnColor;
    [scrollview addSubview:self.uploadButton];
    
    [self.view addSubview:scrollview];
}

-(void)uploadImage:(UIButton*)button{
    NSString *clothesName = self.clothesNameTextField.text;
    // ここでimageをparseにアップロードする
    NSLog(@"upload");
    NSLog(@"%@,and %@", clothesName, self.image);
    

    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:YES forKey:@"originFromUploadOfImagePreviewVCKey"];
    
    if (self.imageView.image == NULL) {
        NSLog(@"error");
    }else{
        [self activityIndicator];
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
                    [self backToCollectionView];
                }
            } else {
                // Handle error
                NSLog(@"ERROR");
                [self showError];
            }
        }];
    }
    
    
    
}

-(void)quitButtonPressed:(UIButton*)button{
    [self dismissViewControllerAnimated:YES completion:nil];

}

-(void)backToCollectionView{
    [self dismissViewControllerAnimated:NO completion:nil];
    // NSUserDefaultsの取得
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:YES forKey:@"photoVCtoVCKey"];
    
}

- (void)showError{
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    
    [alert showError:self title:@"Error"
            subTitle:@"An error occured. Please check the Internet connection."
    closeButtonTitle:@"OK" duration:0.0f];
    
    // 「ud」というインスタンスをつくる。
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    // OKボタンを押した時に、Homeに戻るようにする
    [ud setInteger:2 forKey:@"closeAlertKey"];
    [ud removeObjectForKey:@"closeAlertKeyNote"];
    //        SCLAlertView().showError(self, title: kErrorTitle, subTitle: kSubtitle)
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.1f
                                                      target:self
                                                    selector:@selector(performSegueToHome:)
                                                    userInfo:nil
                                                     repeats:YES
                      ];
    
    
}

-(void)performSegueToHome:(NSTimer*)timer{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    int udId = (int)[ud integerForKey:@"closeAlertKeyNote"];
    if (udId == 1) {
        [ud removeObjectForKey:@"closeAlertKeyNote"];
        [ud removeObjectForKey:@"closeAlertKey"];
        [self backToCollectionView];
    }
    
}


- (void)activityIndicator{
    self.uploadButton.enabled = NO;
    // UIActivityIndicatorViewのインスタンス化
    CGRect rect = CGRectMake(0, 0, 100, 100);
    UIActivityIndicatorView *indicator =
    [[UIActivityIndicatorView alloc]initWithFrame:rect];
    
    // 位置を指定
    indicator.center = self.view.center;
    
    // アクティビティインジケータのスタイルをセット
    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    
    // UIActivityIndicatorViewのインスタンスをビューに追加
    [self.view addSubview:indicator];
    
    // くるくるを表示
    [indicator startAnimating];
    
    // くるくるしているか?
    //    if (indicator.isAnimating) { // yes
    //        // くるくるを止める
    //        [indicator stopAnimating];
    //    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.clothesNameTextField) {
        [textField resignFirstResponder];
    }
    return YES;
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
