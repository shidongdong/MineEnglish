//
//  HomeworkDetailLikeUsersTableViewCell.h
//  X5
//
//  Created by yebw on 2017/11/15.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

extern NSString * const HomeworkDetailLikeUsersTableViewCellId;

@interface HomeworkDetailLikeUsersTableViewCell : UITableViewCell

- (void)setupWithLikeUsers:(NSArray <User *> *)users;

+ (CGFloat)heightWithLikeUsers:(NSArray <User *> *)users;

@end
