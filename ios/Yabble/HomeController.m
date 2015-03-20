//
//  HomeController.m
//  Yabble
//
//  Created by National It Solution on 14/01/15.
//  Copyright (c) 2015 Suman's. All rights reserved.
//

#import "HomeController.h"
#import "HomeCell.h"
#import "ImageYabCell.h"
#import "AppDelegate.h"
#import "EnlargeImageController.h"
#import "HomeNoImageCell.h"
#import "ProfileController.h"
#import "YabDetailsController.h"


NSIndexPath *indexpath;
NSUInteger slideSite;


@interface HomeController ()

@end

@implementation HomeController
@synthesize refreshControl;

- (void)viewDidLoad
{
    [super viewDidLoad];
    //--------------------scale factor-----------------
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    CGFloat scalefactor=screenWidth/320;
    
    windowWidth=screenWidth;
    windowHeight=screenHeight;
    scaleFactor=scalefactor;
    
    viewSettings.frame=CGRectMake(-self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
   //tblHome.frame=CGRectMake(0, -20, self.view.frame.size.width, self.view.frame.size.height);
    
    
    imgProfile.layer.cornerRadius=60.0f;
    imgProfile.layer.masksToBounds=YES;
    
    sliderDistance.thumbTintColor = [UIColor blackColor];
    
    
    UIToolbar *blurView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    blurView.barStyle = UIBarStyleBlackOpaque;
    [viewSettings addSubview:blurView];
    
    [viewSettings insertSubview:blurView atIndex:0];
    
    lblName.font = [UIFont fontWithName:@"Pacifico" size:15];
    [sliderDistance setThumbImage:[UIImage imageNamed:@"crcle15_white.png"]
                         forState:UIControlStateNormal];
    sliderDistance.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
    
    
    refreshControl = [[UIRefreshControl alloc]init];
    
    [tblHome setBackgroundColor: [UIColor clearColor]];
    [tblHome setOpaque: NO];

    arrYabs=[[NSMutableArray alloc]init];
}

-(void)refreshTable
{
    [refreshControl endRefreshing];
}

-(void)viewWillAppear:(BOOL)animated
{
    //get user image saved in documents folder
    
    imgUser=[self loadImage];
    if (imgUser) {
        imgProfile.image=imgUser;
    }
    else{
        imgProfile.image=[UIImage imageNamed:@"default.png"];
    }
    imgProfile.layer.cornerRadius=60.0f;
    imgProfile.layer.masksToBounds=YES;
    
    //get user name from nsuserdefaults
    
    NSUserDefaults *prefs=[NSUserDefaults standardUserDefaults];
    NSString *fname=[prefs valueForKey:@"name"];
    if (fname.length>0) {
        lblName.text=[NSString stringWithFormat:@"Hi %@ !",fname];
        nameUser=fname;
    }
    else{
        lblName.text=[NSString stringWithFormat:@"Hi"];
        nameUser=fname;
    }
    
    
    NSString *fuser_name=[prefs valueForKey:@"user"];
    if (fuser_name.length>0) {
        userName=fuser_name;
    }
    else{
        userName=fuser_name;
    }
    
    
    yabreachVal=[prefs valueForKey:@"yabreach"];
    
    
    sliderDistance.value=[yabreachVal integerValue];
    [self sliderValueChanged:sliderDistance];
    
    
    //lblSlider.text=[NSString stringWithFormat:@"%@ mi",yabreachVal];
    
    
    
    
    [sliderDistance addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
    [sliderDistance addTarget:self action:@selector(sliderChangedEnded:) forControlEvents:UIControlEventTouchUpInside];

    /*
    t = [NSTimer scheduledTimerWithTimeInterval: 30
                                         target: self
                                       selector:@selector(updatePositionAPI:)
                                       userInfo: nil repeats:YES];
    */
/*
    t1 = [NSTimer scheduledTimerWithTimeInterval: 30
                                         target: self
                                       selector:@selector(getYabs)
                                       userInfo: nil repeats:YES];
*/
    
  //  [self performSelector:@selector(getYabs) withObject:nil afterDelay:0.2];
    
    
}

-(void)sliderChanged:(id)sender
{

}

// action for slider in menu

-(void)sliderChangedEnded:(id)sender
{
    int result = (int)sliderDistance.value;
    NSString *sliderVal=[NSString stringWithFormat:@"%d",result];
    
    NSUserDefaults *prefs=[NSUserDefaults standardUserDefaults];
    [prefs setObject:sliderVal forKey:@"yabreach"];
    
    NSString *userId=[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"];
    
    NSString *dataString = [NSString stringWithFormat:@"authkey=%@&userID=%@&show_address=%@&yabreach=%@&device_token_id=%@",AUTH,userId,@"1",sliderVal,@"123456"];
    [self serviceCall:@"userSetting":dataString];
}

// load user image saved in document folder

- (UIImage*)loadImage
{
    NSString *imageFileName=[NSString stringWithFormat:@"Documents/feedback_profile.png"];
    imageFileName = [NSHomeDirectory() stringByAppendingPathComponent:imageFileName];
    UIImage *newImage=[UIImage imageWithContentsOfFile:imageFileName];
    return  newImage;

}

// get yab listing

-(void)getYabs{
   // http://108.179.225.244:3000/api/yab/getyabs/:authkey/:userid/:device_token_id/:lat/:longi
    
    coordinate = [self getLocation];
    /*
    NSString *userId=[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"];
    
    NSString *dataString = [NSString stringWithFormat:@"auth=%@&action=%@&userID=%@&lat=%f&long=%f&device_token_id=%@",AUTH,@"getyabs",userId,coordinate.latitude,coordinate.longitude,@"123456"];
    [self serviceCall:@"getyabs":dataString];
    */
    NSString *userId=[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"];

    NSString *serverAddress=[NSString stringWithFormat:@"%@%@/%@/%@/%@/%f/%f",BASE_URL,GET_YABS_URL,AUTH,userId,@"123456",coordinate.latitude,coordinate.longitude];
    
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
    
    if ([[dict valueForKey:@"totalyabs"] integerValue]==0) {
        lblTotalYabs.text=@"No";
        lblTotalYabsSetting.text=@"No";
        
        arrYabs=[[NSMutableArray alloc]init];
    }
    else{
        lblTotalYabs.text=[NSString stringWithFormat:@"%ld",(long)[[dict valueForKey:@"totalyabs"] integerValue]];
        lblTotalYabsSetting.text=[NSString stringWithFormat:@"%ld",(long)[[dict valueForKey:@"totalyabs"] integerValue]];
        
        arrYabs=[dict objectForKey:@"yablist"];
    }
    
}

// update user current position

-(void)updatePositionAPI:(NSString *)text{
    coordinate = [self getLocation];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *userID=[prefs objectForKey:@"userId"];
    
    NSString *dataString = [NSString stringWithFormat:@"authkey=%@&userID=%@&lat=%f&longi=%f&device_token_id=%@",AUTH,userID,coordinate.latitude,coordinate.longitude,@"123456"];
    [self serviceCall:@"updateuserposition":dataString];
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
    
    NSURL *url;// = [NSURL URLWithString:[NSString stringWithFormat:@"%@",BASE_URL]];
    
    if ([serviceName isEqualToString:@"updateuserposition"]) {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,UPDATE_USER_POSITION_URL]];
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
                                                  if([serviceName isEqualToString:@"updateuserposition"])
                                                  {
                                                      NSMutableDictionary *dict=[[NSMutableDictionary alloc] initWithDictionary:[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil]];
                                                      
                                                      if ([[dict valueForKey:@"Ack"] integerValue]==1) {
                                                          
                                                          
                                                          
                                                      }
                                                      else
                                                      {
                                                          
                                                      }
                                                  }
                                                  else if([serviceName isEqualToString:@"getyabs"])
                                                  {
                                                      NSMutableDictionary *dict=[[NSMutableDictionary alloc] initWithDictionary:[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil]];
                                                      
                                                      if ([[dict valueForKey:@"Ack"] integerValue]==1) {
                                                          
                                                          arrYabs=[[NSMutableArray alloc]init];
                                                          
                                                          if ([[dict valueForKey:@"Count"] integerValue]==0) {
                                                              lblTotalYabs.text=@"No";
                                                              lblTotalYabsSetting.text=@"No";
                                                              
                                                              arrYabs=[[NSMutableArray alloc]init];
                                                          }
                                                          else{
                                                              lblTotalYabs.text=[NSString stringWithFormat:@"%ld",(long)[[dict valueForKey:@"Count"] integerValue]];
                                                              lblTotalYabsSetting.text=[NSString stringWithFormat:@"%ld",(long)[[dict valueForKey:@"Count"] integerValue]];
                                                              
                                                              arrYabs=[dict objectForKey:@"yabs"];
                                                            
                                                          }
                                                          
                                                          
                                                      }
                                                      else{
                                                          arrYabs=[[NSMutableArray alloc]init];
                                                          
                                                          if ([[dict valueForKey:@"Count"] integerValue]==0) {
                                                              lblTotalYabs.text=@"No";
                                                              lblTotalYabsSetting.text=@"No";
                                                          }
                                                          else{
                                                              lblTotalYabs.text=[NSString stringWithFormat:@"%ld",(long)[[dict valueForKey:@"Count"] integerValue]];
                                                              lblTotalYabsSetting.text=[NSString stringWithFormat:@"%ld",(long)[[dict valueForKey:@"Count"] integerValue]];
                                                          }
                                                      }
                                                      
                                                      [tblHome reloadData];
                                                  }
                                                  else if ([serviceName isEqualToString:@"userSetting"]){
                                                      NSMutableDictionary *dict=[[NSMutableDictionary alloc] initWithDictionary:[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil]];
                                                      
                                                      if ([[dict valueForKey:@"Ack"] integerValue]==1) {
                                                          
                                                      }
                                                  }
                                              });
                                          }];
    
    // Initiate the Request
    [postDataTask resume];
    
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
    coordinate = [newLocation coordinate];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrYabs.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *dict=[arrYabs objectAtIndex:indexPath.row];
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
    
    NSDictionary *dict=[arrYabs objectAtIndex:indexPath.row];
    
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
        cell.lblLikes.text=[NSString stringWithFormat:@"%ld",(long)[[dict valueForKey:@"like"] integerValue]];
        cell.lblDistance.text=[NSString stringWithFormat:@"%@ miles",[dict valueForKey:@"broadcast_radius"]];
        cell.lblHour.text=[dict valueForKey:@"post_time_ago"];
        cell.lblDescription.text=[dict valueForKey:@"message"];
        //cell.lblDescription.textAlignment=NSTextAlignmentJustified;
        
        NSLog(@"my indexpath=%ld",(long)indexpath.row);
        
        
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
        
        
        UIButton *btnDetails=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width+0, 0, self.view.frame.size.width, 296)];
        [btnDetails addTarget:self action:@selector(detailsButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        btnDetails.tag=indexPath.row;
        [cell.scrollCell addSubview:btnDetails];
        
        UIButton *btnImage=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width+20, 99, self.view.frame.size.width-40, 192)];
        [btnImage addTarget:self action:@selector(imageButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        btnImage.tag=indexPath.row;
        [cell.scrollCell addSubview:btnImage];
        
        
        UIButton *btnProfile=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width+20, 8, 70, 70)];
        [btnProfile addTarget:self action:@selector(profileButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        btnProfile.tag=indexPath.row;
        [cell.scrollCell addSubview:btnProfile];
        
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
        cell.lblLikes.text=[NSString stringWithFormat:@"%ld",(long)[[dict valueForKey:@"like"] integerValue]];
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
        
        
        UIButton *btnDetails=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width+0, 0, self.view.frame.size.width, 95)];
        [btnDetails addTarget:self action:@selector(detailsButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        btnDetails.tag=indexPath.row;
        [cell.scrollCell addSubview:btnDetails];
        
        
        UIButton *btnProfile=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width+20, 8, 70, 70)];
        [btnProfile addTarget:self action:@selector(profileButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        btnProfile.tag=indexPath.row;
        [cell.scrollCell addSubview:btnProfile];
        
        return cell;
    }
    
    return nil;
}

//go to yab details page

-(IBAction)detailsButtonTapped:(id)sender{
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc=[storyboard instantiateViewControllerWithIdentifier:@"YabDetailsController"];
    YabDetailsController *yabDetails=(YabDetailsController*)vc;
    NSDictionary *dict=[arrYabs objectAtIndex:[sender tag]];
    yabDetails.yab_id=[[dict objectForKey:@"yab_id"] valueForKey:@"$id"];
    
    [self.navigationController pushViewController:vc animated:YES];
}

// enlarge tapped image

-(IBAction)imageButtonTapped:(id)sender{
    NSDictionary *dict=[arrYabs objectAtIndex:[sender tag]];
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

// go to user profile page

-(IBAction)profileButtonTapped:(id)sender{
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc=[storyboard instantiateViewControllerWithIdentifier:@"ProfileController"];
    ProfileController *pc=(ProfileController*)vc;
    NSDictionary *dict=[arrYabs objectAtIndex:[sender tag]];
    pc.strId=[[dict objectForKey:@"userid"] valueForKey:@"$id"] ;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{

}

-(NSString *)GMTtoLocal:(NSString*)myDate
{
    NSDateFormatter *df = [NSDateFormatter new];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *someDateInUTC =[df dateFromString:myDate];
    NSTimeInterval timeZoneSeconds = [[NSTimeZone localTimeZone] secondsFromGMT];
    NSDate *dateInLocalTimezone = [someDateInUTC dateByAddingTimeInterval:timeZoneSeconds];
    
    NSDateFormatter *dateFormatters = [[NSDateFormatter alloc] init];
    [dateFormatters setDateFormat:@"HH:mm, dd MMM"];
    NSString* dateStr = [dateFormatters stringFromDate: dateInLocalTimezone];
    return dateStr;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{

}


-(IBAction)btnMenuHomePressed:(id)sender{
    [UIView animateWithDuration:0.45 animations:^{
        viewSettings.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }];
}

-(IBAction)btnMenuSettingsPressed:(id)sender{
    [UIView animateWithDuration:0.45 animations:^{
        viewSettings.frame=CGRectMake(-self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
    }];
}

-(IBAction)btnNewPostPressed:(id)sender{
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc=[storyboard instantiateViewControllerWithIdentifier:@"NewYabController"];
    [self.navigationController pushViewController:vc animated:YES];
}

-(IBAction)btnChatPressed:(id)sender{
    
}

-(IBAction)sliderValueChanged:(id)sender{
    int result = (int)sliderDistance.value;
    NSString *sliderVal=[NSString stringWithFormat:@"%d",result];
    lblSlider.text=[NSString stringWithFormat:@"%@ mi",sliderVal];
    
    CGRect trackRect = [sliderDistance trackRectForBounds:sliderDistance.bounds];
    CGRect thumbRect = [sliderDistance thumbRectForBounds:sliderDistance.bounds
                                               trackRect:trackRect
                                                   value:sliderDistance.value];
    
    lblSlider.center = CGPointMake(28+thumbRect.origin.x, 438);
}

-(IBAction)btnSettingsPressed:(id)sender{
    
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc=[storyboard instantiateViewControllerWithIdentifier:@"SettingsController"];
    [self.navigationController pushViewController:vc animated:YES];
}

-(IBAction)btnEditProfilePressed:(id)sender{
    
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc=[storyboard instantiateViewControllerWithIdentifier:@"ProfileController"];
    [self.navigationController pushViewController:vc animated:YES];
}


-(void)viewWillDisappear:(BOOL)animated{
    [t invalidate];
    [t1 invalidate];
}
@end
