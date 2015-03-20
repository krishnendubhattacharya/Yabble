//
//  HomeNoImageCell.h
//  Yabble
//
//  Created by National It Solution on 04/02/15.
//  Copyright (c) 2015 Suman's. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeNoImageCell : UITableViewCell
@property(strong,nonatomic)IBOutlet UIImageView *imgProfile;
@property(strong,nonatomic)IBOutlet UIImageView *image;
@property(strong,nonatomic)IBOutlet UILabel *lblName;
@property(strong,nonatomic)IBOutlet UIView *vwLikes;
@property(strong,nonatomic)IBOutlet UIView *vwDistance;
@property(strong,nonatomic)IBOutlet UILabel *lblDescription;
@property(strong,nonatomic)IBOutlet UILabel *lblHour;
@property(strong,nonatomic)IBOutlet UILabel *lblLikes;
@property(strong,nonatomic)IBOutlet UILabel *lblDistance;
@property(strong,nonatomic)IBOutlet UIScrollView *scrollCell;


@property(strong,nonatomic)IBOutlet UIView *vwblue;
@property(strong,nonatomic)IBOutlet UIView *vwred;

@property(strong,nonatomic)IBOutlet UIView *vwBlurred;


@property(strong,nonatomic)IBOutlet UIButton *btnChat;
@property(strong,nonatomic)IBOutlet UIButton *btnArrow;
@property(strong,nonatomic)IBOutlet UIButton *btnHeart;


@property(strong,nonatomic)IBOutlet UIButton *btnAlert;
@property(strong,nonatomic)IBOutlet UIButton *btnDislike;
@property(strong,nonatomic)IBOutlet UIButton *btnMute;
@end
