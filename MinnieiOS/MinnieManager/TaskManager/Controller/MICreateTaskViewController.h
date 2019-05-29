//
//  MICreateTaskViewController.h
//  MinnieManager
//
//  Created by songzhen on 2019/5/28.
//  Copyright © 2019 minnieedu. All rights reserved.
//
#import "Homework.h"
#import "MICreateHomeworkTaskView.h"
#import "BaseViewController.h"


NS_ASSUME_NONNULL_BEGIN

@interface MICreateTaskViewController : BaseViewController

@property (nonatomic, strong) Homework *homework;

@property (nonatomic,assign) MIHomeworkTaskType taskType;

@end

NS_ASSUME_NONNULL_END
