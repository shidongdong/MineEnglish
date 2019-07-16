//
//  ManagerServce.m
//  MinnieManager
//
//  Created by songzhen on 2019/6/1.
//  Copyright © 2019 minnieedu. All rights reserved.
//
#import "ManagerServce.h"
#import "ManagerRequest.h"

@implementation ManagerServce


// 新建任务管理文件夹
+ (BaseRequest *)requestCreateFilesWithFileDto:(FileInfo *)fileDto callback:(RequestCallback)callback{
    
    CeateFilesRequest * request = [[CeateFilesRequest alloc] initWithCeateFilesData:fileDto];
    [request setCallback:callback];
    [request start];
    return request;
}

// 获取任务管理文件夹
+ (BaseRequest *)requestGetFilesWithFileId:(NSInteger)fileId callback:(RequestCallback)callback{
    
    GetFilesRequest * request = [[GetFilesRequest alloc] initWithFileId:fileId];
    request.objectKey = @"list";
    request.objectClassName = @"ParentFileInfo";
    [request setCallback:callback];
    [request start];
    return request;
}

// 删除任务管理文件夹
+ (BaseRequest *)requestDelFilesWithFileId:(NSInteger)fileId callback:(RequestCallback)callback{
    
    DelFilesRequest * request = [[DelFilesRequest alloc] initWithFileId:fileId];
    [request setCallback:callback];
    [request start];
    return request;
}

// 任务位置移动
+ (BaseRequest *)requestMoveFilesWithFileId:(NSInteger)fileId
                                   parentId:(NSInteger)parentId
                                homeworkIds:(NSArray *)homeworkIds
                                   callback:(RequestCallback)callback{
    
    MoveFilesRequest * request = [[MoveFilesRequest alloc] initWithFileId:fileId parentId:parentId homeworkIds:homeworkIds];
    [request setCallback:callback];
    [request start];
    return request;
}

// 根据目录获取任务列表
+ (BaseRequest *)requesthomeworksByFileWithFileId:(NSInteger)fileId
                                          nextUrl:(NSString *_Nullable)nextUrl
                                         callback:(RequestCallback)callback{
    
    HomeworksByFileRequest * request = [[HomeworksByFileRequest alloc] initWithFileId:fileId nextUrl:nextUrl];
    [request setCallback:callback];
    request.objectKey = @"list";
    request.objectClassName = @"Homework";
    [request start];
    return request;
}

// 获取任务类型
+ (BaseRequest *)requestGetWorkTypesWithCallback:(RequestCallback)callback{
    
    GetWorkTypesRequest * request = [[GetWorkTypesRequest alloc] init];
    [request setCallback:callback];
    [request start];
    return request;
}

// 任务得分列表
+ (BaseRequest *)requestScoreListByHomeworkId:(NSInteger)homeworkId
                                      nextUrl:(NSString *_Nullable)nextUrl
                                     callback:(RequestCallback)callback{
    
    ScoreListByHomeworkRequest * request = [[ScoreListByHomeworkRequest alloc] initWithHomeworkId:homeworkId nextUrl:nextUrl];
    [request setCallback:callback];
    request.objectKey = @"list";
    request.objectClassName = @"ScoreInfo";
    [request start];
    return request;
}

// 新建活动（ipad管理端）
+ (BaseRequest *)requestCreateActivity:(ActivityInfo *)activityInfo callback:(RequestCallback)callback{
    
    ActCreateRequest * request = [[ActCreateRequest alloc] initWithActivityInfo:activityInfo];
    [request setCallback:callback];
    [request start];
    return request;
}


// 删除活动(ipad管理端)
+ (BaseRequest *)requestDeleteActivityId:(NSInteger)actId callback:(RequestCallback)callback{
    ActDeleteRequest *request = [[ActDeleteRequest alloc] initWithActId:actId];
    [request setCallback:callback];
    [request start];
    return request;
}


// 获取活动任务列表（ipad管理端&学生端）
+ (BaseRequest *)requestGetActivityListWithCallback:(RequestCallback)callback{
    
    ActGetRequest *request = [[ActGetRequest alloc] init];
    [request setCallback:callback];
    request.objectKey = @"list";
    request.objectClassName = @"ActivityInfo";
    [request start];
    return request;
}

// 获取活动任务详情（ipad管理端&学生端）
+ (BaseRequest *)requestGetActivityDetailWithActId:(NSInteger)actId callback:(RequestCallback)callback{
    
    ActDetailGetRequest *request = [[ActDetailGetRequest alloc] initWithActId:actId];
    [request setCallback:callback];
    request.objectClassName = @"ActivityInfo";
    [request start];
    return request;
}

// 获取活动排名(ipad管理端)
+ (BaseRequest *)requestGetActivityRankListWithActId:(NSInteger)actId callback:(RequestCallback)callback{
    
    ActGetActivityRankRequest *request = [[ActGetActivityRankRequest alloc] initWithActId:actId];
    [request setCallback:callback];
    request.objectClassName = @"ActivityRankListInfo";
    [request start];
    return request;
}

// 获取活动排名(学生端)
+ (BaseRequest *)requestGetStuActivityRankListWithActId:(NSInteger)actId callback:(RequestCallback)callback{
    
    ActGetStuActRankRequest *request = [[ActGetStuActRankRequest alloc] initWithActId:actId];
    [request setCallback:callback];
    request.objectKey = @"list";
    request.objectClassName = @"ActivityRankInfo";
    [request start];
    return request;
}

// 上传活动视频(学生端)
+ (BaseRequest *)requestCommitActivityId:(NSInteger)actId
                                actTimes:(NSInteger)actTimes
                                  actUrl:(NSString *)actUrl
                                callback:(RequestCallback)callback{
    
    ActCommitActRequest *request = [[ActCommitActRequest alloc] initWithActId:actId actTimes:actTimes actUrl:actUrl];
    [request setCallback:callback];
    [request start];
    return request;
}

+ (BaseRequest *)requestactLogsActivityId:(NSInteger)actId
                                    stuId:(NSInteger)stuId
                                 callback:(RequestCallback)callback{
    
    ActLogsRequest *request = [[ActLogsRequest alloc] initWithActId:actId stuId:stuId];
    [request setCallback:callback];
    request.objectKey = @"list";
    request.objectClassName = @"ActLogsInfo";
    [request start];
    return request;
}


// 视频审阅（ipad管理端）
+ (BaseRequest *)requestCorrectActVideoId:(NSInteger)videoId
                                     isOk:(NSInteger)isOk
                                    actId:(NSInteger)actId
                                 callback:(RequestCallback)callback{
 
    VideoCorrectActRequest *request = [[VideoCorrectActRequest alloc] initWithVideoId:videoId isOk:isOk actId:actId];
    [request setCallback:callback];
    [request start];
    return request;
    
}

// 校区列表（ipad管理端）
+ (BaseRequest *)requestCampusWithCampusId:(NSInteger)campusId
                                campusName:(NSString *)campusName
                                  callback:(RequestCallback)callback{
    
    CampusInfoRequest *request = [[CampusInfoRequest alloc] initWithCampusId:campusId campusName:campusName];
    request.objectKey = @"list";
    request.objectClassName = @"CampusInfo";
    [request setCallback:callback];
    [request start];
    return request;
    
}

// 删除校区（ipad管理端）
+ (BaseRequest *)requestDeleteCampusWithCampusId:(NSInteger)campusId
                                        callback:(RequestCallback)callback{
    DeleteCampusRequest *request = [[DeleteCampusRequest alloc] initWithCampusId:campusId];
    [request setCallback:callback];
    [request start];
    return request;
}


@end
