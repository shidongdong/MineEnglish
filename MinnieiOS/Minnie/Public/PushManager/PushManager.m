//
//  PushManager.m
//  AVFileDemo
//
//  Created by yebw on 2018/4/10.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "PushManager.h"
#import <AVOSCloud/AVOSCloud.h>

@implementation PushManager

+ (void)pushText:(NSString *)text {
    [PushManager pushText:text date:nil];
}

+ (void)pushText:(NSString *)text date:(NSDate *)date  {
    AVPush *push = [[AVPush alloc] init];
    
    if (date != nil) {
        [push setPushDate:date];
    }
    
    [push setData:@{@"alert":text, @"badge":@"Increment"}];
    [push sendPushInBackground];
}

+ (void)pushText:(NSString *)text toClasses:(NSArray<NSNumber *> *)classIds {
    [PushManager pushText:text toClasses:classIds date:nil];
}

+ (void)pushText:(NSString *)text toClasses:(NSArray<NSNumber *> *)classIds date:(NSDate *)date {
    if (text.length == 0 || classIds.count == 0) {
        return ;
    }
    
    AVPush *push = [[AVPush alloc] init];
    NSMutableArray *channels = [NSMutableArray array];
    for (NSNumber *classId in classIds) {
        [channels addObject:[NSString stringWithFormat:@"class_%@", classId]];
    }

    [push setChannels:channels];
    
    if (date != nil) {
        [push setPushDate:date];
    }
    
    [push setData:@{@"alert":text, @"badge":@"Increment"}];
    [push sendPushInBackground];
}

+ (void)pushText:(NSString *)text toUsers:(NSArray<NSNumber *> *)userIds {
    [PushManager pushText:text toUsers:userIds date:nil];
}

+ (void)pushText:(NSString *)text toUsers:(NSArray<NSNumber *> *)userIds date:(NSDate *)date {
    if (text.length == 0) {
        return ;
    }
    
    AVPush *push = [[AVPush alloc] init];
    
    NSMutableArray *channels = [NSMutableArray array];
    for (NSNumber *userId in userIds) {
        [channels addObject:[NSString stringWithFormat:@"%@", userId]];
    }
    
    [push setChannels:channels];
    
    if (date != nil) {
        [push setPushDate:date];
    }
    
    [push setData:@{@"alert":text, @"badge":@"Increment"}];
    [push sendPushInBackground];
}

+ (void)pushText:(NSString *)text toUsers:(NSArray<NSNumber *> *)userIds withPushType:(PushManagerType)type
{
    if (text.length == 0) {
        return ;
    }
    
    AVPush *push = [[AVPush alloc] init];
    
    NSMutableArray *channels = [NSMutableArray array];
    for (NSNumber *userId in userIds) {
        [channels addObject:[NSString stringWithFormat:@"%@", userId]];
    }
    
    [push setChannels:channels];
    [push setData:@{@"alert":text, @"badge":@"Increment",@"pushType" :@(type),@"action":@"com.minine.push",@"custom-key":@(type)}];
    [push sendPushInBackground];
}

// 给老师和一些channel发送推送
+ (void)pushText:(NSString *)text toUsers:(NSArray<NSNumber *> *)userIds addChannels:(NSArray <NSString *> *)cs {
    if (text.length == 0) {
        return ;
    }

    AVPush *push = [[AVPush alloc] init];
    
    NSMutableArray *channels = [NSMutableArray array];
    for (NSNumber *userId in userIds) {
        [channels addObject:[NSString stringWithFormat:@"%@", userId]];
    }
    
    for (NSString *c in cs) {
        [channels addObject:c];
    }
    
    [push setChannels:channels];
    
    [push setData:@{@"alert":text, @"badge":@"Increment"}];
    [push sendPushInBackground];
}

@end

