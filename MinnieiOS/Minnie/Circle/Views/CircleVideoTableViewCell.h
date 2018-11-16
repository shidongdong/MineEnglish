//
//  CircleVideoTableViewCell.h
//  X5
//
//  Created by yebw on 2017/10/8.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "CircleContentBaseTableViewCell.h"

typedef void(^CircleVideoClickCallback)(void);


extern NSString * const CircleVideoTableViewCellId;

@interface CircleVideoTableViewCell : CircleContentBaseTableViewCell

@property (nonatomic, copy) CircleVideoClickCallback videoClickCallback;

+ (CGFloat)cellHeight;

@end
