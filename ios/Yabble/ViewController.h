//
//  ViewController.h
//  Yabble
//
//  Created by National It Solution on 14/01/15.
//  Copyright (c) 2015 Suman's. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>


@interface ViewController : UIViewController<UITextFieldDelegate,CLLocationManagerDelegate>
{
    IBOutlet UITextField *tfUserName; // text field for username
    IBOutlet UITextField *tfPassword; //text field for password
    
    
    IBOutlet UITextField *tfEmailForgot;  //text field for email for forgot password
    
    
    IBOutlet UIView *viewForgot;         //view pop up when click forgot button
    CLLocationManager *locationManager;
    CLLocationCoordinate2D coordinate;
}

-(IBAction)btnLogInPressed:(id)sender;  //login action
-(IBAction)btnSignUpPressed:(id)sender; //action for navigation to sign up page
-(IBAction)btnForgotPasswordPressed:(id)sender;  //action for forgot password
-(IBAction)btnSendPressed:(id)sender; //action in forgotpassword to send password to user mail

@end

