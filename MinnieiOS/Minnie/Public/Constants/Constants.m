//
//  Constants.m
// X5
//
//  Created by yebw on 2017/8/23.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "Constants.h"

#pragma mark - Notifications

#pragma mark - 认证/用户信息相关
NSString * const kNotificationKeyOfLoginSuccess = @"kNotificationKeyOfLoginSuccess"; // 登录成功
NSString * const kNotificationKeyOfProfileUpdated = @"kNotificationKeyOfProfileUpdated"; // 资料修改
NSString * const kNotificationKeyOfAuthForbidden = @"kNotificationKeyOfAuthForbidden"; // 认证失败

#pragma mark - 作业任务相关

NSString * const kNotificationKeyOfCorrectHomework = @"kNotificationKeyOfCorrectHomework"; // 教师批改作业
NSString * const kNotificationKeyOfRedoHomework = @"kNotificationKeyOfRedoHomework"; // 学生重做作业
NSString * const kNotificationKeyOfCommitHomework = @"kNotificationKeyOfCommitHomework"; // 学生重做作业
NSString * const kNotificationKeyOfRefreshHomeworkSession = @"kNotificationKeyOfRefreshHomeworkSession";
NSString * const kNotificationKeyOfApnsNewHomeworkSession = @"kNotificationKeyOfApnsNewHomeworkSession"; //apns推送新作业
//NSString * const kNotificationKeyOfApnsFinishHomeworkSession = @"kNotificationKeyOfApnsFinishHomeworkSession";

#pragma mark - 作业管理相关

NSString * const kNotificationKeyOfAddHomework = @"kNotificationKeyOfAddHomework"; // 教师端添加一个作业
NSString * const kNotificationKeyOfDeleteHomework = @"kNotificationKeyOfDeleteHomework"; // 教师端删除一个作业
NSString * const kNotificationKeyOfSendHomework = @"kNotificationKeyOfSendHomework"; // 教师端发送一个作业
NSString * const kNotificationKeyOfAddTags = @"kNotificationKeyOfAddTags"; // 教师端添加标签
NSString * const kNotificationKeyOfDeleteTags = @"kNotificationKeyOfDeleteTags"; // 教师端删除标签

#pragma mark - 同学圈相关

NSString * const kNotificationKeyOfDeleteHomeworkTask = @"kNotificationKeyOfDeleteHomeworkTask"; // 删除同学圈的一条朋友作业
NSString * const kNotificationKeyOfAddComment = @"kNotificationKeyOfAddComment"; // 添加评论
NSString * const kNotificationKeyOfDeleteComment = @"kNotificationKeyOfDeleteComment"; // 删除评论
NSString * const kNotificationKeyOfLike = @"kNotificationKeyOfLike"; // 点赞
NSString * const kNotificationKeyOfUnlike = @"kNotificationKeyOfUnlike"; // 取消点赞

#pragma mark - 班级管理相关

NSString * const kNotificationKeyOfAddClass = @"kNotificationKeyOfAddClass"; // 教师添加一个班级
NSString * const kNotificationKeyOfUpdateClass = @"kNotificationKeyOfUpdateClass"; // 教师更新一个班级
NSString * const kNotificationKeyOfDeleteClass = @"kNotificationKeyOfDeleteClass"; // 教师删除一个班级
NSString * const kNotificationKeyOfAddClassStudents = @"kNotificationKeyOfAddClassStudents"; // 教师端添加学生
NSString * const kNotificationKeyOfDeleteClassStudents = @"kNotificationKeyOfDeleteClassStudents"; // 教师端添加学生
NSString * const kNotificationKeyOfUpdateSchedule = @"kNotificationKeyOfUpdateSchedule"; // 教师端更新课程表

#pragma mark - 教师管理相关

NSString * const kNotificationKeyOfAddTeacher = @"kNotificationKeyOfAddTeacher"; // 教师端添加教师
NSString * const kNotificationKeyOfDeleteTeacher = @"kNotificationKeyOfDeleteTeacher"; // 教师端删除教师
NSString * const kNotificationKeyOfUpdateTeacher = @"kNotificationKeyOfUpdateTeacher"; // 教师端更新教师信息

#pragma mark - 礼物相关

NSString * const kNotificationKeyOfAddAward = @"kNotificationKeyOfAddAward"; // 教师端创建礼物
NSString * const kNotificationKeyOfGiveAward = @"kNotificationKeyOfGiveAward"; // 教师端给兑换礼物
NSString * const kNotificationKeyOfExchangeAward = @"kNotificationKeyOfExchangeAward"; // 学生端请求兑换礼物

#pragma mark - 账号消息

NSString * const kNotificationKeyOfSendNoticeMessage = @"kNotificationKeyOfSendNoticeMessage"; // 教师端发送通知消息

