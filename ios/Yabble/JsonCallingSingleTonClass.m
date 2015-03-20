
//
//  JsonCallingSingleTonClass.m
//  OLO
//
//  Created by Bhaskar on 13/02/14.
//  Copyright (c) 2014 Bhaskar. All rights reserved.
//

#import "JsonCallingSingleTonClass.h"

//#define BASEURL @"http://homevacationclub.com/goloko/webservice/"
#define BASEURL @"http://108.179.225.244/~nationalit/team5/goloko/webservice/"

#define ImageUrl  @"http://www.nationalitsolution.in/team5/instagram/upload/"

@implementation JsonCallingSingleTonClass{
    NSMutableData *_responseData;
    int connectionFlag;
}
@synthesize baseUrl;

#pragma mark Singleton Methods

+ (JsonCallingSingleTonClass *)sharedManager {
    static JsonCallingSingleTonClass *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        baseUrl = BASEURL;
        
    }
    return self;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}

-(void)printBaseUrl{
    NSLog(@"\n\n\n\n<<<<<<<<<<<<<<<BaseURL : %@>>>>>>>>>>>>>>\n\n\n\n",baseUrl);
}

- (void)webServiceCallWithPostString : (NSString *)postString serviceName :(NSString *)serviceName connectionflag :(int)flag
{
    connectionFlag =flag;
    [self connectionStartwithPostString:postString withUrlMethodName:serviceName];
}

- (NSDictionary *)webServiceCallWithPostStringSynchronous : (NSString *)postString serviceName :(NSString *)serviceName connectionflag :(int)flag
{
    connectionFlag =flag;
    NSURL *aUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",baseUrl,serviceName]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    NSLog(@"%@",aUrl);
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSError *error = nil;
    NSHTTPURLResponse *responseCode = nil;
    NSData *response=[NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];
    _responseData=[NSMutableData dataWithData:response];
    NSDictionary *dictResponse=[self SerializeJSONResponse:_responseData];
    
    return dictResponse;
    //[self connectionStartwithPostString:postString withUrlMethodName:serviceName];
    
    
}

#pragma mark Starting a NSURLConnection

-(void)connectionStartwithPostString : (NSString *)postString withUrlMethodName :(NSString *)methodName{
    NSURL *aUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",baseUrl,methodName]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    NSLog(@"%@",aUrl);
    [request setHTTPMethod:@"POST"];
    
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postString length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSURLResponse *response;
    NSError *err;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    _responseData=[NSMutableData dataWithData:responseData];
    NSString* newStr = [[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding];
    NSLog(@"response data:%@",newStr);
    //    if (self.IsSynchronous) {
    //    NSError *error1 = nil;
    //    NSHTTPURLResponse *responseCode = nil;
    //    NSData *response1=[NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error1];
    //    _responseData=[NSMutableData dataWithData:response1];
    if (err) {
        if (self.delegate) {
            [self.delegate webserviceCallFailOrError:@"Some Server Problem Encountered" withFlag:connectionFlag];
            self.delegate = nil;
        }
    }
    else{
        [self connectionDidFinishLoading:nil];
    }
    
    //    }
    //    else{
    //        NSURLConnection *connection= [[NSURLConnection alloc] initWithRequest:request delegate:self];
    //        [connection start];
    //    }
}


-(NSDictionary *) webServiceCallWithPostStringImageDataSynchronous : (NSDictionary *)postDic  withImageData:(NSData *)imageData withUrlMethodName :(NSString *)methodName withIdentifier:(NSString *)strIdentifier connectionflag :(int)flag{
    
    
    
    NSURL *aUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASEURL,methodName]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
    
    
    
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    
    for (NSString *param in postDic) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [postDic objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    //
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    if ([strIdentifier isEqualToString:@"MyProfile"]) {
        [body appendData:[@"Content-Disposition: form-data; name=\"image\"; filename=\"uploadImage.jpeg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    else{
        [body appendData:[@"Content-Disposition: form-data; name=\"image\"; filename=\"uploadImage.jpeg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    
    [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imageData]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    //  NSString *strImage=[NSString stringWithFormat:@"image=%@",body];
    
    //NSString *postString11=[NSString stringWithFormat:@"%@&%@",postString,strImage];
    
    
    
    //NSLog(@">>>>>>>>>9474930220>>>>>>>    %@",postString11);
    
    // [request setHTTPBody:[postString11 dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:body];
    
    // NSURLConnection *connection= [[NSURLConnection alloc] initWithRequest:request delegate:self];
    //[connection start];
    
    //NSMutableData *_responseData;
    
    NSError *error = nil;
    NSHTTPURLResponse *responseCode = nil;
    NSData *response=[NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];
    _responseData=[NSMutableData dataWithData:response];
    NSDictionary *dictResponse=[self SerializeJSONResponse:_responseData];
    
    return dictResponse;
    
}

/*

-(void)webServiceCallWithPostStringImageData : (NSDictionary *)postDic  withImageData:(NSData *)imageData withUrlMethodName :(NSString *)methodName withIdentifier:(NSString *)strIdentifier connectionflag :(int)flag{
    
    
    
    connectionFlag=flag;
    
    NSURL *aUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",baseUrl,methodName]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
    
    
    
    
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    
    for (NSString *param in postDic) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [postDic objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    //
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //    if ([strIdentifier isEqualToString:@"MyProfile"]) {
    //        [body appendData:[@"Content-Disposition: form-data; name=\"image\"; filename=\"uploadImage.jpeg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    //    }
    //    else{
    [body appendData:[@"Content-Disposition: form-data; name=\"image\"; filename=\"uploadImage.jpeg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    //  }
    
    
    [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imageData]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    //  NSString *strImage=[NSString stringWithFormat:@"image=%@",body];
    
    //NSString *postString11=[NSString stringWithFormat:@"%@&%@",postString,strImage];
    
    
    
    //NSLog(@">>>>>>>>>9474930220>>>>>>>    %@",postString11);
    
    // [request setHTTPBody:[postString11 dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:body];
    
    NSURLConnection *connection= [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
    
    
    //    NSError *error = nil;
    //    NSHTTPURLResponse *responseCode = nil;
    //    NSData *response=[NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];
    //    _responseData=[NSMutableData dataWithData:response];
    //    NSDictionary *dictResponse=[self SerializeJSONResponse:_responseData];
    //
    //
    //    if (!error) {
    //        //Do Your Stuff
    //        if (self.delegate) {
    //            [self.delegate WebServiceCallFinishWithData:(NSDictionary *)dictResponse withFlag:connectionFlag];
    //            self.delegate = nil;
    //        }
    //    } else {
    //        //fail delegate will come
    //        if (self.delegate) {
    //            [self.delegate webserviceCallFailOrError:@"Some Server Problem Encountered" withFlag:connectionFlag];
    //            self.delegate = nil;
    //        }
    //        return;
    //    }
    
}

 */


-(void)webServiceCallWithPostStringImageData : (NSDictionary *)postDic  withImageData:(NSData *)imageData withUrlMethodName :(NSString *)methodName withIdentifier:(NSString *)strIdentifier connectionflag :(int)flag{
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:30];
    
    [request setHTTPMethod:@"POST"];
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    // set Content-Type in HTTP header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // post body
    NSMutableData *body = [NSMutableData data];
    
    for (NSString *param in postDic) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [postDic objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    // add image data
    //NSData *imageData = UIImageJPEGRepresentation(imageToPost, 1.0);
    if (imageData) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[@"Content-Disposition: form-data; name=\"photo\"; filename=\"uploadImage.jpeg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        // [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:imageData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:body];
    
    // set the content-length
    NSString *postLength = [NSString stringWithFormat:@"%d", [body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    // set URL
    NSURL *aUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",baseUrl,methodName]];
    [request setURL:aUrl];
    connectionFlag=flag;
    NSURLConnection *connection= [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
}



-(void)webServiceCallWithPostStringImageData1 : (NSDictionary *)postDic  withImageData1:(NSData *)imageData1  withUrlMethodName :(NSString *)methodName withIdentifier:(NSString *)strIdentifier connectionflag :(int)flag{
    connectionFlag=flag;
    
    NSURL *aUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",baseUrl,methodName]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
    
    
    
    
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    
    for (NSString *param in postDic) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [postDic objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    //Imagedata1
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [body appendData:[@"Content-Disposition: form-data; name=\"photo\"; filename=\"uploadImage.jpeg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imageData1]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    
    
    [request setHTTPBody:body];
    
    NSURLConnection *connection= [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
}

-(void)webServiceCallWithPostStringImageData12 : (NSDictionary *)postDic  withImageData1:(NSData *)imageData1  withImageData2:(NSData *)imageData2  withUrlMethodName :(NSString *)methodName withIdentifier:(NSString *)strIdentifier connectionflag :(int)flag{
    connectionFlag=flag;
    
    NSURL *aUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",baseUrl,methodName]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
    
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    
    for (NSString *param in postDic) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [postDic objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    //Imagedata1
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [body appendData:[@"Content-Disposition: form-data; name=\"image1\"; filename=\"uploadImage.jpeg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imageData1]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //Imagedata2
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [body appendData:[@"Content-Disposition: form-data; name=\"image2\"; filename=\"uploadImage2.jpeg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imageData2]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [request setHTTPBody:body];
    
    NSURLConnection *connection= [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
}

-(void)webServiceCallWithPostStringImageData123 : (NSDictionary *)postDic  withImageData1:(NSData *)imageData1  withImageData2:(NSData *)imageData2  withImageData3:(NSData *)imageData3  withUrlMethodName :(NSString *)methodName withIdentifier:(NSString *)strIdentifier connectionflag :(int)flag{
    connectionFlag=flag;
    
    NSURL *aUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",baseUrl,methodName]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
    
    
    
    
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    
    for (NSString *param in postDic) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [postDic objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    //Imagedata1
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [body appendData:[@"Content-Disposition: form-data; name=\"image1\"; filename=\"uploadImage1.jpeg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imageData1]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //Imagedata2
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [body appendData:[@"Content-Disposition: form-data; name=\"image2\"; filename=\"uploadImage2.jpeg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imageData2]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //Imagedata3
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [body appendData:[@"Content-Disposition: form-data; name=\"image3\"; filename=\"uploadImage3.jpeg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imageData3]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    
    
    [request setHTTPBody:body];
    
    NSURLConnection *connection= [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
    
}


#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [_responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    NSError *error;
    
    // Print Rawdata
    NSLog(@"\n\n<<<<<<<<<<<<<<<<<<<<Responsedata : %@\n\n",[NSString stringWithUTF8String:[_responseData bytes]]);
    
    // Convert response o json
    NSJSONSerialization *jsonData = [NSJSONSerialization JSONObjectWithData:_responseData options:NSJSONReadingMutableContainers error:&error];
    //    NSLog(@"\n\n<<<<<<<<<<<<<<<<<<<<Responsedata after convert into JSON : %@\n\n",jsonData);
    
    
    if (!error) {
        //Do Your Stuff
        if (self.delegate) {
            [self.delegate WebServiceCallFinishWithData:(NSDictionary *)jsonData withFlag:connectionFlag];
            // self.delegate = nil;//...souvik
        }
    } else {
        //fail delegate will come
        if (self.delegate) {
            [self.delegate webserviceCallFailOrError:@"Some Server Problem Encountered" withFlag:connectionFlag];
            //  self.delegate = nil;//souvik
        }
        return;
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    if (self.delegate) {
        [self.delegate webserviceCallFailOrError:@"Some Server Problem Encountered" withFlag:connectionFlag];
        self.delegate = nil;
    }
    
    //fail delegate will come
    
}

-(NSDictionary *)SerializeJSONResponse:(NSMutableData *)response{
    NSError *error;
    
    // Print Rawdata
    NSLog(@"\n\n<<<<<<<<<<<<<<<<<<<<Responsedata : %@\n\n",[NSString stringWithUTF8String:[response bytes]]);
    
    // Convert response o json
    NSJSONSerialization *jsonData = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:&error];
    //    NSLog(@"\n\n<<<<<<<<<<<<<<<<<<<<Responsedata after convert into JSON : %@\n\n",jsonData);
    
    
    if (!error) {
        //Do Your Stuff
        return (NSDictionary *)jsonData;
        /*
         if (self.delegate) {
         [self.delegate WebServiceCallFinishWithData:(NSDictionary *)jsonData withFlag:connectionFlag];
         self.delegate = nil;
         }
         */
    } else {
        //fail delegate will come
        return nil;
        /*
         if (self.delegate) {
         [self.delegate webserviceCallFailOrError:@"Some Server Problem Encountered" withFlag:connectionFlag];
         self.delegate = nil;
         }
         return;
         */
    }
    
}


@end
