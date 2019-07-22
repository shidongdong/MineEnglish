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



@interface OnClass : MTLModel<MTLJSONSerializing>
//班级id
@property (nonatomic, assign) NSInteger classId;
//班级名称
@property (nonatomic, copy) NSString *name;
//学生数
@property (nonatomic, assign) NSInteger studentCount;

@end

@interface OnHomework : MTLModel<MTLJSONSerializing>
//作业id
@property (nonatomic, assign) NSInteger homeworkId;
//作业标题
@property (nonatomic, copy) NSString *title;
//平均得分
@property (nonatomic, assign) NSInteger avgScore;
//作业难度1-5星
@property (nonatomic, assign) NSInteger level;

@end


@interface TeacherDetail : MTLModel<MTLJSONSerializing>

//是否在线：1在线；0不在线
@property (nonatomic, assign) NSInteger isOnline;
//在线时长：今天、本周、本月
@property (nonatomic, strong) NSArray *onlineDetail;
//未提交的作业数量
@property (nonatomic, assign) NSInteger uncommitedHomeworksCount;
//待批改的作业数量
@property (nonatomic, assign) NSInteger uncorrectedHomeworksCount;
//已批改作业：今日、本周、本月
@property (nonatomic, strong) NSArray *correctedHomeworksDetail;
//上课班级信息
@property (nonatomic, strong) NSArray<OnClass*> *onClassList;
//任务评分统计
@property (nonatomic, strong) NSArray<OnHomework*> *onHomeworkList;

@end
