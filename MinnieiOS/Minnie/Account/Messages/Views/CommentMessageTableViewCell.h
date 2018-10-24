//
//  CommentMessageTableViewCell.h
//  X5
//
//  Created by yebw on 2017/9/12.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Comment.h"

extern CGFloat const CommentMessageTableViewCellHeight;
extern NSString *const CommentMessageTableViewCellId;

@interface CommentMessageTableViewCell : UITableViewCell

- (void)setupWithMessage:(Comment *)message;

@end
