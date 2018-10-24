//
//  AudioPlayer.h
//  X5Teacher
//
//  Created by yebw on 2018/3/27.
//  Copyright © 2018年 netease. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kNotificationOfAudioPlayerStateDidChange;

typedef NS_ENUM(NSInteger, AudioPlayerState) {
    AudioPlayerStop = 0,
    AudioPlayerPlaying = 1,
};

@interface AudioPlayer : NSObject

@property (nonatomic, readonly) NSURL *currentURL;
@property (nonatomic, readonly) AudioPlayerState state;

+ (instancetype)sharedPlayer;

- (void)playURL:(NSURL *)url;

- (void)stop;

@end



