//
//  HomeworkSessionsContainerViewController.m
//  X5
//
//  Created by yebw on 2017/8/21.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "HomeworkSessionsContainerViewController.h"
#import "HomeworkSessionsViewController.h"
#import "CalendarViewController.h"
#import "SegmentControl.h"
#import <Masonry/Masonry.h>
#import "IMManager.h"
#import "AlertView.h"
#import "Clazz.h"
#import "PublicService.h"
#import "AppVersion.h"
#import "FilterAlertView.h"

#if TEACHERSIDE
#import "HomeworkSearchNameViewController.h"
#import <FileProviderUI/FileProviderUI.h>
#import <FileProvider/FileProvider.h>
#else
#import "AchieverListViewController.h"
#import "AchieverService.h"
#import "MedalFlag.h"
#endif

@interface HomeworkSessionsContainerViewController ()

@property (nonatomic, strong) HomeworkSessionsViewController *unfinishedClassesChildController;
@property (nonatomic, strong) HomeworkSessionsViewController *finishedClassesChildController;

@property (nonatomic, assign) NSInteger  currentFliterType;  //教师端： 0 按时间 1 按作业 2 按人 学生端： 0星~6星

@property (nonatomic, assign) HomeworkSessionsViewController * currentViewController;

#if TEACHERSIDE
@property (nonatomic, strong) HomeworkSessionsViewController *uncommitClassesChildController;

#else
#endif

@property (nonatomic, assign) BOOL ignoreScrollCallback;

@property (nonatomic, weak) IBOutlet UIView *containerView;
@property (nonatomic, weak) IBOutlet UIScrollView *containerScrollView;
@property (nonatomic, weak) IBOutlet UIView *customTitleView;
@property (nonatomic, weak) IBOutlet UIButton * rightFuncButton;
@property (nonatomic, weak) IBOutlet UIButton * leftFuncButton;
@property (nonatomic, weak) SegmentControl *segmentControl;
@property (weak, nonatomic) IBOutlet UIView *redIncoinView;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *heightLayoutConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerContentY;

@property (nonatomic, assign) BOOL everAppeared;

@end

@implementation HomeworkSessionsContainerViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self checkAppVersion];
#if TEACHERSIDE
    
    self.containerContentY.constant = 3 * ScreenWidth;
    
    [self.leftFuncButton setImage:[UIImage imageNamed:@"navbar_search"] forState:UIControlStateNormal];
    [self.rightFuncButton setImage:[UIImage imageNamed:@"navbar_screen"] forState:UIControlStateNormal];
#else
    [self.leftFuncButton setImage:[UIImage imageNamed:@"navbar_medal"] forState:UIControlStateNormal];
    [self.rightFuncButton setImage:[UIImage imageNamed:@"navbar_calendar"] forState:UIControlStateNormal];
#endif
    
    if (isIPhoneX) {
        self.heightLayoutConstraint.constant = -(44 + [UIApplication sharedApplication].statusBarFrame.size.height);
    }
    
    
#if TEACHERSIDE
    self.segmentControl = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SegmentControl class]) owner:nil options:nil] firstObject];
    self.segmentControl.titles = @[@"待批改", @"已完成",@"未提交"];
#else
    self.segmentControl = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SegmentControl class]) owner:nil options:nil] lastObject];
    self.segmentControl.titles = @[@"未完成", @"已完成"];
#endif
    self.segmentControl.selectedIndex = 0;
    
    __weak HomeworkSessionsContainerViewController *weakSelf = self;
    self.segmentControl.indexChangeHandler = ^(NSUInteger selectedIndex) {
#if TEACHERSIDE
#else
        if (selectedIndex == 0)
        {
            [self.rightFuncButton setImage:[UIImage imageNamed:@"navbar_calendar"] forState:UIControlStateNormal];
        }
        else
        {
             [self.rightFuncButton setImage:[UIImage imageNamed:@"navbar_screen"] forState:UIControlStateNormal];
        }
#endif
        [weakSelf showChildPageViewControllerWithIndex:selectedIndex animated:YES shouldLocate:YES];
    };
    [self.customTitleView addSubview:self.segmentControl];
    [self.segmentControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.customTitleView);
    }];
    
    [self showChildPageViewControllerWithIndex:0 animated:NO shouldLocate:YES];
}

- (void)checkAppVersion
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    [PublicService requestAppUpgradeWithVersion:app_Version callback:^(Result *result, NSError *error) {
        if (error == nil && result)
        {
            AppVersion * appUpgraud = (AppVersion *)(result.userInfo);
            NSInteger currentVerIndex = [[app_Version stringByReplacingOccurrencesOfString:@"." withString:@""] integerValue];
            NSInteger newVerIndex =  [[appUpgraud.appVersion stringByReplacingOccurrencesOfString:@"." withString:@""] integerValue];
            if (newVerIndex > currentVerIndex)
            {
                [self createUpgraudAlert:appUpgraud];
            }
            
        }
    }];
}

- (void)createUpgraudAlert:(AppVersion *)appinfo
{

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"升级提示" message:appinfo.upgradeDes preferredStyle:UIAlertControllerStyleAlert];
    if (appinfo.upgradeType == 1)
    {
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"点击取消");
        }]];
        
    }
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSLog(@"点击确认");
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appinfo.appUrl] options:@{} completionHandler:nil];
        //  [APP openURL:];
    }]];
    
    
    [self presentViewController:alertController animated:YES completion:^{
        
    }];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
#if TEACHERSIDE
#else
    [AchieverService requestMedalNoticeFlagWithCallback:^(Result *result, NSError *error) {
        //只处理成功的情况
        if (error == nil)
        {
            MedalFlag * medel = (MedalFlag *)(result.userInfo);
            if (medel.metalFlag == 1)
            {
                self.redIncoinView.layer.cornerRadius = 2.0;
                self.redIncoinView.hidden = NO;
            }
            else
            {
                self.redIncoinView.hidden = YES;
            }
        }
    }];
#endif
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (!self.everAppeared) {
#if TEACHERSIDE
#else
        if (APP.classIdAlertShown != APP.currentUser.clazz.classId) {
            NSString *message = [NSString stringWithFormat:@"你目前在\"%@\"", APP.currentUser.clazz.name];
            
            [AlertView showInView:self.tabBarController.view
                        withImage:[UIImage imageNamed:@"pop_img_welcome"]
                            title:@"欢迎加入minnie英文教室"
                          message:message
                           action:@"知道啦"
                   actionCallback:^{
                       [APP setClassIdAlertShown:APP.currentUser.clazz.classId];
                       
                       self.everAppeared = YES;
                   }];
        }
        
#endif
        
        self.everAppeared = YES;
    }
}

- (IBAction)leftFuncClick:(id)sender {
#if TEACHERSIDE
    
    HomeworkSearchNameViewController * searchVc = [[HomeworkSearchNameViewController alloc] initWithNibName:NSStringFromClass([HomeworkSearchNameViewController class]) bundle:nil];
    [searchVc setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:searchVc animated:YES];
    
#else
    
    //点击勋章主动把小红点隐藏
    
    
    AchieverListViewController * achiverVc = [[AchieverListViewController alloc] initWithNibName:NSStringFromClass([AchieverListViewController class]) bundle:nil];
    [achiverVc setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:achiverVc animated:YES];
#endif
    
}


- (IBAction)rightFuncClick:(id)sender {
#if TEACHERSIDE
    //显示搜索
    
    WeakifySelf;
    [FilterAlertView showInView:self.tabBarController.view atFliterType:self.currentFliterType forFliterArray:@[@"按时间",@"按任务",@"按人"] withAtionBlock:^(NSInteger index) {
        StrongifySelf;
        strongSelf.currentFliterType = index;
        [strongSelf.currentViewController requestSearchForSorceAtIndex:index];
    }];
    
#else
    
    if(self.segmentControl.selectedIndex == 0)
    {
        CalendarViewController *vc = [[CalendarViewController alloc] initWithNibName:@"CalendarViewController" bundle:nil];
        vc.clazz = APP.currentUser.clazz;
        [vc setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        WeakifySelf;
        [FilterAlertView showInView:self.tabBarController.view atFliterType:self.currentFliterType forFliterArray:@[@"全部",@"0星",@"1星",@"2星",@"3星",@"4星",@"5星"] withAtionBlock:^(NSInteger index) {
            StrongifySelf;
            strongSelf.currentFliterType = index;
            [strongSelf.finishedClassesChildController requestSearchForSorceAtIndex:index];
        }];
    }
#endif
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

#pragma mark - Private Method

- (void)showChildPageViewControllerWithIndex:(NSUInteger)index animated:(BOOL)animated shouldLocate:(BOOL)shouldLocate {
    HomeworkSessionsViewController *childPageViewController = nil;
    BOOL existed = YES;
    
    if (index == 0) {
        if (self.unfinishedClassesChildController == nil) {
            self.unfinishedClassesChildController = [[HomeworkSessionsViewController alloc] initWithNibName:NSStringFromClass([HomeworkSessionsViewController class]) bundle:nil];
            self.unfinishedClassesChildController.isUnfinished = YES;
            self.unfinishedClassesChildController.bLoadConversion = YES;
            self.unfinishedClassesChildController.searchFliter = self.currentFliterType;
            existed = NO;
        }
        
        childPageViewController = self.unfinishedClassesChildController;
    } else if (index == 1) {
        if (self.finishedClassesChildController == nil) {
            self.finishedClassesChildController = [[HomeworkSessionsViewController alloc] initWithNibName:NSStringFromClass([HomeworkSessionsViewController class]) bundle:nil];
            self.finishedClassesChildController.isUnfinished = NO;
            self.finishedClassesChildController.bLoadConversion = NO;
            self.finishedClassesChildController.searchFliter = self.currentFliterType;
            existed = NO;
        }
        
        childPageViewController = self.finishedClassesChildController;
    }
    else
    {
#if TEACHERSIDE
        if (self.uncommitClassesChildController == nil) {
            self.uncommitClassesChildController = [[HomeworkSessionsViewController alloc] initWithNibName:NSStringFromClass([HomeworkSessionsViewController class]) bundle:nil];
            self.uncommitClassesChildController.isUnfinished = YES;
            self.uncommitClassesChildController.bLoadConversion = NO;
            self.uncommitClassesChildController.searchFliter = self.currentFliterType;
            existed = NO;
        }
        
        childPageViewController = self.uncommitClassesChildController;
#else
#endif
    }
    
    self.currentViewController = childPageViewController;
    if (!existed) {
        [self addChildViewController:childPageViewController];
        
        [self.containerView addSubview:childPageViewController.view];
        [self addContraintsWithX:index*ScreenWidth view:childPageViewController.view superView:self.containerView];
        
        [childPageViewController didMoveToParentViewController:self];
    }
    
    if (shouldLocate) {
        CGPoint offset = CGPointMake(index*ScreenWidth, 0);
        
        if (animated) {
            self.ignoreScrollCallback = YES;
            [UIView animateWithDuration:0.3
                             animations:^{
                                 [self.containerScrollView setContentOffset:offset];
                             } completion:^(BOOL finished) {
                                 self.ignoreScrollCallback = NO;
                             }];
        } else {
            // 说明：不使用dispatch_async的话viewDidLoad中直接调用[self.containerScrollView setContentOffset:offset];
            // 会导致contentoffset并未设置的问题
            dispatch_async(dispatch_get_main_queue(), ^{
                self.ignoreScrollCallback = YES;
                [self.containerScrollView setContentOffset:offset];
                self.ignoreScrollCallback = NO;
            });
        }
    }
}

- (void)addContraintsWithX:(CGFloat)offsetX view:(UIView *)view superView:(UIView *)superView {
    view.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *leadingConstraint = [NSLayoutConstraint constraintWithItem:view
                                                                         attribute:NSLayoutAttributeLeading
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:superView
                                                                         attribute:NSLayoutAttributeLeading
                                                                        multiplier:1
                                                                          constant:offsetX];
    
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:view
                                                                       attribute:NSLayoutAttributeWidth
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:nil
                                                                       attribute:NSLayoutAttributeNotAnAttribute
                                                                      multiplier:1
                                                                        constant:ScreenWidth];
    
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:view
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:superView
                                                                     attribute:NSLayoutAttributeTop
                                                                    multiplier:1
                                                                      constant:0];
    
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:view
                                                                        attribute:NSLayoutAttributeBottom
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:superView
                                                                        attribute:NSLayoutAttributeBottom
                                                                       multiplier:1
                                                                         constant:0];
    
    [superView addConstraints:@[leadingConstraint, widthConstraint, topConstraint, bottomConstraint]];
}

- (void)updateSegmentControlWithOffsetX:(CGFloat)x {
    [self.segmentControl setPersent:x / ScreenWidth];
}

- (void)updateSegmentControlWhenScrollEnded {
    [self.segmentControl setPersent:self.containerScrollView.contentOffset.x / ScreenWidth];
    
    NSInteger index = MAX(0, ceil(self.segmentControl.titles.count * self.containerScrollView.contentOffset.x / ScreenWidth) - 1);
    [self indexDidChange:index];
}

- (void)indexDidChange:(NSInteger)index {
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.ignoreScrollCallback) {
        return;
    }
    CGFloat offsetX = scrollView.contentOffset.x;
    
    NSUInteger leftIndex = (NSInteger)MAX(0, offsetX)/(NSInteger)(ScreenWidth);
    NSUInteger rightIndex = (NSInteger)MAX(0, offsetX+ScreenWidth)/(NSInteger)(ScreenWidth);
    
    [self showChildPageViewControllerWithIndex:leftIndex animated:NO shouldLocate:NO];
    if (leftIndex != rightIndex) {
        [self showChildPageViewControllerWithIndex:rightIndex animated:NO shouldLocate:NO];
    }
    
    [self updateSegmentControlWithOffsetX:offsetX];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.ignoreScrollCallback) {
        return;
    }
    
    if (!decelerate) {
        [self updateSegmentControlWhenScrollEnded];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.ignoreScrollCallback) {
        return;
    }
    
    [self updateSegmentControlWhenScrollEnded];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (self.ignoreScrollCallback) {
        return;
    }
    
    [self updateSegmentControlWhenScrollEnded];
}

@end




