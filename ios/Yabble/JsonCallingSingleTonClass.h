//
//  JsonCallingSingleTonClass.h
//  OLO
//
//  Created by Bhaskar on 13/02/14.
//  Copyright (c) 2014 Bhaskar. All rights reserved.
//

#import <Foundation/Foundation.h>
#define AUTHEN @"fcea920f7412b5da7be0cf42b8c93759"

@protocol WebServiceCallDeleGate <NSObject>

@required

-(void)webserviceCallFailOrError : (NSString *)errorMessage withFlag : (int)flag;
-(void)WebServiceCallFinishWithData : (NSDictionary *)data withFlag : (int)flag;
@optional



@end

@interface JsonCallingSingleTonClass : NSObject<NSURLConnectionDelegate>{
    NSString *baseUrl;
}
@property (nonatomic, retain) NSString *baseUrl;
@property (nonatomic,strong) id <WebServiceCallDeleGate> delegate;
@property(nonatomic,readwrite)BOOL IsSynchronous;

+ (id)sharedManager;
- (void)printBaseUrl;
- (void)webServiceCallWithPostString : (NSString *)postString serviceName :(NSString *)serviceName connectionflag :(int)flag;
//-(void)webServiceCallWithPostStringImageData : (NSDictionary *)postDic  withImageData:(NSData *)imageData withUrlMethodName :(NSString *)methodName;
-(void)webServiceCallWithPostStringImageData : (NSDictionary *)postDic  withImageData:(NSData *)imageData withUrlMethodName :(NSString *)methodName withIdentifier:(NSString *)strIdentifier connectionflag :(int)flag;

-(void)webServiceCallWithPostStringImageData1 : (NSDictionary *)postDic  withImageData1:(NSData *)imageData1  withUrlMethodName :(NSString *)methodName withIdentifier:(NSString *)strIdentifier connectionflag :(int)flag;

-(void)webServiceCallWithPostStringImageData12 : (NSDictionary *)postDic  withImageData1:(NSData *)imageData1  withImageData2:(NSData *)imageData2  withUrlMethodName :(NSString *)methodName withIdentifier:(NSString *)strIdentifier connectionflag :(int)flag;


-(void)webServiceCallWithPostStringImageData123 : (NSDictionary *)postDic  withImageData1:(NSData *)imageData1  withImageData2:(NSData *)imageData2  withImageData3:(NSData *)imageData3  withUrlMethodName :(NSString *)methodName withIdentifier:(NSString *)strIdentifier connectionflag :(int)flag;





-(NSDictionary *) webServiceCallWithPostStringImageDataSynchronous : (NSDictionary *)postDic  withImageData:(NSData *)imageData withUrlMethodName :(NSString *)methodName withIdentifier:(NSString *)strIdentifier connectionflag :(int)flag;
- (NSDictionary *)webServiceCallWithPostStringSynchronous : (NSString *)postString serviceName :(NSString *)serviceName connectionflag :(int)flag;
@end
