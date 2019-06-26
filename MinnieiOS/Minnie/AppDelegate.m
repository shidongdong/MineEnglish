//
//  AppDelegate.m
//  X5Teacher
//
//  Created by yebw on 2017/11/5.
//  Copyright © 2017年 netease. All rights reserved.
//

#import "Clazz.h"
#import "Constants.h"
#import "IMManager.h"
#import "AuthService.h"
#import "AppDelegate.h"
#import "PushManager.h"
#import <Bugly/Bugly.h>
#import "PublicService.h"
#import "UITabBar+KSBadge.h"
#import <AVOSCloud/AVOSCloud.h>
#import "LoadViewController.h"
#import "LoginViewController.h"
//#import <Fabric/Fabric.h>
//#import <Crashlytics/Crashlytics.h>
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
#import "TeacherClassesViewController.h"
#import "HomeworkSessionsContainerViewController.h"

#endif


@interface AppDelegate ()<UITabBarControllerDelegate>

@property (nonatomic, strong) NSDate *enterBackgroundDate;
@property(nonatomic,strong)NSDate * lastSelectedDate;

@property (nonatomic ,strong)NSDictionary * handleLaunchDict;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.handleLaunchDict = launchOptions;
    
    [Bugly startWithAppId:@"f82097cc09"];
    [self setupLeanCloudServer];
    [AVOSCloud setApplicationId:kAVOSCloudApplicationId clientKey:kAVOSCloudClientKey];
    //正式版
//    [AVOSCloud setApplicationId:@"pe0Om2fpgh5oHCd0NfSUbwkT-gzGzoHsz" clientKey:@"gfJuGSytpQalwcnAmNtunRoP"];
    //开发版
//    [AVOSCloud setApplicationId:@"JE1gHMgc1MJaTRCPFcz30F9E-gzGzoHsz" clientKey:@"Axlm6WN8mJ7j1ivtGjgHxGqb"];
    [AVOSCloud setAllLogsEnabled:YES];
    [AVIMClient setUnreadNotificationEnabled:YES];
    if (@available(iOS 11.0, *)) {
        UITableView.appearance.estimatedRowHeight = 0;
        UITableView.appearance.estimatedSectionFooterHeight = 0;
        UITableView.appearance.estimatedSectionHeaderHeight = 0;
    }
    
    //设置屏幕常亮不自动锁屏
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginDidSuccess:)
                                                 name:kNotificationKeyOfLoginSuccess
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(clientDidKickOut:)
                                                 name:kIMManagerClientDidKickOutReceiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(clientDidKickOut:)
                                                 name:kNotificationKeyOfAuthForbidden
                                               object:nil];
    
#if TEACHERSIDE | MANAGERSIDE
#else
    // 学生端老师批改作业后，刷新个人页面
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshUserInfo:)
                                                 name:kNotificationKeyOfCorrectHomework
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshUserInfo:)
                                                 name:kNotificationKeyOfRedoHomework
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshUserInfo:)
                                                 name:kNotificationKeyOfDeleteHomeworkTask
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshUserInfo:)
                                                 name:kNotificationKeyOfCommitHomework
                                               object:nil];
#endif
    return YES;
}

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


- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
    // 确保当前在首页界面
    if ([viewController isEqual:[tabBarController.viewControllers firstObject]]) {
        // ! 即将选中的页面是之前上一次选中的控制器页面
        if (![viewController isEqual:tabBarController.selectedViewController]) {
            return YES;
        }
        
        // 获取当前点击时间
        NSDate *currentDate = [NSDate date];
        CGFloat timeInterval = currentDate.timeIntervalSince1970 - _lastSelectedDate.timeIntervalSince1970;
        
        // 两次点击时间间隔少于 0.5S 视为一次双击
        if (timeInterval < 0.5) {
            // 通知首页刷新数据
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationKeyOfTabBarDoubleClick object:nil];
            
            // 双击之后将上次选中时间置为1970年0点0时0分0秒,用以避免连续三次或多次点击
            _lastSelectedDate = [NSDate dateWithTimeIntervalSince1970:0];
            return NO;
        }
        // 若是单击将当前点击时间复制给上一次单击时间
        _lastSelectedDate = currentDate;
        
    }
    else if ([viewController isEqual:[tabBarController.viewControllers objectAtIndex:1]])
    {
        [self showTabBarBadgeNum:0 atIndex:1];
    }
    
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    self.enterBackgroundDate = [NSDate date];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSInteger num = application.applicationIconBadgeNumber;
    if (num != 0){
        AVInstallation *currentInstallation = [AVInstallation defaultInstallation];
        [currentInstallation setBadge:0];
        [currentInstallation saveEventually];
        application.applicationIconBadgeNumber=0;
    }
    
    if (self.enterBackgroundDate == nil) {
        return;
    }
    
    if ([[NSDate date] timeIntervalSinceDate:self.enterBackgroundDate] > 30.f) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationKeyOfRefreshHomeworkSession object:nil];
    }
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    //保存token
    APP.deviceToken = deviceToken;
    [AVOSCloud handleRemoteNotificationsWithDeviceToken:deviceToken constructingInstallationWithBlock:^(AVInstallation * _Nonnull currentInstallation) {

    }];
}

#pragma mark - public
- (void)showTabBarBadgeNum:(NSInteger)badge atIndex:(NSInteger)index;
{
    
#if TEACHERSIDE
#else
    // 同学圈不显示小红点
    if (index == 1) {
        return;
    }
#endif

    UIViewController * rootVc = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    if ([rootVc isKindOfClass:[UITabBarController class]])
    {
        UITabBarController * tabbarVc = (UITabBarController *)rootVc;
        [tabbarVc.tabBar showBadgeOnItemIndex:index totalTabbarCount:3 withInfo:badge];
    }
}

- (void)openRemoteNotification
{
    AVInstallation *currentInstallation = [AVInstallation defaultInstallation];
#if TEACHERSIDE | MANAGERSIDE
    currentInstallation.deviceProfile = @"teacher_pro";
    if (APP.currentUser.authority == TeacherAuthoritySuperManager) {
        [currentInstallation addUniqueObject:@"SuperManager" forKey:@"channels"];
    }
#else
    currentInstallation.deviceProfile = @"student_pro";
    Clazz *clazz = APP.currentUser.clazz;
    [currentInstallation addUniqueObject:[NSString stringWithFormat:@"class_%@", @(clazz.classId)] forKey:@"channels"];
#endif
//    [currentInstallation addObject:[NSString stringWithFormat:@"%@", @(APP.currentUser.userId)] forKey:@"userId"];
    [currentInstallation setObject:[NSString stringWithFormat:@"%@", @(APP.currentUser.userId)] forKey:@"userId"];
    [currentInstallation saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        
    }];
}

- (void)removeRemoteNotification
{
    AVInstallation *currentInstallation = [AVInstallation defaultInstallation];
#if TEACHERSIDE | MANAGERSIDE
    currentInstallation.deviceProfile = @"teacher_pro";
    
    if (APP.currentUser.authority == TeacherAuthoritySuperManager) {
        [currentInstallation removeObject:@"SuperManager" forKey:@"channels"];
    }
#else
    currentInstallation.deviceProfile = @"student_pro";
    Clazz *clazz = APP.currentUser.clazz;
    [currentInstallation removeObject:[NSString stringWithFormat:@"class_%@", @(clazz.classId)] forKey:@"channels"];
#endif
//    [currentInstallation removeObject:[NSString stringWithFormat:@"%@", @(APP.currentUser.userId)] forKey:@"userId"];
    [currentInstallation removeObjectForKey:@"userId"];
    
    [currentInstallation saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        
    }];
}

#pragma mark - system
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"%@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
   // NSDictionary * apsDict = [userInfo objectForKey:@"aps"];
    PushManagerType type = (PushManagerType)[[userInfo objectForKey:@"pushType"] integerValue];
    [self handleNotiForPushType:type];
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

#if MANAGERSIDE

#else

#pragma mark - 不支持横屏
//是否支持屏幕旋转
- (BOOL)shouldAutorotate{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    return UIInterfaceOrientationMaskPortrait;
}

#endif

- (void)setupLeanCloudServer{
    
    // 配置 SDK 储存
    [AVOSCloud setServerURLString:@"https://avoscloud.com" forServiceModule:AVServiceModuleAPI];
    // 配置 SDK 推送
    [AVOSCloud setServerURLString:@"https://avoscloud.com" forServiceModule:AVServiceModulePush];
    // 配置 SDK 云引擎
    [AVOSCloud setServerURLString:@"https://avoscloud.com" forServiceModule:AVServiceModuleEngine];
    // 配置 SDK 即时通讯
    [AVOSCloud setServerURLString:@"https://router-g0-push.avoscloud.com" forServiceModule:AVServiceModuleRTM];
}

@end


