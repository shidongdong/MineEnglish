//
//  MIReadingTaskViewController.m
//  Minnie
//
//  Created by songzhen on 2019/6/9.
//  Copyright © 2019 minnieedu. All rights reserved.
//

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

#import "MIRecordWaveView.h"
#import "EditAudioVideo.h"
#import <AFNetworking/AFNetworking.h>


static NSString * const kKeyOfCreateTimestamp = @"createTimestamp";
static NSString * const kKeyOfAudioDuration = @"audioDuration";
static NSString * const kKeyOfVideoDuration = @"videoDuration";

@interface MIReadingTaskViewController ()<
CAAnimationDelegate,
VIResourceLoaderManagerDelegate
>{
    
   CAShapeLayer *shapeLayer;
}
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIView *vedioBgView;

//@property (weak, nonatomic) IBOutlet UIButton *rerecordBtn;
@property (weak, nonatomic) IBOutlet UIButton *startRecordBtn;
@property (weak, nonatomic) IBOutlet UILabel *startRecordLabel;

@property (weak, nonatomic) IBOutlet UIButton *myRecordBtn;
@property (weak, nonatomic) IBOutlet UILabel *myRecordLabel;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;

@property (strong,nonatomic) MIReadingWordsView *wordsView;

@property (nonatomic, strong) MIRecordWaveView *recordWaveView;

// 视频播放器
@property (strong,nonatomic) AVPlayerViewController *playerVC;

@property (nonatomic, strong) VIResourceLoaderManager *resourceLoaderManager;

@property (assign,nonatomic) BOOL isReadingWords;

// 0:未开始 1:正在录制  2:录制完成
@property (assign,nonatomic) NSInteger recordState;

@property (nonatomic, strong) NSDate *startTime;
@property (nonatomic, assign) NSInteger duration;
@property (nonatomic, strong) AVAudioRecorder *audioRecorder;

// 我的录音
@property (nonatomic, strong) AVPlayer *myRecordPlayer;

@property (weak, nonatomic) IBOutlet UIView *recordAniBgView;

@property (nonatomic, strong) AVPlayer *bgMusicPlayer;

@end

@implementation MIReadingTaskViewController

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    if (self.isChecking) { // 查看作业
        
        [self.bgMusicPlayer pause];
        [self.wordsView stopPlayWords];
        self.startRecordBtn.selected = NO;
        self.startRecordLabel.text = @"点击查看录音";
        [self.playerVC.player seekToTime:CMTimeMake(0, 1)];
        [self.playerVC.player pause];
    } else {
        
        [self removeRecordSound];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    if ([self.homework.typeName isEqualToString:kHomeworkTaskWordMemoryName]) {
        self.isReadingWords = YES;
        self.titleLabel.text = kHomeworkTaskWordMemoryName;
    } else {
        self.isReadingWords = NO;
        self.titleLabel.text = kHomeworkTaskFollowUpName;
    }
    [self configureUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEnterBackground) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void) configureUI{
    
    self.view.backgroundColor = [UIColor whiteColor];
    if (self.isChecking) {
        self.commitBtn.hidden = YES;
        self.myRecordBtn.hidden = YES;
        self.myRecordLabel.hidden = YES;
        [self.startRecordBtn setBackgroundImage:[UIImage imageNamed:@"btn_play_green"] forState:UIControlStateNormal];
        [self.startRecordBtn setBackgroundImage:[UIImage imageNamed:@"btn_stop_green"] forState:UIControlStateSelected];
        self.startRecordLabel.text = @"点击查看录音";
    } else {
      
        self.commitBtn.hidden = NO;
        self.myRecordBtn.hidden = NO;//
        self.myRecordLabel.hidden = NO;
        self.myRecordBtn.enabled = NO;
        [self.startRecordBtn setBackgroundImage:[UIImage imageNamed:@"btn_record"] forState:UIControlStateNormal];
        self.startRecordLabel.text = @"点击开始录制";
    }
    if (self.isReadingWords) {
        
        self.wordsView.wordsItem = self.homework.items.lastObject;
        self.wordsView.hidden = NO;
        [self.vedioBgView addSubview:self.wordsView];
        [self.wordsView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.equalTo(self.vedioBgView);
        }];
    } else {
        
        self.wordsView.hidden = YES;
        [self addChildViewController:self.playerVC];
        [self.vedioBgView addSubview:self.playerVC.view];
        [self.playerVC didMoveToParentViewController:self];
        [self.playerVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.equalTo(self.vedioBgView);
        }];
    }
}

#pragma mark  actions
- (IBAction)backAction:(id)sender {
    
    if (self.recordState == 0) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    NSString *title;
    NSString *message;
    NSString *sureTitle;
    if (self.recordState == 1) {
        title = @"正在录音";
        message = @"\n录音还没有完成，是否继续";
        sureTitle = @"继续";
    } else {
        title = @"提交作业";
        message = @"\n你还没有提交录音，是否现在提交作业";
        sureTitle = @"提交";
    }
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title
                                                                     message:message
                                                              preferredStyle:UIAlertControllerStyleAlert];
    WeakifySelf;
    UIAlertAction * sureAction = [UIAlertAction actionWithTitle:sureTitle
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * _Nonnull action) {
                                                          
                                                            if (weakSelf.recordState == 2) {
                                                                [weakSelf uploadRecord];
                                                            }
                                                        }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"一会再说"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                        
                                                             if (weakSelf.recordState == 1) {
                                                                 
                                                                 [weakSelf stopRecordFound];
                                                                 [weakSelf removeRecordSound];
                                                             } else {
                                                                
                                                                 weakSelf.myRecordBtn.selected = NO;
                                                                 [weakSelf.myRecordPlayer pause];
                                                                 [weakSelf removeRecordSound];
                                                             }
                                                             [weakSelf.navigationController popViewControllerAnimated:YES];
                                                         }];
    [alertVC addAction:sureAction];
    [alertVC addAction:cancelAction];
    [self.navigationController presentViewController:alertVC
                                            animated:YES
                                          completion:nil];
    

}

- (void)rerecordAlert:(NSString *)title message:(NSString *)message {
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title
                                                                     message:message
                                                              preferredStyle:UIAlertControllerStyleAlert];
    WeakifySelf;
    UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * _Nonnull action) {
                                                            
                                                            if (weakSelf.recordState == 1) {
                                                             
                                                                [weakSelf stopRecordFound];
                                                            } else {
                                                                [weakSelf.myRecordPlayer pause];
                                                                weakSelf.myRecordBtn.selected = NO;
                                                                [weakSelf starRecoreFound];
                                                            }
                                                        }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                         }];
    
    [alertVC addAction:sureAction];
    [alertVC addAction:cancelAction];
    [self.navigationController presentViewController:alertVC
                                            animated:YES
                                          completion:nil];
}

- (IBAction)startRecordAction:(id)sender {
   
    if (self.isChecking) {
      
        if (self.startRecordBtn.selected) { // 查看录音
            
            if (self.isReadingWords) {
                
                [self.bgMusicPlayer pause];
                [self.wordsView stopPlayWords];
            } else {
                
                [self.playerVC.player seekToTime:CMTimeMake(0, 1)];
                [self.playerVC.player pause];
                [self.bgMusicPlayer pause];
            }
            self.startRecordBtn.selected = NO;
            self.startRecordLabel.text = @"点击查看录音";
        } else {
         
            if (self.isReadingWords) { // 播放单词录音
                self.bgMusicPlayer = [self getPlayerWith:self.audioUrl isLocal:NO];
                [self.bgMusicPlayer play];
                [self.wordsView startPlayWords];
            } else {
                // 播放视频，播放跟读录音
                [self.playerVC.player seekToTime:CMTimeMake(0, 1)];
                self.playerVC.player.volume = 0.0;
                [self.playerVC.player play];
                self.bgMusicPlayer = [self getPlayerWith:self.audioUrl isLocal:NO];
                [self.bgMusicPlayer play];
            }
            self.startRecordBtn.selected = YES;
            self.startRecordLabel.text = @"点击停止播放";
        }
    } else {
     
        if (self.recordState == 0) {
            
            [self starRecoreFound];
        } else if (self.recordState == 1) { // 正在录音
            
            [self rerecordAlert:@"正在录音" message:@"确定停止录制？"];
        } else if (self.recordState == 2) {
            
            [self rerecordAlert:@"确定重新录制？" message:nil];
        }
    }
}

- (IBAction)myRecordAction:(id)sender {
    
    if (self.recordState == 0) {
        
        [HUD showWithMessage:@"你还没有开始录制"];
        return;
    } else if (self.recordState == 1) {
      
        [HUD showWithMessage:@"正在录制"];
        return;
    }
    self.myRecordPlayer = [self getPlayerWith:[self getRecordSoundPath] isLocal:YES];
    if (_myRecordBtn.selected) {
        _myRecordBtn.selected = NO;
        [self.myRecordPlayer pause];
    } else {
        _myRecordBtn.selected = YES;
        [self.myRecordPlayer play];
    }
}

- (IBAction)commitAction:(id)sender {
    if (self.recordState == 0) {
        
        [HUD showWithMessage:@"你还没有开始录制"];
        return;
    } else if (self.recordState == 1) {
        
        [HUD showWithMessage:@"正在录制"];
        return;
    }
    [self uploadRecord];
}

#pragma mark - 上传录制音频
- (void)uploadRecord{
    
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    NSString *soundFilePath = [docsDir stringByAppendingPathComponent:@"sample.aac"];
    NSData *data = [NSData dataWithContentsOfFile:soundFilePath];
    if (data.length == 0) {
        [HUD showErrorWithMessage:@"未找到录制语音文件"];
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
                                     }
                                 }];
    });
}

#pragma mark - 发送消息
- (void)sendAudioMessage:(NSURL *)audioURL duration:(CGFloat)duration {
    int64_t timestamp = (int64_t)([[NSDate date] timeIntervalSince1970] * 1000);
    AVFile *file = [AVFile fileWithRemoteURL:audioURL];
    NSInteger d = (NSInteger)duration;
    NSString *typeName = self.isReadingWords ? kHomeworkTaskWordMemoryName : kHomeworkTaskFollowUpName;
    AVIMAudioMessage *message = [AVIMAudioMessage messageWithText:@"audio"
                                                             file:file
                                                       attributes:@{kKeyOfCreateTimestamp:@(timestamp),
                                                                    kKeyOfAudioDuration:@(d),
                                                                    @"typeName":typeName}];
    [self sendMessage:message];
}

- (void)sendMessage:(AVIMMessage *)message {
    
    //发送消息之前进行IM服务判断
    AVIMClientStatus status = [IMManager sharedManager].client.status;
    if (status == AVIMClientStatusNone ||
        status == AVIMClientStatusClosed ||
        status == AVIMClientStatusPaused) {
        NSString *userId = [NSString stringWithFormat:@"%@", @(APP.currentUser.userId)];
        [[IMManager sharedManager] setupWithClientId:userId callback:^(BOOL success, NSError * _Nullable error)
         {
             if (!success)
             {
                 return;
             }
         }];
    }
    
    if (status != AVIMClientStatusOpened) {
        [HUD showErrorWithMessage:@"IM服务暂不可用，请稍后再试"];
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
                              }
                          }];
}

#pragma mark - VIResourceLoaderManagerDelegate
- (void)resourceLoaderManagerLoadURL:(NSURL *)url didFailWithError:(NSError *)error
{
    //播放失败清除缓存
    [VICacheManager cleanCacheForURL:url error:nil];
}

#pragma mark setter && getter

- (MIReadingWordsView *)wordsView{
    
    if (!_wordsView) {
        
        _wordsView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MIReadingWordsView class]) owner:nil options:nil].lastObject;
        WeakifySelf;
        _wordsView.readingWordsCallBack = ^{
            if (weakSelf.isChecking) {
            } else {
                [weakSelf.bgMusicPlayer pause];
                [weakSelf finishRecordFound];
                NSData *data = [NSData dataWithContentsOfFile:[weakSelf getRecordSoundPath]];
                if (data.length == 0) {
                    [HUD showErrorWithMessage:@"语音录制失败"];
                }
            }
            
        };
    }
    return _wordsView;
}

- (AVPlayerViewController *)playerVC{
    
    if (!_playerVC) {
       
        AVAudioSession *session =[AVAudioSession sharedInstance];
        [session setCategory:AVAudioSessionCategoryPlayback error:nil];
        
        _playerVC = [[AVPlayerViewController alloc]init];
        AVPlayer *player;
        HomeworkItem *otherItem = self.homework.otherItem.firstObject;
        NSInteger playMode = [[Application sharedInstance] playMode];
        NSString *playUrl = otherItem.videoUrl;
        if ([otherItem.type isEqualToString:@"video"]) {
           playUrl = otherItem.videoUrl;
        } else {
            playUrl = otherItem.audioUrl;
        }
        if (playUrl.length) {

            if (playMode == 1)// 在线播放
            {
                [VICacheManager cleanCacheForURL:[NSURL URLWithString:playUrl] error:nil];
                player = [[AVPlayer alloc]initWithURL:[NSURL URLWithString:playUrl]];
            }
            else
            {
                VIResourceLoaderManager *resourceLoaderManager = [VIResourceLoaderManager new];
                resourceLoaderManager.delegate = self;
                self.resourceLoaderManager = resourceLoaderManager;
                AVPlayerItem *playerItem = [resourceLoaderManager playerItemWithURL:[NSURL URLWithString:playUrl]];
                player = [AVPlayer playerWithPlayerItem:playerItem];
            }
        }
        _playerVC.player = player;
        _playerVC.showsPlaybackControls = NO;
        _playerVC.videoGravity = AVLayerVideoGravityResizeAspectFill;
        _playerVC.player.volume = 0.5;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(vedioPlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    }
    return _playerVC;
}

- (MIRecordWaveView *)recordWaveView{
    
    if (!_recordWaveView) {
        _recordWaveView = [[MIRecordWaveView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 150)];
    }
    
    [self.recordAniBgView addSubview:_recordWaveView];
    return _recordWaveView;
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
    // 播放录音完成
    if (playItem == self.myRecordPlayer.currentItem) {
        
        [self.myRecordPlayer seekToTime:CMTimeMake(0, 1)];
        self.myRecordBtn.selected = NO;
    } else if (playItem == self.playerVC.player.currentItem) {// 播放视频完成
        
        if (self.isChecking) {
            
        } else {
          
            [self.playerVC.player seekToTime:CMTimeMake(0, 1)];
            [self finishRecordFound];
        }
        
    } else if (playItem == self.bgMusicPlayer.currentItem) {
        
        if (self.isChecking) {
            
            self.startRecordBtn.selected = NO;
            self.startRecordLabel.text = @"点击查看录音";
            [self.playerVC.player seekToTime:CMTimeMake(0, 1)];
            [self.playerVC.player pause];
            [self.wordsView stopPlayWords];
            [self.bgMusicPlayer seekToTime:CMTimeMake(0, 1)];
        } else {
          
            // 录制未结束循环播放
            [self.bgMusicPlayer seekToTime:CMTimeMake(0, 1)];
            [self.bgMusicPlayer play];
        }
    }
}

- (void)didEnterBackground{
    
    if (self.isChecking) {
        
        [self.bgMusicPlayer pause];
        [self.wordsView stopPlayWords];
        self.startRecordBtn.selected = NO;
        self.startRecordLabel.text = @"点击查看录音";
        [self.playerVC.player seekToTime:CMTimeMake(0, 1)];
        [self.playerVC.player pause];
    } else {
      
        if (self.recordState == 1) {
            // 停止录制
            [self stopRecordFound];
        } else if (self.recordState == 2) {
            _myRecordBtn.selected = NO;
            [self.myRecordPlayer pause];
        }
    }
}


#pragma mark - 开始、停止、完成、删除录制
- (void)starRecoreFound{
    
    self.myRecordBtn.enabled = NO;
    [self.myRecordPlayer pause];
    [self removeRecordSound];
    self.recordState = 1;
    self.startRecordLabel.text = @"停止";
    [self.startRecordBtn setBackgroundImage:[UIImage imageNamed:@"btn_recording"] forState:UIControlStateNormal];
    if (self.isReadingWords) {
        // 播放单词、背景音乐、开始录音
        HomeworkItem *wordsItem = self.homework.items.lastObject;
        if (wordsItem.bgmusicUrl.length) {
            self.bgMusicPlayer = [self getPlayerWith:wordsItem.bgmusicUrl isLocal:NO];
            self.bgMusicPlayer.volume = 0.5;
            [self.bgMusicPlayer play];
        }
        [self.wordsView startPlayWords];
    } else {
        // 播放视频，开始录音
        [self.playerVC.player seekToTime:CMTimeMake(0, 1)];
        self.playerVC.player.volume = 0.5;
        [self.playerVC.player play];
    }
    
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
    [self.recordWaveView startRecordAnimation];
    [self starRecordBtnAnimation];
}

- (void)starRecordBtnAnimation{
    
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.repeatCount = MAXFLOAT;
    animation.keyPath = @"transform.rotation.z";
    animation.duration = 2.0;
    animation.toValue = @(0);
    animation.fromValue = @(M_PI * 2);
    [self.startRecordBtn.layer addAnimation:animation forKey:nil];
}
- (void)stopRecordFound{
    
    self.recordState = 0;
    self.startRecordLabel.text = @"点击开始录音";
    self.myRecordBtn.enabled = NO;
    [self.startRecordBtn setBackgroundImage:[UIImage imageNamed:@"btn_record"] forState:UIControlStateNormal];
    [self.recordWaveView stopRecordAnimation];
    [self.startRecordBtn.layer removeAllAnimations];
    
    if (self.isReadingWords) {
        [self.bgMusicPlayer pause];
        [self.wordsView stopPlayWords];
        [self.bgMusicPlayer seekToTime:CMTimeMake(0, 1)];
    } else {
        [self.playerVC.player pause];
        [self.playerVC.player seekToTime:CMTimeMake(0, 1)];
    }
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

- (void)finishRecordFound{
    
    self.myRecordBtn.enabled = YES;
    self.recordState = 2;
    self.startRecordLabel.text = @"重录";
    [self.startRecordBtn setBackgroundImage:[UIImage imageNamed:@"btn_replay"] forState:UIControlStateNormal];
    [self.recordWaveView stopRecordAnimation];
    [self.startRecordBtn.layer removeAllAnimations];
    
    // 停止录音
    [self.audioRecorder stop];
    self.audioRecorder = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive:NO error:nil];
    [[AudioPlayer sharedPlayer] stop];
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


- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
