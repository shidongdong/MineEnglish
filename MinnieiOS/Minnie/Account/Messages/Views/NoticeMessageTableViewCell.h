//
//  NoticeMessageTableViewCell.h
//  X5
//
//  Created by yebw on 2017/9/4.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeMessage.h"

extern NSString * const NoticeMessageTableViewCellId;

@interface NoticeMessageTableViewCell : UITableViewCell

+ (CGFloat)heightWithMessage:(NoticeMessage *)message;

- (void)setupWithMessage:(NoticeMessage *)message;

@end
