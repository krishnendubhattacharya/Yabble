//
//  SignUpController.h
//  Yabble
//
//  Created by National It Solution on 14/01/15.
//  Copyright (c) 2015 Suman's. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpController : UIViewController<UITextFieldDelegate>
{
    IBOutlet UITextField *tfEmail;   //text field for email
    IBOutlet UITextField *tfPassword;  //text field for password
     IBOutlet UITextField *tfConfirmPassword;  //text field for confirm password
    IBOutlet UITextField *tfUserName;  //text field for username
   
}

-(IBAction)btnBackPressed:(id)sender;  //action to back previous page
-(IBAction)btnSignUpPressed:(id)sender; //action for signup

@end
