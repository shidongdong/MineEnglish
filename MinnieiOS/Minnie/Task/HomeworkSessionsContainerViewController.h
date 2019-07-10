//
//  HomeworkSessionsContainerViewController.h
//  X5Teacher
//
//  Created by yebw on 2018/2/3.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "BaseViewController.h"
#import "HomeworkSessionsViewController.h"

// 消息，任务
@interface HomeworkSessionsContainerViewController : BaseViewController

@property (nonatomic, copy) HomeworkSessionsPushVCCallback pushVCCallBack;

@end
