//
//  SearchHomeworkViewController.h
//  X5Teacher
//
//  Created by yebw on 2018/2/4.
//  Copyright © 2018年 netease. All rights reserved.
//  搜索作业

#import "BaseViewController.h"

@interface SearchHomeworkViewController : BaseViewController

// 0代表全局搜索  否则按照二级文件夹ID搜索
@property (nonatomic, assign) NSInteger fieldId;

@property (nonatomic, copy) void(^popDetailCallBack) (void);

@property (nonatomic, copy) void(^pushVCCallBack) (UIViewController * _Nullable VC);

@end
