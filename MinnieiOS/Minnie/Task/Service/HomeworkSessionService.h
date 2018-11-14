//
//  HomeworkSessionService.h
//  X5Teacher
//
//  Created by yebw on 2018/2/10.
//  Copyright © 2018年 netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Result.h"
#import "BaseRequest.h"

@interface HomeworkSessionService : NSObject

+ (BaseRequest *)requestHomeworkSessionsWithFinishState:(NSInteger)state
                                               callback:(RequestCallback)callback;

+ (BaseRequest *)requestHomeworkSessionsWithNextUrl:(NSString *)nextUrl
                                           callback:(RequestCallback)callback;

+ (BaseRequest *)requestHomeworkSessionWithId:(NSInteger)homeworkSessionId
                                     callback:(RequestCallback)callback;

+ (BaseRequest *)correctHomeworkSessionWithId:(NSInteger)sessionId
                                        score:(NSInteger)score
                                         redo:(NSInteger)redo
                                   sendCircle:(NSInteger)circle
                                         text:(NSString *)text
                                     callback:(RequestCallback)callback;

+ (BaseRequest *)redoHomeworkSessionWithId:(NSInteger)sessionId
                                  callback:(RequestCallback)callback;

+ (BaseRequest *)commitHomeworkWithId:(NSInteger)sessionId
                             imageUrl:(NSString *)imageUrl
                             videoUrl:(NSString *)videoUrl
                             callback:(RequestCallback)callback;

+ (BaseRequest *)updateHomeworkSessionModifiedTimeWithId:(NSInteger)sessionId
                                                callback:(RequestCallback)callback;

//根据评分搜索作业
+ (BaseRequest *)searchHomeworkSessionWithScore:(NSInteger)score callback:(RequestCallback)callback;

@end


