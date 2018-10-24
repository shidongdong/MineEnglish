//
//  ClassScheduleAndStudentsTableViewCell.h
//  X5Teacher
//
//  Created by yebw on 2018/1/28.
//  Copyright © 2018年 netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Clazz.h"

typedef void(^ClassEditTableViewCellManagerScheduleCallback)(void);
typedef void(^ClassEditTableViewCellManagerStudentsCallback)(void);

extern NSString * const ClassScheduleAndStudentsTableViewCellId;
extern CGFloat const ClassScheduleAndStudentsTableViewCellHeight;

@interface ClassScheduleAndStudentsTableViewCell : UITableViewCell

@property (nonatomic, copy) ClassEditTableViewCellManagerScheduleCallback managerScheduleCallback;
@property (nonatomic, copy) ClassEditTableViewCellManagerStudentsCallback managerStudentsCallback;

- (void)setupWithClass:(Clazz *)clazz;

@end
