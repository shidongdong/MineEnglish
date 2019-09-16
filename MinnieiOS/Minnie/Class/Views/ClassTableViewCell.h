//
//  ClassTableViewCell.h
//  X5Teacher
//
//  Created by yebw on 2017/12/16.
//  Copyright © 2017年 netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Clazz.h"

extern NSString * const ClassTableViewCellId;
extern CGFloat const ClassTableViewCellHeight;

@interface ClassTableViewCell : UITableViewCell

- (void)setupWithClass:(Clazz *)clazz;

- (void)updateSelectState:(BOOL)selected;

@end

