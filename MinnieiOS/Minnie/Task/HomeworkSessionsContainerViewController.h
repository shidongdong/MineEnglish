//
//  HomeworkSessionsContainerViewController.h
//  X5Teacher
//
//  Created by yebw on 2018/2/3.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "BaseViewController.h"
#import "HomeworkSessionsViewController.h"

typedef void(^ExchangeSessionTypeCallBack)(void);

// 消息，任务
@interface HomeworkSessionsContainerViewController : BaseViewController

@property (nonatomic, copy) ExchangeSessionTypeCallBack popDetailVCCallBack;
@property (nonatomic, copy) HomeworkSessionsPushVCCallback pushVCCallBack;

// ipad管理端根据老师获取任务列表
- (void)updateHomeworkSessionWithTeacher:(Teacher *)teacher;

@end
