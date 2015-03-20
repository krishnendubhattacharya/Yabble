//
//  ServerLink.h
//  TaskDesk
//
//  Created by NITS_IPhone on 11/25/14.
//  Copyright (c) 2014 NITS. All rights reserved.
//

#import <Foundation/Foundation.h>
//#define BASE_URL @"http://108.179.225.244/~nationalit/team2/yabble/webservice/service.php?"
//#define IMAGE_URL @"http://108.179.225.244/~nationalit/team2/yabble/admin/member_image/"

#define BASE_URL @"http://108.179.225.244:3000/"
#define AUTH @"acea920f7412b7Ya7be0cfl2b8c937Bc9"
#define IMAGE_URL @"http://108.179.225.244:3000/member_image/"

#define LOGIN_URL @"api/appmember/login"
#define FORGOT_PASS_URL @"api/appmember/forgotPassword"
#define SIGNUP_URL @"api/appmember/signup"

#define GET_YABS_URL @"api/yab/getyabs"
#define UPDATE_USER_POSITION_URL @"api/appmember/updateuserposition"
#define USER_SETTING_URL @"api/appmember/userSetting"


#define USER_PROFILE @"api/appmember/userProfile"
#define MY_YABS_URL @"api/yab/myyabs"

#define YAB_DETAILS @"api/yab/yabDetails"
#define POST_COMMENT @"api/yab/postComment"

#define IS_IPHONE_5 (([UIScreen mainScreen].scale == 2.f && [UIScreen mainScreen].bounds.size.height == 568)?YES:NO)

#define IS_IPHONE_6 (([UIScreen mainScreen].scale == 2.f && [UIScreen mainScreen].bounds.size.height == 667)?YES:NO)

#define IS_IPHONE_6Plus (([UIScreen mainScreen].scale == 2.f && [UIScreen mainScreen].bounds.size.height == 736)?YES:NO)

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

#define FbAppId @"408789235954522"

@interface ServerLink : NSObject

@end
