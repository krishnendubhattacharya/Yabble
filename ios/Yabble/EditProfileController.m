//
//  EditProfileController.m
//  Yabble
//
//  Created by National It Solution on 16/01/15.
//  Copyright (c) 2015 Suman's. All rights reserved.
//

#import "EditProfileController.h"
#import "AppDelegate.h"


@interface EditProfileController ()

@end

@implementation EditProfileController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    imgProfile.layer.cornerRadius=40.0f;
    imgProfile.layer.masksToBounds=YES;
    scrollView.contentSize=CGSizeMake(320, 523);
    scrollView.frame=CGRectMake(0, 134, self.view.frame.size.width, self.view.frame.size.height-134);
    scrollView.scrollEnabled=YES;
    
    [segGender setUserInteractionEnabled:NO];
    
    [self performSelector:@selector(getUserInfo) withObject:nil afterDelay:0.2];
}

-(void)viewWillAppear:(BOOL)animated{
    
}

-(void)viewWillDisappear:(BOOL)animated{
    app.networkActivityIndicatorVisible = NO;
}

//get user information from server

-(void)getUserInfo{
    
    NSString *userId=[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"];
    
    NSString *serverAddress=[NSString stringWithFormat:@"%@/%@/%@/%@/",@"http://108.179.225.244:3000/api/appmember/userInfo",AUTH,userId,@"123456"];
    
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
    
    NSDictionary *userDetails=[parsedObject objectForKey:@"userdetails"];
    
    lblName.text=[userDetails valueForKey:@"name"];
    
    NSString *strDescription=[userDetails valueForKey:@"bio"];
    
    if (strDescription.length>0) {
        tvDescription.text=[userDetails valueForKey:@"bio"];
    }
    else{
        tvDescription.text=@"Edit";
    }
    
    lblUserName.text=[NSString stringWithFormat:@"@%@",[userDetails valueForKey:@"username"]];
    
    NSString *strImg;
    imageString=strImg;
    
    @try {
        strImg=[userDetails valueForKey:@"img"];
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
    
    
    tfName.text=[userDetails valueForKey:@"name"];
    tfUserName.text=[userDetails valueForKey:@"username"];
    // tfBio.text=[userDetails valueForKey:@"bio"];
    
    NSString *strGender=[userDetails valueForKey:@"gender"];
    if ([strGender isEqualToString:@"M"]) {
        segGender.selectedSegmentIndex=0;
    }
    else{
        segGender.selectedSegmentIndex=1;
    }
    
    tfEmail.text=[userDetails valueForKey:@"email"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *serverDate=[dateFormatter dateFromString:[userDetails valueForKey:@"dob"]];
    
    [dateFormatter setDateFormat:@"MM-dd-yyyy"];
    
    NSString *strDate = [dateFormatter stringFromDate:serverDate];
    tfDateofBirth.text=strDate;
    
    
    //  tfDateofBirth.text=[userDetails valueForKey:@"dob"];
    
    facebook.text=[userDetails valueForKey:@"facebook"];
    twitter.text=[userDetails valueForKey:@"twitter"];
    instagram.text=[userDetails valueForKey:@"instagram"];
    
}


-(void)serviceCall:(NSString*)serviceName :(NSString*)DataString
{
    if([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable)
    {
        [MMNeedMethods showNetworkError];
        return;
    }
    
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
                                              
                                              NSLog(@"Dict: %@",retVal);
                                              
                                              
                                              
                                              // Update the View
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] delegate].window animated:YES];
                                                  app.networkActivityIndicatorVisible = NO;
                                                  if([serviceName isEqualToString:@"userInfo"])
                                                  {
                                                      NSMutableDictionary *dict=[[NSMutableDictionary alloc] initWithDictionary:[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil]];
                                                      
                                                      if ([[dict valueForKey:@"Ack"] integerValue]==1) {
                                                          
                                                          NSDictionary *userDetails=[dict objectForKey:@"UserDetails"];
                                                          
                                                          lblName.text=[userDetails valueForKey:@"name"];
                                                          
                                                          NSString *strDescription=[userDetails valueForKey:@"bio"];
                                                          
                                                          if (strDescription.length>0) {
                                                              tvDescription.text=[userDetails valueForKey:@"bio"];
                                                          }
                                                          else{
                                                              tvDescription.text=@"Edit";
                                                          }
                                                          
                                                          lblUserName.text=[NSString stringWithFormat:@"@%@",[userDetails valueForKey:@"username"]];
                                                          
                                                          NSString *strImg;
                                                          imageString=strImg;
                                                          
                                                          @try {
                                                              strImg=[userDetails valueForKey:@"img"];
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
                                                          
                                                          
                                                          tfName.text=[userDetails valueForKey:@"name"];
                                                          tfUserName.text=[userDetails valueForKey:@"username"];
                                                         // tfBio.text=[userDetails valueForKey:@"bio"];
                                                          
                                                          NSString *strGender=[userDetails valueForKey:@"gender"];
                                                          if ([strGender isEqualToString:@"M"]) {
                                                              segGender.selectedSegmentIndex=0;
                                                          }
                                                          else{
                                                              segGender.selectedSegmentIndex=1;
                                                          }
                                                          
                                                          tfEmail.text=[userDetails valueForKey:@"email"];
                                                          
                                                          NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                                                          [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                                                          NSDate *serverDate=[dateFormatter dateFromString:[userDetails valueForKey:@"dob"]];
                                                          
                                                          [dateFormatter setDateFormat:@"MM-dd-yyyy"];
                                                          
                                                          NSString *strDate = [dateFormatter stringFromDate:serverDate];
                                                          tfDateofBirth.text=strDate;
                                                          
                                                          facebook.text=[userDetails valueForKey:@"facebook"];
                                                          twitter.text=[userDetails valueForKey:@"twitter"];
                                                          instagram.text=[userDetails valueForKey:@"instagram"];
                                                      }
                                                  }
                                                  else if ([serviceName isEqualToString:@"editprofile"]){
                                                      
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

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//action to change profile picture

-(IBAction)btnProfilePicPressed:(id)sender{
    actnstphoto=[[UIActionSheet alloc] initWithTitle:@"Add Photo" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:Nil otherButtonTitles:@"Add Photos from Camera",@"Add Photos from Album", nil];
    actnstphoto.actionSheetStyle=UIActionSheetStyleBlackTranslucent;
    [actnstphoto showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = (id)self;
    picker.allowsEditing = YES;
    switch (buttonIndex)
    {
        case 0:
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self.navigationController presentViewController:picker animated:YES completion:nil];
            break;
        case 1:
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self.navigationController presentViewController:picker animated:YES completion:nil];
            break;
        default:
            break;
            
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *chooseimage = info[UIImagePickerControllerEditedImage];
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
        imgProfile.image=chooseimage;
    }];
}



-(void)textFieldDidBeginEditing:(UITextField *)textField{

}
-(void)textFieldDidEndEditing:(UITextField *)textField{

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
    
}


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag==1) {
        pckrvwStart = [[UIDatePicker alloc]init];
        pckrvwStart.tag=2;
        pckrvwStart.datePickerMode=UIDatePickerModeDate;
        [pckrvwStart addTarget:self action:@selector(datePickerChanged:) forControlEvents:UIControlEventValueChanged];
        textField.inputView = pckrvwStart;
        
      //  viewDone.hidden=NO;
    }
    
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return FALSE;
    }
    return TRUE;
}

// action to change datepicker value

- (void)datePickerChanged:(UIDatePicker *)datePicker
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yyyy"];
    NSString *strDate = [dateFormatter stringFromDate:datePicker.date];
    tfDateofBirth.text=strDate;
    
}

// action when touch main view

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [tfDateofBirth resignFirstResponder];
    [tfEmail resignFirstResponder];
    [tfName resignFirstResponder];
    [tfUserName resignFirstResponder];
    [tfBio resignFirstResponder];
    [facebook resignFirstResponder];
    [twitter resignFirstResponder];
    [instagram resignFirstResponder];
}

// go to previous page

-(IBAction)btnCrossPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
// action to save user's edited data

-(IBAction)btnSavePressed:(id)sender{
     app.networkActivityIndicatorVisible = YES;
    strName=tfName.text;
    strUserName=tfUserName.text;
    strBio=tfBio.text;
    [self uploadPhoto:@"editprofile"];
}

/*
-(void)uploadPhoto:(NSString*)ServiceName
{
    [tvDescription resignFirstResponder];
    
    NSString *userId=[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"];
    NSString *strGender;
    
    if (segGender.selectedSegmentIndex==0) {
        strGender=@"M";
    }
    else{
        strGender=@"F";
    }
    
    UIImage *UserImage=imgProfile.image;
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",@"http://108.179.225.244:3000/api/appmember/editprofile"]] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:120000];
    
    NSMutableData *myRequestData = [[NSMutableData alloc] init];
    NSString *boundary = [NSString stringWithFormat:@"--"];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    
    myRequestData=[self makeData:myRequestData :boundary :@"String":@"":@"auth":[AUTH dataUsingEncoding:NSUTF8StringEncoding]];
    
    myRequestData=[self makeData:myRequestData :boundary :@"String":@"":@"action":[ServiceName dataUsingEncoding:NSUTF8StringEncoding]];
    
    myRequestData=[self makeData:myRequestData :boundary :@"String":@"":@"userID":[userId dataUsingEncoding:NSUTF8StringEncoding]];
    
    myRequestData=[self makeData:myRequestData :boundary :@"String":@"":@"name":[tfName.text dataUsingEncoding:NSUTF8StringEncoding]];
    
    myRequestData=[self makeData:myRequestData :boundary :@"String":@"":@"uname":[tfUserName.text dataUsingEncoding:NSUTF8StringEncoding]];
    
    myRequestData=[self makeData:myRequestData :boundary :@"String":@"":@"email":[tfEmail.text dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *des;
    if ([tvDescription.text isEqualToString:@"Edit" ]) {
        des=@"";
    }
    else{
        des=tvDescription.text;
    }
    
    myRequestData=[self makeData:myRequestData :boundary :@"String":@"":@"bio":[des dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yyyy"];
    NSDate *myDate=[dateFormatter dateFromString:tfDateofBirth.text];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *strDate=[dateFormatter stringFromDate:myDate];
    
    myRequestData=[self makeData:myRequestData :boundary :@"String":@"":@"dob":[strDate dataUsingEncoding:NSUTF8StringEncoding]];
    
    myRequestData=[self makeData:myRequestData :boundary :@"String":@"":@"gender":[strGender dataUsingEncoding:NSUTF8StringEncoding]];
    
    myRequestData=[self makeData:myRequestData :boundary :@"String":@"":@"facebook":[facebook.text dataUsingEncoding:NSUTF8StringEncoding]];
    
    myRequestData=[self makeData:myRequestData :boundary :@"String":@"":@"twitter":[twitter.text dataUsingEncoding:NSUTF8StringEncoding]];
    
    myRequestData=[self makeData:myRequestData :boundary :@"String":@"":@"instagram":[instagram.text dataUsingEncoding:NSUTF8StringEncoding]];
    
    myRequestData=[self makeData:myRequestData :boundary :@"String":@"":@"show_social":[@"1" dataUsingEncoding:NSUTF8StringEncoding]];
    
    myRequestData=[self makeData:myRequestData :boundary :@"String":@"":@"device_token_id":[@"123456" dataUsingEncoding:NSUTF8StringEncoding]];
    

    myRequestData=[self makeData:myRequestData :boundary :@"File":@"jpg":@"profile_picture":UIImageJPEGRepresentation(UserImage, 0.7)];
    [request setHTTPMethod: @"POST"];
    [request setHTTPBody:myRequestData];
    

    app.networkActivityIndicatorVisible = YES;
    
    // Configure the Session
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    [sessionConfiguration setAllowsCellularAccess:YES];
    [sessionConfiguration setHTTPAdditionalHeaders:@{ @"Accept" : @"application/json" }];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    
    //[request setValue:[NSString stringWithFormat:@"%@=%@", strSessName, strSessVal] forHTTPHeaderField:@"Cookie"];
    
    
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
                                              NSLog(@"the post value:%@",retVal);
                                              
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] delegate].window animated:YES];
                                                  app.networkActivityIndicatorVisible = NO;
                                                  
                                                  NSDictionary *completeimgdict=[[NSMutableDictionary alloc] initWithDictionary:[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil]];
                                                  
                                                  
                                                  
                                                  if ([[completeimgdict objectForKey:@"Ack"] integerValue]==1) {
                                                      [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] delegate].window animated:YES];

                                                      lblName.text=strName;
                                                     // lblDescription.text=strBio;
                                                      lblUserName.text=strUserName;
                                                      imgUser=imgProfile.image;
                                                      [self saveImage:imgProfile.image];
                                                      nameUser=strName;
                                                      userName=strUserName;
                                                      
                                                      NSUserDefaults *prefs=[NSUserDefaults standardUserDefaults];
                                                      
                                                      [prefs setObject:strUserName forKey:@"user"];
                                                      [prefs setObject:strName forKey:@"name"];
                                                      [prefs synchronize];
                                                      
                                                      bioUser=strBio;
                                                      
                                                      UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Yabble" message:@"Profile edited successfully" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                                                      [alert show];
                                                  }
                                                  if (tvDescription.text.length==0) {
                                                      tvDescription.text=@"Edit";
                                                  }
                                                  
                                                  
                                              });
                                              
                                              
                                          }];
    
    // Initiate the Request
    [postDataTask resume];
}




-(NSMutableData*)makeData:(NSMutableData *)myRequestData :(NSString*)boundary :(NSString*)dataType :(NSString*)extention :(NSString*)name :(NSData*)data
{
    [myRequestData appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    if([dataType isEqualToString:@"String"])
    {
        [myRequestData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n",name] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    else
    {
        [myRequestData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"Manab.%@\"\r\n",name,extention]dataUsingEncoding:NSUTF8StringEncoding]];
    }
    [myRequestData appendData:[[NSString stringWithFormat:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [myRequestData appendData:data];
    [myRequestData appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    return myRequestData;
}

 */

// save profile image to documents folder

- (void)saveImage: (UIImage*)image
{
    if (image != nil)
    {
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



-(void)uploadPhoto:(NSString*)ServiceName
{
    NSString *userId=[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"];
    NSString *strGender;
    if (segGender.selectedSegmentIndex==0)
    {
        strGender=@"M";
    }
    else
    {
        strGender=@"F";
    }
    NSData *imgData = UIImageJPEGRepresentation(imgProfile.image, 0.7);
    NSString *des;
    if ([tvDescription.text isEqualToString:@"Edit" ])
    {
        des=@"";
    }
    else
    {
        des=tvDescription.text;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yyyy"];
    NSDate *myDate=[dateFormatter dateFromString:tfDateofBirth.text];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *strDate=[dateFormatter stringFromDate:myDate];
    
    
    NSString *urlString = @"http://108.179.225.244:3000/api/appmember/editprofile";
    
    // create request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:30];
    [request setURL:[NSURL URLWithString:urlString]];
    
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = [NSString stringWithFormat:@"---------------------------14737809831464368775746641449"];
    
    // set Content-Type in HTTP header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // post body
    NSMutableData *body = [NSMutableData data];
    
    // add params (all params are strings)
    
    
    body=[self appendData:body boundary:boundary parameterName:@"authkey" parameterValue:AUTH];
    body=[self appendData:body boundary:boundary parameterName:@"userid" parameterValue:userId];
    body=[self appendData:body boundary:boundary parameterName:@"email" parameterValue:tfEmail.text];
    body=[self appendData:body boundary:boundary parameterName:@"name" parameterValue:tfName.text];
    body=[self appendData:body boundary:boundary parameterName:@"uname" parameterValue:tfUserName.text];
    body=[self appendData:body boundary:boundary parameterName:@"bio" parameterValue:des];
    body=[self appendData:body boundary:boundary parameterName:@"dob" parameterValue:strDate];
    body=[self appendData:body boundary:boundary parameterName:@"gender" parameterValue:strGender];
    body=[self appendData:body boundary:boundary parameterName:@"facebook" parameterValue:@""];
    body=[self appendData:body boundary:boundary parameterName:@"twitter" parameterValue:@""];
    body=[self appendData:body boundary:boundary parameterName:@"instagram" parameterValue:@""];
    body=[self appendData:body boundary:boundary parameterName:@"show_social" parameterValue:@"1"];
    body=[self appendData:body boundary:boundary parameterName:@"device_token_id" parameterValue:@"1234567890"];
    
    // add image data
    body=[self appendDataImage:body boundary:boundary parameterName:@"profile_picture" parameterValue:imgData];
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    // set URL
    [request setURL:[NSURL URLWithString:urlString]];
    
    [NSURLConnection sendAsynchronousRequest: request
                                       queue: [NSOperationQueue mainQueue]
                           completionHandler: ^(NSURLResponse *response,
                                                NSData *data,
                                                NSError *connectionError)
     {
         if (data.length > 0 && connectionError == nil)
         {
             //The data for the response is in "data" Do whatever is required
             
             NSString *retVal = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
             NSLog(@"the post value:%@",retVal);
             dispatch_async(dispatch_get_main_queue(), ^{
                 [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] delegate].window animated:YES];
                 app.networkActivityIndicatorVisible = NO;
                 
                 NSDictionary *completeimgdict=[[NSMutableDictionary alloc] initWithDictionary:[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil]];
                 
                 
                 
                 if ([[completeimgdict objectForKey:@"Ack"] integerValue]==1) {
                     [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] delegate].window animated:YES];
                     
                     lblName.text=strName;
                     // lblDescription.text=strBio;
                     lblUserName.text=strUserName;
                     imgUser=imgProfile.image;
                     [self saveImage:imgProfile.image];
                     nameUser=strName;
                     userName=strUserName;
                     
                     NSUserDefaults *prefs=[NSUserDefaults standardUserDefaults];
                     
                     [prefs setObject:strUserName forKey:@"user"];
                     [prefs setObject:strName forKey:@"name"];
                     [prefs synchronize];
                     
                     bioUser=strBio;
                     
                     UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Yabble" message:@"Profile edited successfully" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                     [alert show];
                 }
                 if (tvDescription.text.length==0) {
                     tvDescription.text=@"Edit";
                 }
                 
                 
             });
         }
     }
     ];
}

-(NSMutableData*)appendData:(NSMutableData *)body boundary:(NSString *)boundary parameterName:(NSString *)parameterName parameterValue:(NSString *)parameterValue
{
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",parameterName] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[parameterValue dataUsingEncoding:NSUTF8StringEncoding]];
    return body;
}

-(NSMutableData*)appendDataImage:(NSMutableData *)body boundary:(NSString *)boundary parameterName:(NSString *)parameterName parameterValue:(NSData *)parameterValue
{
    if(parameterValue)
    {
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"MMTestImage.jpg\"\r\n",parameterName] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:parameterValue];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    return body;
}

-(IBAction)btnFacebookPressed:(id)sender{
    //[MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] delegate].window animated:YES];
    //[MBProgressHUD HUDForView:[[UIApplication sharedApplication] delegate].window].labelText = @"Logging in...";
    
    if (!accountStore) accountStore = [[ACAccountStore alloc] init];
    
    ACAccountType *fbActType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    
    
    /*NSDictionary *options = [[NSDictionary alloc] initWithObjectsAndKeys:
     FbAppId,  ACFacebookAppIdKey,
     [NSArray arrayWithObject:@"email"], ACFacebookPermissionsKey,
     nil];*/
    
    NSDictionary *options = [[NSDictionary alloc] initWithObjectsAndKeys:
                             FbAppId, ACFacebookAppIdKey,[NSArray arrayWithObject:@"email"] , ACFacebookPermissionsKey,
                             nil];
    
    //:@"email,publish_actions"
    //,@"publish_actions",@"publish_stream"
    
    
    [accountStore requestAccessToAccountsWithType:fbActType options:options completion:^(BOOL granted, NSError *error) {
        if (granted) {
            NSLog(@"Success");
            NSArray *accounts = [accountStore accountsWithAccountType:fbActType];
            faceBookAc = [accounts lastObject];
            [self getUserInfoFacebook];
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^(void){
                [MMNeedMethods showOnlyAlert:@"Cannot Proceed" :[NSString stringWithFormat:@"Please enable service for Facebook in device Settings->Facebook->YabbleApp"]];
                [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] delegate].window animated:YES];
            });
            
            // Fail gracefully...
        }
    }
     ];

}

-(void)getUserInfoFacebook
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"http://someurl.com/someimage.jpg", @"picture",
                                   @"LetzFlow Blog", @"name",
                                   @"https://blog.letzflow.com", @"link",
                                   @"LetzFlow shows you how to use Facebook.", @"caption",
                                   @"On old devices we need to do it the old way...", @"description",
                                   nil];
    
    [FBRequestConnection startWithGraphPath:@"me/feed" parameters:params HTTPMethod:@"POST"
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                              if (error) {
                                  NSLog(@"Error on publishing story: %@", error);
                              } else {
                                  NSLog(@"Published story successfully");
                              }
                          }];
}

-(void)requestCompleted:connection forFbID:fbId result:result error:error{
    
}

-(IBAction)btnTwitterPressed:(id)sender{
    
}
-(IBAction)btnInstagramPressed:(id)sender{
    
}


-(void)cancelButtonAction:(NSData *)responseData
{
    
    NSMutableDictionary *DictUser=[[NSMutableDictionary alloc] initWithDictionary:[NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil]];
    @try {
        if([[DictUser objectForKey:@"error"] isEqualToString:@""] || [DictUser objectForKey:@"error"]==Nil)
        {
           /* [FBRequestConnection startWithGraphPath:[NSString stringWithFormat:@"/%@/feed",[DictUser objectForKey:@"id"]]
                                         parameters:nil
                                         HTTPMethod:@"GET"
                                  completionHandler:^(
                                                      FBRequestConnection *connection,
                                                      id result,
                                                      NSError *error
                                                      ) {
                                  }];*/
            
            
            NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                           @"Sharing Tutorial", @"name",
                                           @"Build great social apps and get more installs.", @"caption",
                                           @"Allow your users to share stories on Facebook from your app using the iOS SDK.", @"description",
                                           @"https://developers.facebook.com/docs/ios/share/", @"link",
                                           @"http://i.imgur.com/g3Qc1HN.png", @"picture",
                                           nil];
            
            // Make the request
            [FBRequestConnection startWithGraphPath:[NSString stringWithFormat:@"/%@/feed",[DictUser objectForKey:@"id"]]
                                         parameters:params
                                         HTTPMethod:@"POST"
                                  completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                      if (!error) {
                                          // Link posted successfully to Facebook
                                          NSLog(@"result: %@", result);
                                      } else {
                                          // An error occurred, we need to handle the error
                                          // See: https://developers.facebook.com/docs/ios/errors
                                          NSLog(@"%@", error.description);
                                      }
                                  }];
        }
        else
        {
            [MMNeedMethods showOnlyAlert:@"Error occued" :@"There are some unknown error occurred logging in with facebook, Please reenable facebook service in iPhone settings for this application and try again"];
        }
    }
    @catch (NSException *exception) {
        [MMNeedMethods showOnlyAlert:@"Error occued" :@"There are some unknown error occurred logging in with facebook, Please reenable facebook service in iPhone settings for this application and try again"];
    }
    
    
    
    
    
}
@end
