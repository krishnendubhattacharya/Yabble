//
//  SettingsController.m
//  Yabble
//
//  Created by National It Solution on 17/01/15.
//  Copyright (c) 2015 Suman's. All rights reserved.
//

#import "SettingsController.h"
#import "ViewController.h"
#import "AppDelegate.h"


@interface SettingsController ()

@end

@implementation SettingsController

- (void)viewDidLoad {
    [super viewDidLoad];
    [sliderYabreach setThumbImage:[UIImage imageNamed:@"crcle15.png"]
                         forState:UIControlStateNormal];
    sliderYabreach.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
    
    [sliderYabreach addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
    [sliderYabreach addTarget:self action:@selector(sliderChangedEnded:) forControlEvents:UIControlEventTouchUpInside];
    
    
    switchDistance.transform = CGAffineTransformMakeScale(0.75, 0.75);
    
    
    NSUserDefaults *prefs=[NSUserDefaults standardUserDefaults];
    yabreachVal=[prefs valueForKey:@"yabreach"];
    
    
    sliderYabreach.value=[yabreachVal integerValue];
    [self sliderYabreachValueChanged:sliderYabreach];
    
}

-(void)sliderChanged:(id)sender
{
    
}
//action fires when slider yabreach value changed

-(void)sliderChangedEnded:(id)sender
{
  
    int result = (int)sliderYabreach.value;
    NSString *sliderVal=[NSString stringWithFormat:@"%d",result];
    
    NSString *show_address;
    
    if ([switchDistance isOn]) {
        show_address=@"1";
    }
    else{
        show_address=@"0";
    }
    
    NSString *userId=[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"];
    
    NSString *dataString = [NSString stringWithFormat:@"auth=%@&action=%@&userID=%@&show_address=%@&yabreach=%@&device_token_id=%@",AUTH,@"userSetting",userId,show_address,sliderVal,@"123456"];
    [self serviceCall:@"userSetting":dataString];
    
    //  http://108.179.225.244/~nationalit/team2/yabble/webservice/service.php?auth=acea920f7412b7Ya7be0cfl2b8c937Bc9&action=userSetting&userID=54b768ba5b1620c3288b4567&show_address=1&yabreach=40&device_token_id=1111111111
}


-(void)serviceCall:(NSString*)serviceName :(NSString*)DataString
{
    if([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable)
    {
        [MMNeedMethods showNetworkError];
        return;
    }
    if(![serviceName isEqualToString:@"updateuserposition"] && ![serviceName isEqualToString:@"userSetting"])
    {
        app.networkActivityIndicatorVisible = YES;
    }
    
    
    
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    [sessionConfiguration setAllowsCellularAccess:YES];
    [sessionConfiguration setHTTPAdditionalHeaders:@{ @"Accept" : @"application/json" }];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",BASE_URL]];
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
                                              
                                              
                                              // NSMutableDictionary *DictUser=[[NSMutableDictionary alloc] initWithDictionary:[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error]];
                                              
                                              NSLog(@"Dict: %@",retVal);
                                              
                                              
                                              
                                              // Update the View
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] delegate].window animated:YES];
                                                  app.networkActivityIndicatorVisible = NO;
                                                  if ([serviceName isEqualToString:@"userSetting"]){
                                                      
                                                  }
                                              });
                                          }];
    
    // Initiate the Request
    [postDataTask resume];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)btnBackPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

//action fires when slider yabreach value changed

-(IBAction)sliderYabreachValueChanged:(id)sender{
    int result = (int)sliderYabreach.value;
    NSString *sliderVal=[NSString stringWithFormat:@"%d",result];
    lblYabreach.text=[NSString stringWithFormat:@"%@ mi",sliderVal];
    
    NSUserDefaults *prefs=[NSUserDefaults standardUserDefaults];
    [prefs setObject:sliderVal forKey:@"yabreach"];
    
    
    CGRect trackRect = [sliderYabreach trackRectForBounds:sliderYabreach.bounds];
    CGRect thumbRect = [sliderYabreach thumbRectForBounds:sliderYabreach.bounds
                                                trackRect:trackRect
                                                    value:sliderYabreach.value];
    
    lblYabreach.center = CGPointMake(20+thumbRect.origin.x, 162);
}

//action fires when distance value changed

-(IBAction)switchDistanceValueChanged:(id)sender{
    int result = (int)sliderYabreach.value;
    NSString *sliderVal=[NSString stringWithFormat:@"%d",result];
    
    NSString *show_address;
    
    if ([switchDistance isOn]) {
        show_address=@"1";
    }
    else{
        show_address=@"0";
    }
    
    NSString *userId=[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"];
    
    NSString *dataString = [NSString stringWithFormat:@"auth=%@&action=%@&userID=%@&show_address=%@&yabreach=%@&device_token_id=%@",AUTH,@"userSetting",userId,show_address,sliderVal,@"123456"];
    [self serviceCall:@"userSetting":dataString];
    
    //  http://108.179.225.244/~nationalit/team2/yabble/webservice/service.php?auth=acea920f7412b7Ya7be0cfl2b8c937Bc9&action=userSetting&userID=54b768ba5b1620c3288b4567&show_address=1&yabreach=40&device_token_id=1111111111
}

//log out action

-(IBAction)btnLogOutPressed:(id)sender{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setValue:nil forKey:@"userId"];
    [prefs setValue:nil forKey:@"user"];
    [prefs setValue:nil forKey:@"name"];
    [prefs synchronize];
    
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc=[storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    [self.navigationController pushViewController:vc animated:YES];
    
}
@end
