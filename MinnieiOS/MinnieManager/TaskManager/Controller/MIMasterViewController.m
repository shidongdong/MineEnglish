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
#import "MIStockSplitViewController.h"
#import "MIStockDetailViewController.h"
#import "HomeWorkSendHistoryViewController.h"

@interface MIMasterViewController ()<
RootSheetViewDelete,
SecondSheetViewDelegate
>{
    
    NSArray *_secondDataArray;
    
    NSInteger _firstSelectIndex;
}

//一级文件夹视图
@property (nonatomic, strong)MIRootSheetView *firstSheetView;

// 二级文件夹视图
@property (nonatomic, strong) MISecondSheetView *secondSheetView;

// 任务管理
@property (nonatomic, strong) MITaskListViewController *taskListVC;

@end

@implementation MIMasterViewController
{
    UIButton *_rightButton;
}

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
    
    // 默认 任务管理
    _firstSheetView.selectIndex = 2;
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
            _rightButton.selected = NO;
            [self.customSplitViewController setDisplayMode:CSSplitDisplayModeDisplayPrimaryAndSecondary withAnimated:YES];
        }
        
        SettingsViewController *settingsVC = [[SettingsViewController alloc] initWithNibName:NSStringFromClass([SettingsViewController class]) bundle:nil];
        [settingsVC setHidesBottomBarWhenPushed:YES];
        settingsVC.backBtn.hidden = YES;
        if ([detailVC isKindOfClass:[MIStockDetailViewController class]]) {
            [(MIStockDetailViewController *)detailVC addSubViewController:settingsVC];
        }
    } else if (index == 2){ // 文件夹
       
        self.customSplitViewController.primaryCloumnScale = kRootModularWidth + kFolderModularWidth;
        [self.customSplitViewController setDisplayMode:CSSplitDisplayModeDisplayPrimaryAndSecondary withAnimated:YES];
        if ([detailVC isKindOfClass:[MIStockDetailViewController class]]) {
            [(MIStockDetailViewController *)detailVC addSubViewController:self.taskListVC];
        }
        [self.taskListVC updateTaskList:@[]];
        
        NSArray *folderArray = [NSArray array];
        [_secondSheetView updateData:folderArray];
    }
}

#pragma mark -
- (void)toSendRecord{
    
    UINavigationController *nav = ((UINavigationController *)self.customSplitViewController.viewControllers[1]);
    [nav popToRootViewControllerAnimated:YES];
    
    UIViewController *detailVC = nav.topViewController;
    self.customSplitViewController.primaryCloumnScale = kRootModularWidth + kFolderModularWidth;
    [self.customSplitViewController setDisplayMode:CSSplitDisplayModeDisplayPrimaryAndSecondary withAnimated:YES];
   
    HomeWorkSendHistoryViewController * historyHomeworkVC = [[HomeWorkSendHistoryViewController alloc] initWithNibName:@"HomeWorkSendHistoryViewController" bundle:nil];
//    [nav pushViewController:historyHomeworkVC animated:YES];
  
    if ([detailVC isKindOfClass:[MIStockDetailViewController class]]) {
        [(MIStockDetailViewController *)detailVC addSubViewController:historyHomeworkVC];
    }
}

#pragma mark - SecondSheetViewDelegate  任务管理 一级文件夹 && 二级文件夹
- (void)secondSheetViewFirstLevelData:(MIFirLevelFolderModel *)data index:(NSInteger)index{
   
    UINavigationController *nav = ((UINavigationController *)self.customSplitViewController.viewControllers[1]);
    [nav popToRootViewControllerAnimated:YES];
    UIViewController *detailVC = nav.topViewController;
    if (self.customSplitViewController.displayMode != CSSplitDisplayModeDisplayPrimaryAndSecondary) {
        _rightButton.selected = NO;
        [self.customSplitViewController setDisplayMode:CSSplitDisplayModeDisplayPrimaryAndSecondary withAnimated:YES];
    }
    if ([detailVC isKindOfClass:[MIStockDetailViewController  class]]) {
        
        [(MIStockDetailViewController *)detailVC addSubViewController:self.taskListVC];
    }
    if (data.folderArray.count) { // 显示空内容
        [self.taskListVC updateTaskList:@[]];
        
    } else {// 显示创建文件夹
        [self.taskListVC showEmptyViewWithIsFolder:YES folderIndex:index];
    }
}

- (void)secondSheetViewSecondLevelData:(MIFirLevelFolderModel *)data index:(NSInteger)index{
    
    UINavigationController *nav = ((UINavigationController *)self.customSplitViewController.viewControllers[1]);
    [nav popToRootViewControllerAnimated:YES];
    UIViewController *detailVC = nav.topViewController;
    if (self.customSplitViewController.displayMode != CSSplitDisplayModeDisplayPrimaryAndSecondary) {
        _rightButton.selected = NO;
        [self.customSplitViewController setDisplayMode:CSSplitDisplayModeDisplayPrimaryAndSecondary withAnimated:YES];
    }
   
    MISecLevelFolderModel *secFolder;
    if (index < data.folderArray.count) {
        secFolder = data.folderArray[index];
    }
    if ([detailVC isKindOfClass:[MIStockDetailViewController  class]]) {
        
        [(MIStockDetailViewController *)detailVC addSubViewController:self.taskListVC];
    }
    if (secFolder.taskArray.count) { // 显示当前index文件夹下内容
        [self.taskListVC updateTaskList:@[@"测试内容"]];
    } else {// 显示创建任务
        
        [self.taskListVC showEmptyViewWithIsFolder:NO folderIndex:index];
    }
}

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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
