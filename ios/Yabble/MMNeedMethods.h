//
//  MMNeedMethods.h
//  Zinc
//
//  Created by Manab's on 19/08/14.
//  Copyright (c) 2014 Manab Kumar Mal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "AppDelegate.h"
#import <sys/utsname.h>
#import "ServerLink.h"

UIColor *colTopViewBackColor,*colThemeBorderColor,*colScrlvwBackColor;
@interface MMNeedMethods : NSObject
{
}
+(UIColor*)colorWithHexString:(NSString*)hex;
+(void)animateView:(UIView*)view :(int)yOrigin;
+(void) showNetworkError;
+(void) showConnectionError;
+(void) showOnlyAlert:(NSString*)title :(NSString*)message;
+(void) animate:(UIView*)view rect4Inch:(CGRect)rect4Inch rect3Inch:(CGRect)rect3Inch;
+(NSString*)machineName;
@end
