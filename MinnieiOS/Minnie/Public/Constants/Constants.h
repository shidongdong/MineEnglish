//
//  Constants.h
// X5
//
//  Created by yebw on 2017/8/23.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - Notifications

#pragma mark - 认证/用户信息相关
extern NSString * const kNotificationKeyOfLoginSuccess; // 登录成功
extern NSString * const kNotificationKeyOfProfileUpdated; // 资料修改
extern NSString * const kNotificationKeyOfAuthForbidden; // 认证失败

#pragma mark - 作业任务相关

extern NSString * const kNotificationKeyOfCorrectHomework; // 教师批改作业
extern NSString * const kNotificationKeyOfRedoHomework; // 学生重做作业
extern NSString * const kNotificationKeyOfCommitHomework; // 学生提交作业
extern NSString * const kNotificationKeyOfRefreshHomeworkSession; // 后台唤起重新刷新任务列表
extern NSString * const kNotificationKeyOfApnsNewHomeworkSession; // 推送唤起程序刷新作业新任务列表
//extern NSString * const kNotificationKeyOfApnsFinishHomeworkSession; // 推送唤起程序完成作业刷新任务列表
extern NSString * const kNotificationKeyOfUnReadMessageHomeworkSession;

#pragma mark - 作业管理相关

extern NSString * const kNotificationKeyOfAddHomework; // 教师端添加一个作业
extern NSString * const kNotificationKeyOfDeleteHomework; // 教师端删除一个作业
extern NSString * const kNotificationKeyOfSendHomework; // 教师端发送一个作业
extern NSString * const kNotificationKeyOfAddTags; // 教师端添加标签
extern NSString * const kNotificationKeyOfDeleteTags; // 教师端删除标签
extern NSString * const kNotificationKeyOfAddFormTags; // 教师端添加Form标签
extern NSString * const kNotificationKeyOfDeleteFormTags; // 教师端删除Form标签

#pragma mark - 同学圈相关

extern NSString * const kNotificationKeyOfDeleteHomeworkTask; // 删除同学圈的一条朋友作业
extern NSString * const kNotificationKeyOfAddComment; // 添加评论
extern NSString * const kNotificationKeyOfDeleteComment; // 删除评论
extern NSString * const kNotificationKeyOfLike; // 点赞
extern NSString * const kNotificationKeyOfUnlike; // 取消点赞
extern NSString * const kNotificationKeyOfUpdateStar; //更新小星星

#pragma mark - 班级管理相关

extern NSString * const kNotificationKeyOfAddClass; // 教师添加一个班级
extern NSString * const kNotificationKeyOfUpdateClass; // 教师更新一个班级
extern NSString * const kNotificationKeyOfDeleteClass; // 教师删除一个班级
extern NSString * const kNotificationKeyOfAddClassStudents; // 教师端添加学生
extern NSString * const kNotificationKeyOfDeleteClassStudents; // 教师端添加学生
extern NSString * const kNotificationKeyOfUpdateSchedule; // 教师端更新课程表

#pragma mark - 教师管理相关

extern NSString * const kNotificationKeyOfAddTeacher; // 教师端添加教师
extern NSString * const kNotificationKeyOfDeleteTeacher; // 教师端删除教师
extern NSString * const kNotificationKeyOfUpdateTeacher; // 教师端更新教师信息

#pragma mark - 礼物相关

extern NSString * const kNotificationKeyOfAddAward; // 教师端创建礼物
extern NSString * const kNotificationKeyOfGiveAward; // 教师端给兑换礼物
extern NSString * const kNotificationKeyOfExchangeAward; // 学生端请求兑换礼物

#pragma mark - 账号消息

extern NSString * const kNotificationKeyOfSendNoticeMessage; // 教师端发送通知消息

#pragma mark - 系统消息
extern NSString * const kNotificationKeyOfTabBarDoubleClick;

#pragma mark - 学生标注
extern NSString * const kNotificationKeyOfStudentMarkChange;

#pragma mark - 作业发送成功
extern NSString * const kNotificationKeyOfHomeworkSendSuccess;  // 作业管理作业发送成功通知
