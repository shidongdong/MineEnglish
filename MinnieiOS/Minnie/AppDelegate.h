//
//  AppDelegate.h
//  X5Teacher
//
//  Created by yebw on 2017/11/5.
//  Copyright © 2017年 netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic ,strong)NSDictionary * handleLaunchDict;
@property(nonatomic,strong)NSDate * lastSelectedDate;

@property(nonatomic,assign) CFAbsoluteTime onlineStartTime;

//订阅推送
- (void)openRemoteNotification;

//取消订阅推送
- (void)removeRemoteNotification;

//显示小红点
- (void)showTabBarBadgeNum:(NSInteger)badge atIndex:(NSInteger)index;

@end

