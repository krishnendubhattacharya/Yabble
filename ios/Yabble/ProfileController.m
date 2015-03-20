//
//  ProfileController.m
//  Yabble
//
//  Created by National It Solution on 17/01/15.
//  Copyright (c) 2015 Suman's. All rights reserved.
//

#import "ProfileController.h"
#import "HomeCell.h"
#import "ImageYabCell.h"
#import "AppDelegate.h"
#import "EnlargeImageController.h"
#import "HomeNoImageCell.h"



@interface ProfileController ()

@end

@implementation ProfileController
@synthesize strId;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self performSelector:@selector(getUserInfo) withObject:nil afterDelay:0.2];
    
    imgProfile.layer.cornerRadius=35.0f;
    imgProfile.layer.masksToBounds=YES;
    
   // lblBio.numberOfLines = 0;
   // [lblBio sizeToFit];
    
    imgSelectYabble.hidden=NO;
    imgSelectPhoto.hidden=YES;
    imgSelectChat.hidden=YES;
    
    arrPhoto=[[NSMutableArray alloc]init];
    self.scrollView.hidden=YES;
    
}

-(void)viewWillAppear:(BOOL)animated{
    if (imgUser) {
        imgProfile.image=imgUser;
    }
    else{
        imgProfile.image=[UIImage imageNamed:@"default.png"];
    }
    imgProfile.layer.cornerRadius=35.0f;
    imgProfile.layer.masksToBounds=YES;
    
    
    lblName.text=nameUser;
    lblUserName.text=userName;
    lblBio.text=bioUser;
}

// fetch user information from userProfile api

-(void)getUserInfo{
    NSString *userId;
    if (self.strId.length>0) {
        userId=self.strId;
    }
    else{
        userId=[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"];
    }
    
    
    /*
    NSString *dataString = [NSString stringWithFormat:@"authkey=%@&userID=%@&device_token_id=%@",AUTH,userId,@"123456"];
    [self serviceCall:@"userProfile":dataString];
    
    //  http://108.179.225.244/~nationalit/team2/yabble/webservice/service.php?auth=acea920f7412b7Ya7be0cfl2b8c937Bc9&action=userProfile&userID=54b768ba5b1620c3288b4567&device_token_id=1111111111
    */
    
    NSString *serverAddress=[NSString stringWithFormat:@"%@%@/%@/%@/%@/",BASE_URL,USER_PROFILE,AUTH,userId,@"123456"];
    
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
    
    lblName.text=[dict valueForKey:@"name"];
    lblUserName.text=[NSString stringWithFormat:@"@%@",[dict valueForKey:@"username"]];
    lblBio.text=[dict valueForKey:@"bio"];
    lblTotalYab.text=[NSString stringWithFormat:@"%d",[[dict valueForKey:@"totalyabs"] integerValue]];
    
    NSString *strImg;
    
    
    @try {
        strImg=[dict valueForKey:@"img"];
    }
    @catch (NSException *exception) {
        strImg=@"";
    }
    
    if(strImg.length>0){
        NSString *imgString=[NSString stringWithFormat:@"%@%@",IMAGE_URL,strImg];
        
        
        if (imgProfile.image) {
            [self setImageWithurl:imgString andImageView:imgProfile];
            //  imgUser=imgProfile.image;
        }
        else{
            imgProfile.image=[UIImage imageNamed:@"default.png"];
        }
    }
    else{
        imgProfile.image=[UIImage imageNamed:@"default.png"];
    }
    imgProfile.layer.cornerRadius=35.0f;
    imgProfile.layer.masksToBounds=YES;
    
    [self performSelector:@selector(getMyYabs) withObject:nil afterDelay:0.2];
    

}
//get users posted yabs

-(void)getMyYabs{
    NSString *userId;
    if (self.strId.length>0) {
        userId=self.strId;
    }
    else{
        userId=[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"];
    }
    
    /*
    NSString *dataString = [NSString stringWithFormat:@"auth=%@&action=%@&userID=%@&device_token_id=%@",AUTH,@"myyabs",userId,@"123456"];
    [self serviceCall:@"myyabs":dataString];
    
    //  http://108.179.225.244/~nationalit/team2/yabble/webservice/service.php?auth=acea920f7412b7Ya7be0cfl2b8c937Bc9&action=myyabs&userID=54b768ba5b1620c3288b4567&device_token_id=1111111111
     */
   // http://108.179.225.244:3000/api/yab/myyabs/acea920f7412b7Ya7be0cfl2b8c937Bc9/54bf5fc25b162032298b4567/1111111111
    
    NSString *serverAddress=[NSString stringWithFormat:@"%@%@/%@/%@/%@/",BASE_URL,MY_YABS_URL,AUTH,userId,@"123456"];
    
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
        
        arrMyYabs=[[NSMutableArray alloc]init];
        arrMyYabs=[dict objectForKey:@"yablist"];
    }
    else{
        arrMyYabs=[[NSMutableArray alloc]init];
    }
    [tblMyYab reloadData];
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
      // [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] delegate].window animated:YES];
      //  [MBProgressHUD HUDForView:[[UIApplication sharedApplication] delegate].window].labelText = @"Please wait...";
        app.networkActivityIndicatorVisible = YES;
    }
    
    
    
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    [sessionConfiguration setAllowsCellularAccess:YES];
    [sessionConfiguration setHTTPAdditionalHeaders:@{ @"Accept" : @"application/json" }];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    
    NSURL *url;// = [NSURL URLWithString:[NSString stringWithFormat:@"%@",BASE_URL]];
    
    if ([serviceName isEqualToString:@"myyabs"]) {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",BASE_URL]];
    }
    else if ([serviceName isEqualToString:@"userProfile"]){
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",@"http://108.179.225.244:3000/api/appmember/userProfile"]];
    }
    
    // Configure the Request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:[NSString stringWithFormat:@"%@=%@", strSessName, strSessVal] forHTTPHeaderField:@"Cookie"];
    
    request.HTTPBody = [DataString dataUsingEncoding:NSUTF8StringEncoding];
    
    if ([serviceName isEqualToString:@"myyabs"]) {
        request.HTTPMethod = @"POST";
    }
    else if ([serviceName isEqualToString:@"userProfile"]){
        request.HTTPMethod = @"GET";
    }
    
    
    
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
                                                  if([serviceName isEqualToString:@"myyabs"])
                                                  {
                                                      NSMutableDictionary *dict=[[NSMutableDictionary alloc] initWithDictionary:[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil]];
                                                      
                                                      if ([[dict valueForKey:@"Ack"] integerValue]==1) {
                                                          
                                                          arrMyYabs=[[NSMutableArray alloc]init];
                                                          arrMyYabs=[dict objectForKey:@"yabs"];
                                                      }
                                                      [tblMyYab reloadData];
                                                  }
                                                  else if ([serviceName isEqualToString:@"userProfile"]){
                                                      NSMutableDictionary *dict=[[NSMutableDictionary alloc] initWithDictionary:[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil]];
                                                      
                                                      if ([[dict valueForKey:@"Ack"] integerValue]==1) {
                                                          
                                                          lblName.text=[dict valueForKey:@"name"];
                                                          lblUserName.text=[NSString stringWithFormat:@"@%@",[dict valueForKey:@"username"]];
                                                          lblBio.text=[dict valueForKey:@"bio"];
                                                          lblTotalYab.text=[NSString stringWithFormat:@"%d",[[dict valueForKey:@"totalyabs"] integerValue]];
                                                          
                                                          NSString *strImg;
                                                         
                                                          
                                                          @try {
                                                              strImg=[dict valueForKey:@"img"];
                                                          }
                                                          @catch (NSException *exception) {
                                                              strImg=@"";
                                                          }

                                                          if(strImg.length>0){
                                                              NSString *imgString=[NSString stringWithFormat:@"%@%@",IMAGE_URL,strImg];
                                                              
                                                              
                                                              if (imgProfile.image) {
                                                                  [self setImageWithurl:imgString andImageView:imgProfile];
                                                                  //  imgUser=imgProfile.image;
                                                              }
                                                              else{
                                                                  imgProfile.image=[UIImage imageNamed:@"default.png"];
                                                              }
                                                          }
                                                          else{
                                                              imgProfile.image=[UIImage imageNamed:@"default.png"];
                                                          }
                                                          imgProfile.layer.cornerRadius=35.0f;
                                                          imgProfile.layer.masksToBounds=YES;
                                                          
                                                          [self performSelector:@selector(getMyYabs) withObject:nil afterDelay:0.2];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrMyYabs.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict=[arrMyYabs objectAtIndex:indexPath.row];
    if ([[dict valueForKey:@"image"] length]>0) {
        return 296.0;
    }
    else{
        return 95.0;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSDictionary *dict=[arrMyYabs objectAtIndex:indexPath.row];
    if ([[dict valueForKey:@"image"] length]>0) {
        static NSString *cellIdentifier=@"CellIdentifier";
        HomeCell *cell=(HomeCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell==nil)
        {
            NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"HomeCell" owner:self options:nil];
            cell=[nib objectAtIndex:0];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.scrollCell.delegate=self;
        
        
        cell.lblName.text=[dict valueForKey:@"username"];
        cell.lblLikes.text=[NSString stringWithFormat:@"%d",[[dict valueForKey:@"like"] integerValue]];
        cell.lblDistance.text=[NSString stringWithFormat:@"%@ miles",[dict valueForKey:@"broadcast_radius"]];
        cell.lblHour.text=[dict valueForKey:@"post_time_ago"];
        cell.lblDescription.text=[dict valueForKey:@"message"];
        cell.lblDescription.textAlignment=NSTextAlignmentJustified;
        
        NSString *strImg;
        
        @try {
            strImg=[dict valueForKey:@"img"];
        }
        @catch (NSException *exception) {
            strImg=@"";
        }
        
        NSString *imgString=[NSString stringWithFormat:@"%@%@",IMAGE_URL,strImg];
        [self setImageWithurl:imgString andImageView:cell.imgProfile];
        
        if (cell.imgProfile.image) {
            
        }
        else{
            cell.imgProfile.image=[UIImage imageNamed:@"default.png"];
        }
        
        cell.imgProfile.layer.cornerRadius=45.0f;
        cell.imgProfile.layer.masksToBounds=YES;
        
        cell.image.frame=CGRectMake(20, 84, self.view.frame.size.width-40, 192);
        if ([[dict valueForKey:@"image"] length]>0) {
            NSString *strImage;
            
            @try {
                strImage=[dict valueForKey:@"image"];
            }
            @catch (NSException *exception) {
                strImage=@"";
            }
            [self setImageWithurl:[NSString stringWithFormat:@"%@%@",IMAGE_URL,strImage] andImageView:cell.image];
            cell.image.contentMode=UIViewContentModeScaleAspectFill;
            cell.image.layer.masksToBounds=YES;
        }
        else{
            cell.image.contentMode=UIViewContentModeScaleAspectFit;
            cell.image.layer.masksToBounds=YES;
        }
        
        
        
        [cell.vwblue removeFromSuperview];
        [cell.vwred removeFromSuperview];
        cell.scrollCell.contentSize=CGSizeMake(3*self.view.frame.size.width, 292);
        cell.scrollCell.pagingEnabled=YES;
        cell.vwblue.frame=CGRectMake(0, 0,self.view.frame.size.width, 292);
        cell.vwblue.backgroundColor=[UIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:0.3];
        [cell.vwblue setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
        [cell.scrollCell addSubview:cell.vwblue];
        
        cell.vwred.frame=CGRectMake(2*self.view.frame.size.width, 0,self.view.frame.size.width, 292);
        [cell.vwred setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
        cell.vwred.backgroundColor=[UIColor colorWithWhite:0.0 alpha:0.6];
        cell.vwred.backgroundColor=[UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.3];
        [cell.scrollCell addSubview:cell.vwred];
        
        [cell.scrollCell setContentOffset:CGPointMake(self.view.frame.size.width, 0) animated:YES];
        
        cell.imgProfile.layer.cornerRadius=35.0f;
        cell.imgProfile.layer.masksToBounds=YES;
        
        UIButton *btnImage=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width+20, 99, self.view.frame.size.width-40, 192)];
        [btnImage addTarget:self action:@selector(imageButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        btnImage.tag=indexPath.row;
        [cell.scrollCell addSubview:btnImage];
        
        return cell;
    }
    else{
        static NSString *cellIdentifier=@"CellIdentifier";
        HomeNoImageCell *cell=(HomeNoImageCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell==nil)
        {
            NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"HomeNoImageCell" owner:self options:nil];
            cell=[nib objectAtIndex:0];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.scrollCell.delegate=self;
        
        
        cell.image.frame=CGRectMake(20, 100, self.view.frame.size.width-40, 192);
        if ([[UIScreen mainScreen] bounds].size.height>568) {
            
        }
        else if ([[UIScreen mainScreen] bounds].size.height==568){
            
        }
        else if ([[UIScreen mainScreen] bounds].size.height<568){
            
        }
        
        
        
        cell.lblName.text=[dict valueForKey:@"username"];
        cell.lblLikes.text=[NSString stringWithFormat:@"%d",[[dict valueForKey:@"like"] integerValue]];
        CGFloat distance=[[dict valueForKey:@"distance"] floatValue];
        cell.lblDistance.text=[NSString stringWithFormat:@"%.1f mi",distance];
        cell.lblHour.text=[dict valueForKey:@"post_time_ago"];
        
        cell.lblDescription.text=[dict valueForKey:@"message"];
        cell.lblDescription.numberOfLines = 0;
        cell.lblDescription.frame = CGRectMake(100,40,205,40);
        [cell.lblDescription sizeToFit];
        cell.lblDescription.textAlignment=NSTextAlignmentJustified;
        
        
        NSString *strImg;
        
        @try {
            strImg=[dict valueForKey:@"img"];
        }
        @catch (NSException *exception) {
            strImg=@"";
        }
        
        NSString *imgString=[NSString stringWithFormat:@"%@%@",IMAGE_URL,strImg];
        [self setImageWithurl:imgString andImageView:cell.imgProfile];
        
        if (cell.imgProfile.image) {
            
        }
        else{
            cell.imgProfile.image=[UIImage imageNamed:@"default.png"];
        }
        
        [cell.vwblue removeFromSuperview];
        [cell.vwred removeFromSuperview];
        cell.scrollCell.contentSize=CGSizeMake(3*self.view.frame.size.width, 95);
        cell.scrollCell.pagingEnabled=YES;
        cell.vwblue.frame=CGRectMake(0, 0,self.view.frame.size.width, 95);
        cell.vwblue.backgroundColor=[UIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:0.3];
        [cell.vwblue setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
        [cell.scrollCell addSubview:cell.vwblue];
        
        cell.vwred.frame=CGRectMake(2*self.view.frame.size.width, 0,self.view.frame.size.width, 95);
        [cell.vwred setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
        cell.vwred.backgroundColor=[UIColor colorWithWhite:0.0 alpha:0.6];
        cell.vwred.backgroundColor=[UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.3];
        [cell.scrollCell addSubview:cell.vwred];
        
        [cell.scrollCell setContentOffset:CGPointMake(self.view.frame.size.width, 0) animated:YES];
        
        cell.imgProfile.layer.cornerRadius=35.0f;
        cell.imgProfile.layer.masksToBounds=YES;
        
        return cell;
    }
    
    return nil;
}

-(IBAction)imageButtonTapped:(id)sender{
    NSDictionary *dict=[arrMyYabs objectAtIndex:[sender tag]];
    NSString *strImage;
    
    @try {
        strImage=[dict valueForKey:@"image"];
        strImage=[strImage stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    }
    @catch (NSException *exception) {
        strImage=@"";
    }
    
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc=[storyboard instantiateViewControllerWithIdentifier:@"EnlargeImageController"];
    EnlargeImageController *enlarge=(EnlargeImageController *)vc;
    enlarge.strImage=strImage;
    [self.navigationController pushViewController:vc animated:NO];
}

-(NSString *)GMTtoLocal:(NSString*)myDate
{
    NSLog(@"Befor Convert: %@",myDate);
    NSDateFormatter *df = [NSDateFormatter new];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *someDateInUTC =[df dateFromString:myDate];
    NSTimeInterval timeZoneSeconds = [[NSTimeZone localTimeZone] secondsFromGMT];
    NSDate *dateInLocalTimezone = [someDateInUTC dateByAddingTimeInterval:timeZoneSeconds];
    
    NSDateFormatter *dateFormatters = [[NSDateFormatter alloc] init];
    [dateFormatters setDateFormat:@"HH:mm, dd MMM"];
    //[dateFormatters setDateStyle:NSDateFormatterShortStyle];
    //[dateFormatters setTimeStyle:NSDateFormatterShortStyle];
    //[dateFormatters setDoesRelativeDateFormatting:YES];
    //[dateFormatters setTimeZone:[NSTimeZone localTimeZone]];
    NSString* dateStr = [dateFormatters stringFromDate: dateInLocalTimezone];
    NSLog(@"After Convert : %@", dateStr);
    return dateStr;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(IBAction)btnBackPresed:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)btnSearchPressed:(id)sender{
    
}
-(IBAction)btnYabPlusPressed:(id)sender{
    
}
-(IBAction)btnYabblesPressed:(id)sender{
    imgSelectYabble.hidden=NO;
    imgSelectPhoto.hidden=YES;
    imgSelectChat.hidden=YES;
    
    self.scrollView.hidden=YES;
}


-(IBAction)btnPhotoPressed:(id)sender{
    imgSelectYabble.hidden=YES;
    imgSelectPhoto.hidden=NO;
    imgSelectChat.hidden=YES;
    
    self.scrollView.hidden=NO;
    
    [self performSelector:@selector(getMyPhotos) withObject:nil afterDelay:0.2];
}

// Get all posted photos of user

-(void)getMyPhotos{
   
    
    if (arrPhoto.count==0) {
        NSString *userId;
        if (self.strId.length>0) {
            userId=self.strId;
        }
        else{
            userId=[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"];
        }
        
        
        // http://108.179.225.244:3000/api/yab/myphotos/acea920f7412b7Ya7be0cfl2b8c937Bc9/54f411311eb927f9445c5884/1111111111
        
        
        NSString *serverAddress=[NSString stringWithFormat:@"%@/%@/%@/%@",@"http://108.179.225.244:3000/api/yab/myphotos",AUTH,userId,@"123456"];
        
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
        
        arrPhoto=[dict objectForKey:@"yabList"];
        
        [self ImageGallery:arrPhoto];
    }
    
}

-(void)ImageGallery:(NSArray*)arrImg{
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    int x=2;
    int y=5;
    int count=1;
    for (int i=0; i<arrImg.count; i++) {
        
        UIImageView *subimgView=[[UIImageView alloc]init ];
        
        NSString *imgUrl=[NSString stringWithFormat:@"%@%@",IMAGE_URL,[[arrImg objectAtIndex:i] valueForKey:@"img"]];
        [self setImageWithurl:imgUrl andImageView:subimgView];
        
        subimgView.contentMode=UIViewContentModeScaleAspectFill;
        subimgView.layer.masksToBounds=YES;
        
        [subimgView setFrame: CGRectMake(x, y, self.view.frame.size.width/3-7, self.view.frame.size.width/3-7)];
        [subimgView setUserInteractionEnabled:YES];
        [subimgView.layer setBorderColor: [[UIColor grayColor] CGColor]];
        // [subimgView.layer setBorderWidth: 1.0];
        [subimgView setTag:i];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleImageTap:)];
        [subimgView addGestureRecognizer:tapGesture];
        [self.scrollView addSubview:subimgView];
        
        
        x=x+self.view.frame.size.width/3-7+5;
        if(x>=350){
            y=y+self.view.frame.size.width/3-7+5;
            x=2;
            count=count+1;
            self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width/3-7,self.view.frame.size.width/3*count);
            self.scrollView.frame=CGRectMake(self.scrollView.frame.origin.x, self.scrollView.frame.origin.y, self.scrollView.frame.size.width,self.scrollView.frame.size.height);
        }
    }
    
}

-(void)handleImageTap:(UITapGestureRecognizer *)tapGesture{
    UIImageView *theTappedImageView = (UIImageView *)tapGesture.view;
    NSInteger tag = theTappedImageView.tag;
    
    NSDictionary *dict=[arrPhoto objectAtIndex:tag];
    NSString *strImage;
    
    @try {
        strImage=[dict valueForKey:@"img"];
        strImage=[strImage stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    }
    @catch (NSException *exception) {
        strImage=@"";
    }
    
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc=[storyboard instantiateViewControllerWithIdentifier:@"EnlargeImageController"];
    EnlargeImageController *enlarge=(EnlargeImageController *)vc;
    enlarge.strImage=strImage;
    [self.navigationController pushViewController:vc animated:NO];
}


-(IBAction)btnChatPressed:(id)sender{
    imgSelectYabble.hidden=YES;
    imgSelectPhoto.hidden=YES;
    imgSelectChat.hidden=NO;
    
    self.scrollView.hidden=YES;
}

//action to go to edit page

-(IBAction)btnEditPressed:(id)sender{
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc=[storyboard instantiateViewControllerWithIdentifier:@"EditProfileController"];
    [self.navigationController pushViewController:vc animated:YES];
}




@end
