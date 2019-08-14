//
//  SendAudioManager.h
//  MinnieStudent
//
//  Created by songzhen on 2019/4/29.
//  Copyright © 2019 minnieedu. All rights reserved.
// 发送消息声音

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^FinishedBlock)(void);

typedef void(^StatusBlock)(AVPlayerItemStatus status);

typedef void(^ProgressBlock)(CGFloat time, CGFloat duration);


@interface AudioPlayerManager : NSObject


@property (nonatomic,copy) StatusBlock statusBlock;

@property (nonatomic,copy) FinishedBlock finishedBlock;

@property (nonatomic,copy) ProgressBlock progressBlock;


@property (nonatomic, assign) CGFloat current;

@property (nonatomic, assign) CGFloat duration;


/*
 * 播放、暂停
 */
- (void)play:(BOOL)play;


/*
 * 快进、退
 */
- (void)seekToTime:(NSInteger)time;



- (instancetype)initWithUrl:(NSString *)url;


- (void)resetCurrentPlayer;

@end

NS_ASSUME_NONNULL_END
