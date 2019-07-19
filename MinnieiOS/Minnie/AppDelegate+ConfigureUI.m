//
//  AppDelegate+ConfigureUI.m
//  Minnie
//
//  Created by songzhen on 2019/7/18.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import <Bugly/Bugly.h>
#import "IMManager.h"
#import "AppDelegate.h"
#import "PublicService.h"
#import "ManagerServce.h"
#import "AppDelegate+ConfigureUI.h"
#import "LoginViewController.h"
#import "PortraitNavigationController.h"

#if TEACHERSIDE

#import "PortraitTabBarController.h"
#import "TeacherAccountViewController.h"
#import "TeacherClassesViewController.h"
#import "HomeworkSessionsContainerViewController.h"

#elif MANAGERSIDE

#import "MIStockSplitViewController.h"

#else

#import "GuideViewController.h"
#import "PortraitTabBarController.h"
#import "TrialClassViewController.h"
#import "CircleContainerController.h"
#import "StudentAccountViewController.h"
#import "HomeworkSessionsContainerViewController.h"

#endif

@implementation AppDelegate (ConfigureUI)

#if TEACHERSIDE

- (void)toHome {
    
    UIColor *normalTitleColor = [UIColor colorWithHex:0x999999];
    UIColor *selectedTitleColor = [UIColor colorWithHex:0x0098FE];
    UIFont *font = [UIFont systemFontOfSize:10.f];
    NSDictionary *normalTitleAttributes = @{NSForegroundColorAttributeName: normalTitleColor,
                                            NSFontAttributeName: font};
    NSDictionary *selectedTitleAttributes = @{NSForegroundColorAttributeName: selectedTitleColor,
                                              NSFontAttributeName: font};
    
    HomeworkSessionsContainerViewController *tasksVC = [[HomeworkSessionsContainerViewController alloc] initWithNibName:NSStringFromClass([HomeworkSessionsContainerViewController class]) bundle:nil];
    UINavigationController *tasksNC = [[UINavigationController alloc] initWithRootViewController:tasksVC];
    [tasksNC setNavigationBarHidden:YES];
    UITabBarItem *tasksItem = [[UITabBarItem alloc] initWithTitle:@"消息"
                                                            image:[[UIImage imageNamed:@"buttonbar_correcting_unsel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                    selectedImage:[[UIImage imageNamed:@"buttonbar_correcting_active"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tasksItem setTitleTextAttributes:normalTitleAttributes forState:UIControlStateNormal];
    [tasksItem setTitleTextAttributes:selectedTitleAttributes forState:UIControlStateSelected];
    tasksNC.tabBarItem = tasksItem;
    
    
    TeacherClassesViewController *classesVC = [[TeacherClassesViewController alloc] initWithNibName:NSStringFromClass([TeacherClassesViewController class]) bundle:nil];
    UINavigationController *classesNC = [[UINavigationController alloc] initWithRootViewController:classesVC];
    [classesNC setNavigationBarHidden:YES];
    UITabBarItem *classesItem = [[UITabBarItem alloc] initWithTitle:@"班级"
                                                              image:[[UIImage imageNamed:@"buttonbar_class_manager_unsel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                      selectedImage:[[UIImage imageNamed:@"buttonbar_class_manager_active"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [classesItem setTitleTextAttributes:normalTitleAttributes forState:UIControlStateNormal];
    [classesItem setTitleTextAttributes:selectedTitleAttributes forState:UIControlStateSelected];
    classesNC.tabBarItem = classesItem;
    
    TeacherAccountViewController *accountVC = [[TeacherAccountViewController alloc] initWithNibName:NSStringFromClass([TeacherAccountViewController class]) bundle:nil];
    
    UINavigationController *accountNC = [[UINavigationController alloc] initWithRootViewController:accountVC];
    [accountNC setNavigationBarHidden:YES];
    UITabBarItem *accountItem = [[UITabBarItem alloc] initWithTitle:@"我的"
                                                              image:[[UIImage imageNamed:@"buttonbar_my_unsel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                      selectedImage:[[UIImage imageNamed:@"buttonbar_my_active"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [accountItem setTitleTextAttributes:normalTitleAttributes forState:UIControlStateNormal];
    [accountItem setTitleTextAttributes:selectedTitleAttributes forState:UIControlStateSelected];
    accountNC.tabBarItem = accountItem;
    
    PortraitTabBarController *tbBarController = [[PortraitTabBarController alloc] init];
    tbBarController.viewControllers = @[tasksNC, /*homeworksNC,*/ classesNC, accountNC];
    tbBarController.delegate = self;
    [UIApplication sharedApplication].keyWindow.rootViewController = tbBarController;
    
    if (self.handleLaunchDict)
    {
        NSDictionary * pushDict =  [self.handleLaunchDict objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        
        if (pushDict)
        {
            PushManagerType type = (PushManagerType)[[pushDict objectForKey:@"pushType"] integerValue];
            [self handleNotiForPushType:type];
        }
    }
}

#elif MANAGERSIDE
- (void)toHome {
    
    MIStockSplitViewController *splitView = [[MIStockSplitViewController alloc] init];
    [UIApplication sharedApplication].keyWindow.rootViewController = splitView;
}
#else

- (void)toHome {
    
    //新版本引导页
    if (!APP.userGuide)
    {
        GuideViewController * guideVc = [[GuideViewController alloc] init];
        [self.window setRootViewController:guideVc];
        return;
    }
    
    UIColor *normalTitleColor = [UIColor colorWithHex:0x999999];
    UIColor *selectedTitleColor = [UIColor colorWithHex:0x0098FE];
    UIFont *font = [UIFont systemFontOfSize:10.f];
    NSDictionary *normalTitleAttributes = @{NSForegroundColorAttributeName: normalTitleColor,
                                            NSFontAttributeName: font};
    NSDictionary *selectedTitleAttributes = @{NSForegroundColorAttributeName: selectedTitleColor,
                                              NSFontAttributeName: font};
    
    HomeworkSessionsContainerViewController *tasksVC = [[HomeworkSessionsContainerViewController alloc] initWithNibName:NSStringFromClass([HomeworkSessionsContainerViewController class]) bundle:nil];
    UINavigationController *tasksNC = [[UINavigationController alloc] initWithRootViewController:tasksVC];
    [tasksNC setNavigationBarHidden:YES];
    UITabBarItem *tasksItem = [[UITabBarItem alloc] initWithTitle:@"作业"
                                                            image:[[UIImage imageNamed:@"buttonbar_mission_unsel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                    selectedImage:[[UIImage imageNamed:@"buttonbar_mission_active"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tasksItem setTitleTextAttributes:normalTitleAttributes forState:UIControlStateNormal];
    [tasksItem setTitleTextAttributes:selectedTitleAttributes forState:UIControlStateSelected];
    tasksNC.tabBarItem = tasksItem;
    
    CircleContainerController *classmateVC = [[CircleContainerController alloc] initWithNibName:NSStringFromClass([CircleContainerController class]) bundle:nil];
    
    UINavigationController *classmateNC = [[UINavigationController alloc] initWithRootViewController:classmateVC];
    [classmateNC setNavigationBarHidden:YES];
    UITabBarItem *classmateItem = [[UITabBarItem alloc] initWithTitle:@"同学圈"
                                                                image:[[UIImage imageNamed:@"buttonbar_class_unsel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                        selectedImage:[[UIImage imageNamed:@"buttonbar_class_active"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [classmateItem setTitleTextAttributes:normalTitleAttributes forState:UIControlStateNormal];
    [classmateItem setTitleTextAttributes:selectedTitleAttributes forState:UIControlStateSelected];
    classmateNC.tabBarItem = classmateItem;
    
    StudentAccountViewController *accountVC = [[StudentAccountViewController alloc] initWithNibName:NSStringFromClass([StudentAccountViewController class]) bundle:nil];
    
    UINavigationController *accountNC = [[UINavigationController alloc] initWithRootViewController:accountVC];
    [accountNC setNavigationBarHidden:YES];
    UITabBarItem *accountItem = [[UITabBarItem alloc] initWithTitle:@"我的"
                                                              image:[[UIImage imageNamed:@"buttonbar_my_unsel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                      selectedImage:[[UIImage imageNamed:@"buttonbar_my_active"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [accountItem setTitleTextAttributes:normalTitleAttributes forState:UIControlStateNormal];
    [accountItem setTitleTextAttributes:selectedTitleAttributes forState:UIControlStateSelected];
    accountNC.tabBarItem = accountItem;
    
    PortraitTabBarController *tbBarController = [[PortraitTabBarController alloc] init];
    tbBarController.viewControllers = @[tasksNC, classmateNC, accountNC];
    tbBarController.delegate = self;
    [UIApplication sharedApplication].keyWindow.rootViewController = tbBarController;
}

#endif


- (void)loginDidSuccess:(NSNotification *)notification {
    BOOL shouldToHome = YES;
#if TEACHERSIDE
    Teacher *teacher = (Teacher *)(APP.currentUser);
    [Bugly setUserIdentifier:teacher.nickname];
#elif MANAGERSIDE
    Teacher *teacher = (Teacher *)(APP.currentUser);
    [Bugly setUserIdentifier:teacher.nickname];
#else
    Student *userInfo = (Student *)(APP.currentUser);
    [Bugly setUserIdentifier:userInfo.nickname];
    if (userInfo.clazz.classId==0 || userInfo.enrollState==1) {
        shouldToHome = NO;
    }
    
    TrialClassViewController *clzzVC = [[TrialClassViewController alloc] initWithNibName:NSStringFromClass([TrialClassViewController class]) bundle:nil];
    
    [self.window setRootViewController:clzzVC];
#endif
    
    if (shouldToHome) {
        [self toHome];
    }
}

- (void)clientDidKickOut:(NSNotification *)notification {
    if (APP.currentUser == nil) {
        return;
    }
    
    [[IMManager sharedManager] logout];
    APP.currentUser = nil;
    //新增 by shidongdong
    [self removeRemoteNotification];
    NSString *nibName = nil;
#if TEACHERSIDE
    nibName = @"LoginViewController_Teacher";
    
#elif MANAGERSIDE
    nibName = @"LoginViewController_Teacher";
#else
    nibName = @"LoginViewController_Student";
#endif
    LoginViewController *loginVC = [[LoginViewController alloc] initWithNibName:nibName bundle:nil];
    
    PortraitNavigationController *loginNC = [[PortraitNavigationController alloc] initWithRootViewController:loginVC];
    self.window.rootViewController = loginNC;
}

- (void)handleNotiForPushType:(PushManagerType)type
{
#if TEACHERSIDE | MANAGERSIDE
#else
    if ([self.window.rootViewController isKindOfClass:[PortraitTabBarController class]])
    {
        if (type == PushManagerMessage)
        {
            PortraitTabBarController * rootTabVc = (PortraitTabBarController *)self.window.rootViewController;
            rootTabVc.selectedIndex = 0;
        }
        else if (type == PushManagerCircle)
        {
            PortraitTabBarController * rootTabVc = (PortraitTabBarController *)self.window.rootViewController;
            rootTabVc.selectedIndex = 1;
        }
    }
#endif
}

#pragma mark - UITabBarControllerDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
    // 确保当前在首页界面
    if ([viewController isEqual:[tabBarController.viewControllers firstObject]]) {
        // ! 即将选中的页面是之前上一次选中的控制器页面
        if (![viewController isEqual:tabBarController.selectedViewController]) {
            return YES;
        }
        
        // 获取当前点击时间
        NSDate *currentDate = [NSDate date];
        CGFloat timeInterval = currentDate.timeIntervalSince1970 - self.lastSelectedDate.timeIntervalSince1970;
        
        // 两次点击时间间隔少于 0.5S 视为一次双击
        if (timeInterval < 0.5) {
            // 通知首页刷新数据
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationKeyOfTabBarDoubleClick object:nil];
            
            // 双击之后将上次选中时间置为1970年0点0时0分0秒,用以避免连续三次或多次点击
            self.lastSelectedDate = [NSDate dateWithTimeIntervalSince1970:0];
            return NO;
        }
        // 若是单击将当前点击时间复制给上一次单击时间
        self.lastSelectedDate = currentDate;
        
    }
    else if ([viewController isEqual:[tabBarController.viewControllers objectAtIndex:1]])
    {
        [self showTabBarBadgeNum:0 atIndex:1];
    }
    
    return YES;
}

#pragma mark - 更新用户信息
- (void)refreshUserInfo:(NSNotification *)notification {
    NSInteger userId = APP.currentUser.userId;
    if (userId == 0) {
        return;
    }
    
    [PublicService requestUserInfoWithId:userId
                                callback:^(Result *result, NSError *error) {
                                    if (error == nil) {
#if TEACHERSIDE | MANAGERSIDE
                                        Teacher *userInfo = (Teacher *)(result.userInfo);
#else
                                        Student *userInfo = (Student *)(result.userInfo);
                                        
#endif
                                        userInfo.token = APP.currentUser.token;
                                        APP.currentUser = userInfo;
                                        
                                        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationKeyOfProfileUpdated
                                                                                            object:nil];
                                    }
                                }];
}

#pragma mark - 上下线
- (void)refreshOnlineState:(BOOL)online times:(NSInteger)times{
    
    [ManagerServce requestUpdateOnlineState:online
                                      times:times
                                   callback:^(Result *result, NSError *error) {
        if (error) return ;
        NSLog(@"更新在线状态成功");
    }];
}

@end
