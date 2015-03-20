//
//  PostAbbController.m
//  Yabble
//
//  Created by National It Solution on 16/01/15.
//  Copyright (c) 2015 Suman's. All rights reserved.
//

#import "PostAbbController.h"
#import "AppDelegate.h"


@interface PostAbbController ()

@end

@implementation PostAbbController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    slider = [[RangeSlider alloc] initWithFrame:CGRectMake(20, 100, self.view.frame.size.width-40, 2)]; // the slider enforces a height of 30, although I'm not sure that this is necessary
    
    slider.minimumRangeLength = .00; // this property enforces a minimum range size. By default it is set to 0.0
    
    [slider setMinThumbImage:[UIImage imageNamed:@"rangethumb.png"]]; // the two thumb controls are given custom images
    [slider setMaxThumbImage:[UIImage imageNamed:@"rangethumb.png"]];
    
    
    UIImage *image; // there are two track images, one for the range "track", and one for the filled in region of the track between the slider thumbs
    
    [slider setTrackImage:[[UIImage imageNamed:@"fullrange.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(9.0, 9.0, 9.0, 9.0)]];
    
    image = [UIImage imageNamed:@"fillrange.png"];
    [slider setInRangeTrackImage:image];
    slider.min=0;
    slider.max=1;
    lblSliderMin.text=@"14";
    lblSliderMax.text=@"50";
    [slider addTarget:self action:@selector(report:) forControlEvents:UIControlEventValueChanged];
    [viewType addSubview:slider];
    
    
    [sliderDistance setThumbImage:[UIImage imageNamed:@"crcle15.png"]
                         forState:UIControlStateNormal];
    sliderDistance.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
    
    [self setScrollView];
    
    
    imgProfile.image=self.img;
    imgProfile.contentMode=UIViewContentModeScaleAspectFill;
    imgProfile.layer.masksToBounds=YES;
    
    tvDescription.text=self.str;
    lblName.text=nameUser;
    lblUserName.text=[NSString stringWithFormat:@"@%@",userName];
    lblPlace.text=place;
    
    [switchExpiration setOn:NO];
    datePickerExpiration.hidden=YES;
    lblExpiration.text=@"";

    
    tfSearch.text=place;
    tblSearch.hidden=YES;
    [self setPrevSettings];
}


-(void)viewDidDisappear:(BOOL)animated{
    app.networkActivityIndicatorVisible=NO;
}
//set scrollview for different description sizes

-(void)setScrollView{
    NSString *str =self.str;
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:15];
    CGSize maximumSize = CGSizeMake(self.view.frame.size.width-40, MAXFLOAT);
    CGSize strSize = [str sizeWithFont:font constrainedToSize:maximumSize lineBreakMode:NSLineBreakByWordWrapping];
    strSize=CGSizeMake(maximumSize.width, strSize.height);
    tvDescription.numberOfLines=0;
    tvDescription.frame=CGRectMake(20, 0, self.view.frame.size.width-40, strSize.height+20);
    tvDescription.adjustsFontSizeToFitWidth=YES;
    tvDescription.minimumScaleFactor=0.5;
    
    viewDescription.frame=CGRectMake(viewDescription.frame.origin.x, viewDescription.frame.origin.y, self.view.frame.size.width, strSize.height);
    
    viewType.frame=CGRectMake(viewType.frame.origin.x, viewDescription.frame.origin.y+strSize.height, self.view.frame.size.width, viewType.frame.size.height);
    
    viewExpiration.frame=CGRectMake(viewExpiration.frame.origin.x, viewType.frame.origin.y+viewType.frame.size.height, self.view.frame.size.width, viewExpiration.frame.size.height);
}

//set previous settins

-(void)setPrevSettings{
    NSUserDefaults *prefs=[NSUserDefaults standardUserDefaults];
    NSString *postCategoryType=[prefs valueForKey:@"postCategoryType"];
    if ([postCategoryType isEqualToString:@"E"]) {
        [segType setSelectedSegmentIndex:0];
    }
    else if ([postCategoryType isEqualToString:@"M"]){
        [segType setSelectedSegmentIndex:1];
    }
    else if ([postCategoryType isEqualToString:@"F"]){
        [segType setSelectedSegmentIndex:2];
    }
    
    NSString *postAgeMax=[prefs valueForKey:@"postAgeMax"];
    if (postAgeMax) {
        CGFloat fMax=[postAgeMax floatValue]/100;
        slider.max=fMax*2;
        lblSliderMax.text=[NSString stringWithFormat:@"%.0f",fMax*100];
    }
    
    NSString *postAgeMin=[prefs valueForKey:@"postAgeMin"];
    if (postAgeMin) {
        CGFloat fMin=[postAgeMin floatValue]/100;
        
        slider.min=fMin;
        lblSliderMin.text=[NSString stringWithFormat:@"%.0f",fMin*100];
    }
    
    NSString *postDistance=[prefs valueForKey:@"postDistance"];
    if (postDistance) {
        sliderDistance.value=[postDistance integerValue];
        lblDistance.text=[NSString stringWithFormat:@"%@ mi",postDistance];
    }
}
// action when range slider value changed
- (void)report:(RangeSlider *)sender {

    
    if ((sender.min*100)/2+14<=50) {
        lblSliderMin.text=[NSString stringWithFormat:@"%.0f",(sender.min*100)/2+14];
    }
    if ((sender.max*100)/2>=14) {
        lblSliderMax.text=[NSString stringWithFormat:@"%.0f",(sender.max*100)/2];
    }
    
    
    
    NSUserDefaults *prefs=[NSUserDefaults standardUserDefaults];
    NSLog(@"min=%@",lblSliderMin.text);
    
    [prefs setValue:lblSliderMin.text forKey:@"postAgeMin"];
    [prefs setValue:lblSliderMax.text forKey:@"postAgeMax"];
    [prefs synchronize];
}


-(void)viewWillAppear:(BOOL)animated{
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{

}
-(void)textFieldDidEndEditing:(UITextField *)textField{
 
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
    
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    tblSearch.hidden=NO;
    [self performSelector:@selector(searchAPI:) withObject:textField.text afterDelay:0.1];
    return YES;
}

-(void)searchAPI:(NSString *)text{

    
    NSString *key=@"AIzaSyCHZruCnmsgtnCz_Kv9AN_zw6yPc_dPVlU";
    
    NSURL *dataUrl=[NSURL URLWithString:[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%@&key=%@",text,key]];
    
    NSMutableDictionary *dict=[[NSMutableDictionary alloc] initWithDictionary:[NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:dataUrl] options:kNilOptions error:nil]];
    
    // https://maps.googleapis.com/maps/api/place/autocomplete/json?input=Ar&location=22.552186,88.35278&radius=500&key=AIzaSyCHZruCnmsgtnCz_Kv9AN_zw6yPc_dPVlU
    
    arrSearched=[[NSMutableArray alloc]init];
    arrSearched=[dict objectForKey:@"predictions"];
    [tblSearch reloadData];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30.0;
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrSearched.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }
    NSDictionary *dict=[arrSearched objectAtIndex:indexPath.row];
    cell.contentView.backgroundColor=[UIColor colorWithRed:135.0/255.0 green:195.0/255.0 blue:191.0/255.0 alpha:1];
    
    cell.textLabel.text=[dict valueForKey:@"description"];
    [cell.textLabel setFont:[UIFont fontWithName:@"Helvetica" size:12]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    tblSearch.hidden=YES;
    [tfSearch resignFirstResponder];
    NSDictionary *dict=[arrSearched objectAtIndex:indexPath.row];
    tfSearch.text=[dict valueForKey:@"description"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)switchExpirationValueChanged:(id)sender{
    if ([switchExpiration isOn]) {
        NSDate *now=[NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSString *strDate = [dateFormatter stringFromDate:now];
        lblExpiration.text=strDate;
        
        scrollView.contentSize=CGSizeMake(320, 640);
        scrollView.frame=CGRectMake(0, 65, self.view.frame.size.width, self.view.frame.size.height-65-50);
        scrollView.scrollEnabled=YES;
        
        
       // datePickerExpiration.frame=CGRectMake(22, 77, 277, 195);
        datePickerExpiration.hidden=NO;
        
        [scrollView setContentOffset:CGPointMake(0, 160) animated:YES];
    }
    else{
        lblExpiration.text=@"";
        
        scrollView.contentSize=CGSizeMake(320, self.view.frame.size.height-65-50);
        scrollView.frame=CGRectMake(0, 65, self.view.frame.size.width, self.view.frame.size.height-50-65);
        [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        scrollView.scrollEnabled=NO;
        
        datePickerExpiration.hidden=YES;
        
        
    }
}
//action for slider distance value changed
-(IBAction)sliderDistanceValueChanged:(id)sender{
    int result = (int)sliderDistance.value;
    NSString *sliderVal=[NSString stringWithFormat:@"%d",result];
    lblDistance.text=[NSString stringWithFormat:@"%@ mi",sliderVal];
    
    NSUserDefaults *prefs=[NSUserDefaults standardUserDefaults];
    [prefs setValue:[NSString stringWithFormat:@"%.0f",sliderDistance.value] forKey:@"postDistance"];
    [prefs synchronize];
    
    CGRect trackRect = [sliderDistance trackRectForBounds:sliderDistance.bounds];
    CGRect thumbRect = [sliderDistance thumbRectForBounds:sliderDistance.bounds
                                                trackRect:trackRect
                                                    value:sliderDistance.value];
    
    lblDistance.center = CGPointMake(23+thumbRect.origin.x, 200);
}

//action fires when segment type value changed

-(IBAction)segmentTypeChanged:(id)sender{
    NSUserDefaults *prefs=[NSUserDefaults standardUserDefaults];
    
    if (segType.selectedSegmentIndex==0) {
        [prefs setValue:@"E" forKey:@"postCategoryType"];
    }
    else if (segType.selectedSegmentIndex==1){
        [prefs setValue:@"M" forKey:@"postCategoryType"];
    }
    else if(segType.selectedSegmentIndex==2){
        [prefs setValue:@"F" forKey:@"postCategoryType"];
    }
    [prefs synchronize];
}

//action for expiration datepicker

-(IBAction)datePickerValueChanged:(id)sender{
    UIDatePicker *datePicker=(UIDatePicker *)sender;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *strDate = [dateFormatter stringFromDate:datePicker.date];
    lblExpiration.text=strDate;
}

-(IBAction)btnCrossPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)btnSendYabPressed:(id)sender{
    app.networkActivityIndicatorVisible = YES;
    [self uploadPhoto:@"postyab"];
}


-(UIImage*)imageWithImage: (UIImage*) sourceImage scaledToWidth: (float) i_width
{
    float oldWidth = sourceImage.size.width;
    float scaleFactor = i_width / oldWidth;
    
    float newHeight = sourceImage.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


-(void)uploadPhoto:(NSString*)ServiceName
{
    coordinate = [self getLocation];
    NSString *latitude;
    NSString *longitude;
    
    if (place.length>0) {
        latitude=placeLat;
        longitude=placeLong;
    }
    else{
        latitude=[NSString stringWithFormat:@"%f",coordinate.latitude];
        longitude=[NSString stringWithFormat:@"%f",coordinate.longitude];
    }
    
    NSString *userId=[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"];
    NSString *strType;
    
    if (segType.selectedSegmentIndex==0) {
        strType=@"E";
    }
    else if (segType.selectedSegmentIndex==0){
        strType=@"M";
    }
    else{
        strType=@"F";
    }
    
    int result = (int)sliderDistance.value;
    NSString *sliderVal=[NSString stringWithFormat:@"%d",result];
    
    
    NSString *strMin=lblSliderMin.text;
    NSString *strMax=lblSliderMax.text;
    
    
    UIImage *UserImage=[self imageWithImage:imgProfile.image scaledToWidth:560];
    
    NSString *img_height=[NSString stringWithFormat:@"%f",UserImage.size.height];
    NSString *img_width=[NSString stringWithFormat:@"%f",UserImage.size.width];
    
    
    NSString *urlString = @"http://108.179.225.244:3000/api/yab/postyab";
    
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
    body=[self appendData:body boundary:boundary parameterName:@"message" parameterValue:tvDescription.text];
    body=[self appendData:body boundary:boundary parameterName:@"target_group" parameterValue:strType];
    body=[self appendData:body boundary:boundary parameterName:@"broadcasting_radius" parameterValue:sliderVal];
    body=[self appendData:body boundary:boundary parameterName:@"min_age" parameterValue:strMin];
    body=[self appendData:body boundary:boundary parameterName:@"max_age" parameterValue:strMax];
    body=[self appendData:body boundary:boundary parameterName:@"exp" parameterValue:lblExpiration.text];
    body=[self appendData:body boundary:boundary parameterName:@"location" parameterValue:place];
    body=[self appendData:body boundary:boundary parameterName:@"lat" parameterValue:latitude];
    body=[self appendData:body boundary:boundary parameterName:@"long" parameterValue:longitude];
    body=[self appendData:body boundary:boundary parameterName:@"imagewidth" parameterValue:img_width];
    body=[self appendData:body boundary:boundary parameterName:@"imageheight" parameterValue:img_height];
    body=[self appendData:body boundary:boundary parameterName:@"business_id" parameterValue:@""];
    body=[self appendData:body boundary:boundary parameterName:@"device_token_id" parameterValue:@"123456"];
    
    NSData *imgData = UIImageJPEGRepresentation(imgProfile.image, 0.7);
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
                     UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
                     UIViewController *vc=[storyboard instantiateViewControllerWithIdentifier:@"HomeController"];
                     [self.navigationController pushViewController:vc animated:YES];
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


/*
//action for uploading post with photo

-(void)uploadPhoto:(NSString*)ServiceName
{
    coordinate = [self getLocation];
    NSString *latitude;
    NSString *longitude;
    
    if (place.length>0) {
        latitude=placeLat;
        longitude=placeLong;
    }
    else{
        latitude=[NSString stringWithFormat:@"%f",coordinate.latitude];
        longitude=[NSString stringWithFormat:@"%f",coordinate.longitude];
    }
    
    NSString *userId=[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"];
    NSString *strType;
    
    if (segType.selectedSegmentIndex==0) {
        strType=@"E";
    }
    else if (segType.selectedSegmentIndex==0){
        strType=@"M";
    }
    else{
        strType=@"F";
    }
    
    int result = (int)sliderDistance.value;
    NSString *sliderVal=[NSString stringWithFormat:@"%d",result];
    
    
    NSString *strMin=lblSliderMin.text;
    NSString *strMax=lblSliderMax.text;
    
    
    UIImage *UserImage=[self imageWithImage:imgProfile.image scaledToWidth:560];
    
    NSString *img_height=[NSString stringWithFormat:@"%f",UserImage.size.height];
    NSString *img_width=[NSString stringWithFormat:@"%f",UserImage.size.width];
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",@"http://108.179.225.244:3000/api/appmember/postyab"]] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:120000];
    
    NSMutableData *myRequestData = [[NSMutableData alloc] init];
    NSString *boundary = [NSString stringWithFormat:@"--"];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    
    myRequestData=[self makeData:myRequestData :boundary :@"String":@"":@"auth":[AUTH dataUsingEncoding:NSUTF8StringEncoding]];
    
   // myRequestData=[self makeData:myRequestData :boundary :@"String":@"":@"action":[ServiceName dataUsingEncoding:NSUTF8StringEncoding]];
    
    myRequestData=[self makeData:myRequestData :boundary :@"String":@"":@"userID":[userId dataUsingEncoding:NSUTF8StringEncoding]];
    
    myRequestData=[self makeData:myRequestData :boundary :@"String":@"":@"message":[tvDescription.text dataUsingEncoding:NSUTF8StringEncoding]];
    
    myRequestData=[self makeData:myRequestData :boundary :@"String":@"":@"target_group":[strType dataUsingEncoding:NSUTF8StringEncoding]];
    
    myRequestData=[self makeData:myRequestData :boundary :@"String":@"":@"broadcasting_radius":[sliderVal dataUsingEncoding:NSUTF8StringEncoding]];
    
    myRequestData=[self makeData:myRequestData :boundary :@"String":@"":@"min_age":[strMin dataUsingEncoding:NSUTF8StringEncoding]];
    
    myRequestData=[self makeData:myRequestData :boundary :@"String":@"":@"max_age":[strMax dataUsingEncoding:NSUTF8StringEncoding]];
    
    myRequestData=[self makeData:myRequestData :boundary :@"String":@"":@"expiration":[lblExpiration.text dataUsingEncoding:NSUTF8StringEncoding]];
    
    myRequestData=[self makeData:myRequestData :boundary :@"String":@"":@"location":[tfSearch.text dataUsingEncoding:NSUTF8StringEncoding]];
    
    myRequestData=[self makeData:myRequestData :boundary :@"String":@"":@"lat":[latitude dataUsingEncoding:NSUTF8StringEncoding]];
    
    myRequestData=[self makeData:myRequestData :boundary :@"String":@"":@"long":[longitude dataUsingEncoding:NSUTF8StringEncoding]];
    
    myRequestData=[self makeData:myRequestData :boundary :@"String":@"":@"imagewidth":[img_width dataUsingEncoding:NSUTF8StringEncoding]];
    
    myRequestData=[self makeData:myRequestData :boundary :@"String":@"":@"imageheight":[img_height dataUsingEncoding:NSUTF8StringEncoding]];
    
    myRequestData=[self makeData:myRequestData :boundary :@"String":@"":@"business_id":[@"" dataUsingEncoding:NSUTF8StringEncoding]];
    
    myRequestData=[self makeData:myRequestData :boundary :@"String":@"":@"device_token_id":[@"123456" dataUsingEncoding:NSUTF8StringEncoding]];
    
    

    
    
    if (UserImage) {
        myRequestData=[self makeData:myRequestData :boundary :@"File":@"jpg":@"profile_picture":UIImageJPEGRepresentation(UserImage, 0.7)];
    }
    
    [request setHTTPMethod: @"POST"];
    [request setHTTPBody:myRequestData];
    
    
    app.networkActivityIndicatorVisible = YES;
    
    // Configure the Session
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    [sessionConfiguration setAllowsCellularAccess:YES];
    [sessionConfiguration setHTTPAdditionalHeaders:@{ @"Accept" : @"application/json" }];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    
    [request setValue:[NSString stringWithFormat:@"%@=%@", strSessName, strSessVal] forHTTPHeaderField:@"Cookie"];
    
    
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
                                                      UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                                      UIViewController *vc=[storyboard instantiateViewControllerWithIdentifier:@"HomeController"];
                                                      [self.navigationController pushViewController:vc animated:YES];
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
    //locationManager.location=newLocation;
    //CLLocation *location = [locationManager location];
    coordinate = [newLocation coordinate];
}

@end
