//
//  HomeController.h
//  Yabble
//
//  Created by National It Solution on 14/01/15.
//  Copyright (c) 2015 Suman's. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>


@interface HomeController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,CLLocationManagerDelegate>
{
    IBOutlet UILabel *lblTotalYabs;   //label showing tatal yabs
    IBOutlet UILabel *lblTotalYabsSetting;  //label showing total yabs in menu
    IBOutlet UITableView *tblHome;   //table showing yabs listing

    NSMutableArray *arrYabs; //array of yabs after getyabs method called
    
    IBOutlet UIView *viewSettings;  //view for menu
    IBOutlet UILabel *lblChatCount; // label showing total chat count
    IBOutlet UIImageView *imgProfile; //image showing profile image
    IBOutlet UILabel *lblName; //label showing user name
    IBOutlet UILabel *lblSlider; //label in menu showing yeabreach
    
    IBOutlet UISlider *sliderDistance; //slider in menu for yeabreach
    
    CLLocationManager *locationManager;
    CLLocationCoordinate2D coordinate;
    
    NSTimer *t;   //timer for update user position
    NSTimer *t1;  //timer for get yabs
}
@property(strong,nonatomic)UIRefreshControl *refreshControl;
@property (nonatomic, assign) CGPoint lastContentOffset;

-(IBAction)btnMenuHomePressed:(id)sender;  // action to display menu page
-(IBAction)btnMenuSettingsPressed:(id)sender; //action to hide menu page
-(IBAction)btnNewPostPressed:(id)sender; //action to go new post page
-(IBAction)btnChatPressed:(id)sender;
-(IBAction)sliderValueChanged:(id)sender; //slider action when changing slider value


-(IBAction)btnSettingsPressed:(id)sender; //action to go to settings page
-(IBAction)btnEditProfilePressed:(id)sender; //action to go to profile page

@end
