//
//  EnlargeImageController.h
//  Yabble
//
//  Created by National It Solution on 30/01/15.
//  Copyright (c) 2015 Suman's. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MINIMUM_SCALE 1.0
#define MAXIMUM_SCALE 10.0

@interface EnlargeImageController : UIViewController<UIGestureRecognizerDelegate,UIScrollViewDelegate>
{
    IBOutlet UIScrollView *scrlvwFullImage;
    IBOutlet UIImageView *image; //image which is to be enlarge
    CGFloat lastScale;
}
@property(strong,nonatomic)NSString *strImage; //url string for image

-(IBAction)btnCancelPressed:(id)sender; // action enlarge photo display cancel
@end
