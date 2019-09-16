//
//  MITitleTypeTableViewCell.m
//  MinnieManager
//
//  Created by songzhen on 2019/5/30.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import "MIAddTypeTableViewCell.h"
#import "MITitleTypeTableViewCell.h"
#import "HomeworkVideoTableViewCell.h"
#import "HomeworkImageTableViewCell.h"
#import "HomeworkAudioTableViewCell.h"


#import <objc/runtime.h>
#import <AVKit/AVKit.h>
#import "FileUploader.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>

static const char keyOfPickerDocument;


CGFloat const MITitleTypeTableViewCellHeight = 45.f + 40.f;

NSString * const MITitleTypeTableViewCellId = @"MITitleTypeTableViewCellId";


@interface MITitleTypeTableViewCell ()<
UITableViewDelegate,
UITableViewDataSource,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
UIDocumentPickerDelegate
>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *items;
@property (strong, nonatomic) NSMutableArray *answerItems;


@property (nonatomic,strong) UIViewController *vc;

@property (nonatomic, assign) BOOL isAddingAnswerItem;

@property (nonatomic, strong) MBProgressHUD * mHud;

@property (nonatomic, assign) MIHomeworkCreateContentType contentType;

@end

@implementation MITitleTypeTableViewCell

- (void)awakeFromNib {
   
    [super awakeFromNib];
    // Initialization code
    self.items = [NSMutableArray array];
    self.answerItems = [NSMutableArray array];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self registerCellNibs];
}

- (void)registerCellNibs {
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeworkVideoTableViewCell" bundle:nil] forCellReuseIdentifier:HomeworkVideoTableViewCellId];
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeworkImageTableViewCell" bundle:nil] forCellReuseIdentifier:HomeworkImageTableViewCellId];
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeworkAudioTableViewCell" bundle:nil] forCellReuseIdentifier:HomeworkAudioTableViewCellId];
    [self.tableView registerNib:[UINib nibWithNibName:@"MIAddTypeTableViewCell" bundle:nil] forCellReuseIdentifier:MIAddTypeTableViewCellId];
}

- (void)setupWithItems:(NSArray<HomeworkItem *>*)items vc:(UIViewController *)vc contentType:(MIHomeworkCreateContentType)contentType{
    self.contentType = contentType;
    self.vc = vc;
    self.isAddingAnswerItem = NO;
    self.items = [NSMutableArray arrayWithArray:items];
    [self.tableView reloadData];
}

- (void)setupWithAnswerItems:(NSArray<HomeworkAnswerItem *>*)answerItems vc:(UIViewController *)vc{
    self.vc = vc;
    self.isAddingAnswerItem = YES;
    self.answerItems = [NSMutableArray arrayWithArray:answerItems];
    [self.tableView reloadData];
}
- (void)setTitle:(NSString *)title{
    
    _title = title;
    self.titleLabel.text = _title;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.isAddingAnswerItem) {
        if (indexPath.row == self.answerItems.count) {
            
            return MIAddTypeTableViewCellHeight;
        }
    } else {
        if (indexPath.row == self.items.count) {
            
            return MIAddTypeTableViewCellHeight;
        }
    }
    CGFloat height = 112.f;
    if (self.isAddingAnswerItem) {
        
        HomeworkAnswerItem *item = self.answerItems[indexPath.row];
        if ([item.type isEqualToString:@"audio"]) {
            
            if (item.audioCoverUrl.length > 0 && item.audioUrl.length > 0) {
                
                height = height + 80;
            }
        }
    } else {
     
        HomeworkItem *item = self.items[indexPath.row];
        if ([item.type isEqualToString:@"audio"]) {
            
            if (item.audioCoverUrl.length > 0 && item.audioUrl.length > 0) {
                
                height = height + 80;
            }
        }
    }
    return height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    if (self.isAddingAnswerItem) {
        return self.answerItems.count + 1;
    } else {
        return self.items.count + 1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    if (self.isAddingAnswerItem) {
        
        if (indexPath.row == self.answerItems.count) {
            
            MIAddTypeTableViewCell *contentCell = [tableView dequeueReusableCellWithIdentifier:MIAddTypeTableViewCellId forIndexPath:indexPath];
            WeakifySelf;
            contentCell.addCallback = ^(BOOL isAdd) {
                [weakSelf handleAddAnswerItem];
            };
            [contentCell setupWithCreateType:MIHomeworkCreateContentType_Add];
            cell = contentCell;
        } else {
            
            HomeworkAnswerItem *item = self.answerItems[indexPath.row];
            if ([item.type isEqualToString:@"image"]) {
                
                HomeworkImageTableViewCell *imageCell = [tableView dequeueReusableCellWithIdentifier:HomeworkImageTableViewCellId forIndexPath:indexPath];
                
                [imageCell setupWithImageUrl:item.imageUrl];
                WeakifySelf;
                [imageCell setDeleteCallback:^(BOOL bDel) {
                    if (bDel)
                    {
                        [weakSelf deleteAnswerItem:item];
                    }
                    else
                    {
                        [weakSelf addFileAnswerItem:@[@"public.audio"] withHomeworkItem:item];
                    }
                }];
                
                cell = imageCell;
            } else if ([item.type isEqualToString:@"video"]) {
                
                HomeworkVideoTableViewCell *videoCell = [tableView dequeueReusableCellWithIdentifier:HomeworkVideoTableViewCellId forIndexPath:indexPath];
                
                [videoCell setupWithVideoUrl:item.videoUrl coverUrl:item.videoCoverUrl];
                
                WeakifySelf;
                [videoCell setDeleteCallback:^{
                    [weakSelf deleteAnswerItem:item];
                }];
                cell = videoCell;
            } else if ([item.type isEqualToString:@"audio"]) {
                
                HomeworkAudioTableViewCell *audioCell = [tableView dequeueReusableCellWithIdentifier:HomeworkAudioTableViewCellId forIndexPath:indexPath];
                [audioCell setupWithAudioUrl:item.audioUrl coverUrl:item.audioCoverUrl];
                
                WeakifySelf;
                [audioCell setDeleteCallback:^{
                    [weakSelf deleteAnswerItem:item];
                }];
                
                [audioCell setDeleteFileCallback:^{
                    [weakSelf deleteAnswerMp3ForItem:item];
                }];
                cell = audioCell;
            }
        }
    } else {
       
        if (indexPath.row == self.items.count) {
            
            MIAddTypeTableViewCell *contentCell = [tableView dequeueReusableCellWithIdentifier:MIAddTypeTableViewCellId forIndexPath:indexPath];
            WeakifySelf;
            contentCell.addCallback = ^(BOOL isAdd) {
                [weakSelf handleAddItem];
            };
            [contentCell setupWithCreateType:MIHomeworkCreateContentType_Add];
            cell = contentCell;
        } else {
            
            HomeworkItem *item = self.items[indexPath.row];
            
            if ([item.type isEqualToString:@"image"]) {
                
                HomeworkImageTableViewCell *imageCell = [tableView dequeueReusableCellWithIdentifier:HomeworkImageTableViewCellId forIndexPath:indexPath];
                
                [imageCell setupWithImageUrl:item.imageUrl];
                WeakifySelf;
                [imageCell setDeleteCallback:^(BOOL bDel) {
                    if (bDel)
                    {
                        [weakSelf deleteItem:item];
                    }
                    else
                    {
                        [weakSelf addFileItem:@[@"public.audio"] withHomeworkItem:item];
                    }
                }];
                
                cell = imageCell;
            } else if ([item.type isEqualToString:@"video"]) {
                
                HomeworkVideoTableViewCell *videoCell = [tableView dequeueReusableCellWithIdentifier:HomeworkVideoTableViewCellId forIndexPath:indexPath];
                
                [videoCell setupWithVideoUrl:item.videoUrl coverUrl:item.videoCoverUrl];
                
                WeakifySelf;
                [videoCell setDeleteCallback:^{
                    [weakSelf deleteItem:item];
                }];
                cell = videoCell;
            } else if ([item.type isEqualToString:@"audio"]) {
                
                HomeworkAudioTableViewCell *audioCell = [tableView dequeueReusableCellWithIdentifier:HomeworkAudioTableViewCellId forIndexPath:indexPath];
                [audioCell setupWithAudioUrl:item.audioUrl coverUrl:item.audioCoverUrl];
                
                WeakifySelf;
                [audioCell setDeleteCallback:^{
                    [weakSelf deleteItem:item];
                }];
                
                [audioCell setDeleteFileCallback:^{
                    [weakSelf deleteMp3ForItem:item];
                }];
                cell = audioCell;
                
            }
        }
    }
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId"];
    }
    return cell;
}

#pragma mark - 添加、删除音频、视频、图片、文件材料
- (void)handleAddItem {
    // 适配ipad版本
    UIAlertControllerStyle alertStyle;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        alertStyle = UIAlertControllerStyleActionSheet;
    } else {
        alertStyle = UIAlertControllerStyleAlert;
    }
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"选择作业材料类型"
                                                                     message:nil
                                                              preferredStyle:alertStyle];
    
    UIAlertAction * fileAction = [UIAlertAction actionWithTitle:@"文件"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * _Nonnull action) {
                                                            [self addFileItem:@[@"public.image", @"public.movie",@"public.audio"] withHomeworkItem:nil];
                                                        }];
    
    UIAlertAction * videoAction = [UIAlertAction actionWithTitle:@"视频"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             [self addVideoItem];
                                                         }];
    
    UIAlertAction * imageAction = [UIAlertAction actionWithTitle:@"图片"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             [self addImageItem];
                                                         }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                         }];
    
   
    if (self.contentType == MIHomeworkCreateContentType_AddCovers ||
        self.contentType == MIHomeworkCreateContentType_AddActPic) {
      
        [alertVC addAction:imageAction];
        [alertVC addAction:cancelAction];
    } else if ((self.contentType == MIHomeworkCreateContentType_AddFollowMaterials)){

        [alertVC addAction:imageAction];
        [alertVC addAction:cancelAction];
    } else if ((self.contentType == MIHomeworkCreateContentType_AddBgMusic)){
        
        [alertVC addAction:fileAction];
        [alertVC addAction:cancelAction];
    } else {
    
        [alertVC addAction:fileAction];
        [alertVC addAction:videoAction];
        [alertVC addAction:imageAction];
        [alertVC addAction:cancelAction];
    }
//    [self.vc.navigationController presentViewController:alertVC
//                                            animated:YES
//                                          completion:nil];
    [self presentVC:alertVC];

}

- (void)presentVC:(UIViewController *)VC{
    
#if MANAGERSIDE
    
    UIViewController *rootController = self.window.rootViewController;
    [rootController presentViewController:VC animated:YES completion:nil];
#else
    [self.vc presentViewController:VC
                          animated:YES
                        completion:nil];
#endif
}

- (void)addFileItem:(NSArray *)allowedUTIs withHomeworkItem:(HomeworkItem *)item
{
    self.isAddingAnswerItem = NO;
    UIDocumentPickerViewController * picker = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:allowedUTIs inMode:UIDocumentPickerModeImport];
    picker.delegate = self;
    objc_setAssociatedObject(picker , &keyOfPickerDocument, item, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    [self.vc.navigationController presentViewController:picker animated:YES completion:nil];
    [self presentVC:picker];
    
}

- (void)addVideoItem {
    
    self.isAddingAnswerItem = NO;
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.mediaTypes = @[(NSString *)kUTTypeMovie];
//    [self.vc.navigationController presentViewController:picker animated:YES completion:nil];
    [self presentVC:picker];
}

- (void)addImageItem {
    
    self.isAddingAnswerItem = NO;
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.mediaTypes = @[(NSString *)kUTTypeImage];
//    [self.vc.navigationController presentViewController:picker animated:YES completion:nil];
    [self presentVC:picker];
}

- (void)deleteItem:(HomeworkItem *)item {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确认删除?"
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                         }];
    WeakifySelf;
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"删除"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                              [weakSelf.items removeObject:item];
                                                              [weakSelf.tableView reloadData];
                                                              [weakSelf callBack];
                                                          }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:confirmAction];
//    [self.vc presentViewController:alertController animated:YES completion:nil];
    [self presentVC:alertController];
}

- (void)deleteMp3ForItem:(HomeworkItem *)item
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确认删除?"
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                         }];
    WeakifySelf;
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"删除"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                              item.audioUrl = @"";
                                                              NSString * coverUrl = item.audioCoverUrl;
                                                              item.imageUrl = coverUrl;
                                                              item.audioCoverUrl = @"";
                                                              item.type = HomeworkItemTypeImage;
                                                              [weakSelf.tableView reloadData];
                                                              [weakSelf callBack];
                                                          }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:confirmAction];
//    [self.vc presentViewController:alertController animated:YES completion:nil];
    [self presentVC:alertController];
}
- (void)deleteAnswerMp3ForItem:(HomeworkAnswerItem *)item
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确认删除?"
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                         }];
    WeakifySelf;
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"删除"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                              item.audioUrl = @"";
                                                              NSString * coverUrl = item.audioCoverUrl;
                                                              item.imageUrl = coverUrl;
                                                              item.audioCoverUrl = @"";
                                                              item.type = HomeworkItemTypeImage;
                                                              [weakSelf.tableView reloadData];
                                                              [weakSelf callBack];
                                                          }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:confirmAction];
//    [self.vc presentViewController:alertController animated:YES completion:nil];
    [self presentVC:alertController];
}
- (void)deleteAnswerItem:(HomeworkAnswerItem *)item {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确认删除?"
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                         }];
    WeakifySelf;
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"删除"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                              [weakSelf.answerItems removeObject:item];
                                                              [weakSelf.tableView reloadData];
                                                              [weakSelf callBack];
                                                          }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:confirmAction];
    
//    [self.vc presentViewController:alertController animated:YES completion:nil];
    [self presentVC:alertController];
}

- (void)handleAddAnswerItem {
    // 适配ipad版本
    UIAlertControllerStyle alertStyle;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        alertStyle = UIAlertControllerStyleActionSheet;
    } else {
        alertStyle = UIAlertControllerStyleAlert;
    }
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"选择作业答案类型"
                                                                     message:nil
                                                              preferredStyle:alertStyle];
    
    UIAlertAction * fileAction = [UIAlertAction actionWithTitle:@"文件"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * _Nonnull action) {
                                                            [self addFileAnswerItem:@[@"public.image", @"public.movie",@"public.audio"] withHomeworkItem:nil];
                                                        }];
    
    
    UIAlertAction *videoAction = [UIAlertAction actionWithTitle:@"视频"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * _Nonnull action) {
                                                            [self addVideoAnswerItem];
                                                        }];
    
    UIAlertAction *imageAction = [UIAlertAction actionWithTitle:@"图片"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * _Nonnull action) {
                                                            [self addImageAnswerItem];
                                                        }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                         }];
    [alertVC addAction:fileAction];
    [alertVC addAction:videoAction];
    [alertVC addAction:imageAction];
    [alertVC addAction:cancelAction];
    
//    [self.vc.navigationController presentViewController:alertVC
//                                            animated:YES
//                                          completion:nil];
    
    [self presentVC:alertVC];
}

- (void)addFileAnswerItem:(NSArray *)allowedUTIs withHomeworkItem:(HomeworkAnswerItem *)item
{
    self.isAddingAnswerItem = YES;
    
    UIDocumentPickerViewController * picker = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:allowedUTIs inMode:UIDocumentPickerModeImport];
    picker.delegate = self;
    
    objc_setAssociatedObject(picker , &keyOfPickerDocument, item, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
//    [self.vc.navigationController presentViewController:picker animated:YES completion:nil];
    [self presentVC:picker];
}

- (void)addVideoAnswerItem {
    self.isAddingAnswerItem = YES;
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.mediaTypes = @[(NSString *)kUTTypeMovie];
    
//    [self.vc.navigationController presentViewController:picker animated:YES completion:nil];
    [self presentVC:picker];
}

- (void)addImageAnswerItem {
    self.isAddingAnswerItem = YES;
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.mediaTypes = @[(NSString *)kUTTypeImage];
    
//    [self.vc.navigationController presentViewController:picker animated:YES completion:nil];
    [self presentVC:picker];
}

- (void)deleteHomework {
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
                                                          }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:confirmAction];
//    [self.vc presentViewController:alertController animated:YES completion:nil];
    [self presentVC:alertController];
}

#pragma mark - 上传 音频、视频、图片、文件
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
                        
                        if (weakSelf.isAddingAnswerItem) {
                            HomeworkAnswerItem *item = [[HomeworkAnswerItem alloc] init];
                            item.type = HomeworkItemTypeVideo;
                            item.videoUrl = videoUrl;
                            item.itemTime = durationInSeconds;
                            item.videoCoverUrl = @"";
                            
                            [weakSelf.answerItems addObject:item];
                        } else{
                            HomeworkItem *item = [[HomeworkItem alloc] init];
                            item.type = HomeworkItemTypeVideo;
                            item.videoUrl = videoUrl;
                            item.videoCoverUrl = @"";
                            
                            [weakSelf.items addObject:item];
                        }
                        [weakSelf.tableView reloadData];
                        [weakSelf callBack];
                    }];
                });
            }else{
                NSLog(@"当前压缩进度:%f",exportSession.progress);
            }
            NSLog(@"%@",exportSession.error);
            
        }];
    }
}

- (void)uploadAudioFileForPath:(NSData *)data forHomeworkItem:(id)homework
{
    WeakifySelf;
    __block BOOL flag = NO;
    QNUploadOption * option = [[QNUploadOption alloc] initWithMime:nil progressHandler:^(NSString *key, float percent) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!weakSelf.mHud)
            {
                weakSelf.mHud = [HUD showProgressWithMessage:[NSString stringWithFormat:@"正在上传音频%.f%%...", percent * 100] cancelCallback:^{
                    flag = YES;
                }];
            }
            else
            {
                UILabel * label = [weakSelf.mHud.customView viewWithTag:99];
                
                label.text = [NSString stringWithFormat:@"正在上传音频%.f%%...", percent * 100];
            }
        });
    } params:nil checkCrc:NO cancellationSignal:^BOOL{
        return flag;
    }];
    
    [[FileUploader shareInstance] qn_uploadData:data type:UploadFileTypeAudio_Mp3 option:option completionBlock:^(NSString * _Nullable videoUrl, NSError * _Nullable error) {
        weakSelf.mHud = nil;
        if (videoUrl.length == 0) {
            [HUD showErrorWithMessage:@"音频上传失败"];
            return ;
        }
        [HUD showWithMessage:@"音频上传成功"];
        if (homework)
        {
            if (weakSelf.isAddingAnswerItem) {
                
                HomeworkAnswerItem *item = (HomeworkAnswerItem *)homework;
                item.type = HomeworkItemTypeAudio;
                item.audioUrl = videoUrl;
                NSString * cover = item.imageUrl;
                item.audioCoverUrl = cover;
                
            }
            else
            {
                HomeworkItem *item = (HomeworkItem *)homework;
                item.type = HomeworkItemTypeAudio;
                item.audioUrl = videoUrl;
                NSString * cover = item.imageUrl;
                item.audioCoverUrl = cover;
            }
        }
        else
        {
            if (weakSelf.isAddingAnswerItem) {
                HomeworkAnswerItem *item = [[HomeworkAnswerItem alloc] init];
                item.type = HomeworkItemTypeAudio;
                item.audioUrl = videoUrl;
                item.audioCoverUrl = @"";
                [weakSelf.answerItems addObject:item];
            } else{
                HomeworkItem *item = [[HomeworkItem alloc] init];
                item.type = HomeworkItemTypeAudio;
                item.audioUrl = videoUrl;
                item.audioCoverUrl = @"";
                [weakSelf.items addObject:item];
            }
        }
        [weakSelf.tableView reloadData];
        [weakSelf callBack];
    }];
}

- (void)uploadImageForPath:(UIImage *)image
{
    WeakifySelf;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = UIImageJPEGRepresentation(image, 0.8);
        dispatch_async(dispatch_get_main_queue(), ^{
            [HUD showProgressWithMessage:@"正在上传图片..."];
            
            QNUploadOption * option = [[QNUploadOption alloc] initWithProgressHandler:^(NSString *key, float percent) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [HUD showProgressWithMessage:[NSString stringWithFormat:@"正在上传图片%.f%%...", percent * 100]];
                });
            }];
            
            [[FileUploader shareInstance] qn_uploadData:data type:UploadFileTypeImage option:option completionBlock:^(NSString * _Nullable imageUrl, NSError * _Nullable error) {
                if (imageUrl.length == 0) {
                    
                    [HUD showErrorWithMessage:@"图片上传失败"];
                    return ;
                }
                [HUD showWithMessage:@"图片上传成功"];
                
                if (weakSelf.isAddingAnswerItem) {
                    HomeworkAnswerItem *item = [[HomeworkAnswerItem alloc] init];
                    item.type = HomeworkItemTypeImage;
                    item.imageUrl = imageUrl;
                    item.imageWidth = image.size.width;
                    item.imageHeight = image.size.height;
                    [weakSelf.answerItems addObject:item];
                } else {
                    HomeworkItem *item = [[HomeworkItem alloc] init];
                    item.type = HomeworkItemTypeImage;
                    item.imageUrl = imageUrl;
                    item.imageWidth = image.size.width;
                    item.imageHeight = image.size.height;
                    
                    [weakSelf.items addObject:item];
                }
                [weakSelf.tableView reloadData];
                [weakSelf callBack];
            }];
        });
    });
}

- (void)handleVideoPickerResult:(UIImagePickerController *)picker
  didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:^{
        NSURL *videoUrl = [info objectForKey:UIImagePickerControllerMediaURL];
        [self uploadVideoForPath:videoUrl];
    }];
}

- (void)handlePhotoPickerResult:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        if (image.size.width==0 || image.size.height==0) {
            [HUD showErrorWithMessage:@"图片选择失败"];
            return;
        }
        [self uploadImageForPath:image];
    }];
}


#pragma mark - UIDocumentPickerDelegate
- (void)documentPickerWasCancelled:(UIDocumentPickerViewController *)controller
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentAtURL:(NSURL *)url
{
    id homeworkItem = objc_getAssociatedObject(controller, &keyOfPickerDocument);
    
    if (controller.documentPickerMode == UIDocumentPickerModeImport)
    {
        // 通过文件协调器读取文件地址
        NSFileCoordinator *fileCoordinator = [[NSFileCoordinator alloc] initWithFilePresenter:nil];
        WeakifySelf;
        [fileCoordinator coordinateReadingItemAtURL:url options:NSFileCoordinatorReadingWithoutChanges error:nil  byAccessor:^(NSURL * _Nonnull newURL) {
            // 读取文件
            NSString *fileName = [newURL lastPathComponent];
            [weakSelf saveLocalCachesCont:newURL fileName:fileName withObject:homeworkItem];
            
        }];
    }
}

- (void)saveLocalCachesCont:(NSURL * )fileUrl fileName:(NSString *)name withObject:(id)object
{
    // 255216 jpg;
    // 13780 png;
    // 7368 mp3
    NSData *fileData = [NSData dataWithContentsOfURL:fileUrl];
    
    int char1 = 0 ,char2 =0 ; //必须这样初始化
    [fileData getBytes:&char1 range:NSMakeRange(0, 1)];
    [fileData getBytes:&char2 range:NSMakeRange(1, 1)];
    
    NSString * asciiStr = [NSString stringWithFormat:@"%i%i",char1,char2];
    
    if ([asciiStr isEqualToString:@"255216"] || [asciiStr isEqualToString:@"13780"])
    {
        UIImage * image = [UIImage imageWithData:fileData];
        if (image)
        {
            [self uploadImageForPath:image];
        }
    }
    else if([asciiStr isEqualToString:@"7368"])
    {
        [self uploadAudioFileForPath:fileData forHomeworkItem:object];
    }
    else
    {
        [self uploadVideoForPath:fileUrl];
    }
}

#pragma mark - UIImagePickerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    NSString* mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:@"public.movie"]) {
        [self handleVideoPickerResult:picker didFinishPickingMediaWithInfo:info];
    } else {
        [self handlePhotoPickerResult:picker didFinishPickingMediaWithInfo:info];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (void)callBack{
    
    if (self.isAddingAnswerItem) {
        
        if (self.addAnswerItemCallback) {
            self.addAnswerItemCallback(self.answerItems);
        }
    } else {
        if (self.addItemCallback) {
            self.addItemCallback(self.items);
        }
    }
}

@end
