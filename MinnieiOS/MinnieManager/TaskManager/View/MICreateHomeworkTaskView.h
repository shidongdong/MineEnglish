//
//  MICreateHomeworkTaskView.h
//  MinnieManager
//
//  Created by songzhen on 2019/5/29.
//  Copyright © 2019 minnieedu. All rights reserved.
//  新建作业 - 编辑作业

#import "Homework.h"
#import <UIKit/UIKit.h>

typedef void(^CreateCallBack)(void);

typedef NS_ENUM(NSInteger, MIHomeworkTaskType) {
    
    MIHomeworkTaskType_notify,                  // 通知
    MIHomeworkTaskType_FollowUp,                // 跟读
    MIHomeworkTaskType_WordMemory,              // 单词记忆
    MIHomeworkTaskType_GeneralTask,             // 普通任务
    MIHomeworkTaskType_Activity,                // 活动
    MIHomeworkTaskType_ExaminationStatistics    // 考试统计
};


NS_ASSUME_NONNULL_BEGIN

@interface MICreateHomeworkTaskView : UIView

@property (nonatomic, copy) CreateCallBack callBack;


- (void)setupCreateHomework:(Homework *_Nullable)homework taskType:(MIHomeworkTaskType)taskType;

@end

NS_ASSUME_NONNULL_END
