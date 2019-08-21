//
//  CircleRequest.h
//  MinnieStudent
//
//  Created by songzhen on 2019/8/21.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface CircleRequest : BaseRequest

@end

#pragma mark - 2.4.1    获取同学圈列表（学生端，教师端）
@interface CircleHomeworksRequest : BaseRequest

- (BaseRequest *)initWithUserId:(NSUInteger)userId;

- (BaseRequest *)initWithClassId:(NSUInteger)classId;

- (BaseRequest *)initWithNextUrl:(NSString *)nextUrl;

@end

#pragma mark - 2.4.2    获取同学圈详情（学生端，教师端）
@interface HomeworkRequest : BaseRequest

- (instancetype)initWithHomeworkSessionId:(NSUInteger)homeworkSessionId;

@end

#pragma mark - 2.4.3    点赞（学生端，教师端）
@interface LikeHomeworkRequest : BaseRequest

- (instancetype)initWithHomeworkSessionId:(NSUInteger)homeworkSessionId;

@end

#pragma mark - 2.4.4    取消点赞（学生端，教师端）
@interface UnlikeHomeworkRequest : BaseRequest

- (instancetype)initWithHomeworkSessionId:(NSUInteger)homeworkSessionId;

@end

#pragma mark - 2.4.5    评论（学生端，教师端）
@interface AddHomeworkCommentRequest : BaseRequest

/**
 创建评论请求
 
 @param homeworkSessionId 作业id
 @param commentId 原始评论id
 @param content 评论内容
 @return 实例
 */
- (id)initWithHomeworkSessionId:(NSUInteger)homeworkSessionId
                      commentId:(NSUInteger)commentId
                        content:(NSString *)content;

@end


#pragma mark - 2.4.6    删除评论（学生端，教师端）
@interface DeleteHomeworkCommentRequest : BaseRequest

- (instancetype)initWithCommentId:(NSUInteger)commentId;

@end


#pragma mark - 2.4.7    删除同学圈的作业任务（学生端，教师端）
@interface DeleteCircleHomeworkRequest : BaseRequest

- (instancetype)initWithHomeworkId:(NSUInteger)homeworkId;

@end


#pragma mark - 2.4.8    获取同学圈的更新数量（学生端）
@interface UnreaderCircleCountRequest : BaseRequest

@end


#pragma mark - 2.4.9    同学圈通知（小红点）
@interface CircleHomeworkFlagRequest : BaseRequest

@end


NS_ASSUME_NONNULL_END
