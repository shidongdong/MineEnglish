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

// 任务位置移动
+ (BaseRequest *)requestMoveFilesWithFileId:(NSInteger)fileId
                                   parentId:(NSInteger)parentId
                                homeworkIds:(NSArray *)homeworkIds
                                   callback:(RequestCallback)callback;

// 根据目录获取任务列表
+ (BaseRequest *)requesthomeworksByFileWithFileId:(NSInteger)fileId callback:(RequestCallback)callback;

// 获取任务类型
+ (BaseRequest *)requestGetWorkTypesWithCallback:(RequestCallback)callback;

// 任务得分列表
+ (BaseRequest *)requestScoreListByHomeworkId:(NSInteger)homeworkId callback:(RequestCallback)callback;


#pragma mark - 活动管理

// 新建活动（ipad管理端）
+ (BaseRequest *)requestCreateActivity:(ActivityInfo *)activityInfo callback:(RequestCallback)callback;

// 删除活动(ipad管理端)
+ (BaseRequest *)requestDeleteActivityId:(NSInteger)actId callback:(RequestCallback)callback;

// 获取活动任务列表（ipad管理端&学生端）
+ (BaseRequest *)requestGetActivityListWithcallback:(RequestCallback)callback;

// 结束活动(ipad管理端)

// 获取活动排名(ipad管理端)
+ (BaseRequest *)requestGetActivityRankListWithcallback:(RequestCallback)callback;

// 获取活动排名(学生端)
+ (BaseRequest *)requestGetStuActivityRankListWithcallback:(RequestCallback)callback;

// 上传活动视频(学生端)
+ (BaseRequest *)requestDeleteActivityId:(NSInteger)actId
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
                                 callback:(RequestCallback)callback;

@end


NS_ASSUME_NONNULL_END
