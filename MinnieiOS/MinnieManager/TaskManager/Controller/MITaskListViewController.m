//
//  MITaskListViewController.m
//  MinnieManager
//
//  Created by songzhen on 2019/5/28.
//  Copyright © 2019 minnieedu. All rights reserved.
//  任务管理 - 任务列表

#import "ManagerServce.h"
#import "MITaskEmptyView.h"
#import "HomeworkTableViewCell.h"
#import "MIFirLevelFolderModel.h"
#import "MICreateHomeworkTaskView.h"
#import "MITaskListViewController.h"
#import "MIScoreListViewController.h"
#import "MICreateTaskViewController.h"
#import "HomeworkPreviewViewController.h"
#import "ClassAndStudentSelectorController.h"
#import "HomeWorkSendHistoryViewController.h"

#import "HomeworkService.h"
#import "UIView+Load.h"
#import "UIScrollView+Refresh.h"
#import "TIP.h"
#import "NEPhotoBrowser.h"
#import <AVKit/AVKit.h>
#import "AudioPlayerViewController.h"
#import "VIResourceLoaderManager.h"
#import "VICacheManager.h"

@interface MITaskListViewController ()<
UITableViewDelegate,
UITableViewDataSource,
NEPhotoBrowserDelegate,
NEPhotoBrowserDataSource,
VIResourceLoaderManagerDelegate
>

@property (nonatomic, assign) BOOL inEditMode;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIButton *createBtn;
@property (weak, nonatomic) IBOutlet UIButton *sendRecordBtn;
@property (weak, nonatomic) IBOutlet UILabel *folderLabel;
@property (weak, nonatomic) IBOutlet UIView *footerView;

@property (weak, nonatomic) IBOutlet UILabel *selectCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *footerHeightConstraint;

@property (nonatomic, strong)  MITaskEmptyView *emptyView;

@property (nonatomic, strong) NSMutableArray <Homework *> *homeworks;

@property (nonatomic, strong) NSMutableArray <NSNumber *> *selectedHomeworkIds;

@property (nonatomic, strong) BaseRequest *homeworksRequest;

@property (nonatomic, strong) NSString *nextUrl;

@property (nonatomic, strong) NEPhotoBrowser *photoBrowser;
@property (nonatomic, copy) NSString *currentSelectedImageUrl;
@property (nonatomic, strong) UIImageView *currentSelectedImageView;
@property (nonatomic, strong) VIResourceLoaderManager *resourceLoaderManager;

@property (nonatomic, assign) BOOL shouldReloadWhenAppeared;

@property (nonatomic, strong) FileInfo *currentFileInfo;


@end

@implementation MITaskListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.folderLabel.text = @"未命名文件夹";
    _homeworks = [NSMutableArray array];
    _selectedHomeworkIds = [NSMutableArray array];
    [self registerCellNibs];
    [self configureUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(shouldReloadDataWhenAppeared:)
                                                 name:kNotificationKeyOfAddHomework
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(homeworkDidSendSuccess) name:kNotificationKeyOfHomeworkSendSuccess object:nil];
    
//    [self requestHomeworks];
}

- (void)setFolderTitle:(NSString *)folderTitle{
    
    _folderTitle = folderTitle;
}

- (void)configureUI{
    
    self.view.backgroundColor = [UIColor bgColor];
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 12.f)];
    self.tableView.tableFooterView = footerView;
    self.selectCountLabel.layer.masksToBounds = YES;
    self.selectCountLabel.layer.cornerRadius = 10.5;
}
- (void)registerCellNibs {
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HomeworkTableViewCell class]) bundle:nil] forCellReuseIdentifier:HomeworkTableViewCellId];
}

#pragma mark - actions  新建  发送记录  操作
- (IBAction)addTaskAction:(id)sender {
  
    [self showSelectedTask];
}

- (IBAction)sendRecordAction:(id)sender {
    
    HomeWorkSendHistoryViewController * historyHomeworkVC = [[HomeWorkSendHistoryViewController alloc] initWithNibName:@"HomeWorkSendHistoryViewController" bundle:nil];
    [self.navigationController pushViewController:historyHomeworkVC animated:YES];
}

- (IBAction)operationAction:(id)sender {
    
    self.inEditMode = !self.inEditMode;
    self.sendBtn.selected = self.inEditMode;
    if (self.inEditMode) {
        
        [self.selectedHomeworkIds removeAllObjects];
        self.createBtn.hidden = YES;
        self.folderLabel.hidden = YES;
        self.sendRecordBtn.hidden = YES;
        self.footerView.hidden = NO;
        self.footerHeightConstraint.constant = 50;
    } else {
        self.createBtn.hidden = NO;
        self.folderLabel.hidden = NO;
        self.sendRecordBtn.hidden = NO;
        self.footerView.hidden = YES;
        self.footerHeightConstraint.constant = 0;
    }
    [self.tableView reloadData];
}

#pragma mark - 发送作业 && 删除作业
- (IBAction)sendHomeworkAction:(id)sender {
    
    if (self.selectedHomeworkIds.count == 0) {
        return;
    }
    NSMutableArray *homeworks = [NSMutableArray array];
    for (int i = 0; i < self.selectedHomeworkIds.count; i++)
    {
        NSNumber * homeSelectId = [self.selectedHomeworkIds objectAtIndex:i];
        for (Homework *homework in self.homeworks) {
            if ([homeSelectId integerValue] == homework.homeworkId)
            {
                [homeworks addObject:homework];
            }
        }
    }
    ClassAndStudentSelectorController *vc = [[ClassAndStudentSelectorController alloc] init];
    [vc setHomeworks:homeworks];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

- (IBAction)deleteHomeworkAction:(id)sender {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确认删除?"
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                         }];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"删除"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                              [HUD showProgressWithMessage:@"正在删除"];
                                                              
                                                              [HomeworkService deleteHomeworks:self.selectedHomeworkIds
                                                                                      callback:^(Result *result, NSError *error) {
                                                                                          if (error != nil) {
                                                                                              [HUD showErrorWithMessage:@"删除失败"];
                                                                                              return;
                                                                                          }
                                                                                          
                                                                                          [HUD showWithMessage:@"删除成功"];
                                                                                          
                                                                                          [self.homeworks removeAllObjects];
                                                                                          [self.selectedHomeworkIds removeAllObjects];
                                                                                          self.nextUrl = nil;
                                                                                          
                                                                                          [self.tableView reloadData];
                                                                                          
                                                                                          [self operationAction:nil];
                                                                                          [self requestHomeworks];
                                                                                      }];
                                                          }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:confirmAction];
    [self.navigationController presentViewController:alertController animated:YES completion:nil];
}


#pragma mark - Private Methods
- (void)shouldReloadDataWhenAppeared:(NSNotification *)notification {
    self.shouldReloadWhenAppeared = YES;
}

- (void)homeworkDidSendSuccess{
    self.inEditMode = YES;
    [self operationAction:nil];
}

#pragma mark - 请求作业列表
- (void)requestHomeworksTaskList {
   
    if (self.homeworksRequest != nil) {
        return;
    }
    self.tableView.hidden = YES;
    WeakifySelf;
    self.homeworksRequest = [ManagerServce requesthomeworksByFileWithFileId:self.currentFileInfo.fileId callback:^(Result *result, NSError *error) {
        StrongifySelf;
        [strongSelf handleRequestResult:result error:error];
    }];
}
- (void)requestHomeworks {
   
    if (self.homeworksRequest != nil) {
        return;
    }
    self.tableView.hidden = YES;
    WeakifySelf;
    self.homeworksRequest = [HomeworkService requestHomeworksWithCallback:^(Result *result, NSError *error) {
        StrongifySelf;
        [strongSelf handleRequestResult:result error:error];
    }];
}
- (void)loadMoreHomeworks {
    if (self.homeworksRequest != nil) {
        return;
    }
    
    WeakifySelf;
    self.homeworksRequest = [HomeworkService requestHomeworksWithNextUrl:self.nextUrl
                                                                callback:^(Result *result, NSError *error) {
                                                                    StrongifySelf;
                                                                    [strongSelf handleRequestResult:result error:error];
                                                                }];
}

- (void)handleRequestResult:(Result *)result error:(NSError *)error {
   
    self.homeworksRequest = nil;
    NSDictionary *dictionary = (NSDictionary *)(result.userInfo);
    NSString *nextUrl = dictionary[@"next"];
    NSArray *homeworks = dictionary[@"list"];
    [self showTaskList:YES];
    
    BOOL isLoadMore = self.nextUrl.length > 0;
    if (isLoadMore) {
        [self.tableView footerEndRefreshing];
        self.tableView.hidden = NO;
        
        if (error != nil) {
            return;
        }
        if (homeworks.count > 0) {
            [self.homeworks addObjectsFromArray:homeworks];
        }
        
        if (nextUrl.length == 0) {
            [self.tableView removeFooter];
        }
        
        [self.tableView reloadData];
    } else {
        // 停止加载
        [self.tableView headerEndRefreshing];
        self.tableView.hidden = homeworks.count==0;
        
        if (error != nil) {
            if (homeworks.count > 0) {
                [TIP showText:@"加载失败" inView:self.view];
            } else {
//                WeakifySelf;
//                [self.containerView showFailureViewWithRetryCallback:^{
//                    [weakSelf requestHomeworks];
//                }];
            }
            return;
        }
        
        if (homeworks.count > 0) {
            [self.view hideAllStateView];
            self.tableView.hidden = NO;
            
            [self.homeworks addObjectsFromArray:homeworks];
            [self.tableView reloadData];
            
            if (nextUrl.length > 0) {
                WeakifySelf;
                [self.tableView addInfiniteScrollingWithRefreshingBlock:^{
                    [weakSelf loadMoreHomeworks];
                }];
            } else {
                [self.tableView removeFooter];
            }
        } else {
            [self.view showEmptyViewWithImage:nil
                                        title:@"暂无作业"
                                centerYOffset:0
                                    linkTitle:nil
                            linkClickCallback:nil];
        }
    }
    self.nextUrl = nextUrl;
}

#pragma mark - 显示图片 视频 音频
- (void)showCurrentSelectedImage {
    
    self.photoBrowser = [[NEPhotoBrowser alloc] init];
    self.photoBrowser.delegate = self;
    self.photoBrowser.dataSource = self;
    self.photoBrowser.clickedImageView = self.currentSelectedImageView;
    
    [self.photoBrowser showInContext:self.navigationController];
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

- (void)showAudioWithURL:(NSString *)url withCoverURL:(NSString *)coverUrl
{
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

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.homeworks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeworkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HomeworkTableViewCellId forIndexPath:indexPath];
    
    Homework *homework = self.homeworks[indexPath.row];
    
    [cell setupWithHomework:homework];
    [cell updateWithEditMode:self.inEditMode selected:[self.selectedHomeworkIds containsObject:@(homework.homeworkId)]];
    
    WeakifySelf;
    [cell setSelectCallback:^{
        if ([weakSelf.selectedHomeworkIds containsObject:@(homework.homeworkId)]) {
            [weakSelf.selectedHomeworkIds removeObject:@(homework.homeworkId)];
        } else {
            [weakSelf.selectedHomeworkIds addObject:@(homework.homeworkId)];
        }
        weakSelf.selectCountLabel.text = [NSString stringWithFormat:@"%zd", weakSelf.selectedHomeworkIds.count];
        weakSelf.deleteBtn.enabled = weakSelf.selectedHomeworkIds.count>0;
        weakSelf.sendBtn.enabled = weakSelf.selectedHomeworkIds.count>0;
    }];
    
    // 作业预览
    [cell setPreviewCallback:^{
        
        HomeworkPreviewViewController *vc = [[HomeworkPreviewViewController alloc] init];
        vc.homework = homework;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    
    // 点击空白处 -> 得分列表
    [cell setBlankCallback:^{
        
        MIScoreListViewController *scoreListVC = [[MIScoreListViewController alloc] initWithNibName:NSStringFromClass([MIScoreListViewController class]) bundle:nil];
        scoreListVC.homework = homework;
        [self.navigationController pushViewController:scoreListVC animated:YES];
    }];
    [cell setSendCallback:^{
      
        ClassAndStudentSelectorController *vc = [[ClassAndStudentSelectorController alloc] init];
        [vc setHomeworks:@[homework]];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [weakSelf.navigationController presentViewController:nav animated:YES completion:nil];
    }];
    
    [cell setImageCallback:^(UIImageView *imageView, NSString *imageUrl) {
        weakSelf.currentSelectedImageView = imageView;
        weakSelf.currentSelectedImageUrl = imageUrl;
        
        [weakSelf showCurrentSelectedImage];
    }];
    
    [cell setVideoCallback:^(NSString *videoUrl) {
        [weakSelf showVideoWithUrl:videoUrl];
    }];
    
    [cell setAudioCallback:^(NSString * audioUrl, NSString * audioCoverUrl) {
        [weakSelf showAudioWithURL:audioUrl withCoverURL:audioCoverUrl];
    }];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Homework *homework = self.homeworks[indexPath.row];
    CGFloat height = [HomeworkTableViewCell cellHeightWithHomework:homework];
    return height < 100 ? 100 : height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
//    Homework *homework = self.homeworks[indexPath.row];
//    CreateHomeworkViewController *createHomeworkVC = [[CreateHomeworkViewController alloc] initWithNibName:@"CreateHomeworkViewController" bundle:nil];
//    createHomeworkVC.homework = homework;
//    [self.navigationController pushViewController:createHomeworkVC animated:YES];
}

// 请求作业列表
- (void)showTaskListWithFoldInfo:(FileInfo * _Nullable)fileInfo{
   
    self.currentFileInfo = fileInfo;
    if (fileInfo) {
        // 显示任务列表
//        [self requestHomeworksTaskList];
        [self requestHomeworks];// 临时
    } else { // 显示为空
        [self showTaskList:NO];
    }
}

- (void)showTaskList:(BOOL)isShow{
    
    if (isShow) {
        
        self.tableView.hidden = NO;
        self.headerView.hidden = NO;
        if (self.inEditMode) {
            self.footerView.hidden = NO;
            self.footerHeightConstraint.constant = 50;
        } else {
            self.footerView.hidden = YES;
            self.footerHeightConstraint.constant = 0;
        }
        if (self.emptyView.superview) {
            
            [self.emptyView removeFromSuperview];
        }
    } else {
        self.tableView.hidden = YES;
        self.headerView.hidden = YES;
        self.footerView.hidden = YES;
        self.footerHeightConstraint.constant = 0;
        if (self.emptyView.superview) {
            
            [self.emptyView removeFromSuperview];
        }
    }
}
            
- (void)showEmptyViewWithIsFolder:(BOOL)isAddFolder folderIndex:(NSInteger)index{
    
    if (self.emptyView == nil) {
        
        self.emptyView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MITaskEmptyView class]) owner:nil options:nil] lastObject];
    }
    self.tableView.hidden = YES;
    [self.view addSubview:self.emptyView];
    WeakifySelf;
    self.emptyView.callBack = ^(BOOL isAddFolder) {
        
        __block NSInteger currIndex = index;
        if (isAddFolder) { // 添加二级文件夹
            
            if (weakSelf.addFolderCallBack) {
                
                weakSelf.addFolderCallBack(currIndex);
            }
        } else { // 新建任务
            [weakSelf showSelectedTask];
        }
    };
    [self.emptyView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.top.bottom.equalTo(self.view);
    }];
    self.emptyView.isAddFolder = isAddFolder;
}

- (void)showSelectedTask{
    
    WeakifySelf;
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"选择任务类型"
                                                                     message:nil
                                                              preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"通知"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                 [weakSelf goToCreateTaskWithType:MIHomeworkTaskType_notify];
                                                         }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"跟读"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * _Nonnull action) {
                                 [weakSelf goToCreateTaskWithType:MIHomeworkTaskType_FollowUp];
                                                        
                                                    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"单词记忆"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * _Nonnull action) {
                                 [weakSelf goToCreateTaskWithType:MIHomeworkTaskType_WordMemory];
                                                    }];
    UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"普通任务"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * _Nonnull action) {
                                 [weakSelf goToCreateTaskWithType:MIHomeworkTaskType_GeneralTask];
                                                    }];
    UIAlertAction *action5 = [UIAlertAction actionWithTitle:@"活动"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * _Nonnull action) {
                                 [weakSelf goToCreateTaskWithType:MIHomeworkTaskType_Activity];
                                                    }];
    UIAlertAction *action6 = [UIAlertAction actionWithTitle:@"成绩统计"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * _Nonnull action) {
                        [weakSelf goToCreateTaskWithType:MIHomeworkTaskType_ExaminationStatistics];
                                                    }];
    UIAlertAction *action7 = [UIAlertAction actionWithTitle:@"取消"
                                                      style:UIAlertActionStyleCancel
                                                    handler:^(UIAlertAction * _Nonnull action) {
                                                        
                                                    }];
    
    [alertVC addAction:action1];
    [alertVC addAction:action2];
    [alertVC addAction:action3];
    [alertVC addAction:action4];
    [alertVC addAction:action5];
    [alertVC addAction:action6];
    [alertVC addAction:action7];
    
    [self presentViewController:alertVC
                       animated:YES
                     completion:nil];
}

- (void)goToCreateTaskWithType:(MIHomeworkTaskType)type{
    
    MICreateTaskViewController *createVC = [[MICreateTaskViewController alloc] init];
    [createVC setupCreateHomework:nil taskType:type];
    WeakifySelf;
    createVC.callBack = ^{
      [weakSelf requestHomeworks];
    };
    [self.navigationController pushViewController:createVC animated:YES];
}

- (void)dealloc {
  
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self.homeworksRequest clearCompletionBlock];
    [self.homeworksRequest stop];
    self.homeworksRequest = nil;
    
    NSLog(@"%s", __func__);
}

@end
