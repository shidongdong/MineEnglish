//
//  CircleRequest.m
//  MinnieStudent
//
//  Created by songzhen on 2019/8/21.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import "CircleRequest.h"

@implementation CircleRequest

@end

#pragma mark - 2.4.1    获取同学圈列表（学生端，教师端）
@interface CircleHomeworksRequest()

@property (nonatomic, assign) NSUInteger userId;
@property (nonatomic, assign) NSUInteger classId;
@property (nonatomic, copy) NSString *nextUrl;

@end

@implementation CircleHomeworksRequest

- (BaseRequest *)initWithUserId:(NSUInteger)userId {
    self = [super init];
    if (self != nil) {
        _userId = userId;
    }
    
    return self;
}

- (BaseRequest *)initWithClassId:(NSUInteger)classId {
    self = [super init];
    if (self != nil) {
        _classId = classId;
    }
    
    return self;
}

- (BaseRequest *)initWithNextUrl:(NSString *)nextUrl {
    self = [super init];
    if (self != nil) {
        _nextUrl = nextUrl;
    }
    
    return self;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (NSString *)requestUrl {
    if (self.nextUrl != nil) {
        return self.nextUrl;
    }
    
    return [NSString stringWithFormat:@"%@/circle/homeworkTasks", ServerProjectName];
}

- (id)requestArgument {
    if (self.nextUrl != nil) {
        return nil;
    }
    
    if (self.userId > 0) {
        return @{@"studentId":@(self.userId)};
    } else if (self.classId > 0) {
        return @{@"classId":@(self.classId)};
    }
    
    return nil;
}

@end


#pragma mark - 2.4.2    获取同学圈详情（学生端，教师端）
@interface HomeworkRequest()

@property (nonatomic, assign) NSUInteger homeworkSessionId;

@end

@implementation HomeworkRequest

- (instancetype)initWithHomeworkSessionId:(NSUInteger)homeworkSessionId {
    self = [super init];
    if (self != nil) {
        _homeworkSessionId = homeworkSessionId;
    }
    
    return self;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@/circle/homeworkTask", ServerProjectName];
}

- (id)requestArgument {
    return @{@"id":@(self.homeworkSessionId)};
}

@end


#pragma mark - 2.4.3    点赞（学生端，教师端）
@interface LikeHomeworkRequest()

@property (nonatomic, assign) NSUInteger homeworkSessionId;

@end

@implementation LikeHomeworkRequest

- (instancetype)initWithHomeworkSessionId:(NSUInteger)homeworkSessionId {
    self = [super init];
    if (self != nil) {
        _homeworkSessionId = homeworkSessionId;
    }
    
    return self;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@/circle/like", ServerProjectName];
}

- (id)requestArgument {
    return @{@"id":@(self.homeworkSessionId)};
}

@end


#pragma mark - 2.4.4    取消点赞（学生端，教师端）
@interface UnlikeHomeworkRequest()

@property (nonatomic, assign) NSUInteger homeworkSessionId;

@end

@implementation UnlikeHomeworkRequest

- (instancetype)initWithHomeworkSessionId:(NSUInteger)homeworkSessionId {
    self = [super init];
    if (self != nil) {
        _homeworkSessionId = homeworkSessionId;
    }
    
    return self;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@/circle/unlike", ServerProjectName];
}

- (id)requestArgument {
    return @{@"id":@(self.homeworkSessionId)};
}

@end


#pragma mark - 2.4.5    评论（学生端，教师端）
@interface AddHomeworkCommentRequest()

@property (nonatomic, assign) NSUInteger homeworkSessionId;
@property (nonatomic, assign) NSUInteger commentId;
@property (nonatomic, copy) NSString *content;

@end

@implementation AddHomeworkCommentRequest

- (id)initWithHomeworkSessionId:(NSUInteger)homeworkSessionId
                      commentId:(NSUInteger)commentId
                        content:(NSString *)content {
    self = [super init];
    if (self != nil) {
        _homeworkSessionId = homeworkSessionId;
        _commentId = commentId;
        _content = content;
    }
    
    return self;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@/circle/addComment", ServerProjectName];
}

- (id)requestArgument {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    dict[@"id"] = @(self.homeworkSessionId);
    if (self.commentId > 0) {
        dict[@"originalCommentId"] = @(self.commentId);
    }
    dict[@"content"] = self.content;
    
    return dict;
}

@end


#pragma mark - 2.4.6    删除评论（学生端，教师端）
@interface DeleteHomeworkCommentRequest()

@property (nonatomic, assign) NSUInteger commentId;

@end

@implementation DeleteHomeworkCommentRequest

- (instancetype)initWithCommentId:(NSUInteger)commentId {
    self = [super init];
    if (self != nil) {
        _commentId = commentId;
    }
    
    return self;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@/circle/deleteComment", ServerProjectName];
}

- (id)requestArgument {
    return @{@"id":@(self.commentId)};
}

@end


#pragma mark - 2.4.7    删除同学圈的作业任务（学生端，教师端）
@interface DeleteCircleHomeworkRequest()

@property (nonatomic, assign) NSUInteger homeworkId;

@end

@implementation DeleteCircleHomeworkRequest

- (instancetype)initWithHomeworkId:(NSUInteger)homeworkId {
    self = [super init];
    if (self != nil) {
        _homeworkId = homeworkId;
    }
    
    return self;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@/circle/delete", ServerProjectName];
}

- (id)requestArgument {
    return @{@"id":@(self.homeworkId)};
}

@end


#pragma mark - 2.4.8    获取同学圈的更新数量（学生端）
@implementation UnreaderCircleCountRequest

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@/circle/updateCount", ServerProjectName];
}

@end


#pragma mark - 2.4.9    同学圈通知（小红点）
@implementation CircleHomeworkFlagRequest

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@/circle/getCircleNoticeFlag", ServerProjectName];
}

@end
