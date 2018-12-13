//
//  IMManager.h
//  MU
//
//  Created by yebw on 2018/3/7.
//  Copyright © 2018年 mfox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVOSCloudIM/AVOSCloudIM.h>

extern NSString * const kIMManagerContentMessageDidReceiveNotification;
extern NSString * const kIMManagerContentMessageDidSendNotification;
extern NSString * const kIMManagerClientDidKickOutReceiveNotification;
extern NSString * const kIMManagerClientUnReadMessageCountNotification;
extern NSString * const kIMManagerClientOfflineNotification;
extern NSString * const kIMManagerClientOnlineNotification;

@interface IMManager : NSObject<AVIMClientDelegate>

@property (strong, nonatomic) AVIMClient *client;

#pragma mark - 单例

+ (instancetype)sharedManager;

#pragma mark - 初始化

- (void)setupWithClientId:(NSString *)cliendId
                 callback:(AVIMBooleanResultBlock)callback;

- (void)logout;

@end

