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

static NSString *const kAnimation = @"animation1";

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

@property (weak, nonatomic) IBOutlet UIButton *rerecordBtn;
@property (weak, nonatomic) IBOutlet UIButton *startRecordBtn;
@property (weak, nonatomic) IBOutlet UILabel *startRecordLabel;

@property (weak, nonatomic) IBOutlet UIButton *myRecordBtn;

@property (strong,nonatomic) MIReadingWordsView *wordsView;

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


@property (nonatomic, strong) AVPlayer *bgMusicPlayer;


@property (nonatomic, strong) CALayer *bgLayer;



@end

@implementation MIReadingTaskViewController

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [self removeRecordSound];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if ([self.homework.typeName isEqualToString:kHomeworkTaskWordMemoryName]) {
        self.isReadingWords = YES;
        self.titleLabel.text = kHomeworkTaskWordMemoryName;
    } else {
        self.isReadingWords = NO;
        self.titleLabel.text = kHomeworkTaskFollowUpName;
    }
    [self configureUI];
}

- (void) configureUI{
    
    self.view.backgroundColor = [UIColor whiteColor];
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
        [_playerVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
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
                                                                 
                                                                 [weakSelf stopRecord];
                                                                 [weakSelf removeRecordSound];
                                                             } else {
                                                                
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

- (void)rerecordAlert {
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"确定重新录制？"
                                                                     message:nil
                                                              preferredStyle:UIAlertControllerStyleAlert];
    WeakifySelf;
    UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * _Nonnull action) {
                                                            
                                                            [weakSelf starRecoreFound];
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

- (IBAction)rerecordAction:(id)sender {
    
    if (self.recordState == 0) {
        [HUD showWithMessage:@"你还没有开始录制"];
        return;
    }
    [self rerecordAlert];
}
- (IBAction)startRecordAction:(id)sender {
  
    if (self.recordState == 0) {
        
        [self starRecoreFound];
    } else if (self.recordState == 2) {
        
        [self rerecordAlert];
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
    
    [self uploadRecord];
}

#pragma mark - 开始、停止录制音频
- (void)startRecord {
   
    [self.myRecordPlayer pause];
    [self removeRecordSound];
    
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(
                                                            NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    NSString *soundFilePath = [docsDir
                               stringByAppendingPathComponent:@"sample.aac"];
    [[NSFileManager defaultManager] removeItemAtPath:soundFilePath
                                               error:nil];
    
    NSURL *url = [NSURL fileURLWithPath:soundFilePath];
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
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
    
    [self startRecordAnimation];
}

- (void)startRecordAnimation{

    CABasicAnimation *rotateAni = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotateAni.fromValue = [NSNumber numberWithFloat:M_PI * 2];
    rotateAni.toValue = [NSNumber numberWithFloat:0];
    rotateAni.removedOnCompletion = NO;
    rotateAni.fillMode = kCAFillModeForwards;
    rotateAni.repeatCount = MAXFLOAT;
    rotateAni.duration = 2.0;
    [self.startRecordBtn.layer addAnimation:rotateAni forKey:nil];
}

- (void)setupshapeLayer {
    
    _bgLayer = [CALayer layer];
    _bgLayer.frame = CGRectMake(0, 0, 88, 88);
    [self.startRecordBtn.layer addSublayer:_bgLayer];

    shapeLayer = [[CAShapeLayer alloc] init];
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(44.0, 44.0) radius:30.0 startAngle:0 endAngle:(M_PI * 1)/100.0 clockwise:NO];
    shapeLayer.path = path.CGPath;
    shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
    shapeLayer.lineWidth = 5.0;
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.frame = CGRectMake(0, 0, 88, 88);
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    [_bgLayer addSublayer:shapeLayer];
    
    
    CABasicAnimation *startAni = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    startAni.fromValue = @1.0;
    startAni.toValue = @0.1;
    startAni.repeatCount = 1;
    
    CABasicAnimation *rotateAni = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotateAni.fromValue = [NSNumber numberWithFloat:M_PI * 4.0];
    rotateAni.toValue = [NSNumber numberWithFloat: 0.0];
    rotateAni.repeatCount = MAXFLOAT;
    
    CAAnimationGroup *aniGroup = [CAAnimationGroup animation];
    aniGroup.duration = 3.0;
    aniGroup.removedOnCompletion = NO;
    aniGroup.fillMode = kCAFillModeForwards;
    aniGroup.delegate = self;
    aniGroup.animations = @[startAni,rotateAni];
    [shapeLayer addAnimation:aniGroup forKey:nil];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
  
    CABasicAnimation *rotateAni = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotateAni.fromValue = [NSNumber numberWithFloat:(M_PI * 201)/100.0];
    rotateAni.toValue = [NSNumber numberWithFloat: (M_PI * 1)/100.0];
    rotateAni.removedOnCompletion = NO;
    rotateAni.fillMode = kCAFillModeForwards;
    rotateAni.repeatCount = MAXFLOAT;
    rotateAni.duration = 2.0;
    [_bgLayer addAnimation:rotateAni forKey:nil];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, 88, 88);
    gradientLayer.colors = @[(id)[UIColor whiteColor].CGColor,
                             (id)[UIColor colorWithHex:0x20A4FE].CGColor];
    gradientLayer.locations = @[@0.5,@1.0];
    gradientLayer.startPoint = CGPointMake(0.8, 0.3);
    gradientLayer.endPoint = CGPointMake(1.0, 0.5);
    gradientLayer.mask = shapeLayer;
    [_bgLayer addSublayer:gradientLayer];
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

- (void)stopRecord {
   
    [self.audioRecorder stop];
    self.audioRecorder = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive:NO error:nil];
    
    self.duration = [[NSDate date] timeIntervalSinceDate:self.startTime];
    if (self.duration < 1.f) { // 小于1s直接忽略
        return ;
    }
    
    NSString *soundFilePath = [self getRecordSoundPath];
    NSData *data = [NSData dataWithContentsOfFile:soundFilePath];
    if (data.length == 0) {
        [HUD showErrorWithMessage:@"语音录制失败"];
        
        self.startRecordLabel.text = @"点击开始录制";
        self.recordState = 0;
        return;
    }
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

- (NSString *)getRecordSoundPath{
    
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    NSString *soundFilePath = [docsDir stringByAppendingPathComponent:@"sample.aac"];
    return soundFilePath;
}

- (void)removeRecordSound{
    
    NSString *soundFilePath = [self getRecordSoundPath];
    [[NSFileManager defaultManager] removeItemAtPath:soundFilePath
                                               error:nil];
}

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

#pragma mark - 发送消息
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

- (void)playerVideoWithURL:(NSString *)url {
    
    [[AudioPlayer sharedPlayer] stop];
    AVAudioSession *session =[AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    NSInteger playMode = [[Application sharedInstance] playMode];
    
    AVPlayerViewController *playerViewController = [[AVPlayerViewController alloc]init];
    AVPlayer *player;
    if (playMode == 1)// 在线播放
    {
        [VICacheManager cleanCacheForURL:[NSURL URLWithString:url] error:nil];
        player = [[AVPlayer alloc]initWithURL:[NSURL URLWithString:url]];
    }
    else
    {
        VIResourceLoaderManager *resourceLoaderManager = [VIResourceLoaderManager new];
        resourceLoaderManager.delegate = self;
        self.resourceLoaderManager = resourceLoaderManager;
        AVPlayerItem *playerItem = [resourceLoaderManager playerItemWithURL:[NSURL URLWithString:url]];
        player = [AVPlayer playerWithPlayerItem:playerItem];
    }
    
    playerViewController.player = player;
    playerViewController.showsPlaybackControls = NO;
    playerViewController.player.volume = 1.0;
    self.wordsView.hidden = YES;
    self.vedioBgView.hidden = NO;
    [self addChildViewController:playerViewController];
    [self.vedioBgView addSubview:playerViewController.view];
    playerViewController.view.frame = CGRectMake(0, 0, ScreenWidth, 210);
    [playerViewController didMoveToParentViewController:self];
    [playerViewController.player play];
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
            [weakSelf.bgMusicPlayer pause];
            [weakSelf finishRecordFound];
        };
    }
    return _wordsView;
}

- (AVPlayerViewController *)playerVC{
    
    if (!_playerVC) {
       
        AVAudioSession *session =[AVAudioSession sharedInstance];
        [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        
        _playerVC = [[AVPlayerViewController alloc]init];
        AVPlayer *player;
        HomeworkItem *otherItem = self.homework.otherItem.firstObject;
        NSInteger playMode = [[Application sharedInstance] playMode];
        if (playMode == 1)// 在线播放
        {
            [VICacheManager cleanCacheForURL:[NSURL URLWithString:otherItem.videoUrl] error:nil];
            player = [[AVPlayer alloc]initWithURL:[NSURL URLWithString:otherItem.videoUrl]];
        }
        else
        {
            VIResourceLoaderManager *resourceLoaderManager = [VIResourceLoaderManager new];
            resourceLoaderManager.delegate = self;
            self.resourceLoaderManager = resourceLoaderManager;
            AVPlayerItem *playerItem = [resourceLoaderManager playerItemWithURL:[NSURL URLWithString:otherItem.videoUrl]];
            player = [AVPlayer playerWithPlayerItem:playerItem];
        }
        
        _playerVC.player = player;
        _playerVC.showsPlaybackControls = NO;
        _playerVC.player.volume = 1.0;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(vedioPlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    }
    return _playerVC;
}


- (AVPlayer *)getPlayerWith:(NSString *)urlStr isLocal:(BOOL)isLocal{
    
    AVAudioSession *session =[AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
    
    AVPlayerItem *playerItem;
    if (isLocal) {
        playerItem = [[AVPlayerItem alloc]initWithURL:[NSURL fileURLWithPath:urlStr]];
    } else {
        playerItem = [[AVPlayerItem alloc]initWithURL:[NSURL URLWithString:urlStr]];
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
        
        [self.playerVC.player seekToTime:CMTimeMake(0, 1)];
        [self finishRecordFound];
        
    } else if (playItem == self.bgMusicPlayer.currentItem) {
       // 录制未结束循环播放
        [self.bgMusicPlayer seekToTime:CMTimeMake(0, 1)];
        [self.bgMusicPlayer play];
    }
}

#pragma mark -
- (void)starRecoreFound{
    
    [self removeRecordSound];
    self.startRecordLabel.text = @"正在录制";
    self.recordState = 1;
    [self.startRecordBtn setBackgroundImage:[UIImage imageNamed:@"btn_recording"] forState:UIControlStateNormal];
    if (self.isReadingWords) {
        // 播放单词、背景音乐、开始录音
        HomeworkItem *wordsItem = self.homework.items.lastObject;
        if (wordsItem.bgmusicUrl.length) {
            self.bgMusicPlayer = [self getPlayerWith:wordsItem.bgmusicUrl isLocal:NO];
            [self.bgMusicPlayer play];
        }
        [self.wordsView startPlayWords];
        [self startRecord];
    } else {
        // 播放视频，开始录音
        [self.playerVC.player seekToTime:CMTimeMake(0, 1)];
        [self.playerVC.player play];
        [self startRecord]; // 开始录音
    }
}

- (void)finishRecordFound{
    
    self.recordState = 2;
    self.startRecordLabel.text = @"录制完成";
    [self.startRecordBtn setBackgroundImage:[UIImage imageNamed:@"btn_record"] forState:UIControlStateNormal];
    [self.startRecordBtn.layer removeAllAnimations];
    [self performSelector:@selector(stopRecord) withObject:nil afterDelay:3.0];
}


- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
