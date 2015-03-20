//
//  SettingsController.h
//  Yabble
//
//  Created by National It Solution on 17/01/15.
//  Copyright (c) 2015 Suman's. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsController : UIViewController
{
    IBOutlet UISlider *sliderYabreach; //uislider for yabreach
    IBOutlet UILabel *lblYabreach; //label showing yabrech slider value
    IBOutlet UISwitch *switchDistance; //switch for distance state(on/off)
    
}

-(IBAction)btnBackPressed:(id)sender; //back to previous page
-(IBAction)sliderYabreachValueChanged:(id)sender; //action for yabreach slider value changed
-(IBAction)switchDistanceValueChanged:(id)sender; //action for destance switch value changed
-(IBAction)btnLogOutPressed:(id)sender; //log out action
@end
