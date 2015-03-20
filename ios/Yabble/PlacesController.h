//
//  PlacesController.h
//  Yabble
//
//  Created by National It Solution on 28/01/15.
//  Copyright (c) 2015 Suman's. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>


@interface PlacesController : UIViewController<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate>
{
    IBOutlet UITextField *tfSearch;  //text field for search location
    IBOutlet UITableView *tblSearch; //table that populates valus after serach by google autocomplete
    
    CLLocationManager *locationManager;
    NSMutableArray *arrSearched;  // array for searched values
    CLLocationCoordinate2D coordinate;
    
    NSMutableArray *arrSelection; //array for selection in searched listing
}

-(IBAction)btnBackPressed:(id)sender; //action to back previous page
-(IBAction)btnLocationPressed:(id)sender; //action enabled location

@end
