//
//  ProfileController.h
//  Yabble
//
//  Created by National It Solution on 17/01/15.
//  Copyright (c) 2015 Suman's. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileController : UIViewController<UIScrollViewDelegate>
{
    IBOutlet UIImageView *imgProfile; //uiimageview displaying user peorfile picture
    IBOutlet UILabel *lblName;  //uilabel showing user name
    IBOutlet UILabel *lblUserName; //uilabel showing user username
    IBOutlet UILabel *lblBio;  //uilabel showing bio of user
    IBOutlet UILabel *lblTotalYab; //uilabel showing total yab
    
    IBOutlet UITableView *tblMyYab; //uitableview displaying listing of logged in user's yab
    
    NSMutableArray *arrMyYabs; //array for my yabs
    
    
    
    IBOutlet UIImageView *imgSelectYabble; //selection image for yabble icon
    IBOutlet UIImageView *imgSelectPhoto;  //selection image for photo
    IBOutlet UIImageView *imgSelectChat;  //selection image for chat
    
    IBOutlet UIScrollView *scrollPhoto;
    NSMutableArray *arrPhoto;
}
@property(strong,nonatomic)IBOutlet UIScrollView *scrollView;

@property(strong,nonatomic)NSString *strId;

-(IBAction)btnBackPresed:(id)sender; //action for back to previous page
-(IBAction)btnSearchPressed:(id)sender; //action for search
-(IBAction)btnYabPlusPressed:(id)sender; //action when click yab plus icon
-(IBAction)btnYabblesPressed:(id)sender;
-(IBAction)btnPhotoPressed:(id)sender; //action when photo button click
-(IBAction)btnChatPressed:(id)sender; // action when chat button click

-(IBAction)btnEditPressed:(id)sender; //action to go prifile edit page

@end
