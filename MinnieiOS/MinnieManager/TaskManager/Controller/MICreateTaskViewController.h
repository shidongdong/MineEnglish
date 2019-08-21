//
//  MICreateTaskViewController.h
//  MinnieManager
//
//  Created by songzhen on 2019/6/3.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import "Homework.h"
#import "ActivityInfo.h"
#import "BaseViewController.h"

typedef void(^CreateTaskCallBack)(BOOL isDelete);

typedef void(^CreateTaskCancelCallBack)(void);


NS_ASSUME_NONNULL_BEGIN

@interface MICreateTaskViewController : BaseViewController

@property (nonatomic, copy) CreateTaskCallBack callBack;
//
//@property (nonatomic, copy) CreateTaskCancelCallBack cancelCallBack;

@property (nonatomic, assign) BOOL teacherSider;


@property (nonatomic, strong) UIViewController *parentVC;

// 活动 activity 为空创建活动
- (void)setupCreateActivity:(ActivityInfo *_Nullable)activity;

// 作业 homework 为空创建作业
- (void)setupCreateHomework:(Homework *_Nullable)homework
            currentFileInfo:(FileInfo *_Nullable)currentFileInfo
                   taskType:(MIHomeworkTaskType)taskType;



@end

NS_ASSUME_NONNULL_END
