//
//  NoticeMessageImageItemTableViewCell.h
//  X5
//
//  Created by yebw on 2017/9/19.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeMessageItem.h"

extern NSString * const NoticeMessageImageItemTableViewCellId;

@interface NoticeMessageImageItemTableViewCell : UITableViewCell

+ (CGFloat)heightWithMessageItem:(NoticeMessageItem *)item;

- (void)setupWithMessageItem:(NoticeMessageItem *)item;
    
@end
