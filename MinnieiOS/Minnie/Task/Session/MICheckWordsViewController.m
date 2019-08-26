//
//  MICheckWordsViewController.m
//  Minnie
//
//  Created by songzhen on 2019/6/9.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import "AudioPlayer.h"
#import "MIReadingWordsView.h"
#import <AVOSCloudIM/AVOSCloudIM.h>
#import "MICheckWordsViewController.h"
#import <AVFoundation/AVFoundation.h>

#import "MIRecordWaveView.h"
#import <AFNetworking/AFNetworking.h>
#import "AudioPlayerManager.h"


@interface MICheckWordsViewController ()<
CAAnimationDelegate
>{

}
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *vedioBgView;

@property (weak, nonatomic) IBOutlet UIButton *startRecordBtn;
@property (weak, nonatomic) IBOutlet UILabel *startRecordLabel;

@property (strong,nonatomic) MIReadingWordsView *wordsView;

@property (nonatomic, strong) MIRecordWaveView *recordWaveView;

@property (nonatomic, strong) AudioPlayerManager *audioPlayer;
@property (weak, nonatomic) IBOutlet UIView *recordAniBgView;

@end

@implementation MICheckWordsViewController

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    // 查看作业
    [self.wordsView invalidateTimer];
    [self.audioPlayer resetCurrentPlayer];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.titleLabel.text = kHomeworkTaskWordMemoryName;
    [self configureUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEnterBackground) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void) configureUI{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.startRecordBtn setBackgroundImage:[UIImage imageNamed:@"btn_play_green"] forState:UIControlStateNormal];
    [self.startRecordBtn setBackgroundImage:[UIImage imageNamed:@"btn_stop_green"] forState:UIControlStateSelected];
    self.startRecordLabel.text = @"点击查看录音";
    
    self.wordsView.wordsItem = self.homework.items.lastObject;
    self.wordsView.hidden = NO;
    [self.vedioBgView addSubview:self.wordsView];
    [self.wordsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.vedioBgView);
    }];
}

#pragma mark  actions
- (IBAction)backAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)startRecordAction:(id)sender {
   
    if (self.startRecordBtn.selected) { // 查看录音
        
        [self.audioPlayer play:NO];
        [self.wordsView stopPlayWords];

        self.startRecordBtn.selected = NO;
        self.startRecordLabel.text = @"点击查看录音";
    } else {
        
        // 播放单词录音
        [self.audioPlayer play:YES];
        [self.wordsView startPlayWords];
        
        self.startRecordBtn.selected = YES;
        self.startRecordLabel.text = @"点击停止播放";
    }
}

#pragma mark setter && getter

- (MIReadingWordsView *)wordsView{
    
    if (!_wordsView) {
        
        _wordsView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MIReadingWordsView class]) owner:nil options:nil].lastObject;
        WeakifySelf;
        _wordsView.readingWordsCallBack = ^{
            
        };
        _wordsView.readingWordsSeekCallBack = ^(CGFloat rate) {
          
            CGFloat time = weakSelf.audioPlayer.duration * rate;
            [weakSelf.audioPlayer seekToTime:time];
            weakSelf.startRecordBtn.selected = YES;
            weakSelf.startRecordLabel.text = @"点击停止录音";
            [weakSelf.wordsView startPlayWords];
        };
        _wordsView.readingWordsProgressCallBack = ^(NSInteger index) {
           
//            HomeworkItem *wordItem = weakSelf.wordsView.wordsItem;
//
//            CGFloat rate =  (CGFloat)(weakSelf.audioPlayer.current/weakSelf.audioPlayer.duration);
//            int tempIndex = roundf(rate * wordItem.words.count);
//
//            if (abs(tempIndex - (int)index) > 1) {
//
//                CGFloat time = weakSelf.audioPlayer.duration * index/wordItem.words.count;
//                [weakSelf.audioPlayer seekToTime:time];
//            }
        };
    }
    return _wordsView;
}

- (AudioPlayerManager *)audioPlayer{
    
    if (!_audioPlayer) {
        
        _audioPlayer = [[AudioPlayerManager alloc] initWithUrl:self.audioUrl];
        
        WeakifySelf;
        _audioPlayer.statusBlock = ^(AVPlayerItemStatus status) {
            
            if (status == AVPlayerItemStatusFailed) {
                
                weakSelf.startRecordBtn.selected = NO;
                weakSelf.startRecordLabel.text = @"点击查看录音";
                [weakSelf.wordsView stopPlayWords];
            } else if (status == AVPlayerItemStatusReadyToPlay) {
                NSLog(@"AVPlayerItemStatusReadyToPlay");
            }
        };
        
        _audioPlayer.progressBlock = ^(CGFloat time, CGFloat duration) {
          
        };
        
        _audioPlayer.finishedBlock = ^{
            
            weakSelf.startRecordBtn.selected = NO;
            weakSelf.startRecordLabel.text = @"点击查看录音";
        };
    }
    return _audioPlayer;
}

- (MIRecordWaveView *)recordWaveView{
    
    if (!_recordWaveView) {
        _recordWaveView = [[MIRecordWaveView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 150)];
    }
    
    [self.recordAniBgView addSubview:_recordWaveView];
    return _recordWaveView;
}


- (void)didEnterBackground{
    
    [self.audioPlayer play:NO];
    
    [self.wordsView stopPlayWords];
    self.startRecordBtn.selected = NO;
    self.startRecordLabel.text = @"点击查看录音";
}


- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
