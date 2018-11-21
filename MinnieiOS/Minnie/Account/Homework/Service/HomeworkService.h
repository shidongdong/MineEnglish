//
//  HomeworkService.h
//  X5
//
//  Created by yebw on 2017/12/14.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Homework.h"
#import "Teacher.h"
#import "User.h"
#import "Result.h"
#import "BaseRequest.h"

@interface HomeworkService : NSObject

+ (BaseRequest *)createHomework:(Homework *)homework
                       callback:(RequestCallback)callback;

+ (BaseRequest *)deleteHomeworks:(NSArray <NSNumber *> *)homeworkIds
                        callback:(RequestCallback)callback;

+ (BaseRequest *)requestHomeworksWithCallback:(RequestCallback)callback;

+ (BaseRequest *)requestHomeworksWithNextUrl:(NSString *)nextUrl
                                    callback:(RequestCallback)callback;

+ (BaseRequest *)searchHomeworkWithKeyword:(NSArray<NSString *> *)key
                                  callback:(RequestCallback)callback;

+ (BaseRequest *)searchHomeworkWithNextUrl:(NSString *)nextUrl
                                  callback:(RequestCallback)callback;

+ (BaseRequest *)sendHomeworkIds:(NSArray <NSNumber *> *)homeworkIds
                        classIds:(NSArray <NSNumber *> *)classIds
                      studentIds:(NSArray <NSNumber *> *)studentIds
                       teacherId:(NSInteger)teacherId
                            date:(NSDate *)date
                        callback:(RequestCallback)callback;

//作业发送记录
+ (BaseRequest *)requestSendHomeworkHistoryWithCallback:(RequestCallback)callback;

+ (BaseRequest *)requestSendHomeworkHistoryWithNextUrl:(NSString *)nextUrl callback:(RequestCallback)callback;

@end
