//
//  MICreateTaskViewController.m
//  MinnieManager
//
//  Created by songzhen on 2019/6/3.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import "TagService.h"
#import "HomeworkService.h"
#import "DatePickerView.h"
#import "MIExpandPickerView.h"
#import "ChooseDatePickerView.h"
#import "TagsViewController.h"
#import "HomeworkTagsTableViewCell.h"
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


#import <objc/runtime.h>
#import <AVKit/AVKit.h>
#import "FileUploader.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>

static const char keyOfPickerDocument;

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

@property (nonatomic, strong) Homework *homework;           // 为空创建作业
@property (nonatomic, strong) ActivityInfo *activityInfo;   // 为空创建活动

@property (nonatomic,assign) MIHomeworkTaskType taskType;   // 任务类型

@property (nonatomic, assign) BOOL isAddingAnswerItem;


@property (nonatomic, strong) NSMutableArray<HomeworkItem *> *items;// 材料
@property (nonatomic, strong) NSMutableArray<HomeworkAnswerItem *> *answerItems; // 答案
@property (nonatomic, strong) NSMutableArray<HomeworkItem *> *followItems;// 跟读材料


@property (copy, nonatomic) NSString *homeworkTitle;    // 作业题目
@property (copy, nonatomic) NSString *homeworkContent;  // 作业内容
@property (copy, nonatomic) NSString *activityReq;      //活动要求

@property (nonatomic, copy) NSString *teremark;// 批改备注
@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) NSArray *tags;
@property (nonatomic, strong) NSArray *formTags;
@property (nonatomic, strong) NSMutableArray *selectedTags;

@property (nonatomic, assign) NSInteger categoryType;
@property (nonatomic, assign) NSInteger styleType;
@property (nonatomic, assign) NSInteger level;
@property (nonatomic, assign) NSInteger limitTimeSecs;
@property (nonatomic, strong) NSString * selectFormTag;
@property (nonatomic, strong) MBProgressHUD * mHud;

@end

@implementation MICreateTaskViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self updateSplit:90];
}

-(void)viewWillDisappear:(BOOL)animated{
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
  
    if (self.homework == nil) {
        self.homework = [[Homework alloc] init];
        self.items = [[NSMutableArray alloc] init];
        self.answerItems = [[NSMutableArray alloc] init];
        self.selectedTags = [[NSMutableArray alloc] init];
        self.limitTimeSecs = 300;
        self.categoryType = 1;
        //作业类型：日常1、假期2、集训3
        self.styleType = 1;
    } else {
        
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
        
        self.categoryType = self.homework.category;
        self.styleType = self.homework.style;
        self.level = self.homework.level;
        self.limitTimeSecs = self.homework.limitTimes;
        self.selectedTags = [NSMutableArray arrayWithArray:self.homework.tags];
        self.selectFormTag = self.homework.formTag;
        self.teremark = self.homework.teremark;
    }
    
    self.leftTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.rightTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self registerCellNibs];
}

- (IBAction)closeBtnAction:(id)sender {
 
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)sendBtnAction:(id)sender {
    
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
    self.homework.category = self.categoryType;
    self.homework.style = self.styleType;
    self.homework.limitTimes = self.limitTimeSecs;
    self.homework.level = self.level;
    self.homework.formTag = self.selectFormTag;
    self.homework.teremark = self.teremark;
    
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


- (void)setupCreateHomework:(Homework *_Nullable)homework taskType:(MIHomeworkTaskType)taskType{
    
    self.homework = homework;
    self.taskType = taskType;
    [self setupTitleWithTaskType:taskType];
    [self.createTypeArray removeAllObjects];
    [self.createTypeArray addObjectsFromArray:[self getRowCount]];
    
    if (taskType == MIHomeworkTaskType_Activity) {
        
        self.leftRowCount = 7;
    } else {
        
        self.leftRowCount = 7;
    }
    
    [self.leftTableView reloadData];
    [self.rightTableView reloadData];
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
    
    if (tableView == self.leftTableView) {
        
        NSNumber *createTypeNum = self.createTypeArray[indexPath.row];
        return [self getRowHeightWithCreateType:createTypeNum.integerValue];
    } else {
        
        NSNumber *createTypeNum = self.createTypeArray[indexPath.row + self.leftRowCount];
        return [self getRowHeightWithCreateType:createTypeNum.integerValue];
    }
}

- (void)setupTitleWithTaskType:(MIHomeworkTaskType)taskType{
    
    switch (taskType) {
        case MIHomeworkTaskType_notify:
        {
            self.titleLabel.text = self.homework ? @"通知详情" : @"新建通知";
        }
            break;
        case MIHomeworkTaskType_FollowUp:
        {
            self.titleLabel.text = self.homework ? @"跟读详情" : @"新建跟读";
        }
            break;
        case MIHomeworkTaskType_WordMemory:
        {
            self.titleLabel.text = self.homework ? @"单词记忆详情" : @"新建单词记忆";
        }
            break;
        case MIHomeworkTaskType_GeneralTask:
        {
            self.titleLabel.text = self.homework ? @"普通作业详情" : @"新建普通作业";
        }
            break;
        case MIHomeworkTaskType_Activity:
        {
            self.titleLabel.text = self.homework ? @"活动详情" : @"新建活动";
        }
            break;
        case MIHomeworkTaskType_ExaminationStatistics:
        {
            self.titleLabel.text = self.homework ? @"考试统计详情" : @"新建考试统计";
        }
            break;
        default:
            break;
    }
}

- (NSArray *)getRowCount{
    
    NSArray *typeArray;
    switch (self.taskType) {
        case MIHomeworkTaskType_notify:// 通知
        {
            // 位置、标题、内容、统计类型、选择提交时间，选择星级、添加材料、任务类型(单选)、分类标签（多选）
            typeArray = @[@(MIHomeworkCreateContentType_Localtion),
                          @(MIHomeworkCreateContentType_Title),
                          @(MIHomeworkCreateContentType_Content),
                          @(MIHomeworkCreateContentType_StatisticalType),
                          @(MIHomeworkCreateContentType_CommitTime),
                          @(MIHomeworkCreateContentType_HomeworkDifficulty),
                          @(MIHomeworkCreateContentType_Materials),
                          @(MIHomeworkCreateContentType_Add),
                          @(MIHomeworkCreateContentType_Label),
                          @(MIHomeworkCreateContentType_TypeLabel),
                          @(MIHomeworkCreateContentType_Delete)
                          ];
        }
            break;
        case MIHomeworkTaskType_FollowUp:// 跟读
        {
            // 位置、标题、内容、批改备注、统计类型、选择提交时间、选择星级、添加跟读材料、添加材料、添加答案、任务类型(单选)、分类标签（多选）
            typeArray = @[@(MIHomeworkCreateContentType_Localtion),
                          @(MIHomeworkCreateContentType_Title),
                          @(MIHomeworkCreateContentType_Content),
                          @(MIHomeworkCreateContentType_MarkingRemarks),
                          @(MIHomeworkCreateContentType_StatisticalType),
                          @(MIHomeworkCreateContentType_CommitTime),
                          @(MIHomeworkCreateContentType_HomeworkDifficulty),
                          @(MIHomeworkCreateContentType_AddFollowMaterials),
                          @(MIHomeworkCreateContentType_Add),
                          @(MIHomeworkCreateContentType_Materials),
                          @(MIHomeworkCreateContentType_Add),
                          @(MIHomeworkCreateContentType_Answer),
                          @(MIHomeworkCreateContentType_Add),
                          @(MIHomeworkCreateContentType_Label),
                          @(MIHomeworkCreateContentType_TypeLabel),
                          @(MIHomeworkCreateContentType_Delete)
                          ];
        }
            break;
        case MIHomeworkTaskType_WordMemory:// 单词记忆
        {
            // 位置、标题、批改备注、统计类型、选择提交时间、选择星级、添加单词、播放时间间隔、添加背景音乐、添加材料、任务类型(单选)、分类标签（多选）
            typeArray = @[@(MIHomeworkCreateContentType_Localtion),
                          @(MIHomeworkCreateContentType_Title),
                          @(MIHomeworkCreateContentType_MarkingRemarks),
                          @(MIHomeworkCreateContentType_StatisticalType),
                          @(MIHomeworkCreateContentType_CommitTime),
                          @(MIHomeworkCreateContentType_HomeworkDifficulty),
                          @(MIHomeworkCreateContentType_AddWords),
                          @(MIHomeworkCreateContentType_Add),
                          @(MIHomeworkCreateContentType_WordsTimeInterval),
                          @(MIHomeworkCreateContentType_AddBgMusic),
                          @(MIHomeworkCreateContentType_Add),
                          @(MIHomeworkCreateContentType_Materials),
                          @(MIHomeworkCreateContentType_Add),
                          @(MIHomeworkCreateContentType_Label),
                          @(MIHomeworkCreateContentType_TypeLabel),
                          @(MIHomeworkCreateContentType_Delete)
                          ];
        }
            break;
        case MIHomeworkTaskType_GeneralTask:// 普通作业
        {
            // 位置、标题、内容、批改备注、统计类型、选择提交时间、选择星级、选择时限、添加材料、添加答案、任务类型(单选)、分类标签（多选）
            typeArray = @[@(MIHomeworkCreateContentType_Localtion),
                          @(MIHomeworkCreateContentType_Title),
                          @(MIHomeworkCreateContentType_Content),
                          @(MIHomeworkCreateContentType_MarkingRemarks),
                          @(MIHomeworkCreateContentType_StatisticalType),
                          @(MIHomeworkCreateContentType_CommitTime),
                          @(MIHomeworkCreateContentType_HomeworkDifficulty),
                          @(MIHomeworkCreateContentType_TimeLimit),
                          @(MIHomeworkCreateContentType_Materials),
                          @(MIHomeworkCreateContentType_Add),
                          @(MIHomeworkCreateContentType_Answer),
                          @(MIHomeworkCreateContentType_Add),
                          @(MIHomeworkCreateContentType_Label),
                          @(MIHomeworkCreateContentType_TypeLabel),
                          @(MIHomeworkCreateContentType_Delete)
                          ];
        }
            break;
        case MIHomeworkTaskType_Activity:
        {
            // 标题、添加封面、活动要求、添加材料、可提交次数、视频时限、活动开始时间、活动结束时间、活动参与对象
            typeArray = @[@(MIHomeworkCreateContentType_Title),
                          @(MIHomeworkCreateContentType_AddCovers),
                          @(MIHomeworkCreateContentType_Add),
                          @(MIHomeworkCreateContentType_ActivityReq),
                          @(MIHomeworkCreateContentType_Materials),
                          @(MIHomeworkCreateContentType_Add),
                          @(MIHomeworkCreateContentType_CommitCount),
                          @(MIHomeworkCreateContentType_VideoTimeLimit),
                          @(MIHomeworkCreateContentType_ActivityStartTime),
                          @(MIHomeworkCreateContentType_ActivityEndTime),
                          @(MIHomeworkCreateContentType_ActivityParticipant),
                          @(MIHomeworkCreateContentType_Delete)
                          ];
        }
            break;
        case MIHomeworkTaskType_ExaminationStatistics:// 考试统计
        {
            
            // 位置、标题、内容、批改备注、考试类型、选择提交时间、选择星级、添加材料、添加答案、任务类型(单选)、分类标签（多选）
            typeArray = @[@(MIHomeworkCreateContentType_Localtion),
                          @(MIHomeworkCreateContentType_Title),
                          @(MIHomeworkCreateContentType_Content),
                          @(MIHomeworkCreateContentType_MarkingRemarks),
                          @(MIHomeworkCreateContentType_ExaminationType),
                          @(MIHomeworkCreateContentType_CommitTime),
                          @(MIHomeworkCreateContentType_HomeworkDifficulty),
                          @(MIHomeworkCreateContentType_Materials),
                          @(MIHomeworkCreateContentType_Add),
                          @(MIHomeworkCreateContentType_Answer),
                          @(MIHomeworkCreateContentType_Add),
                          @(MIHomeworkCreateContentType_Label),
                          @(MIHomeworkCreateContentType_TypeLabel),
                          @(MIHomeworkCreateContentType_Delete)
                          ];
        }
            break;
        default:
            break;
    }
    return typeArray;
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
            
            contentCell.leftExpandCallback = ^{
                
                MIExpandPickerView * chooseDataPicker = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MIExpandPickerView class]) owner:nil options:nil] lastObject];
                FileInfo *file = [[FileInfo alloc] init];
                file.fileName = @"文件夹1";
                
                FileInfo *file1 = [[FileInfo alloc] init];
                file1.fileName = @"文件夹2";
                
                FileInfo *file2 = [[FileInfo alloc] init];
                file2.fileName = @"文件夹3";
                
                [chooseDataPicker setDefultFileInfo:file1 fileArray:(NSArray<FileInfo>*)@[file,file1,file2]];
                chooseDataPicker.localCallback = ^(FileInfo * _Nonnull result) {
                    
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
                
                [chooseDataPicker setDefultFileInfo:file1 fileArray:(NSArray<FileInfo>*)@[file,file1,file2]];
                chooseDataPicker.localCallback = ^(FileInfo * _Nonnull result) {
                    
                };
                [chooseDataPicker show];
            };
            [contentCell setupWithLeftText:@"普通任务" rightText:@"第一周" createType:createType];
            cell = contentCell;
        }
            break;
        case MIHomeworkCreateContentType_Title:
        {
            MIInPutTypeTableViewCell *titleCell = [tableView dequeueReusableCellWithIdentifier:MIInPutTypeTableViewCellId forIndexPath:indexPath];
            __weak MIInPutTypeTableViewCell *weakTitleCell = titleCell;
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
            [titleCell setupWithText:self.homeworkTitle
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
                weakSelf.homeworkContent = text;
                
                if (heightChanged) {
                    [weakTableView beginUpdates];
                    [weakTableView endUpdates];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakContentCell ajustTextView];
                    });
                }
            };
            [contentCell setupWithText:self.homeworkContent
                                 title:@"内容:"
                            createType:createType
                           placeholder:@""];
            cell = contentCell;
        }
            break;
        case MIHomeworkCreateContentType_MarkingRemarks:
        {
            MIInPutTypeTableViewCell *contentCell = [tableView dequeueReusableCellWithIdentifier:MIInPutTypeTableViewCellId forIndexPath:indexPath];
            
            __weak MIInPutTypeTableViewCell *weakContentCell = contentCell;
            __weak UITableView *weakTableView = tableView;
            contentCell.callback = ^(NSString *text, BOOL heightChanged) {
                weakSelf.teremark = text;
                
                if (heightChanged) {
                    [weakTableView beginUpdates];
                    [weakTableView endUpdates];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakContentCell ajustTextView];
                    });
                }
            };
            [contentCell setupWithText:self.teremark
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
                weakSelf.activityReq = text;
                
                if (heightChanged) {
                    [weakTableView beginUpdates];
                    [weakTableView endUpdates];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakContentCell ajustTextView];
                    });
                }
            };
            [contentCell setupWithText:self.activityReq
                                 title:@"活动要求:"
                            createType:createType
                           placeholder:@""];
            cell = contentCell;
        }
            break;
        case MIHomeworkCreateContentType_StatisticalType:
        {
            MISegmentTypeTableViewCell *contentCell = [tableView dequeueReusableCellWithIdentifier:MISegmentTypeTableViewCellId forIndexPath:indexPath];
            [contentCell setupWithSelectIndex:1 createType:createType];
            contentCell.callback = ^(NSInteger selectIndex) {
                
                NSLog(@"%ld",selectIndex);
            };
            cell = contentCell;
        }
            break;
        case MIHomeworkCreateContentType_CommitTime:
        {
            MISegmentTypeTableViewCell *contentCell = [tableView dequeueReusableCellWithIdentifier:MISegmentTypeTableViewCellId forIndexPath:indexPath];
            [contentCell setupWithSelectIndex:1 createType:createType];
            contentCell.callback = ^(NSInteger selectIndex) {
                
                NSLog(@"%ld",selectIndex);
            };
            cell = contentCell;
        }
            break;
        case MIHomeworkCreateContentType_HomeworkDifficulty:
        {
            MISegmentTypeTableViewCell *contentCell = [tableView dequeueReusableCellWithIdentifier:MISegmentTypeTableViewCellId forIndexPath:indexPath];
            [contentCell setupWithSelectIndex:1 createType:createType];
            contentCell.callback = ^(NSInteger selectIndex) {
                
                NSLog(@"%ld",selectIndex);
            };
            cell = contentCell;
        }
            break;
        case MIHomeworkCreateContentType_WordsTimeInterval:
        {
            MIExpandSelectTypeTableViewCell *contentCell = [tableView dequeueReusableCellWithIdentifier:MIExpandSelectTypeTableViewCellId forIndexPath:indexPath];
            contentCell.expandCallback = ^{
                MIExpandPickerView * chooseDataPicker = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MIExpandPickerView class]) owner:nil options:nil] firstObject];
                [chooseDataPicker setDefultText:@"2.5" createType:createType];
                [chooseDataPicker show];
            };
            [contentCell setupWithLeftText:@"2.5" rightText:nil createType:createType];
            cell = contentCell;
        }
            break;
        case MIHomeworkCreateContentType_AddWords:
        {
            MITitleTypeTableViewCell *contentCell = [tableView dequeueReusableCellWithIdentifier:MITitleTypeTableViewCellId forIndexPath:indexPath];
            contentCell.title = @"添加单词:";
            cell = contentCell;
        }
            break;
        case MIHomeworkCreateContentType_Materials:
        {
            MITitleTypeTableViewCell *contentCell = [tableView dequeueReusableCellWithIdentifier:MITitleTypeTableViewCellId forIndexPath:indexPath];
            contentCell.title = @"添加材料:";
            cell = contentCell;
        }   break;
        case MIHomeworkCreateContentType_Answer:
        {
            MITitleTypeTableViewCell *contentCell = [tableView dequeueReusableCellWithIdentifier:MITitleTypeTableViewCellId forIndexPath:indexPath];
            contentCell.title = @"添加答案:";
            cell = contentCell;
        }
            break;
        case MIHomeworkCreateContentType_AddCovers:
        {
            MITitleTypeTableViewCell *contentCell = [tableView dequeueReusableCellWithIdentifier:MITitleTypeTableViewCellId forIndexPath:indexPath];
            contentCell.title = @"添加封面:";
            cell = contentCell;
        }
            break;
        case MIHomeworkCreateContentType_AddBgMusic:
        {
            MITitleTypeTableViewCell *contentCell = [tableView dequeueReusableCellWithIdentifier:MITitleTypeTableViewCellId forIndexPath:indexPath];
            contentCell.title = @"添加背景音乐:";
            cell = contentCell;
        }
            break;
        case MIHomeworkCreateContentType_AddFollowMaterials:
        {
            MITitleTypeTableViewCell *contentCell = [tableView dequeueReusableCellWithIdentifier:MITitleTypeTableViewCellId forIndexPath:indexPath];
            contentCell.title = @"添加跟读材料:";
            cell = contentCell;
        }
            break;
        case MIHomeworkCreateContentType_ExaminationType:
        {
            MISegmentTypeTableViewCell *contentCell = [tableView dequeueReusableCellWithIdentifier:MISegmentTypeTableViewCellId forIndexPath:indexPath];
            [contentCell setupWithSelectIndex:1 createType:createType];
            contentCell.callback = ^(NSInteger selectIndex) {
                
                NSLog(@"%ld",selectIndex);
            };
            cell = contentCell;
        }
            break;
        case MIHomeworkCreateContentType_TimeLimit:
        {
            MIExpandSelectTypeTableViewCell *contentCell = [tableView dequeueReusableCellWithIdentifier:MIExpandSelectTypeTableViewCellId forIndexPath:indexPath];
            
            contentCell.expandCallback = ^{
                
                MIExpandPickerView * chooseDataPicker = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MIExpandPickerView class]) owner:nil options:nil] firstObject];
                [chooseDataPicker setDefultText:@"2.5" createType:createType];
                [chooseDataPicker show];
            };
            [contentCell setupWithLeftText:@"250" rightText:nil createType:createType];
            cell = contentCell;
        }
            break;
        case MIHomeworkCreateContentType_ActivityStartTime:
        {
            MIExpandSelectTypeTableViewCell *contentCell = [tableView dequeueReusableCellWithIdentifier:MIExpandSelectTypeTableViewCellId forIndexPath:indexPath];
            
            contentCell.expandCallback = ^{
                
                [DatePickerView showInView:[UIApplication sharedApplication].keyWindow
                                      date:[NSDate date]
                                  callback:^(NSDate *date) {
                                  }];
            };
            [contentCell setupWithLeftText:@"2019年6月2日" rightText:nil createType:createType];
            cell = contentCell;
        }
            break;
        case MIHomeworkCreateContentType_ActivityEndTime:
        {
            MIExpandSelectTypeTableViewCell *contentCell = [tableView dequeueReusableCellWithIdentifier:MIExpandSelectTypeTableViewCellId forIndexPath:indexPath];
            contentCell.expandCallback = ^{
                
                [DatePickerView showInView:[UIApplication sharedApplication].keyWindow
                                      date:[NSDate date]
                                  callback:^(NSDate *date) {
                                  }];
            };
            [contentCell setupWithLeftText:@"2019年6月20日" rightText:nil createType:createType];
            cell = contentCell;
        }
            break;
        case MIHomeworkCreateContentType_VideoTimeLimit:
        {
            MIExpandSelectTypeTableViewCell *contentCell = [tableView dequeueReusableCellWithIdentifier:MIExpandSelectTypeTableViewCellId forIndexPath:indexPath];
            [contentCell setupWithLeftText:@"250" rightText:nil createType:MIHomeworkCreateContentType_TimeLimit];
            cell = contentCell;
        }
            break;
        case MIHomeworkCreateContentType_CommitCount:
        {
            MISegmentTypeTableViewCell *contentCell = [tableView dequeueReusableCellWithIdentifier:MISegmentTypeTableViewCellId forIndexPath:indexPath];
            [contentCell setupWithSelectIndex:1 createType:createType];
            contentCell.callback = ^(NSInteger selectIndex) {
                
                NSLog(@"%ld",selectIndex);
            };
            cell = contentCell;
        }
            break;
        case MIHomeworkCreateContentType_Label:
        {
            HomeworkTagsTableViewCell *tagsCell = [tableView dequeueReusableCellWithIdentifier:HomeworkTagsTableViewCellId forIndexPath:indexPath];
            tagsCell.type = HomeworkTagsTableViewCellSelectMutiType;
            [tagsCell setupWithTags:@[] selectedTags:@[] typeTitle:@"任务类型(单选):"];
            
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
                tagsVC.type = TagsHomeworkTipsType;
                [weakSelf.navigationController pushViewController:tagsVC animated:YES];
            }];
            cell = tagsCell;
        }
            break;
        case MIHomeworkCreateContentType_TypeLabel:
        {
            HomeworkTagsTableViewCell *tagsCell = [tableView dequeueReusableCellWithIdentifier:HomeworkTagsTableViewCellId forIndexPath:indexPath];
            tagsCell.type = HomeworkTagsTableViewCellSelectMutiType;
            [tagsCell setupWithTags:@[] selectedTags:@[] typeTitle:@"分类标签(多选):"];
            
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
                tagsVC.type = TagsHomeworkTipsType;
                [weakSelf.navigationController pushViewController:tagsVC animated:YES];
            }];
            cell = tagsCell;
        }
            break;
        case MIHomeworkCreateContentType_ActivityParticipant:
        {
            HomeworkTagsTableViewCell *tagsCell = [tableView dequeueReusableCellWithIdentifier:HomeworkTagsTableViewCellId forIndexPath:indexPath];
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
                TagsViewController *tagsVC = [[TagsViewController alloc] initWithNibName:@"TagsViewController" bundle:nil];
                tagsVC.type = TagsHomeworkTipsType;
                [weakSelf.navigationController pushViewController:tagsVC animated:YES];
            }];
            
            cell = tagsCell;
        }
            break;
        case MIHomeworkCreateContentType_Add:
        {
            MIAddTypeTableViewCell *contentCell = [tableView dequeueReusableCellWithIdentifier:MIAddTypeTableViewCellId forIndexPath:indexPath];
            WeakifySelf;
            contentCell.addCallback = ^{
                [weakSelf handleAddItem];
            };
            [contentCell setupWithCreateType:createType];
            cell = contentCell;
        }
            break;
        case MIHomeworkCreateContentType_Delete:
        {
            MIAddTypeTableViewCell *contentCell = [tableView dequeueReusableCellWithIdentifier:MIAddTypeTableViewCellId forIndexPath:indexPath];
            contentCell.addCallback = ^{
                
            };
            [contentCell setupWithCreateType:createType];
            cell = contentCell;
        }
            break;
        case MIHomeworkCreateContentType_Audio:
        {
            HomeworkItem *item = [[HomeworkItem alloc] init];
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
            break;
        case MIHomeworkCreateContentType_Video:
        {
            HomeworkItem *item = [[HomeworkItem alloc] init];
            HomeworkVideoTableViewCell *videoCell = [tableView dequeueReusableCellWithIdentifier:HomeworkVideoTableViewCellId forIndexPath:indexPath];
            
            [videoCell setupWithVideoUrl:item.videoUrl coverUrl:item.videoCoverUrl];
            
            WeakifySelf;
            [videoCell setDeleteCallback:^{
                [weakSelf deleteItem:item];
            }];
            
            cell = videoCell;
        }
            break;
        case MIHomeworkCreateContentType_Image:
        {
            HomeworkItem *item = [[HomeworkItem alloc] init];
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
        }
            
            break;
            
        default:
            break;
    }
    return cell;
}

- (CGFloat)getRowHeightWithCreateType:(MIHomeworkCreateContentType) createType{
    
    CGFloat rowHeight = 0;
    switch (createType) {
        case MIHomeworkCreateContentType_Localtion:
            rowHeight = MIExpandSelectTypeTableViewCellHeight;
            break;
        case MIHomeworkCreateContentType_Title:
            rowHeight = [MIInPutTypeTableViewCell cellHeightWithText:self.homeworkTitle];
            break;
        case MIHomeworkCreateContentType_Content:
            rowHeight = [MIInPutTypeTableViewCell cellHeightWithText:self.homeworkContent];
            break;
        case MIHomeworkCreateContentType_MarkingRemarks:
            rowHeight = [MIInPutTypeTableViewCell cellHeightWithText:self.teremark];
            break;
        case MIHomeworkCreateContentType_ActivityReq:
            rowHeight = [MIInPutTypeTableViewCell cellHeightWithText:self.activityReq];
            break;
        case MIHomeworkCreateContentType_CommitCount:
        case MIHomeworkCreateContentType_StatisticalType:
        case MIHomeworkCreateContentType_CommitTime:
        case MIHomeworkCreateContentType_HomeworkDifficulty:
        case MIHomeworkCreateContentType_ExaminationType:
            rowHeight = MISegmentTypeTableViewCellHeight;
            break;
        case MIHomeworkCreateContentType_AddWords:
        case MIHomeworkCreateContentType_Materials:
        case MIHomeworkCreateContentType_Answer:
        case MIHomeworkCreateContentType_AddCovers:
        case MIHomeworkCreateContentType_AddBgMusic:
        case MIHomeworkCreateContentType_AddFollowMaterials:
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
            rowHeight = [HomeworkTagsTableViewCell heightWithTags:@[] typeTitle:@"任务类型(单选)"] + 45;
            break;
        case MIHomeworkCreateContentType_TypeLabel:
            rowHeight = [HomeworkTagsTableViewCell heightWithTags:@[] typeTitle:@"分类标签(多选)"] + 45;
            break;
        case MIHomeworkCreateContentType_ActivityParticipant:
            rowHeight = [HomeworkTagsTableViewCell heightWithTags:@[] typeTitle:@"活动参与对象:"] + 45;
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
    
    [self.leftTableView registerNib:[UINib nibWithNibName:@"HomeworkTagsTableViewCell" bundle:nil] forCellReuseIdentifier:HomeworkTagsTableViewCellId];
    [self.rightTableView registerNib:[UINib nibWithNibName:@"HomeworkTagsTableViewCell" bundle:nil] forCellReuseIdentifier:HomeworkTagsTableViewCellId];
}

#pragma mark - setter && getter
- (NSMutableArray *)createTypeArray{
    
    if (!_createTypeArray) {
        
        _createTypeArray = [NSMutableArray array];
    }
    return _createTypeArray;
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
    
    [alertVC addAction:fileAction];
    [alertVC addAction:videoAction];
    [alertVC addAction:imageAction];
    [alertVC addAction:cancelAction];
    [self.navigationController presentViewController:alertVC
                                            animated:YES
                                          completion:nil];
}

- (void)addFileItem:(NSArray *)allowedUTIs withHomeworkItem:(HomeworkItem *)item
{
    self.isAddingAnswerItem = NO;
    UIDocumentPickerViewController * picker = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:allowedUTIs inMode:UIDocumentPickerModeImport];
    picker.delegate = self;
    objc_setAssociatedObject(picker , &keyOfPickerDocument, item, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self.navigationController presentViewController:picker animated:YES completion:nil];
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
                                                              [self.leftTableView reloadData];
                                                              [self.rightTableView reloadData];
                                                          }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:confirmAction];
    [self presentViewController:alertController animated:YES completion:nil];
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
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"删除"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                              item.audioUrl = @"";
                                                              NSString * coverUrl = item.audioCoverUrl;
                                                              item.imageUrl = coverUrl;
                                                              item.audioCoverUrl = @"";
                                                              item.type = HomeworkItemTypeImage;
                                                              [self.leftTableView reloadData];
                                                              [self.rightTableView reloadData];
                                                          }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:confirmAction];
    [self presentViewController:alertController animated:YES completion:nil];
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
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"删除"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                              item.audioUrl = @"";
                                                              NSString * coverUrl = item.audioCoverUrl;
                                                              item.imageUrl = coverUrl;
                                                              item.audioCoverUrl = @"";
                                                              item.type = HomeworkItemTypeImage;
                                                              [self.leftTableView reloadData];
                                                              [self.rightTableView reloadData];
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
                                                              [self.leftTableView reloadData];
                                                              [self.rightTableView reloadData];
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
                                                          }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:confirmAction];
    [self presentViewController:alertController animated:YES completion:nil];
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
                        
                        [weakSelf.leftTableView reloadData];
                        [weakSelf.rightTableView reloadData];
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
        [self.leftTableView reloadData];
        [self.rightTableView reloadData];
    }];
}
- (void)uploadImageForPath:(UIImage *)image
{
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
                [self.leftTableView reloadData];
                [self.rightTableView reloadData];
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
        
        [fileCoordinator coordinateReadingItemAtURL:url options:NSFileCoordinatorReadingWithoutChanges error:nil  byAccessor:^(NSURL * _Nonnull newURL) {
            // 读取文件
            NSString *fileName = [newURL lastPathComponent];
            [self saveLocalCachesCont:newURL fileName:fileName withObject:homeworkItem];
            
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
