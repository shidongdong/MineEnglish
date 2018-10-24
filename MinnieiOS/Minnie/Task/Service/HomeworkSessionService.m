//
//  HomeworkSessionService.m
//  X5Teacher
//
//  Created by yebw on 2018/2/10.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "HomeworkSessionService.h"
#import "HomeworkSessionsRequest.h"
#import "HomeworkSessionRequest.h"
#import "CorrectHomeworkRequest.h"
#import "RedoHomeworkRequest.h"
#import "CommitHomeworkRequest.h"
#import "UpdateTaskModifiedTimeRequest.h"

@implementation HomeworkSessionService

+ (BaseRequest *)requestHomeworkSessionsWithFinishState:(BOOL)finished
                                               callback:(RequestCallback)callback {
    HomeworkSessionsRequest *request = [[HomeworkSessionsRequest alloc] initWithFinishState:finished];
    
    request.objectKey = @"list";
    request.objectClassName = @"HomeworkSession";
    request.callback = callback;
    [request start];
    
    return request;
}

+ (BaseRequest *)requestHomeworkSessionsWithNextUrl:(NSString *)nextUrl
                                           callback:(RequestCallback)callback {
    HomeworkSessionsRequest *request = [[HomeworkSessionsRequest alloc] initWithNextUrl:nextUrl];
    
    request.objectKey = @"list";
    request.objectClassName = @"HomeworkSession";
    request.callback = callback;
    [request start];
    
    return request;
}

+ (BaseRequest *)requestHomeworkSessionWithId:(NSInteger)homeworkSessionId
                                     callback:(RequestCallback)callback {
    HomeworkSessionRequest *request = [[HomeworkSessionRequest alloc] initWithId:homeworkSessionId];
    
    request.objectClassName = @"HomeworkSession";
    request.callback = callback;
    [request start];
    
    return request;
}

+ (BaseRequest *)correctHomeworkSessionWithId:(NSInteger)sessionId
                                        score:(NSInteger)score
                                         redo:(NSInteger)redo
                                   sendCircle:(NSInteger)circle
                                         text:(NSString *)text
                                     callback:(RequestCallback)callback {
    CorrectHomeworkRequest *request = [[CorrectHomeworkRequest alloc] initWithScore:score text:text canRedo:redo sendCircle:circle homeworkSessionId:sessionId];
    
    request.callback = callback;
    [request start];
    
    return request;
}

+ (BaseRequest *)redoHomeworkSessionWithId:(NSInteger)sessionId
                                  callback:(RequestCallback)callback {
    RedoHomeworkRequest *request = [[RedoHomeworkRequest alloc] initWithHomeworkSessionId:sessionId];
    
    request.callback = callback;
    [request start];

    return request;
}

+ (BaseRequest *)commitHomeworkWithId:(NSInteger)sessionId
                             imageUrl:(NSString *)imageUrl
                             videoUrl:(NSString *)videoUrl
                             callback:(RequestCallback)callback {
    CommitHomeworkRequest *request = [[CommitHomeworkRequest alloc] initWithImageUrl:imageUrl videoUrl:videoUrl homeworkSessionId:sessionId];
    
    request.callback = callback;
    [request start];
    
    return request;
}

+ (BaseRequest *)updateHomeworkSessionModifiedTimeWithId:(NSInteger)sessionId
                                                callback:(RequestCallback)callback {
    UpdateTaskModifiedTimeRequest *request = [[UpdateTaskModifiedTimeRequest alloc] initWithHomeworkSessionId:sessionId];
    
    request.callback = callback;
    [request start];
    
    return request;
}

@end


