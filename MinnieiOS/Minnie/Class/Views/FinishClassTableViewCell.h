//
//  DeleteClassTableViewCell.h
//  X5Teacher
//
//  Created by yebw on 2018/2/3.
//  Copyright © 2018年 netease. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const FinishClassTableViewCellId;
extern CGFloat const FinishClassTableViewCellHeight;

typedef void(^FinishClassTableViewCellDeleteCallback)(void);

@interface FinishClassTableViewCell : UITableViewCell

@property (nonatomic, copy) FinishClassTableViewCellDeleteCallback callback;

@end

