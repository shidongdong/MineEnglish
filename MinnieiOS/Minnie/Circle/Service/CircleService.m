//
//  CirlcleService.m
//  X5
//
//  Created by yebw on 2017/10/8.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "CircleService.h"
#import "CircleRequest.h"

@implementation CirlcleService

+ (BaseRequest *)requestAllHomeworksWithCallback:(RequestCallback)callback {
    CircleHomeworksRequest *request = [[CircleHomeworksRequest alloc] init];
    
    request.objectKey = @"list";
    request.objectClassName = @"CircleHomework";
    
    request.callback = callback;
    [request start];
    
    return request;
}


+ (BaseRequest *)requestHomeworksWithLevel:(NSUInteger)level
                                  callback:(RequestCallback)callback{
    
    CircleHomeworksRequest *request = [[CircleHomeworksRequest alloc] initWithLevel:level];
    request.objectKey = @"list";
    request.objectClassName = @"CircleHomework";
    
    request.callback = callback;
    [request start];
    
    return request;
}
+ (BaseRequest *)requestCircleHomeworkFlagWithcallback:(RequestCallback)callback
{
    CircleHomeworkFlagRequest * request = [[CircleHomeworkFlagRequest alloc] init];
    request.objectClassName = @"CircleHomeworkFlag";
    request.callback = callback;
    [request start];
    return request;
}


+ (BaseRequest *)requestHomeworksWithUserId:(NSUInteger)userId callback:(RequestCallback)callback {
    CircleHomeworksRequest *request = [[CircleHomeworksRequest alloc] initWithUserId:userId];
    
    request.objectKey = @"list";
    request.objectClassName = @"CircleHomework";
    
    request.callback = callback;
    [request start];
    
    return request;
}

+ (BaseRequest *)requestHomeworksWithClassId:(NSUInteger)classId
                                    callback:(RequestCallback)callback {
    CircleHomeworksRequest *request = [[CircleHomeworksRequest alloc] initWithClassId:classId];
    
    request.objectKey = @"list";
    request.objectClassName = @"CircleHomework";
    
    request.callback = callback;
    [request start];
    
    return request;
}

+ (BaseRequest *)loadMoreHomeworksWithURL:(NSString *)nextUrl
                                 callback:(RequestCallback)callback {
    CircleHomeworksRequest *request = [[CircleHomeworksRequest alloc] initWithNextUrl:nextUrl];
    
    request.objectKey = @"list";
    request.objectClassName = @"CircleHomework";
    
    request.callback = callback;
    [request start];
    
    return request;
}

// 赞
+ (BaseRequest *)likeHomework:(NSUInteger)homeworkId
                     callback:(RequestCallback)callback {
    LikeHomeworkRequest *request = [[LikeHomeworkRequest alloc] initWithHomeworkSessionId:homeworkId];
    request.callback = callback;
    [request start];
    
    return request;
}

// 取消赞
+ (BaseRequest *)unlikeHomework:(NSUInteger)homeworkId
                       callback:(RequestCallback)callback {
    UnlikeHomeworkRequest *request = [[UnlikeHomeworkRequest alloc] initWithHomeworkSessionId:homeworkId];
    request.callback = callback;
    [request start];
    
    return request;
}

// 评论
+ (BaseRequest *)commentHomework:(NSUInteger)homeworkSessionId
               originalCommentId:(NSUInteger)commentId
                         content:(NSString *)content
                        callback:(RequestCallback)callback {
    AddHomeworkCommentRequest *request = [[AddHomeworkCommentRequest alloc] initWithHomeworkSessionId:homeworkSessionId commentId:commentId content:content];
    
    request.objectClassName = @"Comment";
    
    request.callback = callback;
    [request start];
    
    return request;
}

// 删除评论
+ (BaseRequest *)deleteComment:(NSUInteger)commentId
                      callback:(RequestCallback)callback {
    DeleteHomeworkCommentRequest *request = [[DeleteHomeworkCommentRequest alloc] initWithCommentId:commentId];
    request.callback = callback;
    [request start];
    
    return request;
}

// 删除同学圈
+ (BaseRequest *)deleteHomework:(NSUInteger)homeworkId
                       callback:(RequestCallback)callback {
    DeleteCircleHomeworkRequest *request = [[DeleteCircleHomeworkRequest alloc] initWithHomeworkId:homeworkId];
    request.callback = callback;
    [request start];
    
    return request;
}

// 获取同学圈详情
+ (BaseRequest *)requestHomeworkWithId:(NSUInteger)homeworkId
                              callback:(RequestCallback)callback {
    HomeworkRequest *request = [[HomeworkRequest alloc] initWithHomeworkSessionId:homeworkId];
    
    request.objectClassName = @"CircleHomework";
    
    request.callback = callback;
    [request start];
    
    return request;
}

+ (BaseRequest *)requestUnreadCircleCountWithCallback:(RequestCallback)callback {
    UnreaderCircleCountRequest *request = [[UnreaderCircleCountRequest alloc] init];
    
    request.callback = callback;
    [request start];

    return request;
}

@end


