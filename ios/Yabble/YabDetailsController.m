//
//  YabDetailsController.m
//  Yabble
//
//  Created by National It Solution on 19/01/15.
//  Copyright (c) 2015 Suman's. All rights reserved.
//

#import "YabDetailsController.h"
#import "AppDelegate.h"
#import "CommentCell.h"


@interface YabDetailsController ()

@end

@implementation YabDetailsController
@synthesize yab_id;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    
    [self performSelector:@selector(getYabDetails) withObject:nil afterDelay:0.2];
    
    tfComment.autocorrectionType=UITextAutocorrectionTypeNo;
    
    [self performSelector:@selector(getYabsDetails) withObject:nil afterDelay:0.2];
}


-(void)getYabsDetails{
    // http://108.179.225.244:3000/api/yab/getyabs/:authkey/:userid/:device_token_id/:lat/:longi
    // /yabDetails/:authkey/:yabid/:device_token_id
    
    
    NSString *userId=[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"];
    
    NSString *serverAddress=[NSString stringWithFormat:@"%@%@/%@/%@/%@",BASE_URL,YAB_DETAILS,AUTH,yab_id,@"123456"];
    
    NSLog(@"serveraddress=%@",serverAddress);
    
    serverAddress=[serverAddress stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:serverAddress]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:10];
    
    [request setHTTPMethod: @"GET"];
    
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    NSError *error;
    
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    
    NSDictionary *dict=[[NSDictionary alloc]initWithDictionary:parsedObject];
    
    if ([[dict valueForKey:@"Ack"] integerValue]==1) {
        
        NSString *strImg;
        @try {
            strImg=[dict valueForKey:@"img"];
        }
        @catch (NSException *exception) {
            strImg=@"";
        }
        
        NSString *imgString=[NSString stringWithFormat:@"%@%@",IMAGE_URL,strImg];
        [self setImageWithurl:imgString andImageView:imgProfile];
        imgProfile.layer.cornerRadius=20.0f;
        imgProfile.layer.masksToBounds=YES;
        
        lblName.text=[dict valueForKey:@"name"];
        lblUserName.text=[NSString stringWithFormat:@"@%@",[dict valueForKey:@"username"]];
        lblDescription.text=[dict valueForKey:@"message"];
        lblDate.text=[dict valueForKey:@"post_date"];
        
        lblLikes.text=[NSString stringWithFormat:@"%d",[[dict valueForKey:@"like"] integerValue]];
        
        lblDistance.text=[NSString stringWithFormat:@"%@ mi",[dict valueForKey:@"broadcast_radius"]];
        
        arrComment=[[NSMutableArray alloc]init];
        
        arrComment=[dict objectForKey:@"comments"];
    }
    [tblComment reloadData];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}


#pragma mark Keyboard notifications

- (void)keyboardWillShow:(NSNotification *)note
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame=viewPost.frame;
        frame.origin.y=frame.origin.y-215+43;
        [viewPost setFrame:frame];
        
       // tblComment.frame=CGRectMake(0, 0, 280, 210);
    }];
    
}

- (void)keyboardWillHide:(NSNotification *)note
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame=viewPost.frame;
        frame.origin.y=frame.origin.y+215-43;
        [viewPost setFrame:frame];
       // tblComment.frame=CGRectMake(0, 0, 280, 443);
    }];
}

//action for get yabdetails

-(void)getYabDetails{
    NSString *dataString = [NSString stringWithFormat:@"auth=%@&action=%@&yabID=%@&device_token_id=%@",AUTH,@"yabDetails",yab_id,@"123456"];
    [self serviceCall:@"yabDetails":dataString];
    
   //   http://108.179.225.244/~nationalit/team2/yabble/webservice/service.php?auth=acea920f7412b7Ya7be0cfl2b8c937Bc9&action=yabDetails&yabID=54b775f45b16207c598b4567&device_token_id=1111111111
    
}


-(void)serviceCall:(NSString*)serviceName :(NSString*)DataString
{
    if([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable)
    {
        [MMNeedMethods showNetworkError];
        return;
    }
    if(![serviceName isEqualToString:@"postComment"])
    {
        // [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] delegate].window animated:YES];
        //  [MBProgressHUD HUDForView:[[UIApplication sharedApplication] delegate].window].labelText = @"Please wait...";
        app.networkActivityIndicatorVisible = YES;
    }
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    [sessionConfiguration setAllowsCellularAccess:YES];
    [sessionConfiguration setHTTPAdditionalHeaders:@{ @"Accept" : @"application/json" }];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    
   // NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",BASE_URL]];
    
    NSURL *url;
    
    if ([serviceName isEqualToString:@"postComment"]) {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,POST_COMMENT]];
    }
    else if ([serviceName isEqualToString:@"getyabs"]){
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",BASE_URL]];
    }
    else if ([serviceName isEqualToString:@"userSetting"]){
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,USER_SETTING_URL]];
    }
    
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
                                                  if([serviceName isEqualToString:@"yabDetails"])
                                                  {
                                                      NSMutableDictionary *dict=[[NSMutableDictionary alloc] initWithDictionary:[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil]];
                                                      
                                                      if ([[dict valueForKey:@"Ack"] integerValue]==1) {
                                                          
                                                          NSString *strImg;
                                                          @try {
                                                              strImg=[dict valueForKey:@"img"];
                                                          }
                                                          @catch (NSException *exception) {
                                                              strImg=@"";
                                                          }
                                                          
                                                          NSString *imgString=[NSString stringWithFormat:@"%@%@",IMAGE_URL,strImg];
                                                          [self setImageWithurl:imgString andImageView:imgProfile];
                                                          imgProfile.layer.cornerRadius=20.0f;
                                                          imgProfile.layer.masksToBounds=YES;
                                                          
                                                          
                                                          lblName.text=[dict valueForKey:@"name"];
                                                          lblUserName.text=[NSString stringWithFormat:@"@%@",[dict valueForKey:@"username"]];
                                                          lblDescription.text=[dict valueForKey:@"message"];
                                                          lblDate.text=[dict valueForKey:@"post_date"];
                                                          
                                                          lblLikes.text=[NSString stringWithFormat:@"%d",[[dict valueForKey:@"like"] integerValue]];
                                                          
                                                          lblDistance.text=[NSString stringWithFormat:@"%@ mi",[dict valueForKey:@"broadcast_radius"]];
                                                          
                                                          arrComment=[[NSMutableArray alloc]init];
                                        
                                                          arrComment=[dict objectForKey:@"comments"];                                                          
                                                      }
                                                      [tblComment reloadData];
                                                  }
                                                  else if ([serviceName isEqualToString:@"postComment"]){
                                                      NSMutableDictionary *dict=[[NSMutableDictionary alloc] initWithDictionary:[NSJSONSerialization JSONObjectWithData:data options:kNilOptions                                                          error:nil]];
                                                      
                                                      if ([[dict valueForKey:@"Ack"] integerValue]==1) {
                                                          
                                                          tfComment.text=@"";
                                                          [tfComment resignFirstResponder];
                                                          [self performSelector:@selector(getYabDetails) withObject:nil afterDelay:0.2];
                                                      }
                                                  }
                                                  
                                              });
                                          }];
    
    // Initiate the Request
    [postDataTask resume];
    
}


-(void)setImageWithurl:(NSString*)url andImageView:(UIImageView*)imgview{
    
    NSString *imageURL=[NSString stringWithFormat:@"%@",url];
    NSString* imageName=[imageURL lastPathComponent];
    NSString *docDir=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSString  *FilePath = [NSString stringWithFormat:@"%@/%@",docDir,imageName];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:FilePath];
    if (fileExists)
    {
        imgview.image=[UIImage imageWithContentsOfFile:FilePath];
    }
    else
    {
        [self processImageDataWithURLString:imageURL andBlock:^(NSData *imageData)
         {
             imgview.image=[UIImage imageWithData:imageData];
             [imageData writeToFile:FilePath atomically:YES];
         }];
    }
    
}


- (void)processImageDataWithURLString:(NSString *)urlString andBlock:(void (^)(NSData *imageData))processImage
{
    NSURL *url = [NSURL URLWithString:urlString];
    
    dispatch_queue_t callerQueue = dispatch_get_main_queue();//dispatch_get_current_queue();
    dispatch_queue_t downloadQueue = dispatch_queue_create("com.myapp.processsmagequeue", NULL);
    dispatch_async(downloadQueue, ^{
        NSData * imageData = [NSData dataWithContentsOfURL:url];
        
        dispatch_async(callerQueue, ^{
            processImage(imageData);
        });
    });
    //  downloadQueue=nil;
    //dispatch_release(downloadQueue);
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrComment.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 95.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"CellIdentifier";
    CommentCell *cell=(CommentCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil)
    {
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"CommentCell" owner:self options:nil];
        cell=[nib objectAtIndex:0];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    NSDictionary *dict=[arrComment objectAtIndex:indexPath.row];
    
    
    NSString *strImg;
    @try {
        strImg=[dict valueForKey:@"comment_user_image"];
    }
    @catch (NSException *exception) {
        strImg=@"";
    }
    
    NSString *imgString=[NSString stringWithFormat:@"%@%@",IMAGE_URL,strImg];
    [self setImageWithurl:imgString andImageView:cell.imgProfile];
    cell.imgProfile.layer.cornerRadius=20.0f;
    cell.imgProfile.layer.masksToBounds=YES;
    
    cell.lblName.text=[dict valueForKey:@"comment_user_name"];
    cell.lblUsername.text=[NSString stringWithFormat:@"@%@",[dict valueForKey:@"comment_user_username"]];
    cell.lblDate.text=[dict valueForKey:@"comment_post_date"];
    cell.lblComment.text=[dict valueForKey:@"comment_text"];
    return cell;
}

//action for post comment

-(IBAction)btnPostPressed:(id)sender{
   // [self performSelector:@selector(addCommentApi) withObject:nil afterDelay:0.2];
    NSString *user_id=[[NSUserDefaults standardUserDefaults]valueForKey:@"userId"];
    
    NSString *dataString = [NSString stringWithFormat:@"auth=%@&yabID=%@&userID=%@&comment=%@&device_token_id=%@",AUTH,yab_id,user_id,tfComment.text,@"123456"];
    [self serviceCall:@"postComment":dataString];
    
   //   http://108.179.225.244/~nationalit/team2/yabble/webservice/service.php?auth=acea920f7412b7Ya7be0cfl2b8c937Bc9&action=postComment&yabID=54b775f45b16207c598b4567&userID=54b768ba5b1620c3288b4567&comment=This is test comment&device_token_id=1111111111
   // authkey,yabid,userid,comment,device_token_id
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
    //back to previous page
-(IBAction)btnBackPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)btnSearchPressed:(id)sender{
    
}
-(IBAction)btnLikePressed:(id)sender{
    
}
-(IBAction)btnChatPressed:(id)sender{
    
}
-(IBAction)btnDislikePressed:(id)sender{
    
}
-(IBAction)btnMutePressed:(id)sender{
    
}
-(IBAction)btnAlertPressed:(id)sender{
    
}


-(IBAction)btnMenuSettingPressed:(id)sender{
    
}

-(IBAction)btnAbbPlusPressed:(id)sender{
    
}

@end
