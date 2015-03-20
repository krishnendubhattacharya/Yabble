//
//  EditProfileController.h
//  Yabble
//
//  Created by National It Solution on 16/01/15.
//  Copyright (c) 2015 Suman's. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import <FacebookSDK/FBDialogs.h>
#import <FacebookSDK/FBLinkShareParams.h>

@interface EditProfileController : UIViewController<UIActionSheetDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate>
{
    UIActionSheet *actnstphoto;
    UIDatePicker *pckrvwStart;  //date picker for date of birth
    
    IBOutlet UITextField *tfName; //text field showing user name
    IBOutlet UITextField *tfUserName; //text field showing user username
    IBOutlet UITextField *tfBio; //textfield showing user's bio
    
    IBOutlet UITextField *tfEmail; //textfield showing users email
    IBOutlet UISegmentedControl *segGender; //uisegment control for gender
    IBOutlet UITextField *tfDateofBirth; //uitextfield showing date of birth
    
    IBOutlet UITextField *facebook;
    IBOutlet UITextField *twitter;
    IBOutlet UITextField *instagram;
    
    
    IBOutlet UIImageView *imgProfile; //uiimageview showing user profile picture
    IBOutlet UILabel *lblName;  //label showing user name
    IBOutlet UILabel *lblUserName; //label showing user username
    IBOutlet UILabel *lblDescription; //label showing description
    IBOutlet UITextView *tvDescription; //text view showing description
    
   
    IBOutlet UIScrollView *scrollView; //scroll view that contains user different text field
    
    
    NSString *strUserName,*strName,*strBio;
    
    
    FBRequestConnection *requestConnection;
}

-(IBAction)btnCrossPressed:(id)sender; //action for previous page
-(IBAction)btnSavePressed:(id)sender;  // action for save user's edited data
-(IBAction)btnProfilePicPressed:(id)sender; //action for changing profile picture

-(IBAction)btnFacebookPressed:(id)sender; //action when facebook button pressed
-(IBAction)btnTwitterPressed:(id)sender; //action when twitter button pressed
-(IBAction)btnInstagramPressed:(id)sender; //action when instagram button pressed

@end
