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
@interface HomeworkSessionsContainerViewController ()

@property (nonatomic, strong) HomeworkSessionsViewController *unfinishedClassesChildController;
@property (nonatomic, strong) HomeworkSessionsViewController *finishedClassesChildController;

@property (nonatomic, assign) BOOL ignoreScrollCallback;

@property (nonatomic, weak) IBOutlet UIView *containerView;
@property (nonatomic, weak) IBOutlet UIScrollView *containerScrollView;
@property (nonatomic, weak) IBOutlet UIView *customTitleView;
@property (nonatomic, weak) IBOutlet UIButton *calendarButton;
@property (nonatomic, weak) SegmentControl *segmentControl;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *heightLayoutConstraint;

@property (nonatomic, assign) BOOL everAppeared;

@end

@implementation HomeworkSessionsContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self checkAppVersion];
#if TEACHERSIDE
    self.calendarButton.hidden = YES;
#else
#endif
    
    if (isIPhoneX) {
        self.heightLayoutConstraint.constant = -(44 + [UIApplication sharedApplication].statusBarFrame.size.height);
    }
    
    self.segmentControl = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SegmentControl class]) owner:nil options:nil] lastObject];
#if TEACHERSIDE
    self.segmentControl.titles = @[@"待批改", @"已完成"];
#else
    self.segmentControl.titles = @[@"未完成", @"已完成"];
#endif
    self.segmentControl.selectedIndex = 0;
    
    __weak HomeworkSessionsContainerViewController *weakSelf = self;
    self.segmentControl.indexChangeHandler = ^(NSUInteger selectedIndex) {
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

- (IBAction)calendarButtonPressed:(id)sender {
#if TEACHERSIDE
#else
    CalendarViewController *vc = [[CalendarViewController alloc] initWithNibName:@"CalendarViewController" bundle:nil];
    vc.clazz = APP.currentUser.clazz;
    [vc setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:vc animated:YES];
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
            existed = NO;
        }
        
        childPageViewController = self.unfinishedClassesChildController;
    } else if (index == 1) {
        if (self.finishedClassesChildController == nil) {
            self.finishedClassesChildController = [[HomeworkSessionsViewController alloc] initWithNibName:NSStringFromClass([HomeworkSessionsViewController class]) bundle:nil];
            self.finishedClassesChildController.isUnfinished = NO;
            
            existed = NO;
        }
        
        childPageViewController = self.finishedClassesChildController;
    }
    
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
    
    NSInteger index = MAX(0, ceil(2 * self.containerScrollView.contentOffset.x / ScreenWidth) - 1);
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




