//
//  Teacher.h
//  X5Teacher
//
//  Created by yebw on 2017/12/29.
//  Copyright © 2017年 netease. All rights reserved.
//

#import "User.h"

typedef NS_ENUM(NSInteger, TeacherAuthority) {
    TeacherAuthoritySuperManager = 1, // 超级管理员
    TeacherAuthorityManager = 2, // 管理员
    TeacherAuthorityTeacher = 3, // 普通教师
};


typedef NS_ENUM(NSInteger, TeacherType) {
    TeacherTypeTeacher = 1, // 教师
    TeacherTypeAssistant = 2, // 助教
};

@interface Teacher : User<MTLJSONSerializing>

@property (nonatomic, assign) TeacherType type; // 类型：教师，助教
@property (nonatomic, assign) TeacherAuthority authority; // 权限：超级管理员，管理员，普通教师

// 权限相关
@property (nonatomic, assign) BOOL canManageHomeworks; // 管理作业
@property (nonatomic, assign) BOOL canManageClasses; // 管理班级
@property (nonatomic, assign) BOOL canManageStudents; // 管理学生
@property (nonatomic, assign) BOOL canCreateRewards; // 新建礼品
@property (nonatomic, assign) BOOL canExchangeRewards; // 兑换礼品
@property (nonatomic, assign) BOOL canCreateNoticeMessage; // 创建通知消息

@property (nonatomic, readonly) NSString *typeDescription;
@property (nonatomic, readonly) NSString *authorityDescription;


@end
