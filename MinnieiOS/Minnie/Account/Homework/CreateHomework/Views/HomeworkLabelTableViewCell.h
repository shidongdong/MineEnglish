//
//  HomeworkLabelTableViewCell.h
//  X5Teacher
//
//  Created by yebw on 2018/1/24.
//  Copyright © 2018年 netease. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const HomeworkLabelTableViewCellId;
extern CGFloat const HomeworkLabelTableViewCellHeight;

@interface HomeworkLabelTableViewCell : UITableViewCell

- (void)setupWithText:(NSString *)text;

@end
