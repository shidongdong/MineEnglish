//
//  ClassSelectorTableViewCell.h
//  X5Teacher
//
//  Created by yebw on 2017/12/27.
//  Copyright © 2017年 netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Clazz.h"

extern NSString * const ClassSelectorTableViewCellId;
extern CGFloat const ClassSelectorTableViewCellHeight;

@interface ClassSelectorTableViewCell : UITableViewCell

@property (nonatomic, assign) BOOL choice;

- (void)setupWithClazz:(Clazz *)clazz;

@end
