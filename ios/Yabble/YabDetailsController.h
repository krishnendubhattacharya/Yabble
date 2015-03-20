//
//  YabDetailsController.h
//  Yabble
//
//  Created by National It Solution on 19/01/15.
//  Copyright (c) 2015 Suman's. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YabDetailsController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UIImageView *imgProfile;  //uiiamgeview showing user profile image
    IBOutlet UILabel *lblName;  //label for user name
    IBOutlet UILabel *lblUserName; // label for user username
    IBOutlet UILabel *lblDescription; //label for yab description
    IBOutlet UILabel *lblDate; //label for yab date
    IBOutlet UILabel *lblLikes; //lbl showing total likes
    IBOutlet UILabel *lblDistance; //lbl showing distance
    
    IBOutlet UITableView *tblComment; //table for comment listing
    IBOutlet UIView *viewDescription; //
    IBOutlet UIView *viewButton;
    
    
    IBOutlet UITextField *tfComment; //textfield for send comment
    NSMutableArray *arrComment; // array of comment
    
    IBOutlet UIView *viewPost; // uiview for comment post
    
}

@property(strong,nonatomic)NSString *yab_id;

-(IBAction)btnBackPressed:(id)sender; //action to back previous page
-(IBAction)btnSearchPressed:(id)sender; //action for search
-(IBAction)btnLikePressed:(id)sender; //action for like yab
-(IBAction)btnChatPressed:(id)sender; //action for chat
-(IBAction)btnDislikePressed:(id)sender; //action for dislike
-(IBAction)btnMutePressed:(id)sender;
-(IBAction)btnAlertPressed:(id)sender;
-(IBAction)btnMenuSettingPressed:(id)sender;
-(IBAction)btnAbbPlusPressed:(id)sender;

-(IBAction)btnPostPressed:(id)sender;//action for post comment
@end
