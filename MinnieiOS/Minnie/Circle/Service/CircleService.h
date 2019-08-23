//
//  CirlcleService.h
//  X5
//
//  Created by yebw on 2017/10/8.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CircleHomework.h"
#import "User.h"
#import "Comment.h"
#import "BaseRequest.h"
#import "Result.h"

typedef NS_ENUM(NSUInteger, CircleType) {
    CircleClass = 0,    // 年级
    CircleSchool = 1,   // 学校
};

@interface CirlcleService : NSObject

+ (BaseRequest *)loadMoreHomeworksWithURL:(NSString *)nextUrl
                                 callback:(RequestCallback)callback;

//获取小红点
+ (BaseRequest *)requestCircleHomeworkFlagWithcallback:(RequestCallback)callback;

// 赞
+ (BaseRequest *)likeHomework:(NSUInteger)homeworkId
                     callback:(RequestCallback)callback;

// 取消赞
+ (BaseRequest *)unlikeHomework:(NSUInteger)homeworkId
                       callback:(RequestCallback)callback;

// 评论
+ (BaseRequest *)commentHomework:(NSUInteger)homeworkSessionId
               originalCommentId:(NSUInteger)commentId
                         content:(NSString *)content
                        callback:(RequestCallback)callback;

// 删除评论
+ (BaseRequest *)deleteComment:(NSUInteger)commentId
                      callback:(RequestCallback)callback;

// 删除同学圈
+ (BaseRequest *)deleteHomework:(NSUInteger)homeworkId
                       callback:(RequestCallback)callback;

#pragma mark - 2.4.2    获取同学圈详情（学生端，教师端）
+ (BaseRequest *)requestHomeworkWithId:(NSUInteger)homeworkId
                              callback:(RequestCallback)callback;


#pragma mark - 2.4.1    获取同学圈列表（学生端，教师端）
// 获取某一个班级的同学作业
+ (BaseRequest *)requestHomeworksWithClassId:(NSUInteger)classId
                                    callback:(RequestCallback)callback;

// 获取某个人用户的同学圈作业
+ (BaseRequest *)requestHomeworksWithUserId:(NSUInteger)userId
                                   callback:(RequestCallback)callback;

+ (BaseRequest *)requestHomeworksWithLevel:(NSUInteger)level
                                  callback:(RequestCallback)callback;
// 获取所有的优秀作业
+ (BaseRequest *)requestAllHomeworksWithCallback:(RequestCallback)callback;


+ (BaseRequest *)requestHomeworksWithLevel:(NSUInteger)level
                                    callback:(RequestCallback)callback;


#pragma mark - 2.4.8    获取同学圈的更新数量（学生端）
+ (BaseRequest *)requestUnreadCircleCountWithCallback:(RequestCallback)callback;

@end


