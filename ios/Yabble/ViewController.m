//
//  ViewController.m
//  Yabble
//
//  Created by National It Solution on 14/01/15.
//  Copyright (c) 2015 Suman's. All rights reserved.
//

#import "ViewController.h"
#import "HomeController.h"
#import "SignUpController.h"
#import "AppDelegate.h"

static int timeOut = 0;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];

    [viewForgot setHidden:YES];
    viewForgot.layer.cornerRadius=8.0f;
    viewForgot.layer.borderWidth=4.0f;
    viewForgot.layer.borderColor=[UIColor colorWithRed:232.0/255.0 green:152.0/255.0 blue:49.0/255.0 alpha:1].CGColor;
     coordinate = [self getLocation];
    
    
    NSUserDefaults *prefs=[NSUserDefaults standardUserDefaults];
    NSString *user=[prefs objectForKey:@"user"];
    [prefs synchronize];
    
    if (user==nil || [user isEqualToString:@"N"]) {
        //user not loggedin
    }
    else{
        // user already loggedin ,no need to display log in page ,go to home page
        UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *vc=[storyboard instantiateViewControllerWithIdentifier:@"HomeController"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //touch event fires, hide keyboard
    
    [viewForgot setHidden:YES];
    [tfUserName resignFirstResponder];
    [tfEmailForgot resignFirstResponder];
    [tfPassword resignFirstResponder];
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
    if (textField==tfUserName) {
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
    else if (textField==tfEmailForgot){
        if ([self validateEmail:string] || [self validateEmail:textField.text]) {
            tfEmailForgot.layer.borderColor=[UIColor whiteColor].CGColor;
            tfEmailForgot.layer.borderWidth= 1.0f;
            tfEmailForgot.layer.masksToBounds=YES;
        }
        else{
            tfEmailForgot.layer.borderColor=[UIColor redColor].CGColor;
            tfEmailForgot.layer.borderWidth= 1.0f;
            tfEmailForgot.layer.masksToBounds=YES;
        }
    }
    
    return YES;
}

-(IBAction)btnLogInPressed:(id)sender{
    [tfUserName resignFirstResponder];
    [tfPassword resignFirstResponder];
    strAction=@"api/appmember/login";
    
    
    NSData *nsdata = [tfPassword.text
                      dataUsingEncoding:NSUTF8StringEncoding];
    
    // Get NSString from NSData object in Base64
    NSString *base64Encoded = [nsdata base64EncodedStringWithOptions:0];
    
    
    coordinate = [self getLocation];
    if ([self displayAlert]) {
        //make datastring for login
        NSString *dataString = [NSString stringWithFormat:@"authkey=%@&user=%@&password=%@&lat=%f&longi=%f&device_token_id=%@",AUTH,tfUserName.text,base64Encoded,coordinate.latitude,coordinate.longitude,@"123456"];
        [self serviceCall:@"login":dataString];
    }
}

-(BOOL)displayAlert{
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
    
    return YES;
    
}

-(CLLocationCoordinate2D) getLocation{
    locationManager =[[CLLocationManager alloc] init];
    locationManager.delegate = self;
#ifdef __IPHONE_8_0
    if(IS_OS_8_OR_LATER)
    {
        // Use one or the other, not both. Depending on what you put in info.plist
        //[locationManager requestWhenInUseAuthorization];
        [locationManager requestAlwaysAuthorization];
        locationManager.delegate = self;
        locationManager.distanceFilter = 0.5;
        [locationManager startUpdatingLocation];
        //[self showCurrentLocation:nil];
    }
#endif
    if ( [CLLocationManager locationServicesEnabled] ) {
        locationManager.delegate = self;
        locationManager.distanceFilter = 0.5;
        [locationManager startUpdatingLocation];
        
        // [self showCurrentLocation:nil];
    }
    
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager startUpdatingLocation];
    CLLocation *location = [locationManager location];
    CLLocationCoordinate2D coordinate = [location coordinate];
    
    return coordinate;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    //locationManager.location=newLocation;
    //CLLocation *location = [locationManager location];
    coordinate = [newLocation coordinate];
    NSLog(@"Location updated...");
    
    if(timeOut >= 4) {
        [locationManager stopUpdatingLocation];
        return;
    }
    
    timeOut++;
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
    //if(![serviceName isEqualToString:@"allCountry"])
    {
        app.networkActivityIndicatorVisible = YES;
    }
    
    
    
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    [sessionConfiguration setAllowsCellularAccess:YES];
    [sessionConfiguration setHTTPAdditionalHeaders:@{ @"Accept" : @"application/json" }];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    
    
    
    NSURL *url;
    
    if([serviceName isEqualToString:@"login"])
    {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,LOGIN_URL]];
    }
    else if ([serviceName isEqualToString:@"forgotPassword"]){
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,FORGOT_PASS_URL]];
    }
    // Configure the Request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:[NSString stringWithFormat:@"%@=%@", strSessName, strSessVal] forHTTPHeaderField:@"Cookie"];
    
    request.HTTPBody = [DataString dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPMethod = @"POST";
    
    NSLog(@"urltotal=%@ %@",url,DataString);
    
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
                                                  if([serviceName isEqualToString:@"login"])
                                                  {
                                                      NSMutableDictionary *dict=[[NSMutableDictionary alloc] initWithDictionary:[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil]];
                                                      
                                                      if ([[dict valueForKey:@"ack"] integerValue]==1) {
                                                          
                                                          NSUserDefaults *prefs=[NSUserDefaults standardUserDefaults];
                                                          [prefs setObject:[[[dict objectForKey:@"userdetail"] valueForKey:@"id"] valueForKey:@"$id"] forKey:@"userId"];
                                                          [prefs setObject:[[dict objectForKey:@"userdetail"] valueForKey:@"username"] forKey:@"user"];
                                                          [prefs setObject:[[dict objectForKey:@"userdetail"] valueForKey:@"name"] forKey:@"name"];
                                                          [prefs setObject:[[dict objectForKey:@"userdetail"] valueForKey:@"yabreach"] forKey:@"yabreach"];
                                                          
                                                          [prefs synchronize];
                                                          
                                                          @try {
                                                              nameUser=[[dict objectForKey:@"userdetail"] valueForKey:@"name"];
                                                              userName=[[dict objectForKey:@"userdetail"] valueForKey:@"username"];
                                                              imgUser=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_URL,[[dict objectForKey:@"userdetail"] valueForKey:@"img"]]]]];
                                                              
                                                              [self saveImage:imgUser];
                                                              
                                                              yabreachVal=[[dict objectForKey:@"userdetail"] valueForKey:@"yabreach"];
                                                              
                                                        
                                                          }
                                                          @catch (NSException *exception) {
                                                              
                                                          }
                                                          
                                                          //go to home page
                                                          
                                                          UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                                          UIViewController *vc=[storyboard instantiateViewControllerWithIdentifier:@"HomeController"];
                                                          [self.navigationController pushViewController:vc animated:YES];
                                                          
                                                      }
                                                      else
                                                      {
                                                          tfUserName.layer.borderColor=[UIColor redColor].CGColor;
                                                          tfUserName.layer.borderWidth= 1.0f;
                                                          tfUserName.layer.masksToBounds=YES;
                                                          
                                                          
                                                          tfPassword.layer.borderColor=[UIColor redColor].CGColor;
                                                          tfPassword.layer.borderWidth= 1.0f;
                                                          tfPassword.layer.masksToBounds=YES;
                                                      }
                                                  }
                                                  else if([serviceName isEqualToString:@"forgotPassword"])
                                                  {
                                                      NSMutableDictionary *dict=[[NSMutableDictionary alloc] initWithDictionary:[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil]];
                                                      
                                                      if ([[dict valueForKey:@"Ack"] integerValue]==1) {
                                                          
                                                          [viewForgot setHidden:YES];
                                                          
                                                          
                                                          UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Yabble" message:@"Your new password has been sent to your email id." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
                                                          [alert show];
                                                          
                                                      }
                                                      else{
                                                          tfEmailForgot.layer.borderColor=[UIColor redColor].CGColor;
                                                          tfEmailForgot.layer.borderWidth= 1.0f;
                                                          tfEmailForgot.layer.masksToBounds=YES;
                                                      }
                                                  }
                                              });
                                          }];
    
    // Initiate the Request
    [postDataTask resume];
    
}


- (void)saveImage: (UIImage*)image
{
    if (image != nil)
    {   //save image to documents folder
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        NSString *imageFileName=[NSString stringWithFormat:@"Documents/feedback_profile.png"];
        imageFileName = [NSHomeDirectory() stringByAppendingPathComponent:imageFileName];
        if([fileMgr fileExistsAtPath:imageFileName]){
            NSData *imageData = UIImagePNGRepresentation(image);
            [imageData writeToFile:imageFileName atomically:NO];
            
        }else{
            NSData *imageData = UIImagePNGRepresentation(image);
            [imageData writeToFile:imageFileName atomically:NO];
        }
    }
}
-(IBAction)btnSignUpPressed:(id)sender{
    //go to sign up page
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc=[storyboard instantiateViewControllerWithIdentifier:@"SignUpController"];
    [self.navigationController pushViewController:vc animated:YES];
}

-(IBAction)btnForgotPasswordPressed:(id)sender{
    // show popup for forgot password
    [viewForgot setHidden:NO];
}

-(IBAction)btnSendPressed:(id)sender{
    if (tfEmailForgot.text.length==0) {
        tfEmailForgot.layer.borderColor=[UIColor redColor].CGColor;
        tfEmailForgot.layer.borderWidth= 1.0f;
        tfEmailForgot.layer.masksToBounds=YES;
    }
    else if (![self validateEmail:[tfEmailForgot text]])
    {
        tfEmailForgot.layer.borderColor=[UIColor redColor].CGColor;
        tfEmailForgot.layer.borderWidth= 1.0f;
        tfEmailForgot.layer.masksToBounds=YES;
    }
    else{
        NSString *dataString = [NSString stringWithFormat:@"authkey=%@&email=%@&device_token_id=%@",AUTH,tfEmailForgot.text,@"123456"];
        [self serviceCall:@"forgotPassword":dataString];
    }
    
}

@end
