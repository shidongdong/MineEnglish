//
//  MIParticipateDetailViewController.m
//  MinnieManager
//
//  Created by songzhen on 2019/5/31.
//  Copyright © 2019 minnieedu. All rights reserved.
//


#import "TIP.h"
#import <AVKit/AVKit.h>
#import "UIView+Load.h"
#import "NEPhotoBrowser.h"
#import "VICacheManager.h"
#import "UIScrollView+Refresh.h"
#import "VIResourceLoaderManager.h"
#import "AudioPlayerViewController.h"
#import "MIParticipateDetailTableViewCell.h"
#import "MIParticipateDetailViewController.h"

#import "ManagerServce.h"

@interface MIParticipateDetailViewController ()<
UITableViewDelegate,
UITableViewDataSource,
VIResourceLoaderManagerDelegate
>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *uploadArray;

@property (nonatomic, strong) VIResourceLoaderManager *resourceLoaderManager;
@end

@implementation MIParticipateDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configureUI];
    [self requestactLogs];
}

- (void)configureUI{
    self.view.backgroundColor = [UIColor bgColor];
    self.uploadArray = [NSMutableArray array];
    
    UIView *footrView = [[UIView alloc] init];
    footrView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = footrView;
    _tableView.cellLayoutMarginsFollowReadableWidth = NO;
}
- (IBAction)backAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.uploadArray.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return MIParticipateDetailTableViewCellHeight;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MIParticipateDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MIParticipateDetailTableViewCellId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MIParticipateDetailTableViewCell class]) owner:nil options:nil] lastObject];
    }
    WeakifySelf;
    cell.playVideoCallback = ^(NSString * _Nullable videoUrl) {
        [weakSelf showVideoWithUrl:videoUrl];
    };
    cell.qualifiedCallback = ^(BOOL isqualified, ActLogsInfo *logInfo) {
        [weakSelf requestCorrectWithLogInfo:logInfo isOk:isqualified];
    };
    [cell setupWithModel:self.uploadArray[indexPath.row]];
    return cell;
}

- (void)showVideoWithUrl:(NSString *)videoUrl {
    
    AVAudioSession *session =[AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    NSInteger playMode = [[Application sharedInstance] playMode];
    
    AVPlayerViewController *playerViewController = [[AVPlayerViewController alloc]init];
    AVPlayer *player;
    if (playMode == 1)// 在线播放
    {
        [VICacheManager cleanCacheForURL:[NSURL URLWithString:videoUrl] error:nil];
        player = [[AVPlayer alloc]initWithURL:[NSURL URLWithString:videoUrl]];
    }
    else
    {
        VIResourceLoaderManager *resourceLoaderManager = [VIResourceLoaderManager new];
        resourceLoaderManager.delegate = self;
        self.resourceLoaderManager = resourceLoaderManager;
        AVPlayerItem *playerItem = [resourceLoaderManager playerItemWithURL:[NSURL URLWithString:videoUrl]];
        player = [AVPlayer playerWithPlayerItem:playerItem];
    }
    playerViewController.player = player;
    [self presentViewController:playerViewController animated:YES completion:nil];
    playerViewController.view.frame = self.view.frame;
    [playerViewController.player play];
}

#pragma mark - VIResourceLoaderManagerDelegate
- (void)resourceLoaderManagerLoadURL:(NSURL *)url didFailWithError:(NSError *)error
{
    [VICacheManager cleanCacheForURL:url error:nil];
    // 适配ipad版本
    UIAlertControllerStyle alertStyle;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        alertStyle = UIAlertControllerStyleActionSheet;
    } else {
        alertStyle = UIAlertControllerStyleAlert;
    }
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil
                                                                     message:@"播放失败"
                                                              preferredStyle:alertStyle];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             [self.tabBarController dismissViewControllerAnimated:YES completion:^{
                                                                 
                                                             }];
                                                         }];
    
    [alertVC addAction:cancelAction];
    
    [self presentViewController:alertVC
                       animated:YES
                     completion:nil];
    
}

#pragma mark - 视频审阅
- (void)requestCorrectWithLogInfo:(ActLogsInfo *)logInfo isOk:(BOOL)isOk{
    WeakifySelf;
    [ManagerServce requestCorrectActVideoId:logInfo.logId isOk:isOk actId:logInfo.actId callback:^(Result *result, NSError *error) {
        if (error) return ;
        [weakSelf requestactLogs];
    }];
}
#pragma mark - 获取上传列表

- (void)requestactLogs{
    
    WeakifySelf;
    [ManagerServce requestactLogsActivityId:self.rankInfo.actId stuId:self.rankInfo.userId callback:^(Result *result, NSError *error) {
        if (error) return;
        
        ActLogsInfo *logs2 = [[ActLogsInfo alloc] init];
        logs2.logId = 1;
        logs2.actTimes = 200;
        logs2.actUrl = @"http://file.zhengminyi.com/mBa6QMBfbOttwEAqplMNPoD.mp4";
        logs2.actId = 1;
        logs2.isOk = 0;
        logs2.upTime = @"2019-10-15 10:20:00";
        
        ActLogsInfo *logs1 = [[ActLogsInfo alloc] init];
        logs1.logId = 1;
        logs1.actTimes = 200;
        logs1.actUrl = @"http://file.zhengminyi.com/mBa6QMBfbOttwEAqplMNPoD.mp4";
        logs1.actId = 1;
        logs1.isOk = 1;
        logs1.upTime = @"2019-10-15 10:20:00";
        
        ActLogsInfo *logs = [[ActLogsInfo alloc] init];
        logs.logId = 1;
        logs.actTimes = 200;
        logs.actUrl = @"http://file.zhengminyi.com/mBa6QMBfbOttwEAqplMNPoD.mp4";
        logs.actId = 1;
        logs.isOk = 2;
        logs.upTime = @"2019-10-15 10:20:00";
        [weakSelf.uploadArray addObject:logs];
        [weakSelf.uploadArray addObject:logs1];
        [weakSelf.uploadArray addObject:logs2];
        [weakSelf.tableView reloadData];
    }];
}
@end
