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
#import "MISecondActivitySheetView.h"
#import "MIStockSplitViewController.h"
#import "MIStockSecondViewController.h"
#import "HomeWorkSendHistoryViewController.h"
#import "UIViewController+PrimaryCloumnScale.h"

#import "MISubStockSplitViewController.h"
#import "MIActivityStockSplitViewController.h"

@interface MIMasterViewController ()<
RootSheetViewDelete,
SecondSheetViewDelegate,
MISecondActivitySheetViewDelegate,
MISubStockSplitViewControllerDelegate
>
// 根菜单视图
@property (nonatomic, strong)MIRootSheetView *firstSheetView;

// 二级任务管理文件夹视图
@property (nonatomic, strong) MISecondSheetView *secondSheetView;

// 二级活动管理视图
@property (nonatomic, strong) MISecondActivitySheetView *secondActivitySheetView;

// 任务管理 - 任务列表
@property (nonatomic, strong) MISubStockSplitViewController *subStockSplitVC;
// 活动管理 - 活动排行列表
@property (nonatomic, strong) MIActivityStockSplitViewController *activityStockSplitVC;


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
    
    _secondSheetView = [[MISecondSheetView alloc] initWithFrame:CGRectMake(kRootModularWidth, 0, kFolderModularWidth, ScreenHeight)];
    _secondSheetView.delegate = self;
    [self.view addSubview:_secondSheetView];
    
    _secondActivitySheetView = [[MISecondActivitySheetView alloc] initWithFrame:CGRectMake(kRootModularWidth, 0, kFolderModularWidth, self.view.frame.size.height)];
    _secondActivitySheetView.delegate = self;
    [self.view addSubview:_secondActivitySheetView];
    
    // 默认选中 任务管理
    _firstSheetView.selectIndex = 2;
    self.secondActivitySheetView.hidden = YES;
}

#pragma mark - RootSheetViewDelete
- (void)rootSheetViewClickedIndex:(NSInteger)index{
    
    UINavigationController *nav = ((UINavigationController *)self.customSplitViewController.viewControllers[1]);
    [nav popToRootViewControllerAnimated:YES];
    UIViewController *detailVC = nav.topViewController;
    
    [_secondActivitySheetView resetCurrentIndex];
    if (index == 7) { // 设置
        SettingsViewController *settingsVC = [[SettingsViewController alloc] initWithNibName:NSStringFromClass([SettingsViewController class]) bundle:nil];
        settingsVC.hiddenBackBtn = YES;
        if ([detailVC isKindOfClass:[MIStockSecondViewController class]]) {
            [(MIStockSecondViewController *)detailVC addSubViewController:settingsVC];
        }
    } else if (index == 2){ // 任务管理 不展开文件夹，不显示内容
       
        self.secondSheetView.hidden = NO;
        self.secondActivitySheetView.hidden = YES;
        [self updatePrimaryCloumnScale:kRootModularWidth + kFolderModularWidth];
        
        if ([detailVC isKindOfClass:[MIStockSecondViewController class]]) {
            [(MIStockSecondViewController *)detailVC addSubViewController:self.subStockSplitVC];
        }
        [self.subStockSplitVC showTaskListWithFoldInfo:nil folderIndex:-1];
        [_secondSheetView collapseAllFolders];
        [_secondSheetView updateFileListInfo];
        
    } else if (index == 3) { // 活动管理
        self.secondSheetView.hidden = YES;
        self.secondActivitySheetView.hidden = NO;
        [self updatePrimaryCloumnScale:kRootModularWidth + kFolderModularWidth];

        if ([detailVC isKindOfClass:[MIStockSecondViewController class]]) {
            [(MIStockSecondViewController *)detailVC addSubViewController:self.activityStockSplitVC];
            [self.activityStockSplitVC updateRankListWithActivityModel:nil index:-1];
        }
        [_secondActivitySheetView updateActivityListInfo];
    }
}

#pragma mark - 发送记录
- (void)toSendRecord{
    
    UINavigationController *nav = ((UINavigationController *)self.customSplitViewController.viewControllers[1]);
    if ([nav.viewControllers.lastObject isKindOfClass:[HomeWorkSendHistoryViewController class]]) {
        [nav popToRootViewControllerAnimated:YES];
        return;
    }
    [nav popToRootViewControllerAnimated:YES];
    
    [_secondSheetView collapseAllFolders];
    [self.subStockSplitVC showTaskListWithFoldInfo:nil folderIndex:-1];
    
    UIViewController *detailVC = nav.topViewController;
    self.customSplitViewController.primaryCloumnScale = kRootModularWidth + kFolderModularWidth;
    [self.customSplitViewController setDisplayMode:CSSplitDisplayModeDisplayPrimaryAndSecondary withAnimated:YES];
   
    HomeWorkSendHistoryViewController * historyHomeworkVC = [[HomeWorkSendHistoryViewController alloc] initWithNibName:@"HomeWorkSendHistoryViewController" bundle:nil];
    historyHomeworkVC.hiddenBackBtn = YES;
    if ([detailVC isKindOfClass:[MIStockSecondViewController class]]) {
        [detailVC.navigationController pushViewController:historyHomeworkVC animated:YES];
    }
}
#pragma mark - 任务管理 一级文件夹 && 二级文件夹
#pragma mark - SecondSheetViewDelegate
- (void)secondSheetViewFirstLevelData:(ParentFileInfo *_Nullable)data index:(NSInteger)index{
   
    MIStockSecondViewController *detailVC = [self getRootDetailViewController];
    if (detailVC) {
        [detailVC addSubViewController:self.subStockSplitVC];
    }
    if (data.subFileList.count) { // 显示空内容
        [self.subStockSplitVC showTaskListWithFoldInfo:nil folderIndex:index];
    } else {// 显示创建文件夹
        [self.subStockSplitVC showEmptyViewWithIsFolder:YES folderIndex:index];
    }
}

- (void)secondSheetViewSecondLevelData:(FileInfo *_Nullable)data index:(NSInteger)index{
 
    MIStockSecondViewController *detailVC = [self getRootDetailViewController];
    if (detailVC) {
        [detailVC addSubViewController:self.subStockSplitVC];
    }
    [self.subStockSplitVC showTaskListWithFoldInfo:data folderIndex:index];
}

- (void)secondSheetViewDeleteFile{

    [self.subStockSplitVC showTaskListWithFoldInfo:nil folderIndex:-1];
}

#pragma mark - 活动管理
#pragma mark - MISecondActivitySheetViewDelegate
- (void)secondActivitySheetViewCreateActivity{
    
    MIStockSecondViewController *detailVC = [self getRootDetailViewController];
    if (detailVC) {
        [detailVC addSubViewController:self.activityStockSplitVC];
        [self.activityStockSplitVC createActivity];
    }
}

- (void)secondActivitySheetViewDidClickedActivity:(ActivityInfo *_Nullable)data index:(NSInteger)index{
    
    MIStockSecondViewController *detailVC = [self getRootDetailViewController];
    if (detailVC) {
        [(MIStockSecondViewController *)detailVC addSubViewController:self.activityStockSplitVC];
        [self.activityStockSplitVC updateRankListWithActivityModel:data index:index];
    }
}

- (MIStockSecondViewController *)getRootDetailViewController{
    
    UINavigationController *nav = ((UINavigationController *)self.customSplitViewController.viewControllers[1]);
    [nav popToRootViewControllerAnimated:YES];
    UIViewController *detailVC = nav.topViewController;
    if (self.customSplitViewController.displayMode != CSSplitDisplayModeDisplayPrimaryAndSecondary) {
        
        [self.customSplitViewController setDisplayMode:CSSplitDisplayModeDisplayPrimaryAndSecondary withAnimated:YES];
    }
    if ([detailVC isKindOfClass:[MIStockSecondViewController  class]]) {
        return (MIStockSecondViewController *)detailVC;
    }
    return nil;
}

#pragma mark - MISubStockSplitViewControllerDelegate
- (void)subStockSplitViewControllerCreateTaskWithState:(NSInteger)state{
    
    if (state == 0) {
        self.customSplitViewController.primaryCloumnScale = kRootModularWidth;
    } else if (state == 1) {
        self.customSplitViewController.primaryCloumnScale = kRootModularWidth + kFolderModularWidth;
    } else {
        self.customSplitViewController.primaryCloumnScale = kRootModularWidth + kFolderModularWidth;
    }
    [self.customSplitViewController setDisplayMode:CSSplitDisplayModeDisplayPrimaryAndSecondary withAnimated:YES];
}

#pragma mark - setter && getter
- (MISubStockSplitViewController *)subStockSplitVC{
   
    if (!_subStockSplitVC) {
        WeakifySelf;
        _subStockSplitVC = [[MISubStockSplitViewController alloc] init];
        _subStockSplitVC.addFolderCallBack = ^(NSInteger folderIndex) {
            [weakSelf.secondSheetView addSecondLevelFolderIndex:folderIndex];
        };
        _subStockSplitVC.subDelegate = self;
    }
    if (_subStockSplitVC.primaryCloumnScale != kColumnThreeWidth) {
         _subStockSplitVC.primaryCloumnScale = kColumnThreeWidth;
        [_subStockSplitVC setDisplayMode:CSSplitDisplayModeDisplayPrimaryAndSecondary withAnimated:YES];
    }
    return _subStockSplitVC;
}

- (MIActivityStockSplitViewController *)activityStockSplitVC{
    
    if (!_activityStockSplitVC) {
        _activityStockSplitVC = [[MIActivityStockSplitViewController alloc] init];
        WeakifySelf;
        _activityStockSplitVC.createCallback = ^(NSInteger activityIndex) {
          
            [weakSelf.secondActivitySheetView activitySheetDidEditIndex:activityIndex];
        };
    }
    if (_subStockSplitVC.primaryCloumnScale != kColumnThreeWidth) {
        _subStockSplitVC.primaryCloumnScale = kColumnThreeWidth;
        [_subStockSplitVC setDisplayMode:CSSplitDisplayModeDisplayPrimaryAndSecondary withAnimated:YES];
    }
    return _activityStockSplitVC;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
