//
//  SendAudioManager.m
//  MinnieStudent
//
//  Created by songzhen on 2019/4/29.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import "SendAudioManager.h"
#import <AVFoundation/AVFoundation.h>

@interface SendAudioManager ()
@property (nonatomic,retain) AVPlayer *audioPlayer;
@property (nonatomic, strong) AVPlayerItem *playerItem;

@end



@implementation SendAudioManager

+ (instancetype)manager{
    
    static SendAudioManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[SendAudioManager alloc] init];
    });
    return manager;
}

- (void)play{
    
    NSString *soundName = @"sendMessage";
    NSString *path = [[NSBundle mainBundle] pathForResource:soundName ofType:@"mp3"];
    self.playerItem = [[AVPlayerItem alloc]initWithURL:[NSURL fileURLWithPath:path]];
    self.audioPlayer = [AVPlayer playerWithPlayerItem:self.playerItem];
    [self.audioPlayer play];
    if (@available(iOS 10.0, *)) {
        
        self.audioPlayer.automaticallyWaitsToMinimizeStalling = NO;
    }
}

- (void)stop{
    
    [self.audioPlayer pause];
    self.playerItem = nil;
    [_audioPlayer replaceCurrentItemWithPlayerItem:nil];
    self.audioPlayer = nil;
}

#pragma mark addObserver playbackFinished
- (void)playbackFinished:(NSNotification *)notice{
    
    NSLog(@"播放完成");
}

#pragma mark - setter && getter
- (void)setPlayerItem:(AVPlayerItem *)playerItem{
    
    if (_playerItem == playerItem) {return;}
    if (_playerItem) {
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:_playerItem];
    }
    _playerItem = playerItem;
    if (playerItem) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
    }
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:AVPlayerItemDidPlayToEndTimeNotification];
}

@end
