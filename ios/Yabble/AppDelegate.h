//
//  AppDelegate.h
//  Yabble
//
//  Created by National It Solution on 14/01/15.
//  Copyright (c) 2015 Suman's. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import <FacebookSDK/FacebookSDK.h>
#import <FacebookSDK/FBAppCall.h>
#import "MMNeedMethods.h"
#import "MBProgressHUD.h"
#import "Reachability.h"
#import "ServerLink.h"

ACAccountStore *accountStore;
ACAccount *faceBookAc;
ACAccountType *accType;


UIApplication* app;
NSString *strAction;

UIImage *imgUser;
NSString *nameUser;
NSString *userName;
NSString *bioUser;
NSString *yabreachVal;

NSString *place;
NSString *placeLat;
NSString *placeLong;

NSString *imageString;

NSString *deviceTokenId;

NSString *strSessName,*strSessVal;

CGFloat scaleFactor;
CGFloat windowWidth;
CGFloat windowHeight;


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(strong,nonatomic)NSString *deviceTokenId;

@end

