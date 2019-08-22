//
//  HomeworkSessionsRequest.h
//  X5Teacher
//
//  Created by yebw on 2018/2/10.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "BaseRequest.h"
#import "Result.h"

#pragma mark - 2.2.1    获取作业任务列表（学生端，教师端，ipad）
@interface HomeworkSessionsRequest : BaseRequest

- (instancetype)initWithFinishState:(NSInteger)finished teacherId:(NSInteger)teacherId;

- (instancetype)initWithNextUrl:(NSString *)nextUrl;

@end


#pragma mark - 2.2.2    获取作业任务详情（学生端，教师端）
@interface HomeworkSessionRequest : BaseRequest

- (instancetype)initWithId:(NSInteger)homeworkId;

@end


#pragma mark - 2.2.3    提交作业（学生端）
@interface CommitHomeworkRequest : BaseRequest

- (instancetype)initWithImageUrl:(NSString *)imageUrl
                        videoUrl:(NSString *)videoUrl
               homeworkSessionId:(NSInteger)homeworkSessionId;

@end



#pragma mark - 2.2.4    重做作业（学生端）
@interface RedoHomeworkRequest : BaseRequest

- (instancetype)initWithHomeworkSessionId:(NSInteger)homeworkSessionId;

@end



#pragma mark - 2.2.5    批改作业（教师端）
@interface CorrectHomeworkRequest : BaseRequest

- (instancetype)initWithScore:(NSInteger)score
                         text:(NSString *)text
                      canRedo:(NSInteger)bRedo
                   sendCircle:(NSInteger)bSend
            homeworkSessionId:(NSInteger)homeworkSessionId;

@end




#pragma mark - 2.2.6    更新作业任务时间（学生端）
@interface UpdateTaskModifiedTimeRequest : BaseRequest

- (instancetype)initWithHomeworkSessionId:(NSInteger)homeworkSessionId;

@end




#pragma mark - 2.2.7    已完成栏目-根据星级搜索作业（学生端）
@interface SearchHomeworkScoreRequest : BaseRequest

- (instancetype)initWithHomeworkSessionForScore:(NSInteger)homeworkScore
                                      teacherId:(NSInteger)teacherId;

- (instancetype)initWithNextUrl:(NSString *)nextUrl;

@end



#pragma mark - 2.2.8    按学生名字搜索作业（教师端，ipad）
@interface SearchHomeworkNameRequest : BaseRequest

- (instancetype)initWithHomeworkSessionForName:(NSString *)name
                               withFinishState:(NSInteger)state
                                     teacherId:(NSInteger)teacherId;

- (instancetype)initWithNextUrl:(NSString *)nextUrl;

@end



#pragma mark - 2.2.9    添加排序(任务&人，教师端，ipad)
@interface SearchHomeworkTypeRequest : BaseRequest

- (instancetype)initWithHomeworkSessionForType:(NSInteger)type
                               withFinishState:(NSInteger)state
                                     teacherId:(NSInteger)teacherId;

- (instancetype)initWithNextUrl:(NSString *)nextUrl;

@end



#pragma mark - 2.3.15    获取作业评语列表
@interface CorrectHomeworkCommentsRequest : BaseRequest

@end



#pragma mark - 2.3.16    增加作业评语
@interface CorrectHomeworkAddCommentRequest : BaseRequest

- (instancetype)initWithAddHomeworkComment:(NSString *)comment;

@end



#pragma mark - 2.3.17    删除作业评语
@interface CorrectHomeworkDelCommentRequest : BaseRequest

- (instancetype)initWithDeleteHomeworkComments:(NSArray<NSString *> *)comment;

@end

