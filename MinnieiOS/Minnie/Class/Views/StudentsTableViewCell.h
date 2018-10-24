//
//  StudentsTableViewCell.h
//  X5Teacher
//
//  Created by yebw on 2018/1/29.
//  Copyright © 2018年 netease. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const StudentsTableViewCellId;

@interface StudentsTableViewCell : UITableViewCell

- (void)setupWithStudents:(NSArray *)students;

+ (CGFloat)cellHeightWithStudents:(NSArray *)students;

@end
