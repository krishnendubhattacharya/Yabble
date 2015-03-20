//
//  PostAbbController.h
//  Yabble
//
//  Created by National It Solution on 16/01/15.
//  Copyright (c) 2015 Suman's. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RangeSlider.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>



@interface PostAbbController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,CLLocationManagerDelegate>
{
    IBOutlet UILabel *lblName;  //label showing user name
    IBOutlet UILabel *lblUserName;   //label showing user username
    IBOutlet UIImageView *imgProfile;  //uiimageview displaying user peorfile picture
    
    IBOutlet UILabel *lblPlace;  //label showing palce of posting yab
    
    IBOutlet UILabel *tvDescription;  //textview for yab description
    
    IBOutlet UIView *viewSlider;
    RangeSlider *slider;            //Range slider for range of age
    IBOutlet UILabel *lblSliderMin; //label showing minimum age
    IBOutlet UILabel *lblSliderMax;  //label showing maximum age
    
    IBOutlet UISegmentedControl *segType; //segment for selecting type among everybody,male,female
    IBOutlet UISlider *sliderDistance;  //slider for yab showing distance
    IBOutlet UISwitch *switchExpiration; //uiswitch for yab expiration
    IBOutlet UIDatePicker *datePickerExpiration;  // uidatepicker of yab expiration
    
    IBOutlet UILabel *lblDistance; //label showing yab distance
    IBOutlet UILabel *lblExpiration; //label showing date of expiration
    
    IBOutlet UIScrollView *scrollView;
    
    IBOutlet UIButton *btnSendYab;  //uibutton for post yab
    
    
    IBOutlet UITextField *tfSearch;
    IBOutlet UITableView *tblSearch;
    
    IBOutlet UIView *viewDescription;  //uiview which is superview of view description
    IBOutlet UIView *viewType;  //uiview which is superview of segment type
    IBOutlet UIView *viewExpiration; //uiview which is superview of switch expiration
    
    CLLocationManager *locationManager;
    NSMutableArray *arrSearched;
    CLLocationCoordinate2D coordinate;
}

@property(strong,nonatomic) UIImage *img;
@property(strong,nonatomic) NSString *str;

-(IBAction)btnCrossPressed:(id)sender; //action to go back previous page


-(IBAction)switchExpirationValueChanged:(id)sender; //action fires when expiration switch state changed
-(IBAction)sliderDistanceValueChanged:(id)sender;  //action for slider distance value changed
-(IBAction)segmentTypeChanged:(id)sender; //action for segment type value changed
-(IBAction)datePickerValueChanged:(id)sender; //action for expiration  datepicker value changed

-(IBAction)btnSendYabPressed:(id)sender; // action fires when send yab button pressed

@end
