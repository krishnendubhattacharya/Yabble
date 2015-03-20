//
//  PlacesController.m
//  Yabble
//
//  Created by National It Solution on 28/01/15.
//  Copyright (c) 2015 Suman's. All rights reserved.
//

#import "PlacesController.h"
#import "AppDelegate.h"
#import "LocationCell.h"


@interface PlacesController ()

@end

@implementation PlacesController

- (void)viewDidLoad {
    [super viewDidLoad];
    tblSearch.hidden=NO;
    coordinate = [self getLocation];
    [self performSelector:@selector(searchAPI:) withObject:@"" afterDelay:0.1];
}

//get current location of device

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

//back to previous page

-(IBAction)btnBackPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)btnLocationPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
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
    app.networkActivityIndicatorVisible = YES;
    
    NSString *key=@"AIzaSyDEEucqjLBy7-Lux1fD8Y_YVKz9Ad5Q0JE";//@"AIzaSyCHZruCnmsgtnCz_Kv9AN_zw6yPc_dPVlU";//@"AIzaSyDikVtmCAxygHob8lpVaDY4NtDHN009wo4";
    
    NSString *strLocation=[NSString stringWithFormat:@"%@,%@",[NSString stringWithFormat:@"%f",coordinate.latitude],[NSString stringWithFormat:@"%f",coordinate.longitude]];
    
    NSUInteger radious=[yabreachVal integerValue]*1609;
    
    NSURL *dataUrl=[NSURL URLWithString:[[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?keyword=%@&key=%@&location=%@&radius=%d",text,key,strLocation,radious] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSMutableDictionary *dict=[[NSMutableDictionary alloc] initWithDictionary:[NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:dataUrl] options:kNilOptions error:nil]];
    
   // https://maps.googleapis.com/maps/api/place/nearbysearch/json?input=&location=22.552186,88.35278&radius=500&key=AIzaSyCHZruCnmsgtnCz_Kv9AN_zw6yPc_dPVlU
    
   //  https://maps.googleapis.com/maps/api/place/autocomplete/json?input=Ar&location=22.552186,88.35278&radius=500&key=AIzaSyCHZruCnmsgtnCz_Kv9AN_zw6yPc_dPVlU
    
    arrSearched=[[NSMutableArray alloc]init];
    arrSearched=[dict objectForKey:@"results"];
    
    arrSelection=[[NSMutableArray alloc] init];
    for (int i=0;i<arrSearched.count;i++) {
        [arrSelection insertObject:@"0" atIndex:i];
    }
    
    [tblSearch reloadData];
    app.networkActivityIndicatorVisible = NO;
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
    static NSString *cellIdentifier=@"CellIdentifier";
    LocationCell *cell=(LocationCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil)
    {
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"LocationCell" owner:self options:nil];
        cell=[nib objectAtIndex:0];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    NSDictionary *dict=[arrSearched objectAtIndex:indexPath.row];
   
    cell.lblLocation.text=[NSString stringWithFormat:@"%@, %@",[dict valueForKey:@"name"],[dict valueForKey:@"vicinity"]];
    cell.imgLocation.hidden=YES;
    if ([[arrSelection objectAtIndex:indexPath.row] isEqualToString:@"1"]) {
        cell.imgLocation.hidden=NO;
    }
    
    
    [cell.textLabel setFont:[UIFont fontWithName:@"Helvetica" size:12]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    /*
    tblSearch.hidden=YES;
    [tfSearch resignFirstResponder];
    NSDictionary *dict=[arrSearched objectAtIndex:indexPath.row];
    tfSearch.text=[dict valueForKey:@"description"];
    
    place=tfSearch.text;
    NSString *key=@"AIzaSyAztf7jxAOCZsrji-7j5MJKYAcASTg-uSM";
    NSString *srtUrl=[NSString stringWithFormat:@"https://maps.google.com/maps/api/geocode/json?address=%@&key=%@",tfSearch.text,key];
    NSURL *dataUrl= [NSURL URLWithString:[srtUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    @try {
        
        NSMutableDictionary *jsonDict=[[NSMutableDictionary alloc] initWithDictionary:[NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:dataUrl] options:kNilOptions error:nil]];
        
        NSDictionary *latDic=[[[jsonDict valueForKey:@"results"] valueForKey:@"geometry"] valueForKey:@"location"];
        NSLog(@"%@",latDic);
        NSArray *lat=[latDic valueForKey:@"lat"];
        NSArray *lng=[latDic valueForKey:@"lng"];
        placeLat=[NSString stringWithFormat:@"%@",[lat objectAtIndex:0]];
        placeLong=[NSString stringWithFormat:@"%@",[lng objectAtIndex:0]];
    }
    @catch (NSException *exception)
    {
        NSLog(@"Exception Occured");
    }
    */
    
    arrSelection=[[NSMutableArray alloc] init];
    for (int i=0;i<arrSearched.count;i++) {
        [arrSelection insertObject:@"0" atIndex:i];
    }
    [arrSelection replaceObjectAtIndex:indexPath.row withObject:@"1"];
    [tblSearch reloadData];
    
    NSDictionary *dict1=[arrSearched objectAtIndex:indexPath.row];
    
    tfSearch.text=[NSString stringWithFormat:@"%@, %@",[dict1 valueForKey:@"name"],[dict1 valueForKey:@"vicinity"]];
    
    NSDictionary *dict=[[[arrSearched objectAtIndex:indexPath.row] objectForKey:@"geometry"] objectForKey:@"location"];
    
    placeLat=[NSString stringWithFormat:@"%@",[dict valueForKey:@"lat"]];
    placeLong=[NSString stringWithFormat:@"%@",[dict valueForKey:@"lng"]];
    
}

@end
