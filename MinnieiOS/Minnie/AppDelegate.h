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

- (void)toHome;

//订阅推送
- (void)openRemoteNotification;

//取消订阅推送
- (void)removeRemoteNotification;

@end

