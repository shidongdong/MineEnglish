//
//  MISutdentActDetailViewController.m
//  Minnie
//
//  Created by songzhen on 2019/6/8.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import "Result.h"
#import "UIView+Load.h"
#import "ManagerServce.h"
#import "MIStuActDetailHeaderView.h"
#import "MISutActDetailTableViewCell.h"
#import "MIStuUploadVideoViewController.h"
#import "MISutdentActDetailViewController.h"


#import "AudioPlayer.h"
#import <AVKit/AVKit.h>
#import "VICacheManager.h"
#import "FileUploader.h"
#import "NEPhotoBrowser.h"
#import "VIResourceLoaderManager.h"
#import "AudioPlayerViewController.h"
#import "WBGImageEditorViewController.h"

#import "HomeworkSessionService.h"
#import "SessionHomeworkTableViewCell.h"
#import "HomeworkPreviewViewController.h"


#import <objc/runtime.h>
#import <AVKit/AVKit.h>
//#import "FileUploader.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>


@interface MISutdentActDetailViewController ()<
NEPhotoBrowserDelegate,
NEPhotoBrowserDataSource,
VIResourceLoaderManagerDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate
>
@property (weak, nonatomic) IBOutlet UILabel *actTitleLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (strong,nonatomic) NSArray *rankList;

@property (nonatomic, strong) MBProgressHUD * mHud;


@property (nonatomic, weak) UIImageView *currentSelectedImageView;
@property (nonatomic, strong) NEPhotoBrowser *photoBrowser;
@property (nonatomic, strong) VIResourceLoaderManager *resourceLoaderManager;

@property (nonatomic, weak) NSString *currentSelectedImageUrl;

@end

@implementation MISutdentActDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    MIStuActDetailHeaderView *header = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MIStuActDetailHeaderView class]) owner:nil options:nil].lastObject;
    header.actInfo = self.actInfo;
    header.autoresizingMask = UIViewAutoresizingNone;
    CGFloat height = [MIStuActDetailHeaderView heightWithActInfo:self.actInfo];
    header.frame = CGRectMake(0, 0, ScreenWidth, height);
    
    
    WeakifySelf;
    [header setVideoCallback:^(NSString *videoUrl) {
        [weakSelf playerVideoWithURL:videoUrl];
    }];
    [header setImageCallback:^(NSString * imageUrl, UIImageView * currentImage, NSInteger index) {
        weakSelf.currentSelectedImageView = currentImage;
        weakSelf.currentSelectedImageUrl = imageUrl;
        [weakSelf showCurrentSelectedImage];
    }];
    
    [header setAudioCallback:^(NSString * audioUrl, NSString * audioCoverUrl) {
        [weakSelf playAudioWithURL:audioUrl withCoverURL:audioCoverUrl];
    }];
    
    self.tableview.tableHeaderView = header;
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor clearColor];
    self.tableview.tableFooterView = footerView;
    
    [self requestGetStuActivityRankList];
}


- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)uploadAction:(id)sender {
    [self handleAddItem];
}

- (IBAction)myUploadAction:(id)sender {
    
    MIStuUploadVideoViewController *uploadVC = [[MIStuUploadVideoViewController alloc] initWithNibName:NSStringFromClass([MIStuUploadVideoViewController class]) bundle:nil];
    uploadVC.actId = self.actInfo.activityId;
    [self.navigationController pushViewController:uploadVC animated:YES];
}

#pragma mark - UITableViewDataSource && UITableViewDelagete
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return MISutActDetailTableViewCellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.rankList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MISutActDetailTableViewCell *contentCell = [tableView dequeueReusableCellWithIdentifier:MISutActDetailTableViewCellId];
    if (contentCell == nil) {
        contentCell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MISutActDetailTableViewCell class]) owner:nil options:nil] lastObject];
    }
    WeakifySelf;
    contentCell.videoCallback = ^(NSString * _Nullable videUrl) {
        [weakSelf playerVideoWithURL:videUrl];
    };
    [contentCell setupRanInfo:self.rankList[indexPath.row] index:indexPath.row + 1];
    return contentCell;
}

#pragma mark - 获取文件夹信息
- (void)requestGetStuActivityRankList{
    
    WeakifySelf;
    
//    [self.tableview showLoadingView];
    [ManagerServce requestGetStuActivityRankListWithActId:self.actInfo.activityId callback:^(Result *result, NSError *error) {
        
        [weakSelf.view hideAllStateView];
        if (error) {
            
            [weakSelf.tableview showFailureViewWithRetryCallback:^{
                [weakSelf requestGetStuActivityRankList];
            }];
            return;
        }
        
        [weakSelf.tableview hideAllStateView];
        NSDictionary *dict = (NSDictionary *)(result.userInfo);
        NSArray *folderList = (NSArray *)(dict[@"list"]);
        
        ActivityRankInfo *rankInfo1 = [[ActivityRankInfo alloc] init];
        rankInfo1.avatar  = @"http://res.zhengminyi.com/FtlXAfzMJPI6YyO3fiQQUcVw9LQT";
        rankInfo1.nickName = @"哈哈😁哈哈";
        rankInfo1.actTimes = 500;
        rankInfo1.actUrl = @"http://file.zhengminyi.com/mBa6QMBfbOttwEAqplMNPoD.mp4";
        
        ActivityRankInfo *rankInfo = [[ActivityRankInfo alloc] init];
        rankInfo.avatar  = @"http://res.zhengminyi.com/FtlXAfzMJPI6YyO3fiQQUcVw9LQT";
        rankInfo.nickName = @"哈哈😁";
        rankInfo.actTimes = 500;
        rankInfo.actUrl = @"http://file.zhengminyi.com/mBa6QMBfbOttwEAqplMNPoD.mp4";
        
        folderList = @[rankInfo1,rankInfo,rankInfo1,rankInfo,rankInfo1,rankInfo,rankInfo1,rankInfo];
        weakSelf.rankList = folderList;
       
        if (weakSelf.rankList.count) {
            [weakSelf.tableview reloadData];
        } else {
            [weakSelf.tableview showEmptyViewWithImage:nil
                                            title:@"列表为空"
                                    centerYOffset:0
                                        linkTitle:nil
                                linkClickCallback:nil
                                    retryCallback:^{
                                        
                                    }];
            [weakSelf.tableview reloadData];
        }
    }];
}


#pragma mark - 播放视频、展示图片
- (void)showCurrentSelectedImage {
    
    self.photoBrowser = [[NEPhotoBrowser alloc] init];
    self.photoBrowser.delegate = self;
    self.photoBrowser.dataSource = self;
    self.photoBrowser.clickedImageView = self.currentSelectedImageView;
    
    [self.photoBrowser showInContext:self.navigationController];
}
- (void)playerVideoWithURL:(NSString *)url {
    
    [[AudioPlayer sharedPlayer] stop];
    AVAudioSession *session =[AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
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
    [self presentViewController:playerViewController animated:YES completion:nil];
    playerViewController.view.frame = self.view.frame;
    [playerViewController.player play];
}

- (void)playAudioWithURL:(NSString *)url withCoverURL:(NSString *)coverUrl
{
    [[AudioPlayer sharedPlayer] stop];
    AVAudioSession *session =[AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    AudioPlayerViewController *playerViewController = [[AudioPlayerViewController alloc]init];
    NSInteger playMode = [[Application sharedInstance] playMode];
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
    [self presentViewController:playerViewController animated:YES completion:nil];
    playerViewController.view.frame = self.view.frame;
    [playerViewController.player play];
    [playerViewController setOverlyViewCoverUrl:coverUrl];
}

#pragma mark - VIResourceLoaderManagerDelegate
- (void)resourceLoaderManagerLoadURL:(NSURL *)url didFailWithError:(NSError *)error
{
    //播放失败清除缓存
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
                                                             [self dismissViewControllerAnimated:YES completion:^{
                                                                 
                                                             }];
                                                         }];
    
    [alertVC addAction:cancelAction];
    
    [self presentViewController:alertVC
                       animated:YES
                     completion:nil];
    
}


#pragma mark - NEPhotoBrowserDataSource
- (NSInteger)numberOfPhotosInPhotoBrowser:(NEPhotoBrowser *)browser {
    return 1;
}
- (NSURL* __nonnull)photoBrowser:(NEPhotoBrowser * __nonnull)browser imageURLForIndex:(NSInteger)index {
    return [NSURL URLWithString:self.currentSelectedImageUrl];
}

- (UIImage * __nullable)photoBrowser:(NEPhotoBrowser * __nonnull)browser placeholderImageForIndex:(NSInteger)index {
    return self.currentSelectedImageView.image;
}

#pragma mark - NEPhotoBrowserDelegate

- (void)photoBrowser:(NEPhotoBrowser * __nonnull)browser willSavePhotoWithView:(NEPhotoBrowserView *)view {
    [HUD showProgressWithMessage:@"正在保存图片"];
}

- (void)photoBrowser:(NEPhotoBrowser * __nonnull)browser didSavePhotoSuccessWithImage:(UIImage *)image {
    [HUD showWithMessage:@"保存图片成功"];
}

- (void)photoBrowser:(NEPhotoBrowser * __nonnull)browser savePhotoErrorWithError:(NSError *)error {
    [HUD showErrorWithMessage:@"保存图片失败"];
}


#pragma mark - 上传视频
- (void)handleAddItem {
    
    // 适配ipad版本
    UIAlertControllerStyle alertStyle;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        alertStyle = UIAlertControllerStyleActionSheet;
    } else {
        alertStyle = UIAlertControllerStyleAlert;
    }
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"选择视频"
                                                                     message:nil
                                                              preferredStyle:alertStyle];
    WeakifySelf;
    UIAlertAction * videoAction = [UIAlertAction actionWithTitle:@"视频"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             [weakSelf addVideoItem];
                                                         }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                         }];
    
    [alertVC addAction:videoAction];
    [alertVC addAction:cancelAction];
    [self.navigationController presentViewController:alertVC
                                           animated:YES
                                         completion:nil];
}

- (void)addVideoItem {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.mediaTypes = @[(NSString *)kUTTypeMovie];
    [self.navigationController presentViewController:picker animated:YES completion:nil];
}

- (void)uploadVideoForPath:(NSURL *)videoUrl{
    
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%ld_compressedVideo.mp4",time(NULL)]];
    [HUD showProgressWithMessage:@"正在压缩视频文件..."];
    AVURLAsset *avAsset = [[AVURLAsset alloc] initWithURL:videoUrl options:nil];
    
    NSTimeInterval durationInSeconds = 0.0;
    if (avAsset != nil) {
        durationInSeconds = CMTimeGetSeconds(avAsset.duration);
    }
    
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    
    if ([compatiblePresets containsObject:AVAssetExportPresetHighestQuality]) {
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPreset1280x720];
        exportSession.outputURL = [NSURL fileURLWithPath:path];
        exportSession.shouldOptimizeForNetworkUse = true;
        exportSession.outputFileType = AVFileTypeMPEG4;
        
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            if ([exportSession status] == AVAssetExportSessionStatusCompleted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    WeakifySelf;
                    __block BOOL flag = NO;
                    QNUploadOption * option = [[QNUploadOption alloc] initWithMime:nil progressHandler:^(NSString *key, float percent) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (!weakSelf.mHud)
                            {
                                weakSelf.mHud = [HUD showProgressWithMessage:[NSString stringWithFormat:@"正在上传视频%.f%%...", percent * 100] cancelCallback:^{
                                    flag = YES;
                                }];
                            }
                            else
                            {
                                UILabel * label = [weakSelf.mHud.customView viewWithTag:99];
                                
                                label.text = [NSString stringWithFormat:@"正在上传视频%.f%%...", percent * 100];
                            }
                        });
                    } params:nil checkCrc:NO cancellationSignal:^BOOL{
                        return flag;
                    }];
                    
                    
                    [[FileUploader shareInstance] qn_uploadFile:path type:UploadFileTypeVideo option:option completionBlock:^(NSString * _Nullable videoUrl, NSError * _Nullable error) {
                        weakSelf.mHud = nil;
                        if (videoUrl.length == 0) {
                            [HUD showErrorWithMessage:@"视频上传失败"];
                            
                            return ;
                        }
                        
                        [HUD showWithMessage:@"视频上传成功"];
                        
                        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
                        
                        HomeworkItem *item = [[HomeworkItem alloc] init];
                        item.type = HomeworkItemTypeVideo;
                        item.videoUrl = videoUrl;
                        item.videoCoverUrl = @"";
                        
                        [weakSelf.tableview reloadData];
                    }];
                });
            }else{
                NSLog(@"当前压缩进度:%f",exportSession.progress);
            }
            NSLog(@"%@",exportSession.error);
            
        }];
    }
}

#pragma mark - UIImagePickerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    NSString* mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:@"public.movie"]) {
        [self handleVideoPickerResult:picker didFinishPickingMediaWithInfo:info];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)handleVideoPickerResult:(UIImagePickerController *)picker
  didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:^{
        NSURL *videoUrl = [info objectForKey:UIImagePickerControllerMediaURL];
        [self uploadVideoForPath:videoUrl];
    }];
}

@end
