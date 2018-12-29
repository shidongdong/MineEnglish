//
//  PushManager.h
//  AVFileDemo
//
//  Created by yebw on 2018/4/10.
//  Copyright © 2018年 netease. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PushManagerType) {
    PushManagerUnknow = 0, // 目前这块消息划分不是很细，待后期优化
    PushManagerMessage = 1, // 消息相关
    PushManagerHomework = 2, // 作业相关
    PushManagerCircle = 3, // 朋友圈相关
};

@interface PushManager : NSObject

// 给所有活跃的客户端发送消息
+ (void)pushText:(NSString *)text;

// 给所有活跃的客户端发送消息
+ (void)pushText:(NSString *)text date:(NSDate *)date;

// 给某些班级发消息
+ (void)pushText:(NSString *)text toClasses:(NSArray<NSNumber *> *)classIds;

// 给某些班级发消息
+ (void)pushText:(NSString *)text toClasses:(NSArray<NSNumber *> *)classIds date:(NSDate *)date;

// 给某些用户发消息
+ (void)pushText:(NSString *)text toUsers:(NSArray<NSNumber *> *)userIds;

// 给某些用户发消息 并且携带类型
+ (void)pushText:(NSString *)text toUsers:(NSArray<NSNumber *> *)userIds withPushType:(PushManagerType)type;

// 给某些用户发消息
+ (void)pushText:(NSString *)text toUsers:(NSArray<NSNumber *> *)userIds date:(NSDate *)date;

// 给某些教师和一些channel发推送消息
+ (void)pushText:(NSString *)text toUsers:(NSArray<NSNumber *> *)userIds addChannels:(NSArray <NSString *> *)channels;

@end
