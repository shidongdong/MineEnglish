//
//  CSStockMasterTableViewController.m
//  CSCustomSplitViewController_Demo
//
//  Created by Huang Chusheng on 16/11/22.
//  Copyright © 2016年 Aaron. All rights reserved.
//

#import "MIRootSheetView.h"
#import "MISecondTeachersView.h"
#import "MISecondSheetView.h"
#import "SettingsViewController.h"
#import "MIMasterViewController.h"
#import "MISecondActivitySheetView.h"
#import "MISecondTeachStatisticsView.h"
#import "MIStockSecondViewController.h"
#import "HomeWorkSendHistoryViewController.h"
#import "UIViewController+PrimaryCloumnScale.h"

#import "MITeacherManagerViewController.h"
#import "MIGifManStockSplitViewController.h"
#import "MITaskStockSplitViewController.h"
#import "MISetterStockSplitViewController.h"
#import "MIActivityStockSplitViewController.h"
#import "MIReaTimTasStockSplitViewController.h"
#import "MITeaStaStockSplitViewController.h"
#import "MICamManStockSplitViewController.h"

@interface MIMasterViewController ()<
RootSheetViewDelete,
SecondSheetViewDelegate,
MISecondTeachersViewDelegate,
MISecondActivitySheetViewDelegate,
MISecondTeachStatisticsViewDelegate
>
// 根菜单视图
@property (nonatomic, strong)MIRootSheetView *firstSheetView;

// 实时任务 教师列表
@property (nonatomic, strong) MISecondTeachersView *reaTimTasSheetView;
// 教师管理 教师列表
@property (nonatomic, strong) MISecondTeachersView *teacherManagerSheetView;
// 任务管理 文件夹列表
@property (nonatomic, strong) MISecondSheetView *secondSheetView;
// 活动管理 活动列表
@property (nonatomic, strong) MISecondActivitySheetView *secondActivitySheetView;
// 教学统计 学生列表
@property (nonatomic, strong) MISecondTeachStatisticsView *secondTeaStaSheetView;


// 实时任务
@property (nonatomic, strong) MIReaTimTasStockSplitViewController *reaTimTasStockSplitVC;
// 教师管理
@property (nonatomic, strong) MITeacherManagerViewController *teacherStockSplitVC;
// 任务管理
@property (nonatomic, strong) MITaskStockSplitViewController *subStockSplitVC;
// 活动管理
@property (nonatomic, strong) MIActivityStockSplitViewController *activityStockSplitVC;
// 教学统计
@property (nonatomic, strong) MITeaStaStockSplitViewController *teaStaStockSplitVC;
// 校区管理
@property (nonatomic, strong) MICamManStockSplitViewController *camManStockSplitVC;
// 礼物管理
@property (nonatomic, strong) MIGifManStockSplitViewController *giftStockSplitVC;
// 设置
@property (nonatomic, strong) MISetterStockSplitViewController *setterStockSplitVC;

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
    
    _reaTimTasSheetView = [[MISecondTeachersView alloc] initWithFrame:CGRectMake(kRootModularWidth, 0, kColumnSecondWidth, self.view.frame.size.height)];
    _reaTimTasSheetView.delegate = self;
    [self.view addSubview:_reaTimTasSheetView];
    
    _teacherManagerSheetView = [[MISecondTeachersView alloc] initWithFrame:CGRectMake(kRootModularWidth, 0, kColumnSecondWidth, self.view.frame.size.height)];
    _teacherManagerSheetView.delegate = self;
    [self.view addSubview:_teacherManagerSheetView];
    
    _secondSheetView = [[MISecondSheetView alloc] initWithFrame:CGRectMake(kRootModularWidth, 0, kColumnSecondWidth, ScreenHeight)];
    _secondSheetView.delegate = self;
    [self.view addSubview:_secondSheetView];
    
    _secondActivitySheetView = [[MISecondActivitySheetView alloc] initWithFrame:CGRectMake(kRootModularWidth, 0, kColumnSecondWidth, self.view.frame.size.height)];
    _secondActivitySheetView.delegate = self;
    [self.view addSubview:_secondActivitySheetView];
    
    _secondTeaStaSheetView = [[MISecondTeachStatisticsView alloc] initWithFrame:CGRectMake(kRootModularWidth, 0, kColumnSecondWidth, self.view.frame.size.height)];
    _secondTeaStaSheetView.delegate = self;
    [self.view addSubview:_secondTeaStaSheetView];
    
    
    // 默认选中 任务管理
    _firstSheetView.selectIndex = 2;
    self.reaTimTasSheetView.hidden = YES;
    self.secondActivitySheetView.hidden = YES;
}

#pragma mark - RootSheetViewDelete
- (void)rootSheetViewClickedIndex:(NSInteger)index{
    
    UINavigationController *nav = ((UINavigationController *)self.customSplitViewController.viewControllers[1]);
    [nav popToRootViewControllerAnimated:YES];
 
    [_secondActivitySheetView resetCurrentIndex];
    self.secondSheetView.hidden = YES;
    self.reaTimTasSheetView.hidden = YES;
    self.secondActivitySheetView.hidden = YES;
    self.teacherManagerSheetView.hidden = YES;
    self.secondTeaStaSheetView.hidden = YES;
    
    if (index == 0) { // 实时任务
        
        self.reaTimTasSheetView.hidden = NO;
        [self updatePrimaryCloumnScale:kRootModularWidth + kColumnSecondWidth];
        [self.secondDetailVC addSubViewController:self.reaTimTasStockSplitVC];
        
        [self.reaTimTasSheetView updateTeacherListWithListType:0];
        [self.reaTimTasStockSplitVC updateHomeworkSessionWithTeacher:nil];
        
    } else if (index == 1){ // 教师管理
        
        self.teacherManagerSheetView.hidden = NO;
        [self updatePrimaryCloumnScale:kRootModularWidth + kColumnSecondWidth];
        [self.secondDetailVC addSubViewController:self.teacherStockSplitVC];
        
        [self.teacherManagerSheetView updateTeacherListWithListType:1];
        [self.teacherStockSplitVC updateTeacher:nil];
        
    } else if (index == 2){ // 任务管理 不展开文件夹，不显示内容
       
        self.secondSheetView.hidden = NO;
        [self updatePrimaryCloumnScale:kRootModularWidth + kColumnSecondWidth];
        [self.secondDetailVC addSubViewController:self.subStockSplitVC];
        
        [self.subStockSplitVC showTaskListWithFoldInfo:nil folderIndex:-1];
        [_secondSheetView collapseAllFolders];
        [_secondSheetView updateFileListInfo];
        
    } else if (index == 3) { // 活动管理
        
        self.secondActivitySheetView.hidden = NO;
        [self updatePrimaryCloumnScale:kRootModularWidth + kColumnSecondWidth];
        [self.secondDetailVC addSubViewController:self.activityStockSplitVC];
        
        [_secondActivitySheetView updateActivityListInfo];
    } else if (index == 4) { // 教学统计
        
        self.secondTeaStaSheetView.hidden = NO;
        [self updatePrimaryCloumnScale:kRootModularWidth + kColumnSecondWidth];
      
        if (![self.secondDetailVC.childViewControllers.lastObject isKindOfClass:[MITeaStaStockSplitViewController class]]) {
            [self.secondDetailVC addSubViewController:self.teaStaStockSplitVC];
        }
        [self.secondTeaStaSheetView updateStudentListWithListType:0];
        [self.teaStaStockSplitVC updateStudent:nil];
    } else if (index == 5) { // 校区管理
        
        [self updatePrimaryCloumnScale:kRootModularWidth];
        [self.secondDetailVC addSubViewController:self.camManStockSplitVC];
    } else if (index == 6) { // 礼物管理
        
        [self updatePrimaryCloumnScale:kRootModularWidth];
        [self.secondDetailVC addSubViewController:self.giftStockSplitVC];
    } else if (index == 7) { // 设置
        [self updatePrimaryCloumnScale:kRootModularWidth];
        [self.secondDetailVC addSubViewController:self.setterStockSplitVC];
    }
}

#pragma mark - 实时任务 && 教师管理
- (void)secondTeaManViewDidClicledWithTeacher:(Teacher *)teacher listType:(NSInteger)type{
    
    if (type == 0) {// 实时任务
        [self.reaTimTasStockSplitVC updateHomeworkSessionWithTeacher:teacher];
    } else {
        [self.teacherStockSplitVC updateTeacher:teacher];
    }
}

#pragma mark - 教学统计 MISecondTeachStatisticsViewDelegate
-(void)secondTeachStatisticsViewDidClicledWithStudent:(User *)student{
    
    [self.teaStaStockSplitVC updateStudent:student];
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
- (MIReaTimTasStockSplitViewController *)reaTimTasStockSplitVC{
    
    if (!_reaTimTasStockSplitVC) {
        _reaTimTasStockSplitVC = [[MIReaTimTasStockSplitViewController alloc] init];
    }
    
    if (_reaTimTasStockSplitVC.primaryCloumnScale != kColumnThreeWidth) {
        _reaTimTasStockSplitVC.primaryCloumnScale = kColumnThreeWidth;
        [_reaTimTasStockSplitVC setDisplayMode:CSSplitDisplayModeDisplayPrimaryAndSecondary withAnimated:YES];
    }
    return _reaTimTasStockSplitVC;
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

- (MITeaStaStockSplitViewController *)teaStaStockSplitVC{
    
    if (!_teaStaStockSplitVC) {
        _teaStaStockSplitVC = [[MITeaStaStockSplitViewController alloc] init];
    }
    if (_teaStaStockSplitVC.primaryCloumnScale != kColumnThreeWidth) {
        _teaStaStockSplitVC.primaryCloumnScale = kColumnThreeWidth;
        [_teaStaStockSplitVC setDisplayMode:CSSplitDisplayModeDisplayPrimaryAndSecondary withAnimated:YES];
    }
    return _teaStaStockSplitVC;
}

- (MICamManStockSplitViewController *)camManStockSplitVC{
    if (!_camManStockSplitVC) {
        _camManStockSplitVC = [[MICamManStockSplitViewController alloc] init];
    }
    CGFloat setterWidth = (ScreenWidth - kRootModularWidth)/2.0;
    if (_camManStockSplitVC.primaryCloumnScale != setterWidth) {
        _camManStockSplitVC.primaryCloumnScale = setterWidth;
        [_camManStockSplitVC setDisplayMode:CSSplitDisplayModeDisplayPrimaryAndSecondary withAnimated:YES];
    }
    return _camManStockSplitVC;
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



@end
