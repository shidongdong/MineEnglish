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

typedef NS_ENUM(NSInteger, MIHomeworkCreateContentType) {
    
    MIHomeworkCreateContentType_Localtion,          // 位置
    MIHomeworkCreateContentType_Title,              // 标题
    MIHomeworkCreateContentType_Content,            // 内容
    MIHomeworkCreateContentType_Requirements,       // 作业要求
    MIHomeworkCreateContentType_ActivityReq,        // 活动要求
    MIHomeworkCreateContentType_AddWords,           // 添加单词
    MIHomeworkCreateContentType_AddCovers,          // 添加封面
    MIHomeworkCreateContentType_WordsTimeInterval,  // 播放时间间隔
    MIHomeworkCreateContentType_AddAttachments,     // 添加附加
    MIHomeworkCreateContentType_Materials,          // 添加材料
    MIHomeworkCreateContentType_Answer,             // 添加答案
    MIHomeworkCreateContentType_StatisticalType,    // 统计类型
    MIHomeworkCreateContentType_CommitTime,         // 提交时间
    MIHomeworkCreateContentType_CommitCount,        // 可提交次数
    MIHomeworkCreateContentType_ExaminationType,    // 考试类型
    MIHomeworkCreateContentType_HomeworkDifficulty, // 作业难度
    MIHomeworkCreateContentType_TimeLimit,          // 选择时限
    MIHomeworkCreateContentType_Label,              // 标签
    MIHomeworkCreateContentType_TypeLabel,          // 类型标签
};

NS_ASSUME_NONNULL_BEGIN

@interface MICreateHomeworkTaskView : UIView

@property (nonatomic, copy) CreateCallBack callBack;

@property (nonatomic, strong) Homework *homework;   // 为空创建作业

@property (nonatomic,assign) MIHomeworkTaskType taskType;

- (void)updateData;

@end

NS_ASSUME_NONNULL_END
