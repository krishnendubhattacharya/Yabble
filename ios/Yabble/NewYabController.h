//
//  NewYabController.h
//  Yabble
//
//  Created by National It Solution on 14/01/15.
//  Copyright (c) 2015 Suman's. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <AssetsLibrary/AssetsLibrary.h> 


@interface NewYabController : UIViewController<UITextViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
{
    IBOutlet UIImageView *imgProfile; //uiiamgeview showing user profile image
    IBOutlet UILabel *lblName; //label showing user name
    IBOutlet UILabel *lblEmail; 
    IBOutlet UILabel *lblCountText; //label counting remaning text in description
    IBOutlet UITextView *tvDescription; //text view for description
    
    ALAssetsLibrary *library;
    NSArray *imageArray;
    NSMutableArray *mutableArray;
    NSMutableArray *arrUrl;
    
    IBOutlet UIImageView *imgBorderLocator;  //selection image for location
    IBOutlet UIImageView *imgBorderGallery;  //selection image for gallery
    IBOutlet UIImageView *imgBorderYab;  //selection image for yab
    
    IBOutlet UICollectionView *collectionGallery;
}
@property(strong,nonatomic)UIImage *choosenImage;
@property(strong,nonatomic)IBOutlet UIScrollView *scrollView;  //scroll view showing images from gallery

-(IBAction)btnCrossPressed:(id)sender;  //action for back to previous page
-(IBAction)btnLocationPressed:(id)sender; //action to go location page
-(IBAction)btnGalerryPressed:(id)sender;  //action to show gallery images
-(IBAction)btnYabblePressed:(id)sender; //action for yab
-(IBAction)btnSendPressed:(id)sender;   //action to go post yab page

@end
