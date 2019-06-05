//
//  MICreateTaskViewController.m
//  MinnieManager
//
//  Created by songzhen on 2019/6/3.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import <YYCategories/NSDate+YYAdd.h>
#import "TagService.h"
#import "HomeworkService.h"
#import "DatePickerView.h"
#import "MIExpandPickerView.h"
#import "ChooseDatePickerView.h"
#import "MITagsViewController.h"
#import "MITagsTableViewCell.h"
#import "MIAddTypeTableViewCell.h"
#import "MITitleTypeTableViewCell.h"
#import "MIInPutTypeTableViewCell.h"
#import "MISegmentTypeTableViewCell.h"
#import "MIExpandSelectTypeTableViewCell.h"
#import "MICreateTaskViewController.h"
#import "CSCustomSplitViewController.h"

#import "HomeworkVideoTableViewCell.h"
#import "HomeworkImageTableViewCell.h"
#import "HomeworkAudioTableViewCell.h"

//
//#import <objc/runtime.h>
//#import <AVKit/AVKit.h>
//#import "FileUploader.h"
//#import <AssetsLibrary/AssetsLibrary.h>
//#import <MobileCoreServices/MobileCoreServices.h>

@interface MICreateTaskViewController ()<
UITableViewDelegate,
UITableViewDataSource,
ChooseDatePickerViewDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
UIDocumentPickerDelegate
>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *leftTableView;
@property (weak, nonatomic) IBOutlet UITableView *rightTableView;
@property (assign, nonatomic) NSInteger leftRowCount;

@property (nonatomic, strong) NSMutableArray *createTypeArray;
@property (nonatomic,assign) MIHomeworkTaskType taskType;   // 任务类型

@property (nonatomic, strong) Homework *homework;           // 为空创建作业
@property (nonatomic, strong) ActivityInfo *activityInfo;   // 为空创建活动


@property (nonatomic, strong) HomeworkItem *wordsItem;    // 内容 word文本格式
@property (nonatomic, strong) HomeworkItem *contentItem;    // 内容 text文本格式

@property (nonatomic, strong) NSMutableArray<HomeworkItem *> *items;// 材料
@property (nonatomic, strong) NSMutableArray<HomeworkAnswerItem *> *answerItems; // 答案
@property (nonatomic, strong) NSMutableArray<HomeworkItem *> *followItems;// 跟读材料

@property (nonatomic, assign) BOOL isAddingAnswerItem;

@property (nonatomic, strong) NSArray *tags;
@property (nonatomic, strong) NSArray *formTags;
@property (nonatomic, strong) NSString * selectFormTag;
@property (nonatomic, strong) NSMutableArray *selectedTags;

@property (nonatomic, assign) NSInteger categoryType;
@property (nonatomic, assign) NSInteger styleType;
@property (nonatomic, assign) NSInteger level;
@property (nonatomic, assign) NSInteger limitTimeSecs;
@property (nonatomic, strong) MBProgressHUD * mHud;


@property (nonatomic, assign) NSInteger isCreateTask;

@end

@implementation MICreateTaskViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self updateSplit:90];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self updateSplit:90+204];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.leftTableView.separatorColor = [UIColor clearColor];
    self.rightTableView.separatorColor = [UIColor clearColor];
    
    self.leftTableView.delegate = self;
    self.leftTableView.dataSource = self;
    self.rightTableView.delegate = self;
    self.rightTableView.dataSource = self;
    
    [self registerCellNibs];
  
    self.leftTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.rightTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self registerCellNibs];
    
    [self setupTitleWithTaskType:self.taskType];
    
    [self requestTags];
    [self requestFormTags];
}

- (IBAction)closeBtnAction:(id)sender {
 
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)sendBtnAction:(id)sender {
    
    if (self.callBack) {
        self.callBack();
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationKeyOfAddHomework object:nil];
    [self.navigationController popViewControllerAnimated:YES];
    return;
    if (self.homework.title.length == 0) {
        [HUD showErrorWithMessage:@"作业标题不能为空"];
        return;
    }
    if (self.contentItem.text.length == 0) {
        [HUD showErrorWithMessage:@"作业内容不能为空"];
        return;
    }
    NSMutableArray *resultItems = [NSMutableArray array];
    [resultItems addObject:self.contentItem];
    [resultItems addObject:self.wordsItem];
    [resultItems addObjectsFromArray:self.items];
    [resultItems addObjectsFromArray:self.followItems];
    
    self.homework.tags = self.selectedTags;
    self.homework.formTag = self.selectFormTag;
    self.homework.items = resultItems;
    self.homework.answerItems = self.answerItems;
    
    if (self.homework.homeworkId == 0) {
        [HUD showProgressWithMessage:@"正在新建作业"];
    } else {
        [HUD showProgressWithMessage:@"正在更新作业"];
    }
    WeakifySelf;
    [HomeworkService createHomework:self.homework
                           callback:^(Result *result, NSError *error) {
                               if (error != nil) {
                                   if (weakSelf.homework.homeworkId == 0) {
                                       [HUD showErrorWithMessage:@"新建作业失败"];
                                   } else {
                                       [HUD showErrorWithMessage:@"更新作业失败"];
                                   }
                                   return;
                               }
                               
                               if (weakSelf.homework.homeworkId == 0) {
                                   [HUD showWithMessage:@"新建作业成功"];
                               } else {
                                   [HUD showWithMessage:@"更新作业成功"];
                               }
                               if (weakSelf.callBack) {
                                   weakSelf.callBack();
                               }
                               
                               [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationKeyOfAddHomework object:nil];
                               [weakSelf.navigationController popViewControllerAnimated:YES];
                           }];
}

- (void)updateSplit:(NSInteger)offset{
    
    UIViewController *vc = self.parentViewController;
    while (1) {
        if ([vc isKindOfClass:[CSCustomSplitViewController  class]]) {
            break;
        } else {
            vc = vc.parentViewController;
        }
    }
    if ([vc isKindOfClass:[CSCustomSplitViewController  class]]) {
        
        CSCustomSplitViewController *detailVC = (CSCustomSplitViewController *)vc;
        
        detailVC.primaryCloumnScale = offset;
        [detailVC setDisplayMode:CSSplitDisplayModeDisplayPrimaryAndSecondary withAnimated:YES];
    }
}


- (void)setupCreateActivity:(ActivityInfo *)activity{
    
    self.activityInfo = activity;
    self.taskType = MIHomeworkTaskType_Activity;
    [self setupTitleWithTaskType:self.taskType];
    
    if (self.activityInfo) {
        
        for (int i = 0; i < self.activityInfo.items.count; i++) {
           
            HomeworkItem *item = self.activityInfo.items[i];
            if (i == 0) {   // 内容
                self.contentItem = item;
            } else { // 附件
                [self.items addObject:item];
            }
        }
    }
    self.leftRowCount = 7;
    [self.createTypeArray removeAllObjects];
    [self.createTypeArray addObjectsFromArray:[self getNumberOfRowsInSection]];
    [self.leftTableView reloadData];
    [self.rightTableView reloadData];
}


- (void)setupCreateHomework:(Homework *_Nullable)homework taskType:(MIHomeworkTaskType)taskType{
    
    if (homework == nil) {
        self.isCreateTask = YES;
        self.limitTimeSecs = 300;
        //作业类型：日常1、假期2、集训3
        self.homework.style = 1;
        self.homework.level = 1;
        self.homework.category = 1;
        self.homework.limitTimes = 300;
        self.homework.examType = 1;
    } else {
        self.isCreateTask = NO;
        self.homework = homework;
        
        self.selectFormTag = self.homework.formTag;
        self.selectedTags = [NSMutableArray arrayWithArray:self.homework.tags];
    }
    self.taskType = taskType;
    
    [self updateHomeworkInfo];
    
    [self.createTypeArray removeAllObjects];
    [self.createTypeArray addObjectsFromArray:[self getNumberOfRowsInSection]];
    self.leftRowCount = 7;
    
    [self.leftTableView reloadData];
    [self.rightTableView reloadData];
}

- (void)updateHomeworkInfo{
    
    if (self.homework) {
        
        for (int i = 0; i < self.homework.items.count; i++) {
            HomeworkItem *item = self.homework.items[i];
            if (i == 0) {   // 内容
                self.contentItem = item;
            } else if ([item.type isEqualToString:@"word"] ) {// 单词
                self.wordsItem = item;
            } else { // 附件
                [self.items addObject:item];
            }
        }
        self.selectFormTag = self.homework.formTag;
        self.selectedTags = [NSMutableArray arrayWithArray:self.homework.tags];
        [self.followItems removeAllObjects];
        [self.followItems addObjectsFromArray:self.homework.otherItem];
        [self.answerItems removeAllObjects];
        [self.answerItems addObjectsFromArray:self.homework.answerItems];
    }
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == self.leftTableView) {
        
        return self.leftRowCount;
    } else {
        return self.createTypeArray.count - self.leftRowCount;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    if (tableView == self.leftTableView) {
        
        NSNumber *createTypeNum = self.createTypeArray[indexPath.row];
        cell = [self getTableViewCellAtIndexPath:indexPath
                                      createType:createTypeNum.integerValue
                                       tableView:self.leftTableView];
    } else {
        
        NSNumber *createTypeNum = self.createTypeArray[indexPath.row + self.leftRowCount];
        cell = [self getTableViewCellAtIndexPath:indexPath
                                      createType:createTypeNum.integerValue
                                       tableView:self.rightTableView];
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSNumber *createTypeNum;
    if (tableView == self.leftTableView) {
        createTypeNum = self.createTypeArray[indexPath.row];
    } else {
        createTypeNum = self.createTypeArray[indexPath.row + self.leftRowCount];
    }
    return [self getHeightForRowWithCreateType:createTypeNum.integerValue];
}

#pragma mark - 设置标题
- (void)setupTitleWithTaskType:(MIHomeworkTaskType)taskType{
    
    switch (taskType) {
        case MIHomeworkTaskType_notify:
            self.titleLabel.text = self.isCreateTask ? @"新建通知" : @"通知详情";
            break;
        case MIHomeworkTaskType_FollowUp:
            self.titleLabel.text = self.isCreateTask ? @"新建跟读" : @"跟读详情";
            break;
        case MIHomeworkTaskType_WordMemory:
            self.titleLabel.text = self.isCreateTask ? @"新建单词记忆" : @"单词记忆详情";
            break;
        case MIHomeworkTaskType_GeneralTask:
            self.titleLabel.text = self.isCreateTask ? @"新建普通作业" : @"普通作业详情";
            break;
        case MIHomeworkTaskType_Activity:
            self.titleLabel.text = self.isCreateTask ? @"新建活动" : @"活动详情";
            break;
        case MIHomeworkTaskType_ExaminationStatistics:
            self.titleLabel.text = self.isCreateTask ? @"新建考试统计" : @"考试统计详情";
            break;
        default:
            break;
    }
}

- (UITableViewCell *)getTableViewCellAtIndexPath:(NSIndexPath *)indexPath
                                      createType:(MIHomeworkCreateContentType) createType
                                       tableView:(UITableView *)tableView
{
    
    WeakifySelf;
    UITableViewCell *cell;
    switch (createType) {
        case MIHomeworkCreateContentType_Localtion:
        {
            MIExpandSelectTypeTableViewCell *contentCell = [tableView dequeueReusableCellWithIdentifier:MIExpandSelectTypeTableViewCellId forIndexPath:indexPath];
            
            __weak MIExpandSelectTypeTableViewCell *weakContentCell = contentCell;
            contentCell.leftExpandCallback = ^{
                
                MIExpandPickerView * chooseDataPicker = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MIExpandPickerView class]) owner:nil options:nil] lastObject];
                FileInfo *file = [[FileInfo alloc] init];
                file.fileName = @"文件夹1";
                
                FileInfo *file1 = [[FileInfo alloc] init];
                file1.fileName = @"文件夹2";
                
                FileInfo *file2 = [[FileInfo alloc] init];
                file2.fileName = @"文件夹3";
                
                self.homework.fileInfos.parentFile = file2;
                [chooseDataPicker setDefultFileInfo:
                 self.homework.fileInfos.parentFile fileArray:(NSArray<FileInfo>*)@[file,file1,file2]];
                WeakifySelf;
                chooseDataPicker.localCallback = ^(FileInfo * _Nonnull result) {
                    weakSelf.homework.fileInfos.parentFile = result;
                    [weakContentCell setupWithLeftText:result.fileName
                                             rightText:weakSelf.homework.fileInfos.subFile.fileName
                                            createType:createType];
                    
                };
                [chooseDataPicker show];
            };
            contentCell.rightExpandCallback = ^{
                
                MIExpandPickerView * chooseDataPicker = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MIExpandPickerView class]) owner:nil options:nil] lastObject];
                FileInfo *file = [[FileInfo alloc] init];
                file.fileName = @"子文件夹1";
                
                FileInfo *file1 = [[FileInfo alloc] init];
                file1.fileName = @"子文件夹2";
                
                FileInfo *file2 = [[FileInfo alloc] init];
                file2.fileName = @"子文件夹3";
                
                self.homework.fileInfos.subFile = file1;
                [chooseDataPicker setDefultFileInfo:
                 self.homework.fileInfos.subFile fileArray:(NSArray<FileInfo>*)@[file,file1,file2]];
                chooseDataPicker.localCallback = ^(FileInfo * _Nonnull result) {
                    weakSelf.homework.fileInfos.subFile = result;
                    [weakContentCell setupWithLeftText:weakSelf.homework.fileInfos.parentFile.fileName
                                             rightText:result.fileName
                                            createType:createType];
                };
                [chooseDataPicker show];
            };
            [contentCell setupWithLeftText:weakSelf.homework.fileInfos.parentFile.fileName
                                 rightText:weakSelf.homework.fileInfos.subFile.fileName
                                createType:createType];
            cell = contentCell;
        }
            break;
        case MIHomeworkCreateContentType_Title:
        {
            MIInPutTypeTableViewCell *titleCell = [tableView dequeueReusableCellWithIdentifier:MIInPutTypeTableViewCellId forIndexPath:indexPath];
            __weak MIInPutTypeTableViewCell *weakTitleCell = titleCell;
            __weak UITableView *weakTableView = tableView;
            titleCell.callback = ^(NSString *text, BOOL heightChanged) {
                weakSelf.homework.title = text;
                if (heightChanged) {
                    [weakTableView beginUpdates];
                    [weakTableView endUpdates];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakTitleCell ajustTextView];
                    });
                }
            };
            [titleCell setupWithText:self.homework.title
                               title:@"标题:"
                          createType:createType
                         placeholder:@"输入题目"];
            cell = titleCell;
        }
            break;
        case MIHomeworkCreateContentType_Content:
        {
            MIInPutTypeTableViewCell *contentCell = [tableView dequeueReusableCellWithIdentifier:MIInPutTypeTableViewCellId forIndexPath:indexPath];
            
            __weak MIInPutTypeTableViewCell *weakContentCell = contentCell;
            __weak UITableView *weakTableView = tableView;
            contentCell.callback = ^(NSString *text, BOOL heightChanged) {
                
                weakSelf.contentItem.text = text;
                if (heightChanged) {
                    [weakTableView beginUpdates];
                    [weakTableView endUpdates];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakContentCell ajustTextView];
                    });
                }
            };
            [contentCell setupWithText:self.contentItem.text
                                 title:@"内容:"
                            createType:createType
                           placeholder:@"输入作业题目或具体要求"];
            cell = contentCell;
        }
            break;
        case MIHomeworkCreateContentType_MarkingRemarks:
        {
            MIInPutTypeTableViewCell *contentCell = [tableView dequeueReusableCellWithIdentifier:MIInPutTypeTableViewCellId forIndexPath:indexPath];
            
            __weak MIInPutTypeTableViewCell *weakContentCell = contentCell;
            __weak UITableView *weakTableView = tableView;
            contentCell.callback = ^(NSString *text, BOOL heightChanged) {
                weakSelf.homework.teremark = text;
                if (heightChanged) {
                    [weakTableView beginUpdates];
                    [weakTableView endUpdates];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakContentCell ajustTextView];
                    });
                }
            };
            [contentCell setupWithText:self.homework.teremark
                                 title:@"批改备注:"
                            createType:createType
                           placeholder:@"输入批改要求"];
            cell = contentCell;
        }
            break;
        case MIHomeworkCreateContentType_ActivityReq:
        {
            MIInPutTypeTableViewCell *contentCell = [tableView dequeueReusableCellWithIdentifier:MIInPutTypeTableViewCellId forIndexPath:indexPath];
            
            __weak MIInPutTypeTableViewCell *weakContentCell = contentCell;
            __weak UITableView *weakTableView = tableView;
            contentCell.callback = ^(NSString *text, BOOL heightChanged) {
                weakSelf.contentItem.text = text;
                if (heightChanged) {
                    [weakTableView beginUpdates];
                    [weakTableView endUpdates];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakContentCell ajustTextView];
                    });
                }
            };
            [contentCell setupWithText:self.contentItem.text
                                 title:@"活动要求:"
                            createType:createType
                           placeholder:@"请输入活动或具体要求"];
            cell = contentCell;
        }
            break;
        case MIHomeworkCreateContentType_StatisticalType:
        {
            MISegmentTypeTableViewCell *contentCell = [tableView dequeueReusableCellWithIdentifier:MISegmentTypeTableViewCellId forIndexPath:indexPath];
            WeakifySelf;
            contentCell.callback = ^(NSInteger selectIndex) {
                weakSelf.homework.category = selectIndex;
            };
            [contentCell setupWithSelectIndex:self.homework.category createType:createType];
            cell = contentCell;
        }
            break;
        case MIHomeworkCreateContentType_CommitTime:
        {
            MISegmentTypeTableViewCell *contentCell = [tableView dequeueReusableCellWithIdentifier:MISegmentTypeTableViewCellId forIndexPath:indexPath];
            WeakifySelf;
            contentCell.callback = ^(NSInteger selectIndex) {
                weakSelf.homework.style = selectIndex;
            };
            [contentCell setupWithSelectIndex:self.homework.style createType:createType];
            cell = contentCell;
        }
            break;
        case MIHomeworkCreateContentType_HomeworkDifficulty:
        {
            MISegmentTypeTableViewCell *contentCell = [tableView dequeueReusableCellWithIdentifier:MISegmentTypeTableViewCellId forIndexPath:indexPath];
            WeakifySelf;
            contentCell.callback = ^(NSInteger selectIndex) {
                weakSelf.homework.level = selectIndex;
            };
            [contentCell setupWithSelectIndex:self.homework.level createType:createType];
            cell = contentCell;
        }
            break;
        case MIHomeworkCreateContentType_WordsTimeInterval:
        {
            MIExpandSelectTypeTableViewCell *contentCell = [tableView dequeueReusableCellWithIdentifier:MIExpandSelectTypeTableViewCellId forIndexPath:indexPath];
            
            __weak  MIExpandSelectTypeTableViewCell *weakContentCell = contentCell;
            NSString *wordPlayTime = [NSString stringWithFormat:@"%lu",self.wordsItem.palytime];
            contentCell.expandCallback = ^{
                MIExpandPickerView * chooseDataPicker = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MIExpandPickerView class]) owner:nil options:nil] firstObject];
                chooseDataPicker.callback = ^(NSString * _Nonnull text) {
                    weakSelf.wordsItem.palytime = text.integerValue;
                    [weakContentCell setupWithLeftText:text rightText:nil createType:createType];
                };
                [chooseDataPicker setDefultText:wordPlayTime createType:createType];
                [chooseDataPicker show];
            };
            [contentCell setupWithLeftText:wordPlayTime rightText:nil createType:createType];
            cell = contentCell;
        }
            break;
        case MIHomeworkCreateContentType_AddWords:
        {
            MITitleTypeTableViewCell *contentCell = [tableView dequeueReusableCellWithIdentifier:MITitleTypeTableViewCellId forIndexPath:indexPath];
            contentCell.title = @"添加单词:";
            contentCell.addItemCallback = ^(NSArray * _Nullable items) {
            };
            //            [contentCell setupWithItems:@[self.wordsItem] vc:self];
            [contentCell setupWithItems:@[] vc:self];
            cell = contentCell;
        }
            break;
        case MIHomeworkCreateContentType_Materials:
        {
            MITitleTypeTableViewCell *contentCell = [tableView dequeueReusableCellWithIdentifier:MITitleTypeTableViewCellId forIndexPath:indexPath];
            contentCell.title = @"添加材料:";
            __weak MITitleTypeTableViewCell *weakContentCell = contentCell;
            __weak UITableView *weakTableView = tableView;
            contentCell.addItemCallback = ^(NSArray * _Nullable items) {
                [weakSelf.items removeAllObjects];
                [weakSelf.items addObjectsFromArray:items];
                [weakContentCell setupWithItems:weakSelf.items vc:weakSelf];
                [weakTableView beginUpdates];
                [weakTableView endUpdates];
            };
            [contentCell setupWithItems:self.items vc:self];
            cell = contentCell;
        }   break;
        case MIHomeworkCreateContentType_Answer:
        {
            MITitleTypeTableViewCell *contentCell = [tableView dequeueReusableCellWithIdentifier:MITitleTypeTableViewCellId forIndexPath:indexPath];
            contentCell.title = @"添加答案:";
            __weak MITitleTypeTableViewCell *weakContentCell = contentCell;
            __weak UITableView *weakTableView = tableView;
            contentCell.addAnswerItemCallback = ^(NSArray * _Nullable anwserItems) {
                [weakSelf.answerItems removeAllObjects];
                [weakSelf.answerItems addObjectsFromArray:anwserItems];
                [weakContentCell setupWithAnswerItems:weakSelf.answerItems vc:weakSelf];
                [weakTableView beginUpdates];
                [weakTableView endUpdates];
            };
            [contentCell setupWithAnswerItems:self.answerItems vc:self];
            cell = contentCell;
        }
            break;
        case MIHomeworkCreateContentType_AddCovers:
        {
            MITitleTypeTableViewCell *contentCell = [tableView dequeueReusableCellWithIdentifier:MITitleTypeTableViewCellId forIndexPath:indexPath];
            contentCell.title = @"添加封面:";
            __weak MITitleTypeTableViewCell *weakContentCell = contentCell;
            __weak UITableView *weakTableView = tableView;
            contentCell.addItemCallback = ^(NSArray * _Nullable items) {
                
                weakSelf.activityInfo.coverItems = items.firstObject;
                [weakContentCell setupWithItems:items vc:weakSelf];
                [weakTableView beginUpdates];
                [weakTableView endUpdates];
            };
            [contentCell setupWithItems:@[] vc:self];
            //            [contentCell setupWithItems:@[self.activityInfo.coverItems] vc:self];
            cell = contentCell;
        }
            break;
        case MIHomeworkCreateContentType_AddBgMusic:
        {
            MITitleTypeTableViewCell *contentCell = [tableView dequeueReusableCellWithIdentifier:MITitleTypeTableViewCellId forIndexPath:indexPath];
            contentCell.title = @"添加背景音乐:";
            __weak MITitleTypeTableViewCell *weakContentCell = contentCell;
            __weak UITableView *weakTableView = tableView;
            contentCell.addItemCallback = ^(NSArray * _Nullable items) {
                
                weakSelf.wordsItem = items.firstObject;
                [weakContentCell setupWithItems:items vc:weakSelf];
                [weakTableView beginUpdates];
                [weakTableView endUpdates];
            };
            [contentCell setupWithItems:@[self.wordsItem] vc:self];
            [contentCell setupWithItems:@[] vc:self];
            cell = contentCell;
        }
            break;
        case MIHomeworkCreateContentType_AddFollowMaterials:
        {
            MITitleTypeTableViewCell *contentCell = [tableView dequeueReusableCellWithIdentifier:MITitleTypeTableViewCellId forIndexPath:indexPath];
            contentCell.title = @"添加跟读材料:";
            __weak MITitleTypeTableViewCell *weakContentCell = contentCell;
            __weak UITableView *weakTableView = tableView;
            contentCell.addItemCallback = ^(NSArray * _Nullable items) {
                [weakSelf.followItems removeAllObjects];
                [weakSelf.followItems addObjectsFromArray:items];
                [weakContentCell setupWithItems:weakSelf.followItems vc:weakSelf];
                [weakTableView beginUpdates];
                [weakTableView endUpdates];
            };
            //            [contentCell setupWithItems:self.followItems vc:self];
            [contentCell setupWithItems:@[] vc:self];
            cell = contentCell;
        }
            break;
        case MIHomeworkCreateContentType_ExaminationType:
        {
            MISegmentTypeTableViewCell *contentCell = [tableView dequeueReusableCellWithIdentifier:MISegmentTypeTableViewCellId forIndexPath:indexPath];
            contentCell.callback = ^(NSInteger selectIndex) {
                weakSelf.homework.examType = selectIndex;
            };
            [contentCell setupWithSelectIndex:self.homework.examType createType:createType];
            cell = contentCell;
        }
            break;
        case MIHomeworkCreateContentType_TimeLimit:
        {
            MIExpandSelectTypeTableViewCell *contentCell = [tableView dequeueReusableCellWithIdentifier:MIExpandSelectTypeTableViewCellId forIndexPath:indexPath];
            
            __weak MIExpandSelectTypeTableViewCell *weakContentCell = contentCell;
            NSString *limit = [NSString stringWithFormat:@"%lu",self.homework.limitTimes];
            contentCell.expandCallback = ^{
                
                MIExpandPickerView * chooseDataPicker = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MIExpandPickerView class]) owner:nil options:nil] firstObject];
                chooseDataPicker.callback = ^(NSString * _Nonnull text) {
                    
                    [weakContentCell setupWithLeftText:text rightText:nil createType:createType];
                    weakSelf.homework.limitTimes = text.integerValue;
                };
                [chooseDataPicker setDefultText:limit createType:createType];
                [chooseDataPicker show];
            };
            [contentCell setupWithLeftText:limit rightText:nil createType:createType];
            cell = contentCell;
        }
            break;
        case MIHomeworkCreateContentType_ActivityStartTime:
        {
            MIExpandSelectTypeTableViewCell *contentCell = [tableView dequeueReusableCellWithIdentifier:MIExpandSelectTypeTableViewCellId forIndexPath:indexPath];
            __weak MIExpandSelectTypeTableViewCell *weakContentCell = contentCell;
            WeakifySelf;
            contentCell.expandCallback = ^{
                
                NSDate *starDate = [NSDate dateWithString:weakSelf.activityInfo.startTime format:@"yyyy:MM:dd"];
                [DatePickerView showInView:[UIApplication sharedApplication].keyWindow
                                      date:starDate
                                  callback:^(NSDate *date) {
                                      NSString *startTime = [date stringWithFormat:@"yyyy:MM:dd"];
                                      [weakContentCell setupWithLeftText:startTime rightText:nil createType:createType];
                                  }];
            };
            [contentCell setupWithLeftText:self.activityInfo.startTime rightText:nil createType:createType];
            cell = contentCell;
        }
            break;
        case MIHomeworkCreateContentType_ActivityEndTime:
        {
            MIExpandSelectTypeTableViewCell *contentCell = [tableView dequeueReusableCellWithIdentifier:MIExpandSelectTypeTableViewCellId forIndexPath:indexPath];
            __weak MIExpandSelectTypeTableViewCell *weakContentCell = contentCell;
            contentCell.expandCallback = ^{
                NSDate *endDate = [NSDate dateWithString:weakSelf.activityInfo.endTime format:@"yyyy:MM:dd"];
                [DatePickerView showInView:[UIApplication sharedApplication].keyWindow
                                      date:endDate
                                  callback:^(NSDate *date) {
                                      NSString *endTime = [date stringWithFormat:@"yyyy:MM:dd"];
                                      [weakContentCell setupWithLeftText:endTime rightText:nil createType:createType];
                                  }];
            };
            [contentCell setupWithLeftText:self.activityInfo.endTime rightText:nil createType:createType];
            cell = contentCell;
            cell = contentCell;
        }
            break;
        case MIHomeworkCreateContentType_VideoTimeLimit:
        {
            MIExpandSelectTypeTableViewCell *contentCell = [tableView dequeueReusableCellWithIdentifier:MIExpandSelectTypeTableViewCellId forIndexPath:indexPath];
            __weak MIExpandSelectTypeTableViewCell *weakContentCell = contentCell;
            NSString *limit = [NSString stringWithFormat:@"%lu",self.activityInfo.limitTimes];
            contentCell.expandCallback = ^{
                
                MIExpandPickerView * chooseDataPicker = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MIExpandPickerView class]) owner:nil options:nil] firstObject];
                chooseDataPicker.callback = ^(NSString * _Nonnull text) {
                    
                    [weakContentCell setupWithLeftText:text rightText:nil createType:createType];
                    weakSelf.activityInfo.limitTimes = text.integerValue;
                };
                [chooseDataPicker setDefultText:limit createType:createType];
                [chooseDataPicker show];
                
            };
            [contentCell setupWithLeftText:limit rightText:nil createType:createType];
            cell = contentCell;
        }
            break;
        case MIHomeworkCreateContentType_CommitCount:
        {
            MISegmentTypeTableViewCell *contentCell = [tableView dequeueReusableCellWithIdentifier:MISegmentTypeTableViewCellId forIndexPath:indexPath];
            WeakifySelf;
            contentCell.callback = ^(NSInteger selectIndex) {
                weakSelf.activityInfo.submitNum = selectIndex;
            };
            [contentCell setupWithSelectIndex:self.activityInfo.submitNum createType:createType];
            cell = contentCell;
        }
            break;
        case MIHomeworkCreateContentType_Label:
        {
            MITagsTableViewCell *tagsCell = [tableView dequeueReusableCellWithIdentifier:MITagsTableViewCellId forIndexPath:indexPath];
            tagsCell.type = HomeworkTagsTableViewCellSelectSigleType;
            NSMutableArray * selectFormTags = [[NSMutableArray alloc] init];
            if (self.selectFormTag)
            {
                [selectFormTags addObject:self.selectFormTag];
            }
            [tagsCell setupWithTags:self.formTags selectedTags:selectFormTags typeTitle:@"任务类型(单选):"];
            
            WeakifySelf;
            [tagsCell setSelectCallback:^(NSString *tag) {
                weakSelf.selectFormTag = (weakSelf.selectFormTag.length > 0) ? @"" : tag;
            }];
            
            [tagsCell setManageCallback:^{
                MITagsViewController *tagsVC = [[MITagsViewController alloc] initWithNibName:@"MITagsViewController" bundle:nil];
                tagsVC.type = TagsHomeworkFormType;
                [weakSelf.navigationController pushViewController:tagsVC animated:YES];
            }];
            
            cell = tagsCell;
        }
            break;
        case MIHomeworkCreateContentType_TypeLabel:
        {
            MITagsTableViewCell *tagsCell = [tableView dequeueReusableCellWithIdentifier:MITagsTableViewCellId forIndexPath:indexPath];
            tagsCell.type = HomeworkTagsTableViewCellSelectMutiType;
            [tagsCell setupWithTags:self.tags selectedTags:self.selectedTags typeTitle:@"分类标签(多选):"];
            
            WeakifySelf;
            [tagsCell setSelectCallback:^(NSString *tag) {
                if ([weakSelf.selectedTags containsObject:tag]) {
                    [weakSelf.selectedTags removeObject:tag];
                } else {
                    [weakSelf.selectedTags addObject:tag];
                }
            }];
            [tagsCell setManageCallback:^{
                MITagsViewController *tagsVC = [[MITagsViewController alloc] initWithNibName:@"MITagsViewController" bundle:nil];
                tagsVC.type = TagsHomeworkTipsType;
                [weakSelf.navigationController pushViewController:tagsVC animated:YES];
            }];
            
            cell = tagsCell;
        }
            break;
        case MIHomeworkCreateContentType_ActivityParticipant:
        {
            MITagsTableViewCell *tagsCell = [tableView dequeueReusableCellWithIdentifier:MITagsTableViewCellId forIndexPath:indexPath];
            tagsCell.type = HomeworkTagsTableViewCellSelectMutiType;
            [tagsCell setupWithTags:@[] selectedTags:@[] typeTitle:@"活动参与对象:"];
            
            WeakifySelf;
            [tagsCell setSelectCallback:^(NSString *tag) {
                if ([weakSelf.selectedTags containsObject:tag]) {
                    [weakSelf.selectedTags removeObject:tag];
                } else {
                    [weakSelf.selectedTags addObject:tag];
                }
            }];
            [tagsCell setManageCallback:^{
                MITagsViewController *tagsVC = [[MITagsViewController alloc] initWithNibName:@"MITagsViewController" bundle:nil];
                tagsVC.type = TagsHomeworkTipsType;
                [weakSelf.navigationController pushViewController:tagsVC animated:YES];
            }];
            
            cell = tagsCell;
        }
            break;
        case MIHomeworkCreateContentType_Delete:
        {
            MIAddTypeTableViewCell *contentCell = [tableView dequeueReusableCellWithIdentifier:MIAddTypeTableViewCellId forIndexPath:indexPath];
            contentCell.addCallback = ^(BOOL isAdd) {
                [weakSelf deleteHomework];
            };
            [contentCell setupWithCreateType:createType];
            cell = contentCell;
        }
            break;
        default:
            
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId"];
            }
            break;
    }
    return cell;
}

#pragma mark - 设置行数、行高
- (NSArray *)getNumberOfRowsInSection{
    
    NSMutableArray *typeArray;
    switch (self.taskType) {
        case MIHomeworkTaskType_notify:// 通知
        {
            // 位置、标题、内容、统计类型、选择提交时间，选择星级、添加材料、任务类型(单选)、分类标签（多选）
            typeArray =
            [NSMutableArray arrayWithArray:@[@(MIHomeworkCreateContentType_Localtion),
                          @(MIHomeworkCreateContentType_Title),
                          @(MIHomeworkCreateContentType_Content),
                          @(MIHomeworkCreateContentType_StatisticalType),
                          @(MIHomeworkCreateContentType_CommitTime),
                          @(MIHomeworkCreateContentType_HomeworkDifficulty),
                          @(MIHomeworkCreateContentType_Materials),
                          @(MIHomeworkCreateContentType_Label),
                          @(MIHomeworkCreateContentType_TypeLabel),
                          @(MIHomeworkCreateContentType_Delete)
                          ]];
        }
            break;
        case MIHomeworkTaskType_FollowUp:// 跟读
        {
            // 位置、标题、内容、批改备注、统计类型、选择提交时间、选择星级、添加跟读材料、添加材料、添加答案、任务类型(单选)、分类标签（多选）
            typeArray =
            [NSMutableArray arrayWithArray:@[@(MIHomeworkCreateContentType_Localtion),
                          @(MIHomeworkCreateContentType_Title),
                          @(MIHomeworkCreateContentType_Content),
                          @(MIHomeworkCreateContentType_MarkingRemarks),
                          @(MIHomeworkCreateContentType_StatisticalType),
                          @(MIHomeworkCreateContentType_CommitTime),
                          @(MIHomeworkCreateContentType_HomeworkDifficulty),
                          @(MIHomeworkCreateContentType_AddFollowMaterials),
                          @(MIHomeworkCreateContentType_Materials),
                          @(MIHomeworkCreateContentType_Answer),
                          @(MIHomeworkCreateContentType_Label),
                          @(MIHomeworkCreateContentType_TypeLabel),
                          @(MIHomeworkCreateContentType_Delete)
                          ]];
        }
            break;
        case MIHomeworkTaskType_WordMemory:// 单词记忆
        {
            // 位置、标题、批改备注、统计类型、选择提交时间、选择星级、添加单词、播放时间间隔、添加背景音乐、添加材料、任务类型(单选)、分类标签（多选）
            typeArray =
            [NSMutableArray arrayWithArray:@[@(MIHomeworkCreateContentType_Localtion),
                          @(MIHomeworkCreateContentType_Title),
                          @(MIHomeworkCreateContentType_Content),
                          @(MIHomeworkCreateContentType_MarkingRemarks),
                          @(MIHomeworkCreateContentType_StatisticalType),
                          @(MIHomeworkCreateContentType_CommitTime),
                          @(MIHomeworkCreateContentType_HomeworkDifficulty),
                          @(MIHomeworkCreateContentType_AddWords),
                          @(MIHomeworkCreateContentType_WordsTimeInterval),
                          @(MIHomeworkCreateContentType_AddBgMusic),
                          @(MIHomeworkCreateContentType_Materials),
                          @(MIHomeworkCreateContentType_Label),
                          @(MIHomeworkCreateContentType_TypeLabel),
                          @(MIHomeworkCreateContentType_Delete)
                          ]];
        }
            break;
        case MIHomeworkTaskType_GeneralTask:// 普通作业
        {
            // 位置、标题、内容、批改备注、统计类型、选择提交时间、选择星级、选择时限、添加材料、添加答案、任务类型(单选)、分类标签（多选）
            typeArray =
            [NSMutableArray arrayWithArray:@[@(MIHomeworkCreateContentType_Localtion),
                          @(MIHomeworkCreateContentType_Title),
                          @(MIHomeworkCreateContentType_Content),
                          @(MIHomeworkCreateContentType_MarkingRemarks),
                          @(MIHomeworkCreateContentType_StatisticalType),
                          @(MIHomeworkCreateContentType_CommitTime),
                          @(MIHomeworkCreateContentType_HomeworkDifficulty),
                          @(MIHomeworkCreateContentType_TimeLimit),
                          @(MIHomeworkCreateContentType_Materials),
                          @(MIHomeworkCreateContentType_Answer),
                          @(MIHomeworkCreateContentType_Label),
                          @(MIHomeworkCreateContentType_TypeLabel),
                          @(MIHomeworkCreateContentType_Delete)
                          ]];
        }
            break;
        case MIHomeworkTaskType_Activity:
        {
            // 标题、添加封面、活动要求、添加材料、可提交次数、视频时限、活动开始时间、活动结束时间、活动参与对象
            typeArray =
            [NSMutableArray arrayWithArray:@[@(MIHomeworkCreateContentType_Title),
                          @(MIHomeworkCreateContentType_AddCovers),
                          @(MIHomeworkCreateContentType_ActivityReq),
                          @(MIHomeworkCreateContentType_Materials),
                          @(MIHomeworkCreateContentType_CommitCount),
                          @(MIHomeworkCreateContentType_VideoTimeLimit),
                          @(MIHomeworkCreateContentType_ActivityStartTime),
                          @(MIHomeworkCreateContentType_ActivityEndTime),
                          @(MIHomeworkCreateContentType_ActivityParticipant),
                          @(MIHomeworkCreateContentType_Delete)
                          ]];
        }
            break;
        case MIHomeworkTaskType_ExaminationStatistics:// 考试统计
        {
            
            // 位置、标题、内容、批改备注、考试类型、选择提交时间、选择星级、添加材料、添加答案、任务类型(单选)、分类标签（多选）
            typeArray =
            [NSMutableArray arrayWithArray:@[@(MIHomeworkCreateContentType_Localtion),
                          @(MIHomeworkCreateContentType_Title),
                          @(MIHomeworkCreateContentType_Content),
                          @(MIHomeworkCreateContentType_MarkingRemarks),
                          @(MIHomeworkCreateContentType_ExaminationType),
                          @(MIHomeworkCreateContentType_CommitTime),
                          @(MIHomeworkCreateContentType_HomeworkDifficulty),
                          @(MIHomeworkCreateContentType_Materials),
                          @(MIHomeworkCreateContentType_Answer),
                          @(MIHomeworkCreateContentType_Label),
                          @(MIHomeworkCreateContentType_TypeLabel),
                          @(MIHomeworkCreateContentType_Delete)
                          ]];
        }
            break;
        default:
            break;
    }
    if (self.isCreateTask) {
        [typeArray removeLastObject];
    }
    return typeArray;
}
- (CGFloat)getHeightForRowWithCreateType:(MIHomeworkCreateContentType) createType{
    
    CGFloat rowHeight = 0;
    switch (createType) {
        case MIHomeworkCreateContentType_Localtion:
            rowHeight = MIExpandSelectTypeTableViewCellHeight;
            break;
        case MIHomeworkCreateContentType_Title:
            rowHeight = [MIInPutTypeTableViewCell cellHeightWithText:self.homework.title];
            break;
        case MIHomeworkCreateContentType_Content:
            rowHeight = [MIInPutTypeTableViewCell cellHeightWithText:self.contentItem.text];
            break;
        case MIHomeworkCreateContentType_MarkingRemarks:
            rowHeight = [MIInPutTypeTableViewCell cellHeightWithText:self.homework.teremark];
            break;
        case MIHomeworkCreateContentType_ActivityReq:
            rowHeight = [MIInPutTypeTableViewCell cellHeightWithText:self.contentItem.text];
            break;
        case MIHomeworkCreateContentType_CommitCount:
        case MIHomeworkCreateContentType_StatisticalType:
        case MIHomeworkCreateContentType_CommitTime:
        case MIHomeworkCreateContentType_HomeworkDifficulty:
        case MIHomeworkCreateContentType_ExaminationType:
            rowHeight = MISegmentTypeTableViewCellHeight;
            break;
        case MIHomeworkCreateContentType_AddWords:
            if (self.wordsItem) {
                rowHeight = 112 + MITitleTypeTableViewCellHeight;
                break;
            }
        case MIHomeworkCreateContentType_Materials:
            if (self.items.count) {
                rowHeight = self.items.count * 112 + MITitleTypeTableViewCellHeight;
                break;
            }
        case MIHomeworkCreateContentType_Answer:
            if (self.answerItems.count) {
                rowHeight = self.answerItems.count * 112  + MITitleTypeTableViewCellHeight;
                break;
            }
        case MIHomeworkCreateContentType_AddCovers:
            if (self.activityInfo.coverItems) {
                rowHeight = 112 + MITitleTypeTableViewCellHeight;
                break;
            }
        case MIHomeworkCreateContentType_AddBgMusic:
            if (self.activityInfo.coverItems) {
                rowHeight = 112 + MITitleTypeTableViewCellHeight;
                break;
            }
        case MIHomeworkCreateContentType_AddFollowMaterials:
            if (self.activityInfo.coverItems) {
                rowHeight = 112 + MITitleTypeTableViewCellHeight;
                break;
            }
            rowHeight = MITitleTypeTableViewCellHeight;
            break;
        case MIHomeworkCreateContentType_WordsTimeInterval:
        case MIHomeworkCreateContentType_TimeLimit:
        case MIHomeworkCreateContentType_ActivityStartTime:
        case MIHomeworkCreateContentType_ActivityEndTime:
        case MIHomeworkCreateContentType_VideoTimeLimit:
            rowHeight = MIExpandSelectTypeTableViewCellHeight;
            break;
        case MIHomeworkCreateContentType_Label:
            rowHeight = [MITagsTableViewCell heightWithTags:self.formTags] + 50;
            break;
        case MIHomeworkCreateContentType_TypeLabel:
            rowHeight = [MITagsTableViewCell heightWithTags:self.tags] + 50;
            break;
        case MIHomeworkCreateContentType_ActivityParticipant:
            rowHeight = [MITagsTableViewCell heightWithTags:@[]] + 45;
            break;
        case MIHomeworkCreateContentType_Add:
        case MIHomeworkCreateContentType_Delete:
            rowHeight = MIAddTypeTableViewCellHeight;
            break;
        default:
            break;
    }
    return rowHeight;
}

#pragma mark - ChooseDatePickerViewDelegate
- (void)finishSelectDate:(NSInteger)seconds{
    
    self.limitTimeSecs = seconds;
}

- (void)registerCellNibs {
    
    [self.leftTableView registerNib:[UINib nibWithNibName:@"MIInPutTypeTableViewCell" bundle:nil] forCellReuseIdentifier:MIInPutTypeTableViewCellId];
    [self.rightTableView registerNib:[UINib nibWithNibName:@"MIInPutTypeTableViewCell" bundle:nil] forCellReuseIdentifier:MIInPutTypeTableViewCellId];
    
    [self.leftTableView registerNib:[UINib nibWithNibName:@"MISegmentTypeTableViewCell" bundle:nil] forCellReuseIdentifier:MISegmentTypeTableViewCellId];
    [self.rightTableView registerNib:[UINib nibWithNibName:@"MISegmentTypeTableViewCell" bundle:nil] forCellReuseIdentifier:MISegmentTypeTableViewCellId];
    
    [self.leftTableView registerNib:[UINib nibWithNibName:@"MIAddTypeTableViewCell" bundle:nil] forCellReuseIdentifier:MIAddTypeTableViewCellId];
    [self.rightTableView registerNib:[UINib nibWithNibName:@"MIAddTypeTableViewCell" bundle:nil] forCellReuseIdentifier:MIAddTypeTableViewCellId];
    
    [self.leftTableView registerNib:[UINib nibWithNibName:@"MITitleTypeTableViewCell" bundle:nil] forCellReuseIdentifier:MITitleTypeTableViewCellId];
    [self.rightTableView registerNib:[UINib nibWithNibName:@"MITitleTypeTableViewCell" bundle:nil] forCellReuseIdentifier:MITitleTypeTableViewCellId];
    
    [self.leftTableView registerNib:[UINib nibWithNibName:@"MIExpandSelectTypeTableViewCell" bundle:nil] forCellReuseIdentifier:MIExpandSelectTypeTableViewCellId];
    [self.rightTableView registerNib:[UINib nibWithNibName:@"MIExpandSelectTypeTableViewCell" bundle:nil] forCellReuseIdentifier:MIExpandSelectTypeTableViewCellId];
    
    [self.leftTableView registerNib:[UINib nibWithNibName:@"MITagsTableViewCell" bundle:nil] forCellReuseIdentifier:MITagsTableViewCellId];
    [self.rightTableView registerNib:[UINib nibWithNibName:@"MITagsTableViewCell" bundle:nil] forCellReuseIdentifier:MITagsTableViewCellId];
}

#pragma mark - setter && getter
- (NSMutableArray *)createTypeArray{
    if (!_createTypeArray) {
        _createTypeArray = [NSMutableArray array];
    }
    return _createTypeArray;
}

- (Homework *)homework{
    if (!_homework) {
        _homework = [[Homework alloc] init];
        _homework.fileInfos = [[HomeworkFileDto alloc] init];
    }
    return _homework;
}
- (HomeworkItem *)wordsItem{
    if (!_wordsItem) {
        _wordsItem = [[HomeworkItem alloc] init];
        _wordsItem.type = @"audio";
    }
    return _wordsItem;
}

- (HomeworkItem *)contentItem{
    if (!_contentItem) {
        _contentItem = [[HomeworkItem alloc] init];
        _contentItem.type = @"text";
    }
    return _contentItem;
}
- (NSMutableArray *)items{
    if (!_items) {
        _items = [NSMutableArray array];
    }
    return _items;
}
- (NSMutableArray *)followItems{
    if (!_followItems) {
        _followItems = [NSMutableArray array];
    }
    return _followItems;
}
- (NSMutableArray *)answerItems{
    if (!_answerItems) {
        _answerItems = [NSMutableArray array];
    }
    return _answerItems;
}
- (NSMutableArray *)selectedTags{
    if (!_selectedTags) {
        _selectedTags = [NSMutableArray array];
    }
    return _selectedTags;
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
    [self presentViewController:alertController animated:YES completion:nil];
}


#pragma mark - 请求标签 && 类型标签
- (void)requestTags {
  
    [TagService requestTagsWithCallback:^(Result *result, NSError *error) {
        
        if (error != nil) {
            [HUD showErrorWithMessage:@"标签请求失败"];
            return ;
        }
        self.tags = (NSArray *)(result.userInfo);
        [self.leftTableView reloadData];
        [self.rightTableView reloadData];
    }];
}
- (void)requestFormTags{
    
    [TagService requestFormTagsWithCallback:^(Result *result, NSError *error) {
        if (error != nil) {
            
            [HUD showErrorWithMessage:@"标签请求失败"];
            return ;
        }
        self.formTags = (NSArray *)(result.userInfo);
        [self.leftTableView reloadData];
        [self.rightTableView reloadData];
    }];
}
@end
