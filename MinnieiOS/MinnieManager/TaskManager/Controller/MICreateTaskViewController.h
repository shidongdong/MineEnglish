//
//  MICreateTaskViewController.h
//  MinnieManager
//
//  Created by songzhen on 2019/6/3.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import "Homework.h"
#import <UIKit/UIKit.h>
#import "ActivityInfo.h"

typedef void(^CreateTaskCallBack)(BOOL isDelete);

typedef NS_ENUM(NSInteger, MIHomeworkTaskType) {
    
    MIHomeworkTaskType_notify,                  // 通知
    MIHomeworkTaskType_FollowUp,                // 跟读
    MIHomeworkTaskType_WordMemory,              // 单词记忆
    MIHomeworkTaskType_GeneralTask,             // 普通任务
    MIHomeworkTaskType_Activity,                // 活动
    MIHomeworkTaskType_ExaminationStatistics    // 考试统计
};

NS_ASSUME_NONNULL_BEGIN

@interface MICreateTaskViewController : UIViewController

@property (nonatomic, copy) CreateTaskCallBack callBack;

@property (nonatomic, assign) BOOL teacherSider;

// 活动
- (void)setupCreateActivity:(ActivityInfo *_Nullable)activity;

// 作业
- (void)setupCreateHomework:(Homework *_Nullable)homework
            currentFileInfo:(FileInfo *_Nullable)currentFileInfo
                   taskType:(MIHomeworkTaskType)taskType;



@end

NS_ASSUME_NONNULL_END
