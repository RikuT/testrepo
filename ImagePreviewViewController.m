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
    self.clothesNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(40, self.imageView.height+15, self.view.bounds.size.width-60, 30)];
    self.clothesNameTextField.borderStyle = UITextBorderStyleBezel;
    self.clothesNameTextField.textColor = [UIColor blackColor];
    self.clothesNameTextField.placeholder = @"Clothes name";
    self.clothesNameTextField.font = [UIFont fontWithName:@"HelveticaNeue" size:18];
    [scrollview addSubview:self.clothesNameTextField];
    [self.clothesNameTextField setDelegate:self];
    
    //TextView for clothes description
    int textViewPositionHeight = 60;
    clothesDesciptionTextView = [[UITextView alloc]initWithFrame:CGRectMake(40, self.imageView.height + textViewPositionHeight, self.view.frame.size.width - 45, 90)];
    clothesDesciptionTextView.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
    clothesDesciptionTextView.backgroundColor = [UIColor grayColor];
    clothesDesciptionTextView.delegate = self;
    textViewPlaceHolder = @"More details (ex. Occasion you wore this...)";
    clothesDesciptionTextView.text = textViewPlaceHolder;
    clothesDesciptionTextView.textColor = [UIColor lightGrayColor];
    [scrollview addSubview:clothesDesciptionTextView];
    UIImage *detailIconImg = [UIImage imageNamed:@"detailsIcon"];
    UIImageView *detailIconView = [[UIImageView alloc] initWithImage: detailIconImg];
    detailIconView.frame = CGRectMake(1, self.imageView.height + textViewPositionHeight, 31, 31);
    [scrollview addSubview:detailIconView];
    
    //Add brand tags
    int brandTagPositionHeight = 170;
    UILabel *hashTagLabel = [[UILabel alloc]initWithFrame: CGRectMake(5, self.imageView.height + brandTagPositionHeight, 60, 40)];
    hashTagLabel.text = @"Brand";
    hashTagLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
    [scrollview addSubview:hashTagLabel];
    
    brandTag = [[TLTagsControl alloc]initWithFrame:CGRectMake(65, self.imageView.height + brandTagPositionHeight + 5, self.view.bounds.size.width - 150, 30)];
    brandTag.mode = TLTagsControlModeList;
    [scrollview addSubview:brandTag];
    UIButton *brandAddButt = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 90, self.imageView.height + brandTagPositionHeight + 5, 90, 30)];
    brandAddButt.backgroundColor = [UIColor whiteColor];
    brandAddButt.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    [brandAddButt setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [brandAddButt setTitle:@"Add brand" forState:UIControlStateNormal];
    [brandAddButt addTarget:self action:@selector(brandButtTapped:) forControlEvents:UIControlEventTouchUpInside];
    [scrollview addSubview:brandAddButt];

    
    //Add Tags
    //
    int tagPositionHeight = 210;
    UILabel *tagLabel = [[UILabel alloc]initWithFrame: CGRectMake(5, self.imageView.height + tagPositionHeight, 30, 30)];
    tagLabel.text = @"#";
    tagLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:25];
    [scrollview addSubview:tagLabel];
    
    miscTag = [[TLTagsControl alloc]initWithFrame:CGRectMake(40, self.imageView.height + tagPositionHeight + 2, self.view.bounds.size.width - 25, 30)];
    [scrollview addSubview:miscTag];
    
    
    //Season information
    int seasonPositionHeight = 250;
    seasonTextF = [[UITextField alloc] initWithFrame:CGRectMake(40, self.imageView.height + seasonPositionHeight, self.view.bounds.size.width - 45, 30)];
    seasonTextF.font = [UIFont fontWithName:@"HelveticaNeue" size:18];
    seasonTextF.delegate = self;
    seasonTextF.placeholder = @"Enter season";
    seasonTextF.backgroundColor = [UIColor grayColor];
    [scrollview addSubview:seasonTextF];
    UIImage *calendarIconImg = [UIImage imageNamed:@"calendarIcon"];
    UIImageView *calendarIconView = [[UIImageView alloc] initWithImage: calendarIconImg];
    calendarIconView.frame = CGRectMake(3, self.imageView.height + seasonPositionHeight - 1, 28, 30);
    [scrollview addSubview:calendarIconView];
    
    /*
     myPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0 , 320, 200)];
     seasonArray = @[@"Spring", @"Summer", @"Fall", @"Winter"];
     myPickerView.dataSource = self;
     myPickerView.delegate = self;
     myPickerView.showsSelectionIndicator = YES;
     [self.view addSubview:myPickerView];
     */
    
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
    
    UITapGestureRecognizer* tapBackground = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    [tapBackground setNumberOfTapsRequired:1];
    [self.view addGestureRecognizer:tapBackground];
}

//////////////////////////

//ここのボタンをタップしたらBrandSearchTableControllerに行けるようにしたい。
-(void)brandButtTapped:(UIButton*)button{
    // ここに何かの処理を記述する
    
    NSLog(@"brandbuttTapped");
    [self performSegueWithIdentifier:@"imagePreviewVCtoBrandSearchVC" sender:self];
    // show the image
    // *imageVC = [[BrandSearchTableController alloc] initWithImage:image];
    //[self presentViewController:imageVC animated:YES completion:nil];
    
}


// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return seasonArray.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return seasonArray[row];
}

// Catpure the picker view selection
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    // This method is triggered whenever the user makes a change to the picker selection.
    // The parameter named row and component represents what was selected.
    NSString *str = [seasonArray objectAtIndex:row];
    NSLog(@"season is %@", str);
    seasonTextF.text = str;
    
}

// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    int sectionWidth = 300;
    
    return sectionWidth;
    
}
////////////////


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
                    posts[@"season"] = seasonTextF.text;
                    posts[@"Tags"] = miscTagArray;
                    posts[@"brandTag"] = brandTagArray;
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



- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if ([textField isEqual:seasonTextF]) {
        [myPickerView removeFromSuperview];
        //For displaying pickerView when season text field was selected
        myPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height , 320, 170)];
        seasonArray = @[@"Spring", @"Summer", @"Fall", @"Winter"];
        myPickerView.dataSource = self;
        myPickerView.delegate = self;
        myPickerView.showsSelectionIndicator = YES;
        //[self.view addSubview:myPickerView];
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:.50];
        myPickerView.center = CGPointMake(myPickerView.center.x, myPickerView.center.y - 170);
        //[UIView setAnimationDelegate:self];
        [self.view addSubview:myPickerView];
        
        [UIView commitAnimations];
        return NO;
        
    }else{
    }
    
    return YES;
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
        textView.textColor = [UIColor blackColor]; //optional
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
    
    self.imageView.frame = self.view.contentBounds;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
