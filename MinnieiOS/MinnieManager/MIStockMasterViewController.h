//
//  CSStockMasterTableViewController.h
//  CSCustomSplitViewController_Demo
//
//  Created by Huang Chusheng on 16/11/22.
//  Copyright © 2016年 Aaron. All rights reserved.
//  任务管理 - 文件夹

#import <UIKit/UIKit.h>
#import "MIStockDetailViewController.h"

typedef void(^UpdatePrimaryCloumnScaleCallBack)(NSInteger primaryCloumnScale);

@interface MIStockMasterViewController : UIViewController

@property (nonatomic,strong) MIStockDetailViewController *secondDetailVC;

@property (nonatomic,copy) UpdatePrimaryCloumnScaleCallBack cloumnSacleCallBack;

@end
