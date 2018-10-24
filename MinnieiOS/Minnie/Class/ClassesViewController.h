//
//  ClassesViewController.h
//  X5Teacher
//
//  Created by yebw on 2017/12/16.
//  Copyright © 2017年 netease. All rights reserved.
//

#import "BaseViewController.h"

@interface ClassesViewController : BaseViewController

@property (nonatomic, assign) BOOL isUnfinished; // 是否是进行中的
@property (nonatomic, assign) BOOL isManageMode; // 是否在是管理页面，管理页面获取全部

@end
