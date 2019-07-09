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
#import "MIStockSecondViewController.h"
#import "HomeWorkSendHistoryViewController.h"
#import "UIViewController+PrimaryCloumnScale.h"

#import "MITeacherManagerViewController.h"
#import "MIGifManStockSplitViewController.h"
#import "MITaskStockSplitViewController.h"
#import "MISetterStockSplitViewController.h"
#import "MIActivityStockSplitViewController.h"

@interface MIMasterViewController ()<
RootSheetViewDelete,
SecondSheetViewDelegate,
MISecondActivitySheetViewDelegate
>
// 根菜单视图
@property (nonatomic, strong)MIRootSheetView *firstSheetView;

// 二级任务管理文件夹视图
@property (nonatomic, strong) MISecondSheetView *secondSheetView;

// 二级活动管理视图
@property (nonatomic, strong) MISecondActivitySheetView *secondActivitySheetView;

// 任务管理
@property (nonatomic, strong) MITaskStockSplitViewController *subStockSplitVC;
// 活动管理
@property (nonatomic, strong) MIActivityStockSplitViewController *activityStockSplitVC;
// 设置
@property (nonatomic, strong) MISetterStockSplitViewController *setterStockSplitVC;
// 礼物管理
@property (nonatomic, strong) MIGifManStockSplitViewController *giftStockSplitVC;
// 教师管理
@property (nonatomic, strong) MITeacherManagerViewController *teacherStockSplitVC;

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
    
    _secondSheetView = [[MISecondSheetView alloc] initWithFrame:CGRectMake(kRootModularWidth, 0, kColumnSecondWidth, ScreenHeight)];
    _secondSheetView.delegate = self;
    [self.view addSubview:_secondSheetView];
    
    _secondActivitySheetView = [[MISecondActivitySheetView alloc] initWithFrame:CGRectMake(kRootModularWidth, 0, kColumnSecondWidth, self.view.frame.size.height)];
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
 
    [_secondActivitySheetView resetCurrentIndex];
    if (index == 0) { // 实时任务
        
    } else if (index == 1){ // 教师管理
        
        [self updatePrimaryCloumnScale:kRootModularWidth + kColumnSecondWidth];
        [self.secondDetailVC addSubViewController:self.teacherStockSplitVC];
        
    } else if (index == 2){ // 任务管理 不展开文件夹，不显示内容
       
        self.secondSheetView.hidden = NO;
        self.secondActivitySheetView.hidden = YES;
        [self updatePrimaryCloumnScale:kRootModularWidth + kColumnSecondWidth];
        [self.secondDetailVC addSubViewController:self.subStockSplitVC];
        
        [self.subStockSplitVC showTaskListWithFoldInfo:nil folderIndex:-1];
        [_secondSheetView collapseAllFolders];
        [_secondSheetView updateFileListInfo];
        
    } else if (index == 3) { // 活动管理
        self.secondSheetView.hidden = YES;
        self.secondActivitySheetView.hidden = NO;
        [self updatePrimaryCloumnScale:kRootModularWidth + kColumnSecondWidth];
        [self.secondDetailVC addSubViewController:self.activityStockSplitVC];
        
        [_secondActivitySheetView updateActivityListInfo];
    } else if (index == 4) { // 教学统计
        
    } else if (index == 5) { // 校区管理
        
    } else if (index == 6) { // 礼物管理
        
        [self updatePrimaryCloumnScale:kRootModularWidth];
        [self.secondDetailVC addSubViewController:self.giftStockSplitVC];
//        [self.giftStockSplitVC updateAwards];
//        [self.giftStockSplitVC updateExchangeAwardsList];
        
    } else if (index == 7) { // 设置
        [self updatePrimaryCloumnScale:kRootModularWidth];
        [self.secondDetailVC addSubViewController:self.setterStockSplitVC];
    }
}

#pragma mark - 发送记录
- (void)toSendRecord{
    
    UINavigationController *nav = ((UINavigationController *)self.customSplitViewController.viewControllers[1]);
    if ([nav.viewControllers.lastObject isKindOfClass:[HomeWorkSendHistoryViewController class]]) {
        return;
    }
    [nav popToRootViewControllerAnimated:YES];
    
    [_secondSheetView collapseAllFolders];
    [self.subStockSplitVC showTaskListWithFoldInfo:nil folderIndex:-1];
    
    self.customSplitViewController.primaryCloumnScale = kRootModularWidth + kColumnSecondWidth;
    [self.customSplitViewController setDisplayMode:CSSplitDisplayModeDisplayPrimaryAndSecondary withAnimated:YES];
   
    HomeWorkSendHistoryViewController * historyHomeworkVC = [[HomeWorkSendHistoryViewController alloc] initWithNibName:@"HomeWorkSendHistoryViewController" bundle:nil];
    [self.secondDetailVC.navigationController pushViewController:historyHomeworkVC animated:YES];
}
#pragma mark - 任务管理 一级文件夹 && 二级文件夹
#pragma mark - SecondSheetViewDelegate
- (void)secondSheetViewFirstLevelData:(ParentFileInfo *_Nullable)data index:(NSInteger)index{

    [self popToRootDetailViewController];
    [self.secondDetailVC addSubViewController:self.subStockSplitVC];
    if (data.subFileList.count) { // 显示空内容
        [self.subStockSplitVC showTaskListWithFoldInfo:nil folderIndex:index];
    } else {// 显示创建文件夹
        [self.subStockSplitVC showEmptyViewWithIsFolder:YES folderIndex:index];
    }
}

- (void)secondSheetViewSecondLevelData:(FileInfo *_Nullable)data index:(NSInteger)index{
    
    [self popToRootDetailViewController];
    [self.secondDetailVC addSubViewController:self.subStockSplitVC];
    [self.subStockSplitVC showTaskListWithFoldInfo:data folderIndex:index];
}

- (void)secondSheetViewDeleteFile{

    [self.subStockSplitVC showTaskListWithFoldInfo:nil folderIndex:-1];
}

#pragma mark - 活动管理
#pragma mark - MISecondActivitySheetViewDelegate
- (void)secondActivitySheetViewCreateActivity{
    
    [self popToRootDetailViewController];
    [self.secondDetailVC addSubViewController:self.activityStockSplitVC];
    [self.activityStockSplitVC createActivity];
}

- (void)secondActivitySheetViewDidClickedActivity:(ActivityInfo *_Nullable)data index:(NSInteger)index{
    
    [self popToRootDetailViewController];
    [self.secondDetailVC addSubViewController:self.activityStockSplitVC];
    [self.activityStockSplitVC updateRankListWithActivityModel:data index:index];
}

- (void)popToRootDetailViewController{
    
    UINavigationController *nav = ((UINavigationController *)self.customSplitViewController.viewControllers[1]);
    [nav popToRootViewControllerAnimated:YES];
}

#pragma mark - setter && getter
- (MITaskStockSplitViewController *)subStockSplitVC{
   
    if (!_subStockSplitVC) {
        WeakifySelf;
        _subStockSplitVC = [[MITaskStockSplitViewController alloc] init];
        _subStockSplitVC.addFolderCallBack = ^(NSInteger folderIndex) {
            [weakSelf.secondSheetView addSecondLevelFolderIndex:folderIndex];
        };
    }
    if (_subStockSplitVC.primaryCloumnScale != kColumnThreeWidth) {
         _subStockSplitVC.primaryCloumnScale = kColumnThreeWidth;
        [_subStockSplitVC setDisplayMode:CSSplitDisplayModeDisplayPrimaryAndSecondary withAnimated:YES];
    }
    return _subStockSplitVC;
}

- (MIActivityStockSplitViewController *)activityStockSplitVC{
    
    if (!_activityStockSplitVC) {
        WeakifySelf;
        _activityStockSplitVC = [[MIActivityStockSplitViewController alloc] init];
        _activityStockSplitVC.createCallback = ^(NSInteger activityIndex) {
          
            [weakSelf.secondActivitySheetView activitySheetDidEditIndex:activityIndex];
        };
    }
    if (_activityStockSplitVC.primaryCloumnScale != kColumnThreeWidth) {
        _activityStockSplitVC.primaryCloumnScale = kColumnThreeWidth;
        [_activityStockSplitVC setDisplayMode:CSSplitDisplayModeDisplayPrimaryAndSecondary withAnimated:YES];
    }
    return _activityStockSplitVC;
}


- (MISetterStockSplitViewController *)setterStockSplitVC{
    
    if (!_setterStockSplitVC) {
        _setterStockSplitVC = [[MISetterStockSplitViewController alloc] init];
    }
    CGFloat setterWidth = (ScreenWidth - kRootModularWidth)/2.0;
    if (_setterStockSplitVC.primaryCloumnScale != setterWidth) {
        _setterStockSplitVC.primaryCloumnScale = setterWidth;
        [_setterStockSplitVC setDisplayMode:CSSplitDisplayModeDisplayPrimaryAndSecondary withAnimated:YES];
    }
    return _setterStockSplitVC;
}

- (MITeacherManagerViewController *)teacherStockSplitVC{
    if (!_teacherStockSplitVC) {
        _teacherStockSplitVC = [[MITeacherManagerViewController alloc] init];
    }
    
    if (_teacherStockSplitVC.primaryCloumnScale != kColumnThreeWidth) {
        _teacherStockSplitVC.primaryCloumnScale = kColumnThreeWidth;
        [_teacherStockSplitVC setDisplayMode:CSSplitDisplayModeDisplayPrimaryAndSecondary withAnimated:YES];
    }
    return _teacherStockSplitVC;
}

- (MIGifManStockSplitViewController *)giftStockSplitVC{
    
    if (!_giftStockSplitVC) {
        _giftStockSplitVC = [[MIGifManStockSplitViewController alloc] init];
    }
    CGFloat setterWidth = (ScreenWidth - kRootModularWidth)/2.0 + 80;
    if (_giftStockSplitVC.primaryCloumnScale != setterWidth) {
        _giftStockSplitVC.primaryCloumnScale = setterWidth;
        [_giftStockSplitVC setDisplayMode:CSSplitDisplayModeDisplayPrimaryAndSecondary withAnimated:YES];
    }
    return _giftStockSplitVC;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
