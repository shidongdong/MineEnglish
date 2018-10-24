//
//  DeleteClassTableViewCell.h
//  X5Teacher
//
//  Created by yebw on 2018/2/3.
//  Copyright © 2018年 netease. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const DeleteClassTableViewCellId;
extern CGFloat const DeleteClassTableViewCellHeight;

typedef void(^DeleteClassTableViewCellDeleteCallback)(void);

@interface DeleteClassTableViewCell : UITableViewCell

@property (nonatomic, copy) DeleteClassTableViewCellDeleteCallback callback;

@end

