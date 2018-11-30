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
@property (nonatomic, assign) NSInteger searchFliter;   //搜索条件  类型 0 按时间 1 按作业 2 按人 如果为 -1的话表示是按名字搜索


//首页请求接口
- (void)requestSearchForSorceAtIndex:(NSInteger)index;

//从搜索页请求接口
- (void)requestSearchForName:(NSString *)name;

@end
