//
//  TasksViewController.h
//  X5Teacher
//
//  Created by yebw on 2018/2/10.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^HomeworkSessionsCallback)(BOOL);

@interface HomeworkSessionsViewController : BaseViewController

@property (nonatomic, assign) BOOL isUnfinished; // 是否是进行中的  
@property (nonatomic, assign) BOOL bLoadConversion; //加载对话

- (void)requestSearchForSorceAtIndex:(NSInteger)index callBack:(HomeworkSessionsCallback)callback;

@end
