//
//  ImageYabCell.h
//  Yabble
//
//  Created by National It Solution on 17/01/15.
//  Copyright (c) 2015 Suman's. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageYabCell : UITableViewCell
@property(strong,nonatomic)IBOutlet UIImageView *imgProfile;
@property(strong,nonatomic)IBOutlet UILabel *lblName;
@property(strong,nonatomic)IBOutlet UIView *vwLikes;
@property(strong,nonatomic)IBOutlet UIView *vwDistance;
@property(strong,nonatomic)IBOutlet UILabel *lblDescription;
@property(strong,nonatomic)IBOutlet UILabel *lblHour;
@property(strong,nonatomic)IBOutlet UILabel *lblLikes;
@property(strong,nonatomic)IBOutlet UILabel *lblDistance;
@property(strong,nonatomic)IBOutlet UIScrollView *scrollCell;

@property(strong,nonatomic)IBOutlet UIImageView *image;
@end
