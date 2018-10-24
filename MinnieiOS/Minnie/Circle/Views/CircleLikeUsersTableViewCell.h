//
//  CircleLikeUsersTableViewCell.h
//  X5
//
//  Created by yebw on 2017/10/8.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YYText/YYText.h>
#import "User.h"


extern NSString * const CircleLikeUsersTableViewCellId;

@interface CircleLikeUsersTableViewCell : UITableViewCell

- (void)setupWithLikeUsers:(NSArray <User *> *)users;

+ (CGFloat)heightWithLikeUsers:(NSArray <User *> *)users;

@end
