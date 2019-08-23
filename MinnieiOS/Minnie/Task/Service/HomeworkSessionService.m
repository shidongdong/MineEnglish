//
//  HomeworkSessionService.m
//  X5Teacher
//
//  Created by yebw on 2018/2/10.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "HomeworkSessionService.h"
#import "HomeworkSessionsRequest.h"

@implementation HomeworkSessionService

+ (BaseRequest *)requestHomeworkSessionsWithFinishState:(NSInteger)state
                                              teacherId:(NSInteger)teacherId
                                               callback:(RequestCallback)callback {
    HomeworkSessionsRequest *request = [[HomeworkSessionsRequest alloc] initWithFinishState:state teacherId:teacherId];
    
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
                                        scope:(NSInteger)scope
                                     callback:(RequestCallback)callback {
    CorrectHomeworkRequest *request = [[CorrectHomeworkRequest alloc] initWithScore:score
                                                                               text:text
                                                                              scope:scope
                                                                            canRedo:redo
                                                                         sendCircle:circle homeworkSessionId:sessionId];
    
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

+ (BaseRequest *)searchHomeworkSessionWithScore:(NSInteger)score
                                      teacherId:(NSInteger)teacherId
                                       callback:(RequestCallback)callback
{
    SearchHomeworkScoreRequest * request = [[SearchHomeworkScoreRequest alloc] initWithHomeworkSessionForScore:score teacherId:teacherId];
    request.objectKey = @"list";
    request.objectClassName = @"HomeworkSession";
    request.callback = callback;
    [request start];
    return request;
}

+ (BaseRequest *)searchHomeworkSessionWithScoreWithNextUrl:(NSString *)nextUrl
                                           callback:(RequestCallback)callback {
    SearchHomeworkScoreRequest *request = [[SearchHomeworkScoreRequest alloc] initWithNextUrl:nextUrl];
    
    request.objectKey = @"list";
    request.objectClassName = @"HomeworkSession";
    request.callback = callback;
    [request start];
    
    return request;
}

+ (BaseRequest *)searchHomeworkSessionWithType:(NSInteger)type
                                     teacherId:(NSInteger)teacherId
                                      forState:(NSInteger)state
                                      callback:(RequestCallback)callback
{
    SearchHomeworkTypeRequest * request = [[SearchHomeworkTypeRequest alloc] initWithHomeworkSessionForType:type withFinishState:state teacherId:teacherId];
    request.objectKey = @"list";
    request.objectClassName = @"HomeworkSession";
    request.callback = callback;
    [request start];
    return request;
}

+ (BaseRequest *)searchHomeworkSessionWithTypeWithNextUrl:(NSString *)nextUrl
                                                  callback:(RequestCallback)callback {
    SearchHomeworkTypeRequest *request = [[SearchHomeworkTypeRequest alloc] initWithNextUrl:nextUrl];
    
    request.objectKey = @"list";
    request.objectClassName = @"HomeworkSession";
    request.callback = callback;
    [request start];
    
    return request;
}

+ (BaseRequest *)searchHomeworkSessionWithName:(NSString *)name
                                      forState:(NSInteger)state
                                     teacherId:(NSInteger)teacherId
                                      callback:(RequestCallback)callback
{
    SearchHomeworkNameRequest * request = [[SearchHomeworkNameRequest alloc] initWithHomeworkSessionForName:name withFinishState:state teacherId:teacherId];
    request.objectKey = @"list";
    request.objectClassName = @"HomeworkSession";
    request.callback = callback;
    [request start];
    return request;
}

+ (BaseRequest *)searchHomeworkSessionWithNameWithNextUrl:(NSString *)nextUrl
                                                 callback:(RequestCallback)callback {
    SearchHomeworkNameRequest *request = [[SearchHomeworkNameRequest alloc] initWithNextUrl:nextUrl];
    
    request.objectKey = @"list";
    request.objectClassName = @"HomeworkSession";
    request.callback = callback;
    [request start];
    
    return request;
}

//获取常用评语列表
+ (BaseRequest *)searchHomeworkSessionCommentWithCallback:(RequestCallback)callback
{
    CorrectHomeworkCommentsRequest * request = [[CorrectHomeworkCommentsRequest alloc] init];
    request.objectKey = @"list";
    request.callback = callback;
    [request start];
    return request;
}

//添加常用评语
+ (BaseRequest *)addHomeworkSessionComment:(NSString *)comment callback:(RequestCallback)callback
{
    CorrectHomeworkAddCommentRequest * request = [[CorrectHomeworkAddCommentRequest alloc] initWithAddHomeworkComment:comment];
    request.callback = callback;
    [request start];
    return request;
}

//删除常用评语
+ (BaseRequest *)delHomeworkSessionComment:(NSArray<NSString *> *)comments callback:(RequestCallback)callback
{
    CorrectHomeworkDelCommentRequest * request = [[CorrectHomeworkDelCommentRequest alloc] initWithDeleteHomeworkComments:comments];
    request.callback = callback;
    [request start];
    return request;
}


@end


