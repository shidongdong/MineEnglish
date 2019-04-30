//
//  SendAudioManager.h
//  MinnieStudent
//
//  Created by songzhen on 2019/4/29.
//  Copyright © 2019 minnieedu. All rights reserved.
// 发送消息声音

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SendAudioManager : NSObject

+ (instancetype)manager;

/*
 * 播放发送消息语言语音
 */
- (void)play;

/*
 * 停止播放
 */
- (void)stop;



@end

NS_ASSUME_NONNULL_END
