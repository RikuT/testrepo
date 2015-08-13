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
//#import "Stylist-Swift.h"
//#import "BrandSearchTableController.swift"
//#import "UIImage+Crop.h"

@interface ImagePreviewViewController ()
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIButton *quitButton;
@property (strong, nonatomic) UIButton *uploadButton;
@property (strong, nonatomic) UITextField *clothesNameTextField;
@property (strong, nonatomic) UILabel *detailLabel;

//@property (strong, nonatomic) NSMutableArray *tagArray;

@end

@implementation ImagePreviewViewController

/////*******ADD HIDE ACTIVITY INDICATOR
///////Dismiss other type of keyboard when another one appears

- (instancetype)initWithImage:(UIImage *)image {
    self = [super initWithNibName:nil bundle:nil];
    if(self) {
        _image = image;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:@"BRAND" forKey:@"brandNameKey"];
    brandArray = [NSMutableArray array];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenRect.size.width, screenRect.size.height)];
    backgroundView.contentMode = UIViewContentModeScaleAspectFit;
    backgroundView.image = self.image;
    
    [self.view addSubview:backgroundView];
    
    
    //ブラースタイルの決定
    UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    //VisualEffectViewにVisualEffectを設定
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    //VisualEffectViewを_blurViewと同じサイズに設定
    effectView.frame = self.view.bounds;
    //_blurViewにVisualEffectViewを追加
    [backgroundView addSubview:effectView];

    
    self.imageView = [[UIImageView alloc] initWithImage:self.image];
    float pictAspect = (float)self.image.size.height / self.image.size.width;
    self.imageView.frame = CGRectMake(0, 0, screenRect.size.width, (screenRect.size.width) * pictAspect);
    self.imageView.backgroundColor = [UIColor blackColor];
    
    float scrollViewVisibleY = (self.view.frame.size.height / 2) - 15;
    scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    scrollview.contentSize = CGSizeMake(self.view.frame.size.width, (self.view.frame.size.height * 1.53)-20);

    [scrollview addSubview:self.imageView];
    scrollview.backgroundColor = [UIColor clearColor];

    

    
    

    // button to quit taking photos
    self.quitButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.quitButton.frame = CGRectMake(5, 5, 21.0f + 20.0f, 21.0f + 20.0f);
    self.quitButton.tintColor = [UIColor whiteColor];
    [self.quitButton setImage:[UIImage imageNamed:@"whiteCancel.png"] forState:UIControlStateNormal];
    self.quitButton.imageEdgeInsets = UIEdgeInsetsMake(13.0f, 13.0f, 13.0f, 13.0f);
    [self.quitButton addTarget:self action:@selector(quitButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [scrollview addSubview:self.quitButton];

    
    //Setting upload button
    self.uploadButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.uploadButton.frame = CGRectMake(self.view.frame.size.width - 46, 5, 21.0f + 20.0f, 21.0f + 20.0f);
    self.uploadButton.tintColor = [UIColor whiteColor];
    [self.uploadButton setImage:[UIImage imageNamed:@"Checkmark-50"] forState:UIControlStateNormal];
    self.uploadButton.imageEdgeInsets = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
    [self.uploadButton addTarget:self action:@selector(uploadImage:)forControlEvents:UIControlEventTouchUpInside];
    [scrollview addSubview:self.uploadButton];
    
    float containerViewY = (self.view.frame.size.height / 2) - 15;
    UIView *whiteContainerView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.height-20, self.view.width, self.view.height / 1.93)];
    whiteContainerView.backgroundColor = [UIColor whiteColor];
    [scrollview addSubview:whiteContainerView];
    
    
    self.detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 20)];
    self.detailLabel.text = @"e d i t  d e t a i l s";
    self.detailLabel.font = [UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:17];
    self.detailLabel.textAlignment = NSTextAlignmentCenter;
    self.detailLabel.textColor = [UIColor whiteColor];
    self.detailLabel.backgroundColor = [UIColor colorWithRed:0 green:0.698 blue:0.792 alpha:1];
    [whiteContainerView addSubview:self.detailLabel];
    
    float buttonLocationH = 0;
    //Change textfield design over here
    self.clothesNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(40, buttonLocationH+30, self.view.bounds.size.width-60, 30)];
    self.clothesNameTextField.textColor = [UIColor darkGrayColor];
    self.clothesNameTextField.placeholder = @"Clothes name";
    self.clothesNameTextField.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
    [whiteContainerView addSubview:self.clothesNameTextField];
    [self.clothesNameTextField setDelegate:self];
    
    UILabel *grayLine = [[UILabel alloc]initWithFrame:CGRectMake(0, buttonLocationH + 30 + 30 + 5, self.view.frame.size.width, 0.3)];
    grayLine.backgroundColor = [UIColor lightGrayColor];
    [whiteContainerView addSubview:grayLine];
    
    //TextView for clothes description
    int textViewPositionHeight = 75;
    clothesDesciptionTextView = [[UITextView alloc]initWithFrame:CGRectMake(40, buttonLocationH + textViewPositionHeight, self.view.frame.size.width - 45, 90)];
    clothesDesciptionTextView.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
    clothesDesciptionTextView.backgroundColor = [UIColor clearColor];
    clothesDesciptionTextView.delegate = self;
    textViewPlaceHolder = @"More details (ex. Occasion you wore this...)";
    clothesDesciptionTextView.text = textViewPlaceHolder;
    clothesDesciptionTextView.textColor = [UIColor lightGrayColor];
    [whiteContainerView addSubview:clothesDesciptionTextView];
    UIImage *detailIconImg = [UIImage imageNamed:@"detailsIcon"];
    UIImageView *detailIconView = [[UIImageView alloc] initWithImage: detailIconImg];
    detailIconView.frame = CGRectMake(1, buttonLocationH + textViewPositionHeight + 6, 29, 29);
    [whiteContainerView addSubview:detailIconView];
    
    UILabel *grayLine1 = [[UILabel alloc]initWithFrame:CGRectMake(0, clothesDesciptionTextView.frame.origin.y + clothesDesciptionTextView.frame.size.height + 5, self.view.frame.size.width, 0.3)];
    grayLine1.backgroundColor = [UIColor lightGrayColor];
    [whiteContainerView addSubview:grayLine1];
    

    //Add brand tags
    int brandTagPositionHeight = 170;
    UILabel *hashTagLabel = [[UILabel alloc]initWithFrame: CGRectMake(5, buttonLocationH + brandTagPositionHeight, 60, 40)];
    hashTagLabel.text = @"Brand";
    hashTagLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
    [whiteContainerView addSubview:hashTagLabel];
    
    brandTag = [[TLTagsControl alloc]initWithFrame:CGRectMake(62, buttonLocationH + brandTagPositionHeight + 5, self.view.bounds.size.width - 100, 30)];
    brandTag.mode = TLTagsControlModeList;
    [whiteContainerView addSubview:brandTag];
    UIButton *brandAddButt = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 45, buttonLocationH + brandTagPositionHeight + 5, 40, 30)];
    brandAddButt.backgroundColor = [UIColor whiteColor];
    brandAddButt.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    [brandAddButt setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [brandAddButt setTitle:@"Add" forState:UIControlStateNormal];
    [brandAddButt addTarget:self action:@selector(brandButtTapped:) forControlEvents:UIControlEventTouchUpInside];
    [whiteContainerView addSubview:brandAddButt];
    
    UILabel *grayLine2 = [[UILabel alloc]initWithFrame:CGRectMake(0, brandTag.frame.origin.y + brandTag.frame.size.height + 5, self.view.frame.size.width, 0.3)];
    grayLine2.backgroundColor = [UIColor lightGrayColor];
    [whiteContainerView addSubview:grayLine2];
    
    
    
    //Add Tags
    //
    int tagPositionHeight = 213;
    UILabel *tagLabel = [[UILabel alloc]initWithFrame: CGRectMake(5, buttonLocationH + tagPositionHeight, 30, 30)];
    tagLabel.text = @"#";
    tagLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:25];
    [whiteContainerView addSubview:tagLabel];
    
    miscTag = [[TLTagsControl alloc]initWithFrame:CGRectMake(40, buttonLocationH + tagPositionHeight + 2, self.view.bounds.size.width - 25, 30)];
    [whiteContainerView addSubview:miscTag];
    
    
    UILabel *grayLine3 = [[UILabel alloc]initWithFrame:CGRectMake(0,  miscTag.frame.origin.y + miscTag.frame.size.height + 5, self.view.frame.size.width, 0.3)];
    grayLine3.backgroundColor = [UIColor lightGrayColor];
    [whiteContainerView addSubview:grayLine3];
    
    
    //Season information
    int seasonPositionHeight = 258;
/*
    let seasonArray: NSArray = ["Spring", "Summer", "Fall", "Winter"]
    seasonSegment = UISegmentedControl(items: seasonArray as [AnyObject])
    seasonSegment.tintColor = UIColor.lightGrayColor()
    seasonSegment.frame = CGRectMake(45, heightInWhiteView + seasonPositionHeight + 3, self.view.bounds.size.width - 50, 27)
*/
    NSArray *seasonArray = [NSArray arrayWithObjects: @"Spring", @"Summer", @"Fall", @"Winter" , nil];
    seasonSegment = [[UISegmentedControl alloc]initWithItems:seasonArray];
    seasonSegment.frame = CGRectMake(45, buttonLocationH + seasonPositionHeight + 2, self.view.frame.size.width - 50, 27);
    seasonSegment.tintColor = [UIColor lightGrayColor];
    [whiteContainerView addSubview:seasonSegment];
    UIImage *calendarIconImg = [UIImage imageNamed:@"calendarIcon"];
    UIImageView *calendarIconView = [[UIImageView alloc] initWithImage: calendarIconImg];
    calendarIconView.frame = CGRectMake(3, buttonLocationH + seasonPositionHeight - 1, 28, 30);
    [whiteContainerView addSubview:calendarIconView];
    
    
    /*
     myPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0 , 320, 200)];
     seasonArray = @[@"Spring", @"Summer", @"Fall", @"Winter"];
     myPickerView.dataSource = self;
     myPickerView.delegate = self;
     myPickerView.showsSelectionIndicator = YES;
     [self.view addSubview:myPickerView];
     */
    
    
    

    
    [self.view addSubview:scrollview];
    [self.view bringSubviewToFront:self.uploadButton];
    
    UITapGestureRecognizer* tapBackground = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    [tapBackground setNumberOfTapsRequired:1];
    [self.view addGestureRecognizer:tapBackground];
    
    self.lastVisibleView = scrollview;
    
}

//////////////////////////

//ここのボタンをタップしたらBrandSearchTableControllerに行く。
-(void)brandButtTapped:(UIButton*)button{
    // ここに何かの処理を記述する
    
    NSLog(@"brandbuttTapped");
    NSString * storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"imagePreviewVCtoBrandSearchVC"];
    
    [self presentViewController:vc animated:YES completion:nil];
    //animated can be NO
    
}


-(void) dismissKeyboard:(id)sender
{
    [self.view endEditing:YES];
    [myPickerView removeFromSuperview];
    
}

-(void)uploadImage:(UIButton*)button{
    [self activityIndicator];
    
    NSString *clothesName = self.clothesNameTextField.text;
    // ここでimageをparseにアップロードする
    NSLog(@"upload");
    NSLog(@"%@,and %@", clothesName, self.image);
    
    NSArray *miscTagArray = miscTag.tags;
    NSArray *brandTagArray = brandTag.tags;
    
    if ([clothesDesciptionTextView.text isEqualToString:textViewPlaceHolder]) {
        clothesDesciptionTextView.text = @"";
    }
    
    
    
    
    
    
    
    
    //CHANGE ACTIVITY INDICATOR LOCATION
    //////////////////////////////////////
    
    
    
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:YES forKey:@"originFromUploadOfImagePreviewVCKey"];
    
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
                    posts[@"clothesExplanation"] = clothesDesciptionTextView.text;
                    int seasonSelection = seasonSegment.selectedSegmentIndex;
                    NSString *selectedSeason;
                    if (seasonSelection == 0) {
                        selectedSeason = @"Spring";
                    }else if(seasonSelection == 1){
                        selectedSeason = @"Summer";
                    }else if (seasonSelection == 2){
                        selectedSeason = @"Fall";
                    }else if(seasonSelection == 3){
                        selectedSeason = @"Winter";
                    }else{
                        //Automatically putting in a season when season was not selected manually
                        NSLog(@"season not selected");
                        NSDate *date = [NSDate date];
                        NSCalendar *gregorian = [NSCalendar currentCalendar];
                        NSDateComponents *dateComponents = [gregorian components:(NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear) fromDate:date];
                        NSInteger month = [dateComponents month];
                        if (3 <= month && month <= 5) {
                            selectedSeason = @"Spring";
                        }else if (6 <= month && month <= 8) {
                            selectedSeason = @"Summer";
                        }else if (9 <= month && month <= 11) {
                            selectedSeason = @"Fall";
                        }else{
                            selectedSeason = @"Winter";
                        }
                    }
                    posts[@"season"] = selectedSeason;
                    posts[@"Tags"] = miscTagArray;
                    posts[@"brandTag"] = brandTagArray;
                    NSArray *aggregateTags = [miscTagArray arrayByAddingObjectsFromArray:brandTagArray];
                    posts[@"searchTag"] = [aggregateTags componentsJoinedByString:@" "];
                    //posts[@"tags"] =T
                    [posts saveInBackground];
                    
                    //Setting tags (check if there is an overlapping tag and calculate tag popularity)
                    if (miscTagArray.count != 0) {
                        
                        PFQuery *query = [PFQuery queryWithClassName:@"TagTrend"];
                        NSMutableArray *preexistingTags = [NSMutableArray array];
                        NSMutableArray *preexistingTagId = [NSMutableArray array];
                        NSMutableArray *numPostsArray = [NSMutableArray array];
                        
                        //Saving tags
                        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
                            NSLog(@"tag processing");
                            if (error == nil) {
                                int count = (int)objects.count;
                                for (PFObject *object in objects){
                                    NSString *tagName = [NSString stringWithFormat:@"%@", [object objectForKey:@"TagName"]];
                                    [preexistingTags addObject:tagName];
                                    NSLog(@"tagname %@", tagName);
                                    
                                    NSNumber *numPostsNSNUM = [object objectForKey:@"NumberOfPosts"];
                                    //int numPosts = [numPostsStr intValue];
                                    [numPostsArray addObject:numPostsNSNUM];
                                    NSLog(@"tagNum %@", numPostsNSNUM);
                                    
                                    
                                    //NSLog(@"number of posts %i", numPosts);
                                    NSString *objectId = [NSString stringWithFormat:@"%@", [object objectId]];
                                    [preexistingTagId addObject:objectId];
                                    NSLog(@"tagId %@", objectId);
                                    
                                    
                                    count --;
                                    
                                    if (count == 0) {
                                        
                                        //HAVE TO MAKE SURE THAT IT DOESNT LOOP UNTIL PROCESS DONE
                                        
                                        for (int i = 0; i < miscTagArray.count; i++) {
                                            NSString *tagName = [miscTagArray objectAtIndex:i];
                                            NSString *tagObjectId = [preexistingTagId objectAtIndex:i];
                                            NSNumber *numPosts = [numPostsArray objectAtIndex:i];
                                            BOOL sameTag = [preexistingTags containsObject:tagName];
                                            
                                            if (sameTag == NO){
                                                PFObject* tagPop = [PFObject objectWithClassName:@"TagTrend"];
                                                NSLog(@"NO %@",tagName);
                                                
                                                // NSString *numPostsStr = @"1";
                                                NSNumber *numPosts = @1;
                                                tagPop[@"NumberOfPosts"] = numPosts;
                                                
                                                tagPop[@"TagName"] = tagName;
                                                
                                                [tagPop saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
                                                    if (!error) {
                                                        NSLog(@"success");
                                                    }else{
                                                        NSLog(@"failure");}
                                                }];
                                            }else{
                                                NSUInteger tagIndex = [preexistingTags indexOfObject:tagName];
                                                NSString *sameTagId = [preexistingTagId objectAtIndex:tagIndex];
                                                
                                                PFObject* tagPop = [PFObject objectWithoutDataWithClassName:@"TagTrend" objectId: sameTagId];
                                                NSLog(@"YES %@",tagName);
                                                int tempNumPosts = [numPosts intValue];
                                                tempNumPosts ++;
                                                tagPop[@"NumberOfPosts"] = [NSNumber numberWithInt:tempNumPosts];
                                                [tagPop saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
                                                    if (!error) {
                                                        NSLog(@"success");
                                                        NSLog(@"tag done");
                                                    }else{
                                                        NSLog(@"failure");}
                                                    
                                                }];
                                            }
                                            
                                            
                                        }
                                        NSLog(@"success!!");
                                        [self backToCollectionView];
                                        
                                    }}}}];
                    }else{
                        
                        NSLog(@"success!!");
                        [self backToCollectionView];
                        
                    }
                    
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
    
    /*
     
     
     var container: UIView = UIView()
     container.frame = uiView.frame
     container.center = uiView.center
     container.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
     
     
     */
    [self dismissKeyboard:self];
    
    UIView *container = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    container.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    [self.view addSubview:container];
    
    
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



//For showing placeholder for textView
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:textViewPlaceHolder]) {
        textView.text = @"";
        textView.textColor = [UIColor darkGrayColor]; //optional
    }
    [textView becomeFirstResponder];
}
//For showing placeholder for textView

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = textViewPlaceHolder;
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
    [textView resignFirstResponder];
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
    
   // self.imageView.frame = self.view.contentBounds;
    
}

-(void)viewWillAppear:(BOOL)animated{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *addedBrand = [ud objectForKey:@"brandNameKey"];
    NSLog(@"addedbrand %@", addedBrand);
    
    if ([addedBrand isEqualToString:@"BRAND"]) {
        NSLog(@"no added brand");
    }else{
        BOOL brandArrayContains = [brandArray containsObject:addedBrand];
        if (brandArrayContains == NO) {
            [brandArray addObject:addedBrand];
            NSLog(@"brandArray %@", brandArray);
            brandTag.tags = [brandArray mutableCopy];
            //[self initializeBrandTags];
            [brandTag reloadTagSubviews];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
