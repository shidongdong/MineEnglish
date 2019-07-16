//
//  ManagerServce.h
//  MinnieManager
//
//  Created by songzhen on 2019/6/1.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import "BaseRequest.h"
#import "ActivityInfo.h"
#import "ParentFileInfo.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ManagerServce : NSObject

#pragma mark - 任务管理

// 新建任务管理文件夹
+ (BaseRequest *)requestCreateFilesWithFileDto:(FileInfo *)fileDto callback:(RequestCallback)callback;


// 获取任务管理文件夹
+ (BaseRequest *)requestGetFilesWithFileId:(NSInteger)fileId callback:(RequestCallback)callback;

// 删除任务管理文件夹
+ (BaseRequest *)requestDelFilesWithFileId:(NSInteger)fileId callback:(RequestCallback)callback;

// 任务位置移动 
+ (BaseRequest *)requestMoveFilesWithFileId:(NSInteger)fileId
                                   parentId:(NSInteger)parentId
                                homeworkIds:(NSArray *)homeworkIds
                                   callback:(RequestCallback)callback;

// 根据目录获取任务列表
+ (BaseRequest *)requesthomeworksByFileWithFileId:(NSInteger)fileId
                                          nextUrl:(NSString *_Nullable)nextUrl
                                         callback:(RequestCallback)callback;

// 获取任务类型
+ (BaseRequest *)requestGetWorkTypesWithCallback:(RequestCallback)callback;

// 任务得分列表
+ (BaseRequest *)requestScoreListByHomeworkId:(NSInteger)homeworkId nextUrl:(NSString *_Nullable)nextUrl callback:(RequestCallback)callback;

#pragma mark - 活动管理

// 新建活动（ipad管理端）
+ (BaseRequest *)requestCreateActivity:(ActivityInfo *)activityInfo callback:(RequestCallback)callback;

// 删除活动(ipad管理端) 进行中的活动不能删除，活动开始前和结束后的可以删除
+ (BaseRequest *)requestDeleteActivityId:(NSInteger)actId callback:(RequestCallback)callback;

// 获取活动任务列表（ipad管理端&学生端）
+ (BaseRequest *)requestGetActivityListWithCallback:(RequestCallback)callback;

// 获取活动任务详情（ipad管理端&学生端）
+ (BaseRequest *)requestGetActivityDetailWithActId:(NSInteger)actId callback:(RequestCallback)callback;

// 结束活动(ipad管理端)

// 获取活动排名(ipad管理端)
+ (BaseRequest *)requestGetActivityRankListWithActId:(NSInteger)actId callback:(RequestCallback)callback;

// 获取活动排名(学生端)
+ (BaseRequest *)requestGetStuActivityRankListWithActId:(NSInteger)actId callback:(RequestCallback)callback;
    
// 上传活动视频(学生端)
+ (BaseRequest *)requestCommitActivityId:(NSInteger)actId
                                actTimes:(NSInteger)actTimes
                                  actUrl:(NSString *)actUrl
                                callback:(RequestCallback)callback;

// 我的上传（学生&ipad管理端）
+ (BaseRequest *)requestactLogsActivityId:(NSInteger)actId
                                    stuId:(NSInteger)stuId
                                 callback:(RequestCallback)callback;


// 视频审阅（ipad管理端）
+ (BaseRequest *)requestCorrectActVideoId:(NSInteger)videoId
                                     isOk:(NSInteger)isOk
                                    actId:(NSInteger)actId
                                 callback:(RequestCallback)callback;

// 校区列表（ipad管理端）
+ (BaseRequest *)requestCampusWithCampusId:(NSInteger)campusId
                                campusName:(NSString *)campusName
                                  callback:(RequestCallback)callback;

// 删除校区（ipad管理端）
+ (BaseRequest *)requestDeleteCampusWithCampusId:(NSInteger)campusId
                                  callback:(RequestCallback)callback;
@end


NS_ASSUME_NONNULL_END
