//
//  AccountManageTableViewCell.h
//  X5Teacher
//
//  Created by yebw on 2017/12/16.
//  Copyright © 2017年 netease. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HomeworkManageCallback)(void);
typedef void(^TeacherManageCallback)(void);
typedef void(^ClassManageCallback)(void);
typedef void(^StudentManageCallback)(void);

extern NSString * const AccountManageTableViewCellId;
extern CGFloat const AccountManageTableViewCellHeight;

@interface AccountManageTableViewCell : UITableViewCell

@property (nonatomic, copy) HomeworkManageCallback homeworkManageCallback;
@property (nonatomic, copy) TeacherManageCallback teacherManageCallback;
@property (nonatomic, copy) ClassManageCallback classManageCallback;
@property (nonatomic, copy) StudentManageCallback studentManageCallback;

- (void)setup;

@end


