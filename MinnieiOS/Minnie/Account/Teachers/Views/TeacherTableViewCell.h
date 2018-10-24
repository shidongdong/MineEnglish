//
//  TeacherTableViewCell.h
//  X5Teacher
//
//  Created by yebw on 2017/12/19.
//  Copyright © 2017年 netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Teacher.h"

extern NSString * const TeacherTableViewCellId;
extern CGFloat const TeacherTableViewCellHeight;

@interface TeacherTableViewCell : UITableViewCell

- (void)setupWithTeacher:(Teacher *)teacher;

@end
