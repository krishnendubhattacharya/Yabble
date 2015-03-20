//
//  CommentCell.h
//  Yabble
//
//  Created by National It Solution on 06/02/15.
//  Copyright (c) 2015 Suman's. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentCell : UITableViewCell
@property(strong,nonatomic)IBOutlet UIImageView *imgProfile;
@property(strong,nonatomic)IBOutlet UILabel *lblName;
@property(strong,nonatomic)IBOutlet UILabel *lblUsername;
@property(strong,nonatomic)IBOutlet UILabel *lblDate;
@property(strong,nonatomic)IBOutlet UILabel *lblComment;

@end
