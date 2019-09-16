//
//  HomeworkSessionViewController.h
//  X5Teacher
//
//  Created by yebw on 2018/2/8.
//  Copyright © 2018年 netease. All rights reserved.
//  作业详情 - 聊天记录

#import "BaseViewController.h"
#import "HomeworkSession.h"

typedef void(^SessionDetailDisappearCallBack)(void);

// 作业聊天页面
@interface HomeworkSessionViewController : BaseViewController

// 作业session
@property (nonatomic, strong) HomeworkSession *homeworkSession;

// （管理端）
@property (nonatomic, strong) Teacher *teacher;
@property (nonatomic, copy) SessionDetailDisappearCallBack dissCallBack;

@end

