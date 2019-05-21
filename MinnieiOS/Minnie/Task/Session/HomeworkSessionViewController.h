//
//  HomeworkSessionViewController.h
//  X5Teacher
//
//  Created by yebw on 2018/2/8.
//  Copyright © 2018年 netease. All rights reserved.
//  作业详情 - 聊天记录

#import "BaseViewController.h"
#import "HomeworkSession.h"

// 作业聊天页面
@interface HomeworkSessionViewController : BaseViewController

// 作业session
@property (nonatomic, strong) HomeworkSession *homeworkSession;

@end

