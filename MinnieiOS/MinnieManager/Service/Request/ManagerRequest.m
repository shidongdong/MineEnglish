//
//  ManagerRequest.m
//  MinnieManager
//
//  Created by songzhen on 2019/6/1.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import "ManagerRequest.h"

@implementation ManagerRequest

@end

#pragma mark - CeateFilesRequest
@interface CeateFilesRequest ()

@property (nonatomic,strong) FileInfo *model;

@end

@implementation CeateFilesRequest


- (instancetype)initWithCeateFilesData:(FileInfo *)data{
  
    self = [super init];
    if (self != nil) {
        self.model = data;
    }
    return self;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@/homework/createFiles", ServerProjectName];
}

- (id)requestArgument {

    if (self.model.fileId == 0) {
        
        return @{@"fileName":self.model.fileName,
                 @"parentId":@(self.model.parentId),
                 @"depth":@(self.model.depth)};
    } else {
      
        return @{@"id":@(self.model.fileId),
                 @"fileName":self.model.fileName,
                 @"parentId":@(self.model.parentId),
                 @"depth":@(self.model.depth)};
    }
}

@end


#pragma mark - GetFilesRequest
@interface GetFilesRequest ()

@property (nonatomic,assign) NSInteger fileId;

@end

@implementation GetFilesRequest

- (instancetype)initWithFileId:(NSInteger)fileId{
   
    self = [super init];
    if (self != nil) {
        self.fileId = fileId;
    }
    return self;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@/homework/getFiles", ServerProjectName];
}

- (id)requestArgument {
    return @{@"fileId":@(self.fileId)};
}

@end



#pragma mark - DelFilesRequest
@interface DelFilesRequest ()

@property (nonatomic,assign) NSInteger fileId;

@end

@implementation DelFilesRequest : BaseRequest

- (instancetype)initWithFileId:(NSInteger) fileId{
    
    self = [super init];
    if (self != nil) {
        self.fileId = fileId;
    }
    return self;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@/homework/delFiles", ServerProjectName];
}

- (id)requestArgument {
    return @{@"fileId":@(self.fileId)};
}

@end

#pragma mark MoveFilesRequest
@interface MoveFilesRequest ()

@property (nonatomic,assign) NSInteger fileId;
@property (nonatomic,assign) NSInteger parentId;
@property (nonatomic,strong) NSArray *homeworkIds;

@end

@implementation MoveFilesRequest

- (instancetype)initWithFileId:(NSInteger)fileId
                      parentId:(NSInteger)parentId
                   homeworkIds:(NSArray *)homeworkIds{
    self = [super init];
    if (self != nil) {
        self.fileId = fileId;
        self.parentId = parentId;
        self.homeworkIds = homeworkIds;
    }
    return self;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@/homework/moveFiles", ServerProjectName];
}

- (id)requestArgument {
    return @{@"fileId":@(self.fileId),
             @"parentId":@(self.parentId),
             @"homeworkIds":self.homeworkIds
             };
}

@end

#pragma mark - HomeworksByFileRequest

@interface HomeworksByFileRequest ()

@property (nonatomic,assign) NSInteger fileId;

@property (nonatomic,copy) NSString *nextUrl;
@end

@implementation HomeworksByFileRequest


- (instancetype)initWithFileId:(NSInteger)fileId nextUrl:(NSString *_Nullable)nextUrl{
    
    self = [super init];
    if (self != nil) {
        self.fileId = fileId;
        self.nextUrl = nextUrl;
    }
    return self;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (NSString *)requestUrl {
    if (self.nextUrl.length >0) {
        return self.nextUrl;
    } else {
        return [NSString stringWithFormat:@"%@/homework/homeworksByFile", ServerProjectName];
    }
}

- (id)requestArgument {
    return @{@"fileId":@(self.fileId)};
}

@end

#pragma mark - GetWorkTypesRequest

@implementation GetWorkTypesRequest

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@/homework/getWorkTypes", ServerProjectName];
}

@end

#pragma mark - ScoreListByHomeworkRequest

@interface ScoreListByHomeworkRequest ()

@property (nonatomic,assign) NSInteger homeworkId;

@property (nonatomic,copy) NSString *nextUrl;

@end


@implementation ScoreListByHomeworkRequest

- (instancetype)initWithHomeworkId:(NSInteger)homeworkId nextUrl:(NSString *_Nullable)nextUrl{
    
    self = [super init];
    if (self != nil) {
        self.nextUrl = nextUrl;
        self.homeworkId = homeworkId;
    }
    return self;
}
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (NSString *)requestUrl {
    if (self.nextUrl.length > 0) {
        
        return self.nextUrl;
    } else {
        
        return [NSString stringWithFormat:@"%@/homeworkTask/scoreListByHomework", ServerProjectName];
    }
}

- (id)requestArgument {
    return @{@"homeworkId":@(self.homeworkId)};
}

@end

#pragma ActCreateRequest
@interface ActCreateRequest ()

@property (nonatomic,strong) ActivityInfo *activityInfo;

@end

@implementation ActCreateRequest

- (instancetype)initWithActivityInfo:(ActivityInfo *)activityInfo{
    
    self = [super init];
    if (self != nil) {
        self.activityInfo = activityInfo;
    }
    return self;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@/actwork/create", ServerProjectName];
}

- (id)requestArgument {
    
    return [self.activityInfo dictionaryForUpload];
}

@end

#pragma mark - 删除活动(ipad管理端)
@interface ActDeleteRequest ()

@property (nonatomic,assign) NSInteger actId;

@end

@implementation ActDeleteRequest

- (instancetype)initWithActId:(NSInteger)actId{
    
    self = [super init];
    if (self != nil) {
        self.actId = actId;
    }
    return self;
}
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@/actwork/delAct", ServerProjectName];
}

- (id)requestArgument {
    return @{@"actId":@(self.actId)};
}

@end

#pragma mark ActGetRequest
@implementation ActGetRequest

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@/actwork/actworks", ServerProjectName];
}

@end


#pragma mark - 获取活动任务详情（ipad管理端&学生端）
@interface ActDetailGetRequest ()

@property (nonatomic,assign) NSInteger actId;

@end

@implementation ActDetailGetRequest

- (instancetype)initWithActId:(NSInteger)actId{
    
    self = [super init];
    if (self != nil) {
        self.actId = actId;
    }
    return self;
}
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@/actwork/actworkDetail", ServerProjectName];
}

- (id)requestArgument {
    return @{@"actId":@(self.actId)};
}

@end


#pragma mark - 获取活动排名(ipad管理端)
@interface ActGetActivityRankRequest ()

@property (nonatomic,assign) NSInteger actId;

@end

@implementation ActGetActivityRankRequest

- (instancetype)initWithActId:(NSInteger)actId{
    
    self = [super init];
    if (self != nil) {
        self.actId = actId;
    }
    return self;
}
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@/actworkTask/actRankByTech", ServerProjectName];
}

- (id)requestArgument {
    return @{@"actId":@(self.actId)};
}

@end


#pragma mark - 获取活动排名(学生端)
@interface ActGetStuActRankRequest ()

@property (nonatomic,assign) NSInteger actId;

@end

@implementation ActGetStuActRankRequest

- (instancetype)initWithActId:(NSInteger)actId{
    
    self = [super init];
    if (self != nil) {
        self.actId = actId;
    }
    return self;
}
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@/actworkTask/actRankByStu", ServerProjectName];
}

- (id)requestArgument {
    return @{@"actId":@(self.actId)};
}

@end


#pragma mark - 上传活动视频(学生端)
@interface ActCommitActRequest ()

@property (nonatomic,copy) NSString *actUrl;
@property (nonatomic,assign) NSInteger actId;
@property (nonatomic,assign) NSInteger actTimes;

@end

@implementation ActCommitActRequest

- (instancetype)initWithActId:(NSInteger)actId
                     actTimes:(NSInteger)actTimes
                       actUrl:(NSString *)actUrl{
    
    self = [super init];
    if (self != nil) {
        self.actId = actId;
        self.actTimes = actTimes;
        self.actUrl = actUrl;
    }
    return self;
}
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@/actworkTask/commitAct", ServerProjectName];
}

- (id)requestArgument {
    return @{@"actId":@(self.actId),
             @"actTimes":@(self.actTimes),
             @"actUrl":self.actUrl
             };
}

@end


#pragma mark - 我的上传（学生&ipad管理端）
@interface ActLogsRequest ()

@property (nonatomic,assign) NSInteger actId;
@property (nonatomic,assign) NSInteger stuId;

@end

@implementation ActLogsRequest

- (instancetype)initWithActId:(NSInteger)actId
                        stuId:(NSInteger)stuId{
    
    self = [super init];
    if (self != nil) {
        self.actId = actId;
        self.stuId = stuId;
    }
    return self;
}
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@/actworkTask/actLogs", ServerProjectName];
}

- (id)requestArgument {
    return @{@"actId":@(self.actId),
             @"stuId":@(self.stuId)
             };
}

@end


#pragma mark - 视频审阅（ipad管理端）
@interface VideoCorrectActRequest ()

@property (nonatomic,assign) NSInteger isOk;
@property (nonatomic,assign) NSInteger actId;
@property (nonatomic,assign) NSInteger videoId;


@end

@implementation VideoCorrectActRequest

- (instancetype)initWithVideoId:(NSInteger)videoId isOk:(NSInteger)isOk actId:(NSInteger)actId{
    
    self = [super init];
    if (self != nil) {
        self.isOk = isOk;
        self.actId = actId;
        self.videoId = videoId;
    }
    return self;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@/actworkTask/correctAct", ServerProjectName];
}

- (id)requestArgument {
    return @{@"id":@(self.videoId),
             @"isOk":@(self.isOk)};
}

@end

#pragma mark - 校区列表（ipad管理端）
@implementation CampusInfoRequest

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@/campus/getCampus", ServerProjectName];
}

@end


#pragma mark - 删除校区（ipad管理端
@interface DeleteCampusRequest ()

@property (nonatomic,assign) NSInteger campusId;

@end

@implementation DeleteCampusRequest

- (instancetype)initWithCampusId:(NSInteger)campusId{
   
    self = [super init];
    if (self != nil) {
        self.campusId = campusId;
    }
    return self;
}
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@/campus/delCampus", ServerProjectName];
}

- (id)requestArgument {
    return @{@"campusId":@(self.campusId)};
}

@end
