//
//  MIStudentWordsViewController.m
//  MinnieStudent
//
//  Created by songzhen on 2019/8/8.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import "MIToastView.h"
#import "AppDelegate.h"
#import "IMManager.h"
#import "PushManager.h"
#import "AudioPlayer.h"
#import "FileUploader.h"
#import "VICacheManager.h"
#import "MIReadingWordsView.h"
#import "VIResourceLoaderManager.h"
#import <AVOSCloudIM/AVOSCloudIM.h>
#import "MIReadingTaskViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "AudioPlayerViewController.h"
#import "MIStudentWordsViewController.h"

static NSString * const kKeyOfCreateTimestamp = @"createTimestamp";
static NSString * const kKeyOfAudioDuration = @"audioDuration";
static NSString * const kKeyOfVideoDuration = @"videoDuration";

@interface MIStudentWordsViewController ()


@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *wordLabel;
@property (weak, nonatomic) IBOutlet UIView *progressBgView;

@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@property (strong,nonatomic) NSTimer *wordsTimer;
@property (strong,nonatomic) NSTimer *countTimer;
@property (assign,nonatomic) NSInteger currentWordIndex;
@property (nonatomic,strong) HomeworkItem *wordsItem;

@property (nonatomic,strong) NSMutableArray *progressViews;

// 1:正在录制  2:录制完成
@property (assign,nonatomic) NSInteger recordState;
// 背景音乐
@property (nonatomic, strong) AVPlayer *bgMusicPlayer;

// 录音
@property (nonatomic, strong) NSDate *startTime;
@property (nonatomic, assign) NSInteger duration;
@property (nonatomic, strong) AVAudioRecorder *audioRecorder;

@end

@implementation MIStudentWordsViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setNewOrientation:YES];//调用转屏代码
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self setNewOrientation:NO];
  
    [self stopRecordFound];
    [self removeRecordSound];
    [self stopTask];
    [self.bgMusicPlayer pause];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
 
    _progressViews = [NSMutableArray array];
    HomeworkItem *tempWordItem =  self.homework.items.lastObject;
    if ([tempWordItem.type isEqualToString:@"word"]) {
      
        self.wordsItem = tempWordItem;
    }
    
    [self configureUI];
    [self startTask];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEnterBackground) name:UIApplicationWillEnterForegroundNotification object:nil];
    
}

- (void)configureUI{
    
    // 进度条
    CGFloat proWidth = CGRectGetWidth(self.progressBgView.frame) /self.wordsItem.words.count;
    for (NSInteger i = 0; i < self.wordsItem.words.count; i++) {
        
        UIView *progress = [[UIView alloc] init];
        if (i == 0) {
            progress.frame = CGRectMake(0, 0, proWidth - 1, 5);
        } else if (i == self.wordsItem.words.count - 1) {
            progress.frame = CGRectMake(i * proWidth + 1, 0, proWidth - 1, 5);
        } else {
            progress.frame = CGRectMake(i * proWidth + 1, 0, proWidth - 2, 5);
        }
        progress.backgroundColor = [UIColor detailColor];
        progress.layer.cornerRadius = 2.0;
        [self.progressBgView addSubview:progress];
        
        [_progressViews addObject:progress];
    }
    self.progressBgView.layer.cornerRadius = 2.0;
    
    // 初始状态
    self.timeLabel.text = [NSString stringWithFormat:@"%d",3];
    self.timeLabel.layer.cornerRadius = 140;
    self.timeLabel.layer.borderWidth = 5.0;
    self.timeLabel.layer.borderColor = [UIColor detailColor].CGColor;
    self.wordLabel.hidden = YES;
    self.timeLabel.hidden = NO;
}

- (IBAction)backAction:(id)sender {
  
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)startTask{
    
    [self startCountTime];
}

- (void)stopTask{
    
    [self invalidateCountTimer];
    [self invalidateTimer];
}

#pragma mark - 1.开始倒计时
- (void)startCountTime{
   
    [self stopTask];
    _recordState = 1;
    _currentWordIndex = -4;
    [self.countTimer fireDate];
    
    for (UIView *progress in self.progressViews) {
        progress.backgroundColor = [UIColor detailColor];
    }
}

#pragma mark - 2.开始播放单词,播放背景音乐,并录音
- (void)startPlayWords{
    
    [self invalidateTimer];
    // 播放单词
    WordInfo *tempWord = _wordsItem.words.firstObject;
    self.wordLabel.text = tempWord.english;
    [self.wordsTimer fireDate];
    
    // 播放背景音乐
    if (self.wordsItem.bgmusicUrl.length) {
        self.bgMusicPlayer = [self getPlayerWith:self.wordsItem.bgmusicUrl isLocal:NO];
        self.bgMusicPlayer.volume = 0.5;
        [self.bgMusicPlayer play];
    }
    // 开始录音
    [self starRecoreFound];
}

- (void)starRecoreFound{
    
    [self removeRecordSound];
    
    // 开始录音
    NSString *soundFilePath = [self getRecordSoundPath];
    [[NSFileManager defaultManager] removeItemAtPath:soundFilePath error:nil];
    NSURL *url = [NSURL fileURLWithPath:soundFilePath];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    
    NSError *error = nil;
    self.audioRecorder = [[AVAudioRecorder alloc] initWithURL:url settings:[self audioRecordingSettings] error:&error];
    self.audioRecorder.meteringEnabled = YES;
    if ([self.audioRecorder prepareToRecord]){
        self.audioRecorder.meteringEnabled = YES;
        [self.audioRecorder record];
        self.duration = 0;
        self.startTime = [NSDate date];
    }
}

- (void)stopRecordFound{
    
    WeakifySelf;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // 停止录制
        [[AudioPlayer sharedPlayer] stop];
        [weakSelf.audioRecorder stop];
        weakSelf.audioRecorder = nil;
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        [[AVAudioSession sharedInstance] setActive:NO error:nil];
    });
}

#pragma mark - 3.是否提交
- (void)finishedToast{

    WeakifySelf;
    [MIToastView setTitle:@"是否提交作业？"
                  confirm:@"立即提交"
                   cancel:@"重新来过"
                superView:self.view
             confirmBlock:^{
             
                 [weakSelf uploadRecord];
             } cancelBlock:^{
                 
                 [weakSelf startTask];
    }];
    [self.view addSubview:self.backBtn];
}

#pragma mark - 4.上传录制音频
- (void)uploadRecord{
    
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    NSString *soundFilePath = [docsDir stringByAppendingPathComponent:@"sample.aac"];
    NSData *data = [NSData dataWithContentsOfFile:soundFilePath];
    if (data.length == 0) {
        [HUD showErrorWithMessage:@"未找到录制语音文件"];
        [self finishedToast];
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [HUD showProgressWithMessage:@"正在上传语音..."];
        WeakifySelf;
        [[FileUploader shareInstance] uploadData:data
                                            type:UploadFileTypeAudio
                                   progressBlock:^(NSInteger number) {
                                       [HUD showProgressWithMessage:[NSString stringWithFormat:@"正在上传语音%@%%...", @(number)]];
                                   }
                                 completionBlock:^(NSString * _Nullable audioUrl, NSError * _Nullable error) {
                                     if (audioUrl.length > 0) {
                                         [[NSFileManager defaultManager] removeItemAtPath:soundFilePath
                                                                                    error:nil];
                                         
                                         [HUD hideAnimated:YES];
                                         [weakSelf sendAudioMessage:[NSURL URLWithString:audioUrl] duration:weakSelf. duration];
                                     } else {
                                         [HUD showErrorWithMessage:@"音频上传失败"];
                                         [weakSelf finishedToast];
                                     }
                                 }];
    });
}
#pragma mark - 5.发送消息
- (void)sendAudioMessage:(NSURL *)audioURL duration:(CGFloat)duration {
    int64_t timestamp = (int64_t)([[NSDate date] timeIntervalSince1970] * 1000);
    AVFile *file = [AVFile fileWithRemoteURL:audioURL];
    NSInteger d = (NSInteger)duration;
    NSString *typeName =  kHomeworkTaskWordMemoryName;
    AVIMAudioMessage *message = [AVIMAudioMessage messageWithText:@"audio"
                                                             file:file
                                                       attributes:@{kKeyOfCreateTimestamp:@(timestamp),
                                                                    kKeyOfAudioDuration:@(d),
                                                                    @"typeName":typeName}];
    [self sendMessage:message];
}

- (void)sendMessage:(AVIMMessage *)message {
    
    //发送消息之前进行IM服务判断
    NSString *userId;
    NSString *clientId = [IMManager sharedManager].client.clientId;
    AVIMClientStatus status = [IMManager sharedManager].client.status;
#if MANAGERSIDE
    userId = [NSString stringWithFormat:@"%@", @(self.teacher.userId)];
#else
    userId = [NSString stringWithFormat:@"%@", @(APP.currentUser.userId)];
#endif
    if ([userId isEqualToString:clientId] && status == AVIMClientStatusOpened) {
    } else {
        [[IMManager sharedManager] setupWithClientId:userId callback:^(BOOL success,  NSError * error) {
            if (!success) return ;
        }];
    }
    if (status != AVIMClientStatusOpened) {
        [HUD showErrorWithMessage:@"IM服务暂不可用，请稍后再试"];
        [self finishedToast];
        return;
    }
    
    NSString *text = @"[语音]";
    AVIMMessageOption *option = [[AVIMMessageOption alloc] init];
    option.pushData = @{@"alert":@{@"body":text,@"action-loc-key":@"com.minine.push",@"loc-key":@(PushManagerMessage)}, @"badge":@"Increment",@"pushType" :@(PushManagerMessage),@"action":@"com.minine.push"};
    
    WeakifySelf;
    [self.conversation sendMessage:message
                            option:option
                          callback:^(BOOL succeeded, NSError * _Nullable error) {
                              
                              if (succeeded) {
                                  if (weakSelf.finishCallBack) {
                                      weakSelf.finishCallBack((AVIMAudioMessage *)message);
                                  }
                                  [[NSNotificationCenter defaultCenter] postNotificationName:kIMManagerContentMessageDidSendNotification object:nil userInfo:@{@"message": message}];
                                  
                                  [weakSelf.navigationController popViewControllerAnimated:YES];
                              } else {
                                
                                  [HUD showErrorWithMessage:@"发送消息失败"];
                                  [weakSelf finishedToast];
                              }
                          }];
}

- (void)invalidateTimer{
    [self.wordsTimer invalidate];
    self.wordsTimer = nil;
}

- (void)invalidateCountTimer{
    [self.countTimer invalidate];
    self.countTimer = nil;
}

#pragma mark - 定时播放任务
- (void)countTime { // 计时
    
    if (_currentWordIndex < 0) { // 4,3, 2, 1, 0
        
        self.wordLabel.hidden = YES;
        self.timeLabel.hidden = NO;
        
        if (_currentWordIndex == -1) {
            self.timeLabel.text = [NSString stringWithFormat:@"Ready\nGo!"];
            self.timeLabel.layer.borderColor = [UIColor clearColor].CGColor;
        } else {
            
            self.timeLabel.text = [NSString stringWithFormat:@"%lu",-(_currentWordIndex + 1)];
            self.timeLabel.layer.cornerRadius = 140;
            self.timeLabel.layer.borderWidth = 5.0;
            self.timeLabel.layer.borderColor = [UIColor detailColor].CGColor;
        }
        _currentWordIndex ++;
    }
    if (_currentWordIndex >= 0) {
        
        [self invalidateCountTimer];
        [self startPlayWords];
    }
}
- (void)playWords{ // 播放单词
    
    if (_currentWordIndex >=0 && _currentWordIndex < self.wordsItem.words.count) {
        
        self.wordLabel.hidden = NO;
        self.timeLabel.hidden = YES;
        
        WordInfo *tempWord = self.wordsItem.words[_currentWordIndex];
        self.wordLabel.text = tempWord.english;
        
        if ( _currentWordIndex < self.progressViews.count) {
            WeakifySelf;
            [UIView animateWithDuration:0.5 animations:^{
                
                UIView *view = weakSelf.progressViews[weakSelf.currentWordIndex];
                view.backgroundColor = [UIColor mainColor];
            }];
        }
        _currentWordIndex ++;
 
    } else {
        
        // 停止播放单词
        [self invalidateTimer];
        
        self.wordLabel.text = @"Good job!";
        
        // 停止背景音乐
        [self.bgMusicPlayer pause];
        [self.bgMusicPlayer seekToTime:CMTimeMake(0, 1)];
        // 停止录音
        [self stopRecordFound];
        
        // 播放完成提示音
        AVPlayer *finishPlayer = [self getPlayerWith:self.wordsItem.bgmusicUrl isLocal:YES];
        finishPlayer.volume = 0.5;
        [finishPlayer play];
        _recordState = 2;
        [self finishedToast];
    }
}

#pragma mark setter && getter
- (NSTimer *)wordsTimer{
    
    if (!_wordsTimer) {
        
        NSInteger playTime = self.wordsItem.playtime/1000;
        if (playTime == 0) {
            playTime = 2.0;
        }
        _wordsTimer = [NSTimer scheduledTimerWithTimeInterval:playTime target:self selector:@selector(playWords) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_wordsTimer forMode:NSDefaultRunLoopMode];
    }
    return _wordsTimer;
}

- (NSTimer *)countTimer{
    
    if (!_countTimer) {
        
        _countTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countTime) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_countTimer forMode:NSDefaultRunLoopMode];
    }
    return _countTimer;
}

- (AVPlayer *)getPlayerWith:(NSString *)urlStr isLocal:(BOOL)isLocal{
    
    AVAudioSession *session =[AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
    
    AVPlayerItem *playerItem;
    if (urlStr.length) {
        
        if (isLocal) {
            playerItem = [[AVPlayerItem alloc]initWithURL:[NSURL fileURLWithPath:urlStr]];
        } else {
            playerItem = [[AVPlayerItem alloc]initWithURL:[NSURL URLWithString:urlStr]];
        }
    }
    AVPlayer *recordPlayer = [AVPlayer playerWithPlayerItem:playerItem];
    if (@available(iOS 10.0, *)) {
        
        recordPlayer.automaticallyWaitsToMinimizeStalling = NO;
    }
    recordPlayer.volume = 1.0;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(vedioPlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    return recordPlayer;
}

#pragma mark - 音视频播放结束
- (void)vedioPlayDidEnd:(NSNotification *)notify{
    
    AVPlayerItem *playItem = notify.object;
    if (playItem == self.bgMusicPlayer.currentItem) {
        
        // 录制未结束循环播放
        [self.bgMusicPlayer seekToTime:CMTimeMake(0, 1)];
        [self.bgMusicPlayer play];
    }
}

#pragma - 设置横屏切换
- (void)setNewOrientation:(BOOL)fullscreen{
    
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.allowRotation = fullscreen;//(打开,关闭横屏开关)
    if (fullscreen) {
        
        NSNumber *resetOrientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationUnknown];
        [[UIDevice currentDevice] setValue:resetOrientationTarget forKey:@"orientation"];
        NSNumber *orientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight];
        [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
    }else{
        
        NSNumber *resetOrientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationUnknown];
        [[UIDevice currentDevice] setValue:resetOrientationTarget forKey:@"orientation"];
        NSNumber *orientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
        [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
    }
}

#pragma mark -
- (void)didEnterBackground{
    
    if (_recordState != 2) {
      
        [HUD showErrorWithMessage:@"录音失败"];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark - private
- (void)removeRecordSound{
    
    NSString *soundFilePath = [self getRecordSoundPath];
    [[NSFileManager defaultManager] removeItemAtPath:soundFilePath
                                               error:nil];
}

- (NSString *)getRecordSoundPath{
    
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    NSString *soundFilePath = [docsDir stringByAppendingPathComponent:@"sample.aac"];
    return soundFilePath;
}

- (NSDictionary *)audioRecordingSettings{
    
    NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:kAudioFormatMPEG4AAC], AVFormatIDKey,
                              [NSNumber numberWithFloat:16000], AVSampleRateKey,
                              [NSNumber numberWithInt:2], AVNumberOfChannelsKey,
                              [NSNumber numberWithInt:AVAudioQualityMedium], AVSampleRateConverterAudioQualityKey,
                              [NSNumber numberWithInt:64000], AVEncoderBitRateKey,
                              [NSNumber numberWithInt:8], AVEncoderBitDepthHintKey,
                              nil];
    
    return settings;
}

@end
