//
//  TextMessageTableViewCell.h
// X5
//
//  Created by yebw on 2017/8/25.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "MessageTableViewCell.h"

typedef void(^TextMessageTableViewClickCallback)(void); // 点击回调

extern NSString * const LeftTextMessageTableViewCellId;
extern NSString * const RightTextMessageTableViewCellId;

@interface TextMessageTableViewCell : MessageTableViewCell

@property (nonatomic, copy) TextMessageTableViewClickCallback clickCallback;

@end

