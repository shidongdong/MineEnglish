//
//  CreateHomeworkViewController.m
//  X5Teacher
//
//  Created by yebw on 2018/1/22.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "CreateHomeworkViewController.h"
#import "HomeworkService.h"
#import "HomeworkLabelTableViewCell.h"
#import "HomeworkTagsTableViewCell.h"
#import "HomeworkTitleTableViewCell.h"
#import "HomeworkTextTableViewCell.h"
#import "HomeworkVideoTableViewCell.h"
#import "HomeworkAudioTableViewCell.h"
#import "HomeworkImageTableViewCell.h"
#import "HomeworkAddTableViewCell.h"
#import "TagService.h"
#import "TagsViewController.h"
#import "Homework.h"
#import "FileUploader.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVKit/AVKit.h>

@interface CreateHomeworkViewController ()<UITableViewDataSource, UITableViewDelegate,
UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, weak) IBOutlet UITableView *homeworkTableView;
@property (nonatomic, copy) NSString *homeworkTitle;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) NSMutableArray<HomeworkItem *> *items;
@property (nonatomic, strong) NSMutableArray<HomeworkAnswerItem *> *answerItems;
@property (nonatomic, strong) NSArray *tags;
@property (nonatomic, strong) NSMutableArray *selectedTags;
@property (nonatomic, assign) BOOL isAddingAnswerItem;

@end

@implementation CreateHomeworkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.homework == nil) {
        self.homework = [[Homework alloc] init];
        self.items = [[NSMutableArray alloc] init];
        self.answerItems = [[NSMutableArray alloc] init];
        self.selectedTags = [[NSMutableArray alloc] init];
    } else {
        self.customTitleLabel.text = @"作业详情";
        
        self.homeworkTitle = self.homework.title;
        
        HomeworkItem *item = self.homework.items[0];
        self.text = item.text;
        NSArray *items = [self.homework.items subarrayWithRange:NSMakeRange(1, self.homework.items.count-1)];
        self.items = [NSMutableArray arrayWithArray:items];
        
        if (self.homework.answerItems.count == 0) {
            self.answerItems = [[NSMutableArray alloc] init];
        } else {
            self.answerItems = [NSMutableArray arrayWithArray:self.homework.answerItems];
        }
        
        self.selectedTags = [NSMutableArray arrayWithArray:self.homework.tags];
    }
    
    self.homeworkTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(requestTags)
                                                 name:kNotificationKeyOfAddTags
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(requestTags)
                                                 name:kNotificationKeyOfDeleteTags
                                               object:nil];
    
    [self registerCellNibs];
    
    [self requestTags];
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

#pragma mark - IBAction

- (IBAction)saveButtonPressed:(id)sender {
    if (self.homeworkTitle.length == 0) {
        [HUD showErrorWithMessage:@"作业标题不能为空"];
        return;
    }
    
    if (self.text.length == 0 && self.items.count==0) {
        [HUD showErrorWithMessage:@"作业内容不能为空"];
        return;
    }
    
    NSMutableArray *items = [NSMutableArray arrayWithArray:self.items];
    
    HomeworkItem *textItem = [[HomeworkItem alloc] init];
    textItem.type = HomeworkItemTypeText;
    textItem.text = self.text==nil?@"":self.text;
    [items insertObject:textItem atIndex:0];
    
    self.homework.title = self.homeworkTitle;
    self.homework.items = items;
    self.homework.answerItems = self.answerItems;
    self.homework.tags = self.selectedTags;
    self.homework.createTeacher = APP.currentUser;
    
    if (self.homework.homeworkId == 0) {
        [HUD showProgressWithMessage:@"正在新建作业"];
    } else {
        [HUD showProgressWithMessage:@"正在更新作业"];
    }
    [HomeworkService createHomework:self.homework
                           callback:^(Result *result, NSError *error) {
                               if (error != nil) {
                                   if (self.homework.homeworkId == 0) {
                                       [HUD showErrorWithMessage:@"新建作业失败"];
                                   } else {
                                       [HUD showErrorWithMessage:@"更新作业失败"];
                                   }
                                   return;
                               }
                               
                               if (self.homework.homeworkId == 0) {
                                   [HUD showWithMessage:@"新建作业成功"];
                               } else {
                                   [HUD showWithMessage:@"更新作业成功"];
                               }
                               
                               [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationKeyOfAddHomework object:nil];
                               
                               [self.navigationController popViewControllerAnimated:YES];
                           }];
}

#pragma mark - Private Methods

- (void)registerCellNibs {
    [self.homeworkTableView registerNib:[UINib nibWithNibName:@"HomeworkLabelTableViewCell" bundle:nil] forCellReuseIdentifier:HomeworkLabelTableViewCellId];
    [self.homeworkTableView registerNib:[UINib nibWithNibName:@"HomeworkTitleTableViewCell" bundle:nil] forCellReuseIdentifier:HomeworkTitleTableViewCellId];
    [self.homeworkTableView registerNib:[UINib nibWithNibName:@"HomeworkTextTableViewCell" bundle:nil] forCellReuseIdentifier:HomeworkTextTableViewCellId];
    [self.homeworkTableView registerNib:[UINib nibWithNibName:@"HomeworkVideoTableViewCell" bundle:nil] forCellReuseIdentifier:HomeworkVideoTableViewCellId];
    [self.homeworkTableView registerNib:[UINib nibWithNibName:@"HomeworkAudioTableViewCell" bundle:nil] forCellReuseIdentifier:HomeworkAudioTableViewCellId];
    [self.homeworkTableView registerNib:[UINib nibWithNibName:@"HomeworkImageTableViewCell" bundle:nil] forCellReuseIdentifier:HomeworkImageTableViewCellId];
    [self.homeworkTableView registerNib:[UINib nibWithNibName:@"HomeworkTagsTableViewCell" bundle:nil] forCellReuseIdentifier:HomeworkTagsTableViewCellId];
    [self.homeworkTableView registerNib:[UINib nibWithNibName:@"HomeworkAddTableViewCell" bundle:nil] forCellReuseIdentifier:HomeworkAddTableViewCellId];
}

- (void)requestTags {
    [TagService requestTagsWithCallback:^(Result *result, NSError *error) {
        if (error != nil) {
            [HUD showErrorWithMessage:@"标签请求失败"];
            
            return ;
        }
        
        self.tags = (NSArray *)(result.userInfo);
        [self.homeworkTableView reloadData];
    }];
}

- (void)handleAddItem {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"选择作业材料类型"
                                                                     message:nil
                                                              preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *videoAction = [UIAlertAction actionWithTitle:@"视频"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * _Nonnull action) {
                                                            [self addVideoItem];
                                                        }];
    
    UIAlertAction *imageAction = [UIAlertAction actionWithTitle:@"图片"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * _Nonnull action) {
                                                            [self addImageItem];
                                                        }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                         }];
    
    [alertVC addAction:videoAction];
    [alertVC addAction:imageAction];
    [alertVC addAction:cancelAction];
    
    [self.navigationController presentViewController:alertVC
                                            animated:YES
                                          completion:nil];
}

- (void)addVideoItem {
    self.isAddingAnswerItem = NO;
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.mediaTypes = @[(NSString *)kUTTypeMovie];
    
    [self.navigationController presentViewController:picker animated:YES completion:nil];
}

- (void)addImageItem {
    self.isAddingAnswerItem = NO;
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.mediaTypes = @[(NSString *)kUTTypeImage];
    
    [self.navigationController presentViewController:picker animated:YES completion:nil];
}

- (void)handleAddAnswerItem {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"选择作业答案类型"
                                                                     message:nil
                                                              preferredStyle:UIAlertControllerStyleActionSheet];
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
    
    [alertVC addAction:videoAction];
    [alertVC addAction:imageAction];
    [alertVC addAction:cancelAction];
    
    [self.navigationController presentViewController:alertVC
                                            animated:YES
                                          completion:nil];
}

- (void)addVideoAnswerItem {
    self.isAddingAnswerItem = YES;
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.mediaTypes = @[(NSString *)kUTTypeMovie];
    
    [self.navigationController presentViewController:picker animated:YES completion:nil];
}

- (void)addImageAnswerItem {
    self.isAddingAnswerItem = YES;

    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.mediaTypes = @[(NSString *)kUTTypeImage];
    
    [self.navigationController presentViewController:picker animated:YES completion:nil];
}

- (void)deleteItem:(HomeworkItem *)item {
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
                                                              [self.items removeObject:item];
                                                              [self.homeworkTableView reloadData];
                                                          }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:confirmAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)deleteAnswerItem:(HomeworkAnswerItem *)item {
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
                                                              [self.answerItems removeObject:item];
                                                              [self.homeworkTableView reloadData];
                                                          }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:confirmAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
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
                                                              [self doDeleteHomework];
                                                          }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:confirmAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)doDeleteHomework {
    
}

- (void)handleVideoPickerResult:(UIImagePickerController *)picker
  didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:^{
        NSURL *videoUrl = [info objectForKey:UIImagePickerControllerMediaURL];
        NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%ld_compressedVideo.mp4",time(NULL)]];
        
        [HUD showProgressWithMessage:@"正在压缩视频文件..."];

        AVURLAsset *avAsset = [[AVURLAsset alloc] initWithURL:videoUrl options:nil];
        NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
        if ([compatiblePresets containsObject:AVAssetExportPresetHighestQuality]) {
            AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPreset1280x720];
            exportSession.outputURL = [NSURL fileURLWithPath:path];
            exportSession.shouldOptimizeForNetworkUse = true;
            exportSession.outputFileType = AVFileTypeMPEG4;
            
            [exportSession exportAsynchronouslyWithCompletionHandler:^{
                if ([exportSession status] == AVAssetExportSessionStatusCompleted) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [HUD showProgressWithMessage:@"正在上传视频..."];
                        
                        [FileUploader uploadDataWithLocalFilePath:path
                                                    progressBlock:^(NSInteger progress) {
                                                        [HUD showProgressWithMessage:[NSString stringWithFormat:@"正在上传视频%@%%...", @(progress)]];
                                                    }
                                                  completionBlock:^(NSString * _Nullable videoUrl, NSError * _Nullable error) {
                                                      if (videoUrl.length == 0) {
                                                          [HUD showErrorWithMessage:@"视频上传失败"];
                                                          
                                                          return ;
                                                      }
                                                      
                                                      [HUD showWithMessage:@"视频上传成功"];
                                                      
                                                      [[NSFileManager defaultManager] removeItemAtPath:path error:nil];

                                                      if (self.isAddingAnswerItem) {
                                                          HomeworkAnswerItem *item = [[HomeworkAnswerItem alloc] init];
                                                          item.type = HomeworkItemTypeVideo;
                                                          item.videoUrl = videoUrl;
                                                          item.videoCoverUrl = @"";
                                                          
                                                          [self.answerItems addObject:item];
                                                      } else{
                                                          HomeworkItem *item = [[HomeworkItem alloc] init];
                                                          item.type = HomeworkItemTypeVideo;
                                                          item.videoUrl = videoUrl;
                                                          item.videoCoverUrl = @"";
                                                          
                                                          [self.items addObject:item];
                                                      }

                                                      [self.homeworkTableView reloadData];
                                                  }];
                        
                    });
                }else{
                    NSLog(@"当前压缩进度:%f",exportSession.progress);
                }
                NSLog(@"%@",exportSession.error);
                
            }];
        }
    }];
}

- (void)handlePhotoPickerResult:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        if (image.size.width==0 || image.size.height==0) {
            [HUD showErrorWithMessage:@"图片选择失败"];
            return;
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *data = UIImageJPEGRepresentation(image, 0.8);
            dispatch_async(dispatch_get_main_queue(), ^{
                [HUD showProgressWithMessage:@"正在上传图片..."];
                
                [FileUploader uploadData:data
                                    type:UploadFileTypeImage
                           progressBlock:^(NSInteger progress) {
                               [HUD showProgressWithMessage:[NSString stringWithFormat:@"正在上传图片%@%%...", @(progress)]];
                           }
                         completionBlock:^(NSString * _Nullable imageUrl, NSError * _Nullable error) {
                             if (imageUrl.length == 0) {
                                 [HUD showErrorWithMessage:@"图片上传失败"];
                                 
                                 return ;
                             }
                             
                             [HUD showWithMessage:@"图片上传成功"];
                             
                             if (self.isAddingAnswerItem) {
                                 HomeworkAnswerItem *item = [[HomeworkAnswerItem alloc] init];
                                 item.type = HomeworkItemTypeImage;
                                 item.imageUrl = imageUrl;
                                 item.imageWidth = image.size.width;
                                 item.imageHeight = image.size.height;
                                 
                                 [self.answerItems addObject:item];
                             } else {
                                 HomeworkItem *item = [[HomeworkItem alloc] init];
                                 item.type = HomeworkItemTypeImage;
                                 item.imageUrl = imageUrl;
                                 item.imageWidth = image.size.width;
                                 item.imageHeight = image.size.height;
                                 
                                 [self.items addObject:item];
                             }

                             [self.homeworkTableView reloadData];
                         }];
            });
        });
    }];
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


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numberOfRows = 2; // 标题 + 文本
    
    numberOfRows += 1;// 添加材料文案
    
    numberOfRows += self.items.count;
    
    numberOfRows += 1; // 添加材料按钮
    
    numberOfRows += 1; // 添加答案文案
    
    numberOfRows += self.answerItems.count;
    
    numberOfRows += 1; // 添加答案按钮
    
    numberOfRows += 1; // tag
    
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    
    if (indexPath.row == 0) { // 文本
        WeakifySelf;
        
        HomeworkTitleTableViewCell *titleCell = [tableView dequeueReusableCellWithIdentifier:HomeworkTitleTableViewCellId forIndexPath:indexPath];
        
        [titleCell setupWithText:self.homeworkTitle];
        
        __weak HomeworkTitleTableViewCell *weakTitleCell = titleCell;
        __weak UITableView *weakTableView = tableView;
        titleCell.callback = ^(NSString *text, BOOL heightChanged) {
            weakSelf.homeworkTitle = text;
            
            if (heightChanged) {
                [weakTableView beginUpdates];
                [weakTableView endUpdates];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakTitleCell ajustTextView];
                });
            }
        };
        
        cell = titleCell;
    } else if (indexPath.row == 1) { // 文本
        WeakifySelf;
        
        HomeworkTextTableViewCell *textCell = [tableView dequeueReusableCellWithIdentifier:HomeworkTextTableViewCellId forIndexPath:indexPath];
        
        [textCell setupWithText:self.text];
        
        __weak HomeworkTextTableViewCell *weakTextCell = textCell;
        __weak UITableView *weakTableView = tableView;
        textCell.callback = ^(NSString *text, BOOL heightChanged) {
            weakSelf.text = text;
            
            if (heightChanged) {
                [weakTableView beginUpdates];
                [weakTableView endUpdates];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakTextCell ajustTextView];
                });
            }
        };
        
        cell = textCell;
    } else if (indexPath.row == 2) { // 添加材料标签
        HomeworkLabelTableViewCell *labelCell = [tableView dequeueReusableCellWithIdentifier:HomeworkLabelTableViewCellId forIndexPath:indexPath];
        
        [labelCell setupWithText:@"添加材料:"];
        
        cell = labelCell;
    } else if (indexPath.row > 2 && indexPath.row < 2 + self.items.count + 1) { // 材料
        NSInteger row = indexPath.row - 3;
        HomeworkItem *item = self.items[row];
        NSString *type = item.type;
        if ([type isEqualToString:HomeworkItemTypeVideo]) {
            HomeworkVideoTableViewCell *videoCell = [tableView dequeueReusableCellWithIdentifier:HomeworkVideoTableViewCellId forIndexPath:indexPath];
            
            [videoCell setupWithVideoUrl:item.videoUrl coverUrl:item.videoCoverUrl];
            
            WeakifySelf;
            [videoCell setDeleteCallback:^{
                [weakSelf deleteItem:item];
            }];
            
            cell = videoCell;
        } else if ([type isEqualToString:HomeworkItemTypeImage]) {
            HomeworkImageTableViewCell *imageCell = [tableView dequeueReusableCellWithIdentifier:HomeworkImageTableViewCellId forIndexPath:indexPath];
            
            [imageCell setupWithImageUrl:item.imageUrl];
            
            WeakifySelf;
            [imageCell setDeleteCallback:^{
                [weakSelf deleteItem:item];
            }];
            
            cell = imageCell;
        }
    } else if (indexPath.row == 2 + self.items.count + 1) { // 添加按钮
        HomeworkAddTableViewCell *addCell = [tableView dequeueReusableCellWithIdentifier:HomeworkAddTableViewCellId forIndexPath:indexPath];
        
        WeakifySelf;
        [addCell setAddCallback:^{
            [weakSelf handleAddItem];
        }];
        
        cell = addCell;
    } else if (indexPath.row == 2 + self.items.count + 2) { // 标签
        HomeworkLabelTableViewCell *labelCell = [tableView dequeueReusableCellWithIdentifier:HomeworkLabelTableViewCellId forIndexPath:indexPath];
        
        [labelCell setupWithText:@"添加答案:"];
        
        cell = labelCell;
    } else if (indexPath.row > 2 + self.items.count + 2 &&
               indexPath.row < 2 + self.items.count + 2 + self.answerItems.count + 1) {
        NSInteger row = indexPath.row - (2 + self.items.count + 3);
        HomeworkAnswerItem *item = self.answerItems[row];
        NSString *type = item.type;
        if ([type isEqualToString:HomeworkItemTypeVideo]) {
            HomeworkVideoTableViewCell *videoCell = [tableView dequeueReusableCellWithIdentifier:HomeworkVideoTableViewCellId forIndexPath:indexPath];
            
            [videoCell setupWithVideoUrl:item.videoUrl coverUrl:item.videoCoverUrl];
            
            WeakifySelf;
            [videoCell setDeleteCallback:^{
                [weakSelf deleteAnswerItem:item];
            }];
            
            cell = videoCell;
        } else if ([type isEqualToString:HomeworkItemTypeImage]) {
            HomeworkImageTableViewCell *imageCell = [tableView dequeueReusableCellWithIdentifier:HomeworkImageTableViewCellId forIndexPath:indexPath];
            
            [imageCell setupWithImageUrl:item.imageUrl];
            
            WeakifySelf;
            [imageCell setDeleteCallback:^{
                [weakSelf deleteAnswerItem:item];
            }];
            
            cell = imageCell;
        }
    } else if (indexPath.row == 2 + self.items.count + 2 + self.answerItems.count + 1) {
        HomeworkAddTableViewCell *addCell = [tableView dequeueReusableCellWithIdentifier:HomeworkAddTableViewCellId forIndexPath:indexPath];
        
        WeakifySelf;
        [addCell setAddCallback:^{
            [weakSelf handleAddAnswerItem];
        }];
        
        cell = addCell;
    } else {
        HomeworkTagsTableViewCell *tagsCell = [tableView dequeueReusableCellWithIdentifier:HomeworkTagsTableViewCellId forIndexPath:indexPath];
        
        [tagsCell setupWithTags:self.tags selectedTags:self.selectedTags];
        
        WeakifySelf;
        [tagsCell setSelectCallback:^(NSString *tag) {
            if ([weakSelf.selectedTags containsObject:tag]) {
                [weakSelf.selectedTags removeObject:tag];
            } else {
                [weakSelf.selectedTags addObject:tag];
            }
        }];
        
        [tagsCell setManageCallback:^{
            TagsViewController *tagsVC = [[TagsViewController alloc] initWithNibName:@"TagsViewController" bundle:nil];
            [weakSelf.navigationController pushViewController:tagsVC animated:YES];
        }];
        
        cell = tagsCell;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0.f;
    
    if (indexPath.row == 0) { // 标题
        height = [HomeworkTextTableViewCell cellHeightWithText:self.homeworkTitle];
    } else if (indexPath.row == 1) { // 文本
        height = [HomeworkTextTableViewCell cellHeightWithText:self.text];
    } else if (indexPath.row == 2) { // 标签
        height = HomeworkLabelTableViewCellHeight;
    } else if (indexPath.row > 2 && indexPath.row < 2 + self.items.count + 1) { // 材料
        NSInteger row = indexPath.row - 3;
        HomeworkItem *item = self.items[row];
        NSString *type = item.type;
        if ([type isEqualToString:HomeworkItemTypeVideo]) {
            height = HomeworkVideoTableViewCellHeight;
        } else if ([type isEqualToString:HomeworkItemTypeImage]) {
            height = HomeworkImageTableViewCellHeight;
        }
    } else if (indexPath.row == 2 + self.items.count + 1) { // 添加按钮
        height = HomeworkAddTableViewCellHeight;
    } else if (indexPath.row == 2 + self.items.count + 2) { // 标签
        height = HomeworkLabelTableViewCellHeight;
    } else if (indexPath.row > 2 + self.items.count + 2 &&
               indexPath.row < 2 + self.items.count + 2 + self.answerItems.count + 1) {
        NSInteger row = indexPath.row - (2 + self.items.count + 3);
        HomeworkAnswerItem *item = self.answerItems[row];
        NSString *type = item.type;
        if ([type isEqualToString:HomeworkItemTypeVideo]) {
            height = HomeworkVideoTableViewCellHeight;
        } else if ([type isEqualToString:HomeworkItemTypeImage]) {
            height = HomeworkImageTableViewCellHeight;
        }
    } else if (indexPath.row == 2 + self.items.count + 2 + self.answerItems.count + 1) {
        height = HomeworkAddTableViewCellHeight;
    } else {
        height = [HomeworkTagsTableViewCell heightWithTags:self.tags];
    }
    
    return height;
}

@end


