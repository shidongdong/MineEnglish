//
//  HomeworkSearchNameViewController.h
//  Minnie
//
//  Created by 栋栋 施 on 2018/11/29.
//  Copyright © 2018年 minnieedu. All rights reserved.
//  搜索作业

#import "BaseViewController.h"

@interface HomeworkSearchNameViewController : BaseViewController

@property (nonatomic, strong) Teacher *teacher; // （管理端）
@property (nonatomic, assign) NSInteger  finished;  //完成状态

@property (nonatomic, copy) void(^cancelCallBack)(void);
@property (nonatomic, copy) void(^pushVCCallBack)(UIViewController *vc);

@end

