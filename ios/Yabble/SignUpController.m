//
//  SignUpController.m
//  Yabble
//
//  Created by National It Solution on 14/01/15.
//  Copyright (c) 2015 Suman's. All rights reserved.
//

#import "SignUpController.h"
#import "AppDelegate.h"


@interface SignUpController ()

@end

@implementation SignUpController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (IS_IPHONE_5) {
        textField.returnKeyType=UIReturnKeyDone;
        if (textField.frame.origin.y>=250) {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationBeginsFromCurrentState:YES];
            self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-textField.frame.origin.y+250 ,self.view.frame.size.width, self.view.frame.size.height);
            [UIView commitAnimations];
        }
    }
    else{
        textField.returnKeyType=UIReturnKeyDone;
        if (textField.frame.origin.y>=150) {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationBeginsFromCurrentState:YES];
            self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-textField.frame.origin.y+150 ,self.view.frame.size.width, self.view.frame.size.height);
            [UIView commitAnimations];
        }
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationBeginsFromCurrentState:YES];
    self.view .frame = CGRectMake(self.view.frame.origin.x, 0,
                                  self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
    
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField==tfEmail) {
        if ([self validateEmail:string] || [self validateEmail:textField.text]) {
            tfEmail.layer.borderColor=[UIColor whiteColor].CGColor;
            tfEmail.layer.borderWidth= 1.0f;
            tfEmail.layer.masksToBounds=YES;
        }
        else{
            tfEmail.layer.borderColor=[UIColor redColor].CGColor;
            tfEmail.layer.borderWidth= 1.0f;
            tfEmail.layer.masksToBounds=YES;
        }
    }
    else if (textField==tfUserName){
        if (textField.text.length==0) {
            tfUserName.layer.borderColor=[UIColor redColor].CGColor;
            tfUserName.layer.borderWidth= 1.0f;
            tfUserName.layer.masksToBounds=YES;
        }
        else{
            tfUserName.layer.borderColor=[UIColor whiteColor].CGColor;
            tfUserName.layer.borderWidth= 1.0f;
            tfUserName.layer.masksToBounds=YES;
        }
    }
    else if (textField==tfPassword){
        if (textField.text.length==0) {
            tfPassword.layer.borderColor=[UIColor redColor].CGColor;
            tfPassword.layer.borderWidth= 1.0f;
            tfPassword.layer.masksToBounds=YES;
        }
        else{
            tfPassword.layer.borderColor=[UIColor whiteColor].CGColor;
            tfPassword.layer.borderWidth= 1.0f;
            tfPassword.layer.masksToBounds=YES;
        }
    }
    else if (textField==tfConfirmPassword){
        if (textField.text.length==0) {
            tfConfirmPassword.layer.borderColor=[UIColor redColor].CGColor;
            tfConfirmPassword.layer.borderWidth= 1.0f;
            tfConfirmPassword.layer.masksToBounds=YES;
        }
        else{
            tfConfirmPassword.layer.borderColor=[UIColor whiteColor].CGColor;
            tfConfirmPassword.layer.borderWidth= 1.0f;
            tfConfirmPassword.layer.masksToBounds=YES;
        }
    }
    
    return YES;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [tfEmail resignFirstResponder];
    [tfUserName resignFirstResponder];
    [tfPassword resignFirstResponder];
    [tfConfirmPassword resignFirstResponder];
}
-(IBAction)btnBackPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)btnSignUpPressed:(id)sender{
    //make datastring for signup
    if ([self displayAlert]) {
        
        deviceTokenId=@"123456";
        NSString *dataString = [NSString stringWithFormat:@"authkey=%@&email=%@&password=%@&device_token_id=%@&uname=%@",AUTH,tfEmail.text,tfPassword.text,@"123456",tfUserName.text];
        [self serviceCall:@"signup":dataString];
    }
    
}

-(BOOL)displayAlert{
    if (tfEmail.text.length==0) {
        tfEmail.layer.borderColor=[UIColor redColor].CGColor;
        tfEmail.layer.borderWidth= 1.0f;
        tfEmail.layer.masksToBounds=YES;
        return NO;
    }
    if (![self validateEmail:[tfEmail text]])
    {
        tfEmail.layer.borderColor=[UIColor redColor].CGColor;
        tfEmail.layer.borderWidth= 1.0f;
        tfEmail.layer.masksToBounds=YES;
        return NO;
    }
    if (tfUserName.text.length==0) {
        tfUserName.layer.borderColor=[UIColor redColor].CGColor;
        tfUserName.layer.borderWidth= 1.0f;
        tfUserName.layer.masksToBounds=YES;
        return NO;
    }
    if (tfPassword.text.length==0) {
        tfPassword.layer.borderColor=[UIColor redColor].CGColor;
        tfPassword.layer.borderWidth= 1.0f;
        tfPassword.layer.masksToBounds=YES;
        return NO;
    }
    
    if (tfConfirmPassword.text.length==0) {
        tfConfirmPassword.layer.borderColor=[UIColor redColor].CGColor;
        tfConfirmPassword.layer.borderWidth= 1.0f;
        tfConfirmPassword.layer.masksToBounds=YES;
        return NO;
    }
    if (![tfPassword.text isEqualToString:tfConfirmPassword.text]) {
        tfPassword.layer.borderColor=[UIColor redColor].CGColor;
        tfPassword.layer.borderWidth= 1.0f;
        tfPassword.layer.masksToBounds=YES;
        
        tfConfirmPassword.layer.borderColor=[UIColor redColor].CGColor;
        tfConfirmPassword.layer.borderWidth= 1.0f;
        tfConfirmPassword.layer.masksToBounds=YES;
        return NO;
    }
    
    return YES;
    
}

- (BOOL)validateEmail:(NSString *)emailStr
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+]+@[A-Za-z0-9.]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailStr];
}


-(void)serviceCall:(NSString*)serviceName :(NSString*)DataString
{
    if([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable)
    {
        [MMNeedMethods showNetworkError];
        return;
    }
    app.networkActivityIndicatorVisible = YES;
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    [sessionConfiguration setAllowsCellularAccess:YES];
    [sessionConfiguration setHTTPAdditionalHeaders:@{ @"Accept" : @"application/json" }];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    
    //make base url for signup
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,SIGNUP_URL]];
    
    // Configure the Request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:[NSString stringWithFormat:@"%@=%@", strSessName, strSessVal] forHTTPHeaderField:@"Cookie"];
    
    request.HTTPBody = [DataString dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPMethod = @"POST";
    
    NSLog(@"View Controller registration Data String: %@",DataString);
    // post the request and handle response
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                          {
                                              // Handle the Response
                                              if(error)
                                              {
                                                  NSLog(@"%@",[NSString stringWithFormat:@"Connection failed: %@", [error description]]);
                                                  
                                                  // Update the View
                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                      
                                                      // Hide the Loader
                                                      [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] delegate].window animated:YES];
                                                      
                                                      [MMNeedMethods showConnectionError];
                                                  });
                                                  return;
                                              }
                                              NSArray * cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:request.URL];
                                              for (NSHTTPCookie * cookie in cookies)
                                              {
                                                  NSLog(@"%@=%@", cookie.name, cookie.value);
                                                  strSessName=cookie.name;
                                                  strSessVal=cookie.value;
                                                  
                                                  NSLog(@"%@=%@", strSessName, strSessVal);
                                                  // Here you can store the value you are interested in for example
                                              }
                                              
                                              
                                              
                                              NSString *retVal = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                              
                                              NSLog(@"Dict: %@",retVal);
                                              
                                              // Update the View
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] delegate].window animated:YES];
                                                  app.networkActivityIndicatorVisible = NO;
                                                  if([serviceName isEqualToString:@"signup"])
                                                  {
                                                      NSMutableDictionary *dict=[[NSMutableDictionary alloc] initWithDictionary:[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil]];
                                                      
                                                      if ([[dict valueForKey:@"Ack"] integerValue]==1) {
                                                          
                                                          NSUserDefaults *prefs=[NSUserDefaults standardUserDefaults];
                                                          [prefs setObject:[[[dict objectForKey:@"userdetail"] valueForKey:@"id"] valueForKey:@"$id"] forKey:@"userId"];
                                                          [prefs setObject:[[dict objectForKey:@"userdetail"] valueForKey:@"username"] forKey:@"user"];
                                                          [prefs synchronize];
                                                          
                                                          NSLog(@"id=%@",[prefs valueForKey:@"userId"]);
                                                          NSLog(@"username=%@",[prefs valueForKey:@"user"]);

                                                          @try {
                                                              nameUser=@"";
                                                              userName=[[dict objectForKey:@"userdetail"] valueForKey:@"username"];
                                                              
                                                          }
                                                          @catch (NSException *exception) {
                                                              nameUser=@"";
                                                          }
                                                          //go to home page
                                                          
                                                          UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                                          UIViewController *vc=[storyboard instantiateViewControllerWithIdentifier:@"HomeController"];
                                                          [self.navigationController pushViewController:vc animated:YES];
                                                          
                                                      }
                                                  }
                                              });
                                          }];
    
    // Initiate the Request
    [postDataTask resume];
    
}

@end
