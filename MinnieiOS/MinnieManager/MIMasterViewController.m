//
//  CSStockMasterTableViewController.m
//  CSCustomSplitViewController_Demo
//
//  Created by Huang Chusheng on 16/11/22.
//  Copyright © 2016年 Aaron. All rights reserved.
//

#import "MIRootSheetView.h"
#import "MISecondSheetView.h"
#import "SettingsViewController.h"
#import "MIMasterViewController.h"
#import "MITaskListViewController.h"
#import "MISecondActivitySheetView.h"
#import "MIStockSplitViewController.h"
#import "MIStockDetailViewController.h"
#import "MIActivityRankListViewController.h"
#import "HomeWorkSendHistoryViewController.h"

@interface MIMasterViewController ()<
RootSheetViewDelete,
SecondSheetViewDelegate,
MISecondActivitySheetViewDelegate
>{
    
    NSArray *_secondDataArray;
    
    NSInteger _firstSelectIndex;
}

// 跟菜单视图
@property (nonatomic, strong)MIRootSheetView *firstSheetView;

// 二级任务管理文件夹视图
@property (nonatomic, strong) MISecondSheetView *secondSheetView;

// 二级活动管理视图
@property (nonatomic, strong) MISecondActivitySheetView *secondActivitySheetView;

// 任务管理 - 任务列表
@property (nonatomic, strong) MITaskListViewController *taskListVC;

// 活动管理 - 活动排行列表
@property (nonatomic, strong) MIActivityRankListViewController *activityListVC;

@end

@implementation MIMasterViewController


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidLoad {
  
    [super viewDidLoad];
   
    _firstSheetView = [[MIRootSheetView alloc] initWithFrame:CGRectMake(0, 0, kRootModularWidth, self.view.frame.size.height)];
    _firstSheetView.delegate = self;
    [self.view addSubview:_firstSheetView];
    
    _secondSheetView = [[MISecondSheetView alloc] initWithFrame:CGRectMake(kRootModularWidth, 0, kFolderModularWidth, self.view.frame.size.height)];
    _secondSheetView.delegate = self;
    [self.view addSubview:_secondSheetView];
    
    _secondActivitySheetView = [[MISecondActivitySheetView alloc] initWithFrame:CGRectMake(kRootModularWidth, 0, kActivitySheetWidth, self.view.frame.size.height)];
    _secondActivitySheetView.delegate = self;
    [self.view addSubview:_secondActivitySheetView];
    
    // 默认 任务管理
    _firstSheetView.selectIndex = 2;
    self.secondActivitySheetView.hidden = YES;
}


#pragma mark - RootSheetViewDelete
- (void)rootSheetViewClickedIndex:(NSInteger)index{
    
    UINavigationController *nav = ((UINavigationController *)self.customSplitViewController.viewControllers[1]);
    [nav popToRootViewControllerAnimated:YES];
    UIViewController *detailVC = nav.topViewController;
    
    if (index == 7) { // 设置
        
        self.customSplitViewController.primaryCloumnScale = kRootModularWidth;
        [self.customSplitViewController setDisplayMode:CSSplitDisplayModeDisplayPrimaryAndSecondary withAnimated:YES];
        
        if (self.customSplitViewController.displayMode != CSSplitDisplayModeDisplayPrimaryAndSecondary) {
            [self.customSplitViewController setDisplayMode:CSSplitDisplayModeDisplayPrimaryAndSecondary withAnimated:YES];
        }
        
        SettingsViewController *settingsVC = [[SettingsViewController alloc] initWithNibName:NSStringFromClass([SettingsViewController class]) bundle:nil];
        [settingsVC setHidesBottomBarWhenPushed:YES];
        settingsVC.hiddenBackBtn = YES;
        if ([detailVC isKindOfClass:[MIStockDetailViewController class]]) {
            [(MIStockDetailViewController *)detailVC addSubViewController:settingsVC];
        }
    } else if (index == 2){ // 任务管理 不展开文件夹，不显示内容
       
        self.secondSheetView.hidden = NO;
        self.secondActivitySheetView.hidden = YES;
        
        self.customSplitViewController.primaryCloumnScale = kRootModularWidth + kFolderModularWidth;
        [self.customSplitViewController setDisplayMode:CSSplitDisplayModeDisplayPrimaryAndSecondary withAnimated:YES];
        if ([detailVC isKindOfClass:[MIStockDetailViewController class]]) {
            [(MIStockDetailViewController *)detailVC addSubViewController:self.taskListVC];
        }
        [self.taskListVC showTaskListWithFoldInfo:nil folderIndex:-1];
        [_secondSheetView updateFileListInfo];
    } else if (index == 3) { // 活动管理
        
        self.secondSheetView.hidden = YES;
        self.secondActivitySheetView.hidden = NO;
        
        self.customSplitViewController.primaryCloumnScale = kRootModularWidth + kActivitySheetWidth;
        [self.customSplitViewController setDisplayMode:CSSplitDisplayModeDisplayPrimaryAndSecondary withAnimated:YES];
        if ([detailVC isKindOfClass:[MIStockDetailViewController class]]) {
            [(MIStockDetailViewController *)detailVC addSubViewController:self.activityListVC];
            [self.activityListVC updateRankListWithActivityModel:nil index:-1];
        }
        [_secondActivitySheetView updateActivityListInfo];
    }
}

#pragma mark -
#pragma mark - 任务管理
- (void)toSendRecord{
    
    UINavigationController *nav = ((UINavigationController *)self.customSplitViewController.viewControllers[1]);
    [nav popToRootViewControllerAnimated:YES];
    
    UIViewController *detailVC = nav.topViewController;
    self.customSplitViewController.primaryCloumnScale = kRootModularWidth + kFolderModularWidth;
    [self.customSplitViewController setDisplayMode:CSSplitDisplayModeDisplayPrimaryAndSecondary withAnimated:YES];
   
    HomeWorkSendHistoryViewController * historyHomeworkVC = [[HomeWorkSendHistoryViewController alloc] initWithNibName:@"HomeWorkSendHistoryViewController" bundle:nil];
    historyHomeworkVC.hiddenBackBtn = YES;
    if ([detailVC isKindOfClass:[MIStockDetailViewController class]]) {
        [(MIStockDetailViewController *)detailVC addSubViewController:historyHomeworkVC];
    }
}

#pragma mark - SecondSheetViewDelegate  任务管理 一级文件夹 && 二级文件夹
- (void)secondSheetViewFirstLevelData:(ParentFileInfo *_Nullable)data index:(NSInteger)index{
   
    UINavigationController *nav = ((UINavigationController *)self.customSplitViewController.viewControllers[1]);
    [nav popToRootViewControllerAnimated:YES];
    UIViewController *detailVC = nav.topViewController;
    if (self.customSplitViewController.displayMode != CSSplitDisplayModeDisplayPrimaryAndSecondary) {
        
        [self.customSplitViewController setDisplayMode:CSSplitDisplayModeDisplayPrimaryAndSecondary withAnimated:YES];
    }
    if ([detailVC isKindOfClass:[MIStockDetailViewController  class]]) {
        
        [(MIStockDetailViewController *)detailVC addSubViewController:self.taskListVC];
    }
    if (data.subFileList.count) { // 显示空内容
        
        [self.taskListVC showTaskListWithFoldInfo:nil folderIndex:index];
    } else {// 显示创建文件夹
        [self.taskListVC showEmptyViewWithIsFolder:YES folderIndex:index];
    }
}

- (void)secondSheetViewSecondLevelData:(FileInfo *_Nullable)data index:(NSInteger)index{
    
    UINavigationController *nav = ((UINavigationController *)self.customSplitViewController.viewControllers[1]);
    [nav popToRootViewControllerAnimated:YES];
    UIViewController *detailVC = nav.topViewController;
    if (self.customSplitViewController.displayMode != CSSplitDisplayModeDisplayPrimaryAndSecondary) {
       
        [self.customSplitViewController setDisplayMode:CSSplitDisplayModeDisplayPrimaryAndSecondary withAnimated:YES];
    }
   
    if ([detailVC isKindOfClass:[MIStockDetailViewController  class]]) {
        
        [(MIStockDetailViewController *)detailVC addSubViewController:self.taskListVC];
    }
    [self.taskListVC showTaskListWithFoldInfo:data folderIndex:index];
}

#pragma mark -
#pragma mark - 活动管理
- (void)createActivity{
    
    UINavigationController *nav = ((UINavigationController *)self.customSplitViewController.viewControllers[1]);
    [nav popToRootViewControllerAnimated:YES];
    UIViewController *detailVC = nav.topViewController;
    if (self.customSplitViewController.displayMode != CSSplitDisplayModeDisplayPrimaryAndSecondary) {
        
        [self.customSplitViewController setDisplayMode:CSSplitDisplayModeDisplayPrimaryAndSecondary withAnimated:YES];
    }
    
    if ([detailVC isKindOfClass:[MIStockDetailViewController  class]]) {
        
        [(MIStockDetailViewController *)detailVC addSubViewController:self.activityListVC];
        [self.activityListVC createActivity];
    }
}
- (void)secondActivitySheetViewDidClickedActivity:(ActivityInfo *_Nullable)data index:(NSInteger)index{
    
    UINavigationController *nav = ((UINavigationController *)self.customSplitViewController.viewControllers[1]);
    [nav popToRootViewControllerAnimated:YES];
    UIViewController *detailVC = nav.topViewController;
    if (self.customSplitViewController.displayMode != CSSplitDisplayModeDisplayPrimaryAndSecondary) {
        
        [self.customSplitViewController setDisplayMode:CSSplitDisplayModeDisplayPrimaryAndSecondary withAnimated:YES];
    }
    
    if ([detailVC isKindOfClass:[MIStockDetailViewController  class]]) {
        
        [(MIStockDetailViewController *)detailVC addSubViewController:self.activityListVC];
        [self.activityListVC updateRankListWithActivityModel:data index:index];
    }
}

#pragma mark - setter && getter
- (MITaskListViewController *)taskListVC{
    
    if (!_taskListVC) {
        
        _taskListVC = [[MITaskListViewController alloc] initWithNibName:NSStringFromClass([MITaskListViewController class]) bundle:nil];
        WeakifySelf;
        _taskListVC.addFolderCallBack = ^(NSInteger folderIndex) {
            
            [weakSelf.secondSheetView addSecondLevelFolderIndex:folderIndex];
        };
        [_taskListVC setHidesBottomBarWhenPushed:YES];
    }
    return _taskListVC;
}

- (MIActivityRankListViewController *)activityListVC{
    
    if (!_activityListVC) {
        
        _activityListVC = [[MIActivityRankListViewController alloc] initWithNibName:NSStringFromClass([MIActivityRankListViewController class]) bundle:nil];
        WeakifySelf;
        _activityListVC.callback = ^(NSInteger activityIndex) {
          
            [weakSelf.secondActivitySheetView activitySheetDidEditIndex:activityIndex];
        };
        [_activityListVC setHidesBottomBarWhenPushed:YES];
    }
    return _activityListVC;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
