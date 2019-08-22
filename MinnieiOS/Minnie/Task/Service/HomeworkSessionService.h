//
//  HomeworkSessionService.h
//  X5Teacher
//
//  Created by yebw on 2018/2/10.
//  Copyright © 2018年 netease. All rights reserved.
// 获取作业列表

#import <Foundation/Foundation.h>
#import "Result.h"
#import "BaseRequest.h"

@interface HomeworkSessionService : NSObject

// 按时间获取作业列表
#pragma mark - 2.2.1    获取作业任务列表（学生端，教师端，ipad）
+ (BaseRequest *)requestHomeworkSessionsWithFinishState:(NSInteger)state
                                              teacherId:(NSInteger)teacherId
                                               callback:(RequestCallback)callback;
+ (BaseRequest *)requestHomeworkSessionsWithNextUrl:(NSString *)nextUrl
                                           callback:(RequestCallback)callback;


// 获取作业任务详情
#pragma mark - 2.2.2    获取作业任务详情（学生端，教师端）
+ (BaseRequest *)requestHomeworkSessionWithId:(NSInteger)homeworkSessionId
                                     callback:(RequestCallback)callback;


#pragma mark - 2.2.3    提交作业（学生端）
+ (BaseRequest *)commitHomeworkWithId:(NSInteger)sessionId
                             imageUrl:(NSString *)imageUrl
                             videoUrl:(NSString *)videoUrl
                             callback:(RequestCallback)callback;


#pragma mark - 2.2.4    重做作业（学生端）
+ (BaseRequest *)redoHomeworkSessionWithId:(NSInteger)sessionId
                                  callback:(RequestCallback)callback;


#pragma mark - 2.2.5    批改作业（教师端）
+ (BaseRequest *)correctHomeworkSessionWithId:(NSInteger)sessionId
                                        score:(NSInteger)score
                                         redo:(NSInteger)redo
                                   sendCircle:(NSInteger)circle
                                         text:(NSString *)text
                                     callback:(RequestCallback)callback;


#pragma mark - 2.2.6    更新作业任务时间（学生端）
+ (BaseRequest *)updateHomeworkSessionModifiedTimeWithId:(NSInteger)sessionId
                                                callback:(RequestCallback)callback;


//根据评分搜索作业列表
#pragma mark - 2.2.7    已完成栏目-根据星级搜索作业（学生端）
+ (BaseRequest *)searchHomeworkSessionWithScore:(NSInteger)score
                                      teacherId:(NSInteger)teacherId
                                       callback:(RequestCallback)callback;
+ (BaseRequest *)searchHomeworkSessionWithScoreWithNextUrl:(NSString *)nextUrl
                                                  callback:(RequestCallback)callback;


// 按学生名字搜索作业（教师端，ipad）
#pragma mark - 2.2.8    按学生名字搜索作业（教师端，ipad）
+ (BaseRequest *)searchHomeworkSessionWithName:(NSString *)name
                                      forState:(NSInteger)state
                                     teacherId:(NSInteger)teacherId
                                      callback:(RequestCallback)callback;
+ (BaseRequest *)searchHomeworkSessionWithNameWithNextUrl:(NSString *)nextUrl
                                                 callback:(RequestCallback)callback;


// 根据类型(任务&人)搜索作业列表(教师端，ipad)
#pragma mark - 2.2.9    添加排序(任务&人，教师端，ipad)
+ (BaseRequest *)searchHomeworkSessionWithType:(NSInteger)type
                                     teacherId:(NSInteger)teacherId
                                      forState:(NSInteger)state
                                      callback:(RequestCallback)callback;
+ (BaseRequest *)searchHomeworkSessionWithTypeWithNextUrl:(NSString *)nextUrl
                                                 callback:(RequestCallback)callback;


#pragma mark - 2.3.15    获取作业评语列表
+ (BaseRequest *)searchHomeworkSessionCommentWithCallback:(RequestCallback)callback;


#pragma mark - 2.3.16    增加作业评语
+ (BaseRequest *)addHomeworkSessionComment:(NSString *)comment callback:(RequestCallback)callback;


#pragma mark - 2.3.17    删除作业评语
+ (BaseRequest *)delHomeworkSessionComment:(NSArray<NSString *> *)comments callback:(RequestCallback)callback;

@end


