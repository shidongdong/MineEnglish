//
//  HomeworkSessionsRequest.m
//  X5Teacher
//
//  Created by yebw on 2018/2/10.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "HomeworkSessionsRequest.h"

#pragma mark - 2.2.1    获取作业任务列表（学生端，教师端，ipad）
@interface HomeworkSessionsRequest()

@property (nonatomic, assign) NSInteger finished;  //0表示未完成，1表示已完成  2未提交
@property (nonatomic, copy) NSString *nextUrl;
@property (nonatomic, assign) NSInteger teacherId;

@end

@implementation HomeworkSessionsRequest

- (instancetype)initWithFinishState:(NSInteger)finished teacherId:(NSInteger)teacherId{
    self = [super init];
    if (self != nil) {
        _finished = finished;
        _teacherId = teacherId;
    }
    return self;
}

- (instancetype)initWithNextUrl:(NSString *)nextUrl {
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
    if (self.nextUrl.length > 0) {
        return self.nextUrl;
    }

    return [NSString stringWithFormat:@"%@/homeworkTask/homeworkTasks", ServerProjectName];
}

- (id)requestArgument {
    
    if (self.nextUrl.length > 0) {
        return nil;
    }
    if (self.teacherId == 0) {
        
        return @{@"finished":@(self.finished),
//                 @"pageNo":@(0),
//                 @"pageNum":@(100)
                 };
    } else {
        return @{@"finished":@(self.finished),
                 @"teacherId":@(self.teacherId)};
    }
}

@end



#pragma mark - 2.2.2    获取作业任务详情（学生端，教师端）
@interface HomeworkSessionRequest()

@property (nonatomic, assign) NSInteger homeworkId;

@end

@implementation HomeworkSessionRequest

- (instancetype)initWithId:(NSInteger)homeworkId {
    self = [super init];
    if (self != nil) {
        _homeworkId = homeworkId;
    }
    
    return self;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@/homeworkTask/detail", ServerProjectName];
}

- (id)requestArgument {
    return @{@"id":@(self.homeworkId)};
}

@end



#pragma mark - 2.2.3    提交作业（学生端）
@interface CommitHomeworkRequest()

@property (nonatomic, assign) NSInteger homeworkSessionId;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSString *videoUrl;

@end

@implementation CommitHomeworkRequest

- (instancetype)initWithImageUrl:(NSString *)imageUrl
                        videoUrl:(NSString *)videoUrl
               homeworkSessionId:(NSInteger)homeworkSessionId {
    self = [super init];
    if (self != nil) {
        _homeworkSessionId = homeworkSessionId;
        _imageUrl = imageUrl;
        _videoUrl = videoUrl;
    }
    
    return self;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@/homeworkTask/commitHomework", ServerProjectName];
}

- (id)requestArgument {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"id"] = @(self.homeworkSessionId);
    
    if (self.imageUrl.length > 0) {
        dict[@"imageUrl"] = self.imageUrl;
    }
    
    if (self.videoUrl.length > 0) {
        dict[@"videoUrl"] = self.videoUrl;
    }
    
    return dict;
}

@end




#pragma mark - 2.2.4    重做作业（学生端）
@interface RedoHomeworkRequest()

@property (nonatomic, assign) NSInteger sessionId;

@end

@implementation RedoHomeworkRequest

- (instancetype)initWithHomeworkSessionId:(NSInteger)homeworkSessionId {
    self = [super init];
    if (self != nil) {
        _sessionId = homeworkSessionId;
    }
    
    return self;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@/homeworkTask/redoHomework", ServerProjectName];
}

- (id)requestArgument {
    return @{@"id":@(self.sessionId)};
}

@end



#pragma mark - 2.2.5    批改作业（教师端）
@interface CorrectHomeworkRequest()

@property (nonatomic, assign) NSInteger sessionId;
@property (nonatomic, assign) NSInteger score;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) NSInteger isRedo;
@property (nonatomic, assign) NSInteger isCircle;
@end

@implementation CorrectHomeworkRequest

- (instancetype)initWithScore:(NSInteger)score
                         text:(NSString *)text
                      canRedo:(NSInteger)bRedo
                   sendCircle:(NSInteger)bSend
            homeworkSessionId:(NSInteger)homeworkSessionId {
    self = [super init];
    if (self != nil) {
        _score = score;
        //避免插入空指针
        if (text.length == 0)
        {
            _text = @"";
        }
        else
        {
            _text = text;
        }
        _sessionId = homeworkSessionId;
        _isRedo = bRedo;
        _isCircle = bSend;
    }
    
    return self;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@/homeworkTask/correctHomework", ServerProjectName];
}

- (id)requestArgument {
    return @{@"id":@(self.sessionId),
             @"score":@(self.score),
             @"content":self.text,
             @"isRedo":@(self.isRedo),
             @"isCircle":@(self.isCircle),
             };
}

@end



#pragma mark - 2.2.6    更新作业任务时间（学生端）
@interface UpdateTaskModifiedTimeRequest()

@property (nonatomic, assign) NSInteger sessionId;

@end

@implementation UpdateTaskModifiedTimeRequest

- (instancetype)initWithHomeworkSessionId:(NSInteger)homeworkSessionId {
    self = [super init];
    if (self != nil) {
        _sessionId = homeworkSessionId;
    }
    
    return self;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@/homeworkTask/updateModifiedTime", ServerProjectName];
}

- (id)requestArgument {
    return @{@"id":@(self.sessionId)};
}

@end




#pragma mark - 2.2.7    已完成栏目-根据星级搜索作业（学生端）
@interface SearchHomeworkScoreRequest()

@property(nonatomic,assign)NSInteger score;
@property (nonatomic, copy) NSString *nextUrl;
@property(nonatomic,assign)NSInteger teacherId;

@end

@implementation SearchHomeworkScoreRequest

- (instancetype)initWithHomeworkSessionForScore:(NSInteger)homeworkScore
                                      teacherId:(NSInteger)teacherId
{
    self = [super init];
    if (self != nil) {
        _score = homeworkScore;
        _teacherId = teacherId;
    }
    return self;
}

- (instancetype)initWithNextUrl:(NSString *)nextUrl
{
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
    if (self.nextUrl.length > 0) {
        return self.nextUrl;
    }
    
    return [NSString stringWithFormat:@"%@/homeworkTask/getHomeworkTasksByScore", ServerProjectName];
}

- (id)requestArgument {
    if (self.nextUrl.length > 0) {
        return nil;
    }
    if (self.teacherId == 0) {
        
        return @{@"score":@(self.score)
//                 @"pageNo":@(0),
//                 @"pageNum":@(100)
                 };
    } else {
        return @{@"score":@(self.score),
                 @"teacherId":@(self.teacherId)};
    }
}

@end



#pragma mark - 2.2.8    按学生名字搜索作业（教师端，ipad）
@interface SearchHomeworkNameRequest()

@property(nonatomic,copy)NSString * name;      //1:任务；2人
@property(nonatomic,assign)NSInteger finished;  //0：待批改；1已完成；2未提交
@property (nonatomic, copy) NSString *nextUrl;
@property(nonatomic,assign)NSInteger teacherId;

@end

@implementation SearchHomeworkNameRequest

- (instancetype)initWithHomeworkSessionForName:(NSString *)name
                               withFinishState:(NSInteger)state
                                     teacherId:(NSInteger)teacherId
{
    self = [super init];
    if (self != nil) {
        _name = name;
        _finished = state;
        _teacherId = teacherId;
    }
    return self;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (instancetype)initWithNextUrl:(NSString *)nextUrl
{
    self = [super init];
    if (self != nil) {
        
        NSString *utfNextUrl = [nextUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        
        _nextUrl = utfNextUrl;
    }
    
    return self;
}

- (NSString *)requestUrl {
    if (self.nextUrl.length > 0) {
        return self.nextUrl;
    }
    
    return [NSString stringWithFormat:@"%@/homeworkTask/getHomeworkTasksByStudent", ServerProjectName];
}

- (id)requestArgument {
    if (self.nextUrl.length > 0) {
        return nil;
    }
    if (self.teacherId == 0) {
        return @{@"studentName":self.name,
                 @"finished":@(self.finished),
//                 @"pageNo":@(0),
//                 @"pageNum":@(100)
                 };
    } else {
        return @{@"studentName":self.name,
                 @"finished":@(self.finished),
                 @"teacherId":@(self.teacherId)};
    }
}

@end



#pragma mark - 2.2.9    添加排序(任务&人，教师端，ipad)
@interface SearchHomeworkTypeRequest()

@property(nonatomic,assign)NSInteger type;      //1:任务；2人
@property(nonatomic,assign)NSInteger finished;  //0：待批改；1已完成；2未提交
@property (nonatomic, copy) NSString *nextUrl;
@property(nonatomic,assign)NSInteger teacherId;
@end

@implementation SearchHomeworkTypeRequest

- (instancetype)initWithHomeworkSessionForType:(NSInteger)type
                               withFinishState:(NSInteger)state
                                     teacherId:(NSInteger)teacherId
{
    self = [super init];
    if (self != nil) {
        _type = type;
        _finished = state;
        _teacherId = teacherId;
    }
    return self;
}

- (instancetype)initWithNextUrl:(NSString *)nextUrl
{
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
    if (self.nextUrl.length > 0) {
        return self.nextUrl;
    }
    
    return [NSString stringWithFormat:@"%@/homeworkTask/getHomeworkByType", ServerProjectName];
}

- (id)requestArgument {
    if (self.nextUrl.length > 0) {
        return nil;
    }
    if (self.teacherId == 0) {
        
        return @{@"type":@(self.type),
                 @"finished":@(self.finished),
//                 @"pageNo":@(0),
//                 @"pageNum":@(100)
                 };
    } else {
        
        return @{@"type":@(self.type),
                 @"finished":@(self.finished),
                 @"teacherId":@(self.teacherId)};
    }
}

@end



#pragma mark - 2.3.15    获取作业评语列表
@implementation CorrectHomeworkCommentsRequest

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@/homework/comments", ServerProjectName];
}

@end



#pragma mark - 2.3.16    增加作业评语
@interface CorrectHomeworkAddCommentRequest()

@property(nonatomic,strong)NSString * comment;

@end

@implementation CorrectHomeworkAddCommentRequest


- (instancetype)initWithAddHomeworkComment:(NSString *)comment
{
    self = [super init];
    if (self != nil) {
        _comment = comment;
    }
    return self;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@/homework/addComment", ServerProjectName];
}

- (id)requestArgument {
    
    return @{@"comment":self.comment};
}

@end



#pragma mark - 2.3.17    删除作业评语
@interface CorrectHomeworkDelCommentRequest()

@property(nonatomic,strong)NSArray<NSString *> * comments;

@end

@implementation CorrectHomeworkDelCommentRequest

- (instancetype)initWithDeleteHomeworkComments:(NSArray<NSString *> *)comment
{
    self = [super init];
    if (self != nil) {
        _comments = comment;
    }
    return self;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@/homework/deleteComments", ServerProjectName];
}

- (id)requestArgument {
    
    return @{@"comments":self.comments};
}

@end

