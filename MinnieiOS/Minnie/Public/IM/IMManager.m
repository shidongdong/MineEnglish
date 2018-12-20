//
//  IMManager.m
//  MU
//
//  Created by yebw on 2018/3/7.
//  Copyright © 2018年 mfox. All rights reserved.
//

#import "IMManager.h"
#import "HUD.h"

NSString * const kIMManagerContentMessageDidReceiveNotification = @"kIMManagerContentMessageDidReceiveNotification";
NSString * const kIMManagerContentMessageDidSendNotification = @"kIMManagerContentMessageDidSendNotification";
NSString * const kIMManagerClientDidKickOutReceiveNotification = @"kIMManagerClientDidKickOutReceiveNotification";
NSString * const kIMManagerClientUnReadMessageCountNotification = @"kIMManagerClientUnReadMessageCountNotification";  //未读消息个数通知
NSString * const kIMManagerClientOfflineNotification = @"kIMManagerClientOfflineNotification";
NSString * const kIMManagerClientOnlineNotification = @"kIMManagerClientOnlineNotification";

@interface IMManager()

@end

@implementation IMManager

+ (instancetype)sharedManager {
    static IMManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[IMManager alloc] init];
    });
    
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        
    }
    
    return self;
}

- (void)setupWithClientId:(NSString *)cliendId
                 callback:(AVIMBooleanResultBlock)callback {
    self.client = [[AVIMClient alloc] initWithClientId:cliendId tag:@"uniq"];
    self.client.delegate = self;
    
    [self.client openWithOption:AVIMClientOpenOptionForceOpen
                       callback:^(BOOL succeeded, NSError * _Nullable error) {
                           if (callback != nil) {
                               callback(succeeded, error);
                           }

                           if (succeeded) {
                               [[NSNotificationCenter defaultCenter] postNotificationName:kIMManagerClientOnlineNotification object:nil];
                           } else {
//                               [HUD showErrorWithMessage:@"网络连接失败，请检查网络"];
                               [[NSNotificationCenter defaultCenter] postNotificationName:kIMManagerClientOfflineNotification object:nil];
                           }
                       }];
}

- (void)logout {
    [self.client closeWithCallback:^(BOOL success, NSError * error) {
    }];
}

#pragma mark -

- (void)messageDidReceive:(AVIMTypedMessage *)message {
    [[NSNotificationCenter defaultCenter] postNotificationName:kIMManagerContentMessageDidReceiveNotification
                                                        object:nil
                                                      userInfo:@{@"message": message}];
}

- (void)messageDidUpdate:(AVIMTypedMessage *)message {
    
}

#pragma mark -

- (void)imClientPaused:(AVIMClient *)imClient {
    NSLog(@"%s", __func__);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kIMManagerClientOfflineNotification object:nil];
}

- (void)imClientResuming:(AVIMClient *)imClient {
    NSLog(@"%s", __func__);
}

- (void)imClientResumed:(AVIMClient *)imClient {
    NSLog(@"%s", __func__);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kIMManagerClientOnlineNotification object:nil];
}

- (void)conversation:(AVIMConversation *)conversation
didReceiveTypedMessage:(AVIMTypedMessage *)message {
    [self messageDidReceive:message];
}

- (void)conversation:(AVIMConversation *)conversation
    messageDelivered:(AVIMMessage *)message {
    NSLog(@"%s", __func__);
}

- (void)conversation:(AVIMConversation *)conversation
     didUpdateForKey:(NSString *)key {
    //目前只处理未读消息的key
    /* 有未读消息产生，请更新 UI，或者拉取对话。 */
        
#if TEACHERSIDE
#else
    if ([key isEqualToString:@"unreadMessagesCount"]) {
        //超过7天的作业直接不处理
        
        NSDate * date = [NSDate date];
        NSTimeZone *zone = [NSTimeZone systemTimeZone];
        NSInteger interval = [zone secondsFromGMTForDate:date];
        NSDate *localDate = [date dateByAddingTimeInterval:interval];
        
        interval = [zone secondsFromGMTForDate:conversation.createAt];
        NSDate * zoneCreateDate = [conversation.createAt dateByAddingTimeInterval:interval];
        NSUInteger countSecs = [localDate timeIntervalSinceDate:zoneCreateDate];
        
        if (countSecs > 7 * 24 * 3600)
        {
            return;
        }
        
        NSUInteger unreadMessagesCount = conversation.unreadMessagesCount;
        [[NSNotificationCenter defaultCenter] postNotificationName:kIMManagerClientUnReadMessageCountNotification
                                                            object:nil
                                                          userInfo:@{@"unReadCount": @(unreadMessagesCount),@"homeworkSessionId":@([conversation.name integerValue])}];
    }
        
#endif
    
        
        
    
}

- (void)client:(AVIMClient *)client
didOfflineWithError:(NSError *)error {
    if (error.code == 4111) { // 被人踢出来了，应用退出
        NSLog(@"被人踢出来了，应用退出");

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [HUD showErrorWithMessage:@"你的帐号在别处登录"];
        });
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kIMManagerClientDidKickOutReceiveNotification
                                                            object:nil];
    }
}

- (void)imClientClosed:(nonnull AVIMClient *)imClient
                 error:(NSError * _Nullable)error {
}

#pragma mark - AVIMConversationDelegate

- (void)conversation:(AVIMConversation *)conversation
messageHasBeenUpdated:(AVIMMessage *)message {
    [self messageDidUpdate:(AVIMTypedMessage *)message];
}

@end


