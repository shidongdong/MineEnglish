//
//  MICreateTaskViewController.m
//  MinnieManager
//
//  Created by songzhen on 2019/6/3.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import <YYCategories/NSDate+YYAdd.h>
#import "TagService.h"
#import "ManagerServce.h"
#import "HomeworkService.h"
#import "DatePickerView.h"
#import "NSDate+Extension.h"
#import "MICreateWordView.h"
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

#import "MIAddWordTableViewCell.h"
#import "MIStockDetailViewController.h"
#import "MIHomeworkManagerViewController.h"
#import "ClassAndStudentSelectorController.h"


@interface MICreateTaskViewController ()<
UITableViewDelegate,
UITableViewDataSource,
ChooseDatePickerViewDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
UIDocumentPickerDelegate,
ClassAndStudentSelectorControllerDelegate
>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *leftTableView;
@property (weak, nonatomic) IBOutlet UITableView *rightTableView;
@property (assign, nonatomic) NSInteger leftRowCount;
@property (weak, nonatomic) IBOutlet UIView *midLineView;

// 老师端创建作业
@property (weak, nonatomic) IBOutlet UITableView *contentTableView;

@property (nonatomic, strong) NSMutableArray *createTypeArray;
@property (nonatomic,assign) MIHomeworkTaskType taskType;   // 任务类型

@property (nonatomic, strong) Homework *homework;           // 为空创建作业
@property (nonatomic, strong) ActivityInfo *activityInfo;   // 为空创建活动

@property (nonatomic,strong) FileInfo *currentFileInfo;
@property (nonatomic,strong) NSArray<ParentFileInfo*> *currentFileList;

@property (nonatomic, strong) HomeworkItem *wordsItem;    // 内容 word文本格式
@property (nonatomic, strong) HomeworkItem *contentItem;    // 内容 text文本格式


@property (nonatomic, strong) NSArray<Clazz *> *clazzs;     //班级对象列表
@property (nonatomic, strong) NSArray<User *> *students;    // 学生对象列表

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


@property (nonatomic, assign) CGFloat collectionWidth;
@property (nonatomic, assign) NSInteger isCreateTask;

@end

@implementation MICreateTaskViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    if (!self.teacherSider) {
        [self updateSplit:kRootModularWidth];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    if (!self.teacherSider) {
        [self updateSplit:kRootModularWidth+kFolderModularWidth];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    if (self.teacherSider) {
        self.collectionWidth = ScreenWidth;
        self.leftTableView.hidden = YES;
        self.rightTableView.hidden = YES;
        self.contentTableView.hidden = NO;
        self.contentTableView.separatorColor = [UIColor clearColor];
    } else {
        self.collectionWidth = (ScreenWidth - kRootModularWidth)/2.0;
        self.leftTableView.hidden = NO;
        self.rightTableView.hidden = NO;
        self.contentTableView.hidden = YES;
       
        self.leftTableView.delegate = self;
        self.leftTableView.dataSource = self;
        self.rightTableView.delegate = self;
        self.rightTableView.dataSource = self;
        
        self.leftTableView.separatorColor = [UIColor clearColor];
        self.rightTableView.separatorColor = [UIColor clearColor];
        self.leftTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        self.rightTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    
    [self registerCellNibs];
    [self setupTitleWithTaskType:self.taskType];
    
    [self requestTags];
    [self requestFormTags];
    [self requestGetFiles];
}

- (IBAction)closeBtnAction:(id)sender {
 
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)sendBtnAction:(id)sender {
    
    if (self.taskType == MIHomeworkTaskType_Activity) {
        [self createActivity];
    } else {
        [self createHomeworkTask];
    }
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
    
    if (activity) {
       
        self.isCreateTask = NO;
        self.activityInfo = activity;
        for (int i = 0; i < self.activityInfo.items.count; i++) {
           
            HomeworkItem *item = self.activityInfo.items[i];
            if (i == 0) {   // 内容
                self.contentItem = item;
            } else { // 附件
                [self.items addObject:item];
            }
        }
        NSMutableArray *classArray = [NSMutableArray array];
        for (int i = 0; i < self.activityInfo.classIds.count; i++) {
            Clazz *clazz = [[Clazz alloc] init];
            NSNumber *classId = self.activityInfo.classIds[i];
            clazz.classId = classId.integerValue;
            if (i < self.activityInfo.classNames.count) {
                
                clazz.name = self.activityInfo.classNames[i];
            } else {
                break;
            }
            [classArray addObject:clazz];
        } self.clazzs = classArray;
        
        NSMutableArray *studentArray = [NSMutableArray array];
        for (int i = 0; i < self.activityInfo.studentIds.count; i++) {
            User *studnet = [[User alloc] init];
            NSNumber *studentId = self.activityInfo.studentIds[i];
            studnet.userId = studentId.integerValue;
            if (i < self.activityInfo.studentNames.count) {
                
                studnet.nickname = self.activityInfo.studentNames[i];
            } else {
                break;
            }
            [studentArray addObject:studnet];
        } self.students = studentArray;
        
    } else {
        self.isCreateTask = YES;
        self.activityInfo.submitNum = 4;
        self.activityInfo.limitTimes = 300;
        self.activityInfo.endTime = [[NSDate date] stringWithFormat:@"yyyy-MM-dd"];
        self.activityInfo.startTime = [[NSDate date] stringWithFormat:@"yyyy-MM-dd"];
    }
    [self.createTypeArray removeAllObjects];
    [self.createTypeArray addObjectsFromArray:[self getNumberOfRowsInSection]];
    
    if (self.teacherSider) {
        [self.contentTableView reloadData];
    } else {
        self.leftRowCount = 7;
        [self.leftTableView reloadData];
        [self.rightTableView reloadData];
    }
}


- (void)setupCreateHomework:(Homework *_Nullable)homework
            currentFileInfo:(FileInfo *_Nullable)currentFileInfo
                   taskType:(MIHomeworkTaskType)taskType{
   
    if (taskType == MIHomeworkTaskType_Activity) {
        [self setupCreateActivity:nil];
        return;
    }
    
    self.currentFileInfo = currentFileInfo;
    if (homework == nil) {// 新建作业
      
        self.taskType = taskType;
        self.isCreateTask = YES;
        self.limitTimeSecs = 300;
        self.homework.style = 1;
        self.homework.level = 1;
        self.homework.category = 1;
        self.homework.limitTimes = 300;
        self.homework.examType = 1;
        self.wordsItem.palytime = 1.0;
    } else {// 编辑作业
        
        self.taskType = [self setTaskTypeWithHomeWork:homework];
        self.isCreateTask = NO;
        self.homework = homework;
        [self updateHomeworkItemData];
        self.selectFormTag = self.homework.formTag;
        self.selectedTags = [NSMutableArray arrayWithArray:self.homework.tags];
        self.followItems = [NSMutableArray arrayWithArray:self.homework.otherItem];
    }
    
    [self.createTypeArray removeAllObjects];
    [self.createTypeArray addObjectsFromArray:[self getNumberOfRowsInSection]];

    if (self.teacherSider) {
        [self.contentTableView reloadData];
    } else {
        self.leftRowCount = 7;
        [self.leftTableView reloadData];
        [self.rightTableView reloadData];
    }
}

- (void)updateHomeworkItemData{
    
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

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == self.contentTableView) {
        return self.createTypeArray.count;
    } else {
        if (tableView == self.leftTableView) {
            return self.leftRowCount;
        } else {
            return self.createTypeArray.count - self.leftRowCount;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    if (tableView == self.contentTableView) {
        NSNumber *createTypeNum = self.createTypeArray[indexPath.row];
        cell = [self getTableViewCellAtIndexPath:indexPath
                                      createType:createTypeNum.integerValue
                                       tableView:tableView];
    } else {
        if (tableView == self.leftTableView) {
            
            NSNumber *createTypeNum = self.createTypeArray[indexPath.row];
            cell = [self getTableViewCellAtIndexPath:indexPath
                                          createType:createTypeNum.integerValue
                                           tableView:tableView];
        } else {
            
            NSNumber *createTypeNum = self.createTypeArray[indexPath.row + self.leftRowCount];
            cell = [self getTableViewCellAtIndexPath:indexPath
                                          createType:createTypeNum.integerValue
                                           tableView:tableView];
        }
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSNumber *createTypeNum;
    if (tableView == self.contentTableView) {
        
        createTypeNum = self.createTypeArray[indexPath.row];
    } else {
        
        if (tableView == self.leftTableView) {
            createTypeNum = self.createTypeArray[indexPath.row];
        } else {
            createTypeNum = self.createTypeArray[indexPath.row + self.leftRowCount];
        }
    }
    return [self getHeightForRowWithCreateType:createTypeNum.integerValue];
}


#pragma mark - 设置标题
- (void)setupTitleWithTaskType:(MIHomeworkTaskType)taskType{
    
    switch (taskType) {
        case MIHomeworkTaskType_notify:
            self.homework.typeName = @"通知";
            self.titleLabel.text = self.isCreateTask ? @"新建通知" : @"通知详情";
            break;
        case MIHomeworkTaskType_FollowUp:
            self.homework.typeName = @"跟读任务";
            self.titleLabel.text = self.isCreateTask ? @"新建跟读任务" : @"跟读任务详情";
            break;
        case MIHomeworkTaskType_WordMemory:
            self.homework.typeName = @"单词记忆";
            self.titleLabel.text = self.isCreateTask ? @"新建单词记忆" : @"单词记忆详情";
            break;
        case MIHomeworkTaskType_GeneralTask:
            self.homework.typeName = @"普通任务";
            self.titleLabel.text = self.isCreateTask ? @"新建普通任务" : @"普通任务详情";
            break;
        case MIHomeworkTaskType_Activity:
            self.homework.typeName = @"活动";
            self.titleLabel.text = self.isCreateTask ? @"新建活动" : @"活动详情";
            break;
        case MIHomeworkTaskType_ExaminationStatistics:
            self.homework.typeName = @"考试统计";
            self.titleLabel.text = self.isCreateTask ? @"新建考试统计" : @"考试统计详情";
            break;
        default:
            break;
    }
}
- (MIHomeworkTaskType)setTaskTypeWithHomeWork:(Homework *)homework{
    
    MIHomeworkTaskType taskType = MIHomeworkTaskType_GeneralTask;
    if (homework.typeName.length == 0) {
        return taskType;
    }
    if ([homework.typeName isEqualToString:@"通知"]) {
        taskType = MIHomeworkTaskType_notify;
    } else if ([homework.typeName isEqualToString:@"跟读任务"]) {
        taskType = MIHomeworkTaskType_FollowUp;
    } else if ([homework.typeName isEqualToString:@"单词记忆"]) {
        taskType = MIHomeworkTaskType_WordMemory;
    } else if ([homework.typeName isEqualToString:@"普通任务"]) {
        taskType = MIHomeworkTaskType_GeneralTask;
    } else if ([homework.typeName isEqualToString:@"考试统计"]) {
        taskType = MIHomeworkTaskType_ExaminationStatistics;
    }
    return taskType;
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
                [chooseDataPicker setDefultParentFileInfo:self.homework.fileInfos.parentFile fileArray:self.currentFileList];
                WeakifySelf;
                chooseDataPicker.localCallback = ^(id _Nonnull result) {
                  
                    // 选则父文件夹，默认选择对应文件夹下面的子文件夹
                    if ([result isKindOfClass:[ParentFileInfo class]]) {
                        
                        ParentFileInfo *parentResult = result;
                        if (weakSelf.homework.fileInfos.subFile.parentId !=parentResult.fileInfo.fileId) {
                            FileInfo *subInfo = parentResult.subFileList.firstObject;
                            weakSelf.homework.fileInfos.subFile = subInfo;
                        }
                        weakSelf.homework.fileInfos.parentFile = parentResult.fileInfo;
                        [weakContentCell setupWithLeftText:parentResult.fileInfo.fileName
                                                 rightText:weakSelf.homework.fileInfos.subFile.fileName
                                                createType:createType];
                    }
                };
                [chooseDataPicker show];
            };
            contentCell.rightExpandCallback = ^{
                
                MIExpandPickerView * chooseDataPicker = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MIExpandPickerView class]) owner:nil options:nil] lastObject];
                chooseDataPicker.localCallback = ^(id _Nonnull result) {
                    if ([result isKindOfClass:[FileInfo class]]) {
                        
                        FileInfo *subResult = result;
                        weakSelf.homework.fileInfos.subFile = result;
                        [weakContentCell setupWithLeftText:weakSelf.homework.fileInfos.parentFile.fileName
                                                 rightText:subResult.fileName
                                                createType:createType];
                    }
                };
                [chooseDataPicker setDefultFileInfo:
                 self.homework.fileInfos.subFile fileArray:self.currentFileList];
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
                if (weakSelf.taskType == MIHomeworkTaskType_Activity) {
                    weakSelf.activityInfo.title = text;
                } else {
                    weakSelf.homework.title = text;
                }
                if (heightChanged) {
                    [weakTableView beginUpdates];
                    [weakTableView endUpdates];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakTitleCell ajustTextView];
                    });
                }
            };
            if (self.taskType == MIHomeworkTaskType_Activity) {
                
                [titleCell setupWithText:self.activityInfo.title
                                   title:@"标题:"
                              createType:createType
                             placeholder:@"输入题目"];
            } else {
                [titleCell setupWithText:self.homework.title
                                   title:@"标题:"
                              createType:createType
                             placeholder:@"输入题目"];
            }
            cell = titleCell;
        }
            break;
        case MIHomeworkCreateContentType_Content: // 内容 && 活动要求
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
            if (weakSelf.taskType == MIHomeworkTaskType_Activity) {
                [contentCell setupWithText:self.contentItem.text
                                     title:@"活动要求:"
                                createType:createType
                               placeholder:@"请输入活动或具体要求"];
            } else {
                [contentCell setupWithText:self.contentItem.text
                                     title:@"内容:"
                                createType:createType
                               placeholder:@"输入作业题目或具体要求"];
            }
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
            MIAddWordTableViewCell *tagsCell = [tableView dequeueReusableCellWithIdentifier:MIAddWordTableViewCellId forIndexPath:indexPath];
            __weak UITableView *weakTableView = tableView;
            __weak MIAddWordTableViewCell *weakTagCell = tagsCell;
            tagsCell.callback = ^(BOOL isAdd, NSArray * _Nonnull dataArray) {
                if (isAdd) {
                    
                    MICreateWordView *wordView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MICreateWordView class]) owner:nil options:nil].lastObject;
                    wordView.callback = ^(WordInfo * _Nullable word) {
                        
                        NSMutableArray *wordInfoList = [NSMutableArray arrayWithArray:weakSelf.wordsItem.words];
                        [wordInfoList addObject:word];
                        weakSelf.wordsItem.words = (NSArray<WordInfo>*)wordInfoList;
                        [weakTagCell setupAwordWithDataArray:weakSelf.wordsItem.words collectionView:weakSelf.collectionWidth];
                        [weakTableView beginUpdates];
                        [weakTableView endUpdates];
                    };
                    wordView.frame = [UIScreen mainScreen].bounds;
                    [[UIApplication sharedApplication].keyWindow addSubview:wordView];
                    
                } else {
                    
                    NSMutableArray *wordInfo = [NSMutableArray array];
                    for (id tempObjc in dataArray) {
                        if ([tempObjc isKindOfClass:[WordInfo class]]) {
                            [wordInfo addObject:tempObjc];
                        }
                    }
                    weakSelf.wordsItem.words = (NSArray<WordInfo>*)wordInfo;
                    [weakTagCell setupAwordWithDataArray:weakSelf.wordsItem.words collectionView:weakSelf.collectionWidth];
                    [weakTableView beginUpdates];
                    [weakTableView endUpdates];
                }
            };
            [tagsCell setupAwordWithDataArray:self.wordsItem.words collectionView:weakSelf.collectionWidth];
            cell = tagsCell;
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
                [weakContentCell setupWithItems:weakSelf.items vc:weakSelf contentType:createType];
                [weakTableView beginUpdates];
                [weakTableView endUpdates];
            };
            [contentCell setupWithItems:self.items vc:self contentType:createType];
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
                
                HomeworkItem *coverItem = items.lastObject;
                weakSelf.activityInfo.actCoverUrl = coverItem.imageUrl;
                [weakContentCell setupWithItems:items vc:weakSelf contentType:createType];
                [weakTableView beginUpdates];
                [weakTableView endUpdates];
            };
            if (self.activityInfo.actCoverUrl.length) {
                
                HomeworkItem *coverItem = [[HomeworkItem alloc] init];
                coverItem.imageUrl = self.activityInfo.actCoverUrl;
                coverItem.type = @"image";
                [contentCell setupWithItems:@[coverItem] vc:self contentType:createType];
            } else {
                [contentCell setupWithItems:@[] vc:self contentType:createType];
            }
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
                
                weakSelf.wordsItem = items.lastObject;
                [weakContentCell setupWithItems:items vc:weakSelf contentType:createType];
                [weakTableView beginUpdates];
                [weakTableView endUpdates];
            };
            if (self.wordsItem.audioUrl.length) {
                [contentCell setupWithItems:@[self.wordsItem] vc:self contentType:createType];
            } else {
                [contentCell setupWithItems:@[] vc:self contentType:createType];
            }
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
                [weakSelf.followItems addObject:items.lastObject];
                [weakContentCell setupWithItems:weakSelf.followItems vc:weakSelf contentType:createType];
                [weakTableView beginUpdates];
                [weakTableView endUpdates];
            };
            [contentCell setupWithItems:self.followItems vc:self contentType:createType];
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
                
                NSDate *starDate = [NSDate dateWithString:weakSelf.activityInfo.startTime format:@"yyyy-MM-dd HH:mm:ss"];
                [DatePickerView showInView:[UIApplication sharedApplication].keyWindow
                                      date:[starDate dateAtStartOfDay]
                                  callback:^(NSDate *date) {
                                      NSString *startTime = [[date dateAtStartOfDay] stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
                                      weakSelf.activityInfo.startTime = startTime;
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
                NSDate *endDate = [NSDate dateWithString:weakSelf.activityInfo.endTime format:@"yyyy-MM-dd HH:mm:ss"];
                [DatePickerView showInView:[UIApplication sharedApplication].keyWindow
                                      date:[endDate dateAtStartOfDay]
                                  callback:^(NSDate *date) {
                                      NSString *endTime = [[date dateAtStartOfDay] stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
                                      weakSelf.activityInfo.endTime = endTime;
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
            [tagsCell setupWithTags:self.formTags selectedTags:selectFormTags typeTitle:@"任务类型(单选):" collectionWidth:weakSelf.collectionWidth];
            
            WeakifySelf;
            [tagsCell setSelectCallback:^(NSString *tag) {
                weakSelf.selectFormTag = (weakSelf.selectFormTag.length > 0) ? @"" : tag;
            }];
            
            [tagsCell setManageCallback:^{
                MITagsViewController *tagsVC = [[MITagsViewController alloc] initWithNibName:@"MITagsViewController" bundle:nil];
                tagsVC.type = TagsHomeworkFormType;
                tagsVC.teacherSider = weakSelf.teacherSider;
                [weakSelf.navigationController pushViewController:tagsVC animated:YES];
            }];
            
            cell = tagsCell;
        }
            break;
        case MIHomeworkCreateContentType_TypeLabel:
        {
            MITagsTableViewCell *tagsCell = [tableView dequeueReusableCellWithIdentifier:MITagsTableViewCellId forIndexPath:indexPath];
            tagsCell.type = HomeworkTagsTableViewCellSelectMutiType;
            [tagsCell setupWithTags:self.tags selectedTags:self.selectedTags typeTitle:@"分类标签(多选):" collectionWidth:self.collectionWidth];
            
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
                tagsVC.teacherSider = weakSelf.teacherSider;
                [weakSelf.navigationController pushViewController:tagsVC animated:YES];
            }];
            cell = tagsCell;
        }
            break;
        case MIHomeworkCreateContentType_ActivityParticipant:
        {
            MIAddWordTableViewCell *tagsCell = [tableView dequeueReusableCellWithIdentifier:MIAddWordTableViewCellId forIndexPath:indexPath];
            WeakifySelf;
            __weak UITableView *weakTableView = tableView;
            __weak MIAddWordTableViewCell *weakTagCell = tagsCell;
            tagsCell.callback = ^(BOOL isAdd, NSArray * _Nonnull dataArray) {
                
                if (isAdd) {
                    ClassAndStudentSelectorController *vc = [[ClassAndStudentSelectorController alloc] init];
                    vc.delegate = weakSelf;
                    vc.isCreateActivityTask = YES;
                    [weakSelf.navigationController presentViewController:vc animated:YES completion:nil];
                } else {
                    
                    NSMutableArray *tempClazz = [NSMutableArray array];
                    NSMutableArray *tempStudent = [NSMutableArray array];
                    for (id tempObjc in dataArray) {
                        if ([tempObjc isKindOfClass:[Clazz class]]) {
                            [tempClazz addObject:tempObjc];
                        } else if ([tempObjc isKindOfClass:[User class]]){
                            [tempStudent addObject:tempObjc];
                        }
                    }
                    weakSelf.clazzs = tempClazz;
                    weakSelf.students = tempStudent;
                    [weakTagCell setupParticipateWithClazzArray:weakSelf.clazzs studentArray:weakSelf.students collectionView:weakSelf.collectionWidth];
                    [weakTableView beginUpdates];
                    [weakTableView endUpdates];
                }
            };
            [tagsCell setupParticipateWithClazzArray:self.clazzs studentArray:self.students collectionView:weakSelf.collectionWidth];
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
                          @(MIHomeworkCreateContentType_TypeLabel)
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
                          @(MIHomeworkCreateContentType_TypeLabel)
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
                          @(MIHomeworkCreateContentType_TypeLabel)
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
                          @(MIHomeworkCreateContentType_TypeLabel)
                          ]];
        }
            break;
        case MIHomeworkTaskType_Activity:
        {
            // 标题、添加封面、活动要求、添加材料、可提交次数、视频时限、活动开始时间、活动结束时间、活动参与对象
            typeArray =
            [NSMutableArray arrayWithArray:@[@(MIHomeworkCreateContentType_Title),
                          @(MIHomeworkCreateContentType_AddCovers),
                          @(MIHomeworkCreateContentType_Content),
                          @(MIHomeworkCreateContentType_Materials),
                          @(MIHomeworkCreateContentType_CommitCount),
                          @(MIHomeworkCreateContentType_VideoTimeLimit),
                          @(MIHomeworkCreateContentType_ActivityStartTime),
                          @(MIHomeworkCreateContentType_ActivityEndTime),
                          @(MIHomeworkCreateContentType_ActivityParticipant)
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
                          @(MIHomeworkCreateContentType_TypeLabel)
                          ]];
        }
            break;
        default:
            break;
    }
    if (self.taskType == MIHomeworkTaskType_Activity) {
        if (self.isCreateTask == NO) {
          
            NSDate *startDate = [NSDate dateWithString:self.activityInfo.startTime format:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *endDate = [NSDate dateWithString:self.activityInfo.endTime format:@"yyyy-MM-dd HH:mm:ss"];
            if ([startDate isLaterThanDate:[[NSDate date] dateAtStartOfDay]] ||
                [endDate isEarlierThanDate:[[NSDate date] dateAtStartOfDay]]
                ) {
                [typeArray addObject:@(MIHomeworkCreateContentType_Delete)];
            }
        }
    } else {
        if (self.isCreateTask == NO) {
            [typeArray addObject:@(MIHomeworkCreateContentType_Delete)];
        }
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
            rowHeight = [MIInPutTypeTableViewCell cellHeightWithText:self.homework.title cellWidth:self.collectionWidth];
            break;
        case MIHomeworkCreateContentType_Content:
            rowHeight = [MIInPutTypeTableViewCell cellHeightWithText:self.contentItem.text cellWidth:self.collectionWidth];
            break;
        case MIHomeworkCreateContentType_MarkingRemarks:
            rowHeight = [MIInPutTypeTableViewCell cellHeightWithText:self.homework.teremark cellWidth:self.collectionWidth];
            break;
        case MIHomeworkCreateContentType_CommitCount:
        case MIHomeworkCreateContentType_StatisticalType:
        case MIHomeworkCreateContentType_CommitTime:
        case MIHomeworkCreateContentType_HomeworkDifficulty:
        case MIHomeworkCreateContentType_ExaminationType:
            rowHeight = MISegmentTypeTableViewCellHeight;
            break;
        case MIHomeworkCreateContentType_AddWords:
            if (self.wordsItem.words.count) {
                NSMutableArray *words = [NSMutableArray array];
                [words addObjectsFromArray:self.wordsItem.words];
                WordInfo *wordInfo = [[WordInfo alloc] init];
                wordInfo.english = @"+";
                wordInfo.chinese = @"添加单词";
                [words addObject:wordInfo];
                rowHeight = [MIAddWordTableViewCell heightWithTags:words collectionView:self.collectionWidth] + 50;
                break;
            } else {
                rowHeight = MITitleTypeTableViewCellHeight;
            }
        case MIHomeworkCreateContentType_Materials:
            if (self.items.count) {
                rowHeight = self.items.count * 112 + MITitleTypeTableViewCellHeight;
            } else {
                rowHeight = MITitleTypeTableViewCellHeight;
            }
            break;
        case MIHomeworkCreateContentType_Answer:
            if (self.answerItems.count) {
                rowHeight = self.answerItems.count * 112  + MITitleTypeTableViewCellHeight;
            } else {
                rowHeight = MITitleTypeTableViewCellHeight;
            }
            break;
        case MIHomeworkCreateContentType_AddCovers:
            if (self.activityInfo.actCoverUrl.length) {
                rowHeight = 112 + MITitleTypeTableViewCellHeight;
            } else {
                rowHeight = MITitleTypeTableViewCellHeight;
            }
            break;
        case MIHomeworkCreateContentType_AddBgMusic:
            if (self.wordsItem.bgmusicUrl.length) {
                rowHeight = 112 + MITitleTypeTableViewCellHeight;
            } else {
                rowHeight = MITitleTypeTableViewCellHeight;
            }
            break;
        case MIHomeworkCreateContentType_AddFollowMaterials:
            if (self.followItems.count) {
                rowHeight = self.followItems.count * 112 + MITitleTypeTableViewCellHeight;
            } else {
                rowHeight = MITitleTypeTableViewCellHeight;
            }
            break;
        case MIHomeworkCreateContentType_WordsTimeInterval:
        case MIHomeworkCreateContentType_TimeLimit:
        case MIHomeworkCreateContentType_ActivityStartTime:
        case MIHomeworkCreateContentType_ActivityEndTime:
        case MIHomeworkCreateContentType_VideoTimeLimit:
            rowHeight = MIExpandSelectTypeTableViewCellHeight;
            break;
        case MIHomeworkCreateContentType_Label:
            rowHeight = [MITagsTableViewCell heightWithTags:self.formTags collectionWidth:self.collectionWidth] + 50;
            break;
        case MIHomeworkCreateContentType_TypeLabel:
            rowHeight = [MITagsTableViewCell heightWithTags:self.tags collectionWidth:self.collectionWidth] + 50;
            break;
        case MIHomeworkCreateContentType_ActivityParticipant:
        {
            NSMutableArray *participant = [NSMutableArray array];
            [participant addObjectsFromArray:self.clazzs];
            [participant addObjectsFromArray:self.students];
            [participant addObject:@"+添加对象"];
            rowHeight = [MIAddWordTableViewCell heightWithTags:participant collectionView:self.collectionWidth] + 50;
        }
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
    
    [self.leftTableView registerNib:[UINib nibWithNibName:@"MIAddWordTableViewCell" bundle:nil] forCellReuseIdentifier:MIAddWordTableViewCellId];
    [self.rightTableView registerNib:[UINib nibWithNibName:@"MIAddWordTableViewCell" bundle:nil] forCellReuseIdentifier:MIAddWordTableViewCellId];
    
    
    [self.contentTableView registerNib:[UINib nibWithNibName:@"MIInPutTypeTableViewCell" bundle:nil] forCellReuseIdentifier:MIInPutTypeTableViewCellId];
    [self.contentTableView registerNib:[UINib nibWithNibName:@"MISegmentTypeTableViewCell" bundle:nil] forCellReuseIdentifier:MISegmentTypeTableViewCellId];
    [self.contentTableView registerNib:[UINib nibWithNibName:@"MIAddTypeTableViewCell" bundle:nil] forCellReuseIdentifier:MIAddTypeTableViewCellId];
    [self.contentTableView registerNib:[UINib nibWithNibName:@"MITitleTypeTableViewCell" bundle:nil] forCellReuseIdentifier:MITitleTypeTableViewCellId];
    [self.contentTableView registerNib:[UINib nibWithNibName:@"MIExpandSelectTypeTableViewCell" bundle:nil] forCellReuseIdentifier:MIExpandSelectTypeTableViewCellId];
    [self.contentTableView registerNib:[UINib nibWithNibName:@"MITagsTableViewCell" bundle:nil] forCellReuseIdentifier:MITagsTableViewCellId];
    [self.contentTableView registerNib:[UINib nibWithNibName:@"MIAddWordTableViewCell" bundle:nil] forCellReuseIdentifier:MIAddWordTableViewCellId];
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
        _homework.fileInfos.subFile = [[FileInfo alloc] init];
        _homework.fileInfos.parentFile = [[FileInfo alloc] init];
    }
    return _homework;
}

- (ActivityInfo *)activityInfo{
    if (!_activityInfo) {
        _activityInfo = [[ActivityInfo alloc] init];
    }
    return _activityInfo;
}

- (HomeworkItem *)wordsItem{
    if (!_wordsItem) {
        _wordsItem = [[HomeworkItem alloc] init];
        _wordsItem.type = @"word";
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

- (FileInfo *)currentFileInfo{

    if (!_currentFileInfo) {
        _currentFileInfo = [[FileInfo alloc] init];
    }
    return _currentFileInfo;
}

#pragma mark - 删除任务 && 活动
- (void)deleteHomework {
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
                                                              
                                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                                  
                                                                  [weakSelf deleteTask];
                                                              });
                                                          }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:confirmAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)deleteTask{
    
    if (self.taskType == MIHomeworkTaskType_Activity) {
        WeakifySelf;
        [HUD showProgressWithMessage:@"正在删除活动"];
        [ManagerServce requestDeleteActivityId:self.activityInfo.activityId callback:^(Result *result, NSError *error) {
            
            if (error) return;
            [HUD showWithMessage:@"删除成功"];
            if (weakSelf.callBack) {
                weakSelf.callBack(YES);
            }
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
    } else {
        WeakifySelf;
        [HUD showProgressWithMessage:@"正在删除作业"];
        [HomeworkService deleteHomeworks:@[@(self.homework.homeworkId)]
                                callback:^(Result *result, NSError *error) {
                                    if (error != nil) {
                                        [HUD showErrorWithMessage:@"删除失败"];
                                        return;
                                        
                                    }
                                    [HUD showWithMessage:@"删除成功"];
                                        if (weakSelf.callBack) {
                                            weakSelf.callBack(YES);
                                        }
                                    [weakSelf popToVCAfterDelete];
                                }];
    }
}
- (void)popToVCAfterDelete{
    
    UINavigationController *tempNav = self.navigationController;
    for (UIViewController *tempVC in tempNav.viewControllers) {
      
        if (self.teacherSider) {
            if ([tempVC isKindOfClass:[MIHomeworkManagerViewController class]]) {
                [self.navigationController popToViewController:tempVC animated:YES];
                break;
            }
            if (!tempVC) {
                [self.navigationController popToRootViewControllerAnimated:YES];
                break;
            }
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        } 
    }
}


#pragma mark - 请求标签 && 类型标签
- (void)requestTags {
  
    [TagService requestTagsWithCallback:^(Result *result, NSError *error) {
        
        if (error != nil) {
            [HUD showErrorWithMessage:@"标签请求失败"];
            return ;
        }
        self.tags = (NSArray *)(result.userInfo);
        if (self.teacherSider) {
            [self.contentTableView reloadData];
        } else {
            [self.leftTableView reloadData];
            [self.rightTableView reloadData];
        }
    }];
}
- (void)requestFormTags{
    
    WeakifySelf;
    [TagService requestFormTagsWithCallback:^(Result *result, NSError *error) {
        if (error != nil) {
            
            [HUD showErrorWithMessage:@"标签请求失败"];
            return ;
        }
        self.formTags = (NSArray *)(result.userInfo);
        if (weakSelf.teacherSider) {
            [weakSelf.contentTableView reloadData];
        } else {
            [weakSelf.leftTableView reloadData];
            [weakSelf.rightTableView reloadData];
        }
    }];
}

- (void)requestGetFiles{
    
    WeakifySelf;
    [ManagerServce requestGetFilesWithFileId:0 callback:^(Result *result, NSError *error) {
        StrongifySelf;
        if (error) return ;
        NSDictionary *dict = (NSDictionary *)(result.userInfo);
        weakSelf.currentFileList = (NSArray *)(dict[@"list"]);
        [strongSelf setFileInfo:strongSelf.currentFileList];
        if (weakSelf.createTypeArray.count) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            if (weakSelf.teacherSider) {
                [weakSelf.contentTableView rectForRowAtIndexPath:indexPath];
            } else {
                [weakSelf.leftTableView rectForRowAtIndexPath:indexPath];
            }
        }
    }];
}

- (void)setFileInfo:(NSArray *)currentFileList{
    
    for (ParentFileInfo *parentInfo in currentFileList) {
        
        for (FileInfo *subInfo in parentInfo.subFileList) {
           
            if (subInfo.fileId == self.currentFileInfo.fileId) {
                
                self.homework.fileInfos.subFile = subInfo;
                self.homework.fileInfos.parentFile = parentInfo.fileInfo;
            }
        }
    }
    if (self.homework.fileInfos.parentFile.fileName.length == 0) {
       
        ParentFileInfo *parentFileInfo = currentFileList.firstObject;
        self.homework.fileInfos.parentFile = parentFileInfo.fileInfo;
        self.homework.fileInfos.subFile = parentFileInfo.subFileList.firstObject;
    }
}

#pragma mark - ClassAndStudentSelectorControllerDelegate
- (void)classesDidSelect:(NSArray<Clazz *> *)classes{
    
    NSMutableArray *clazzs = [NSMutableArray array];
    [clazzs addObjectsFromArray:self.clazzs];
    [clazzs addObjectsFromArray:classes];
    
    // 去重
    NSMutableArray *resultArrM = [NSMutableArray array];
    for (Clazz *tempClass in clazzs) {
        if (![resultArrM containsObject:tempClass]) {
            [resultArrM addObject:tempClass];
        }
    }
    self.clazzs = resultArrM;
    if (self.teacherSider) {
        [self.contentTableView reloadData];
    } else {
        [self.leftTableView reloadData];
        [self.rightTableView reloadData];
    }
}
- (void)studentsDidSelect:(NSArray<User *> *)students{
    
    NSMutableArray *tempStudents = [NSMutableArray array];
    [tempStudents addObjectsFromArray:self.students];
    [tempStudents addObjectsFromArray:students];
    
    // 去重
    NSMutableArray *resultArrM = [NSMutableArray array];
    for (User *tempStu in tempStudents) {
        if (![resultArrM containsObject:tempStu]) {
            [resultArrM addObject:tempStu];
        }
    }
    self.students = resultArrM;
    if (self.teacherSider) {
        [self.contentTableView reloadData];
    } else {
        [self.leftTableView reloadData];
        [self.rightTableView reloadData];
    }
}


#pragma mark - 创建活动
- (void)createActivity{
   
    if (self.activityInfo.title.length == 0) {
        [HUD showErrorWithMessage:@"活动标题不能为空"];
        return;
    }
    if (self.contentItem.text.length == 0) {
        [HUD showErrorWithMessage:@"活动要求不能为空"];
        return;
    }
    if (self.activityInfo.actCoverUrl.length == 0) {
        [HUD showErrorWithMessage:@"请添加活动封面"];
        return;
    }
    
    if ([[NSDate dateWithString:self.activityInfo.startTime format:@"yyyy-MM-dd HH:mm:ss"] isLaterThanDate:[NSDate dateWithString:self.activityInfo.endTime format:@"yyyy-MM-dd HH:mm:ss"]]) {
        [HUD showErrorWithMessage:@"开始时间晚于结束时间"];
        return;
    }
    
    NSMutableArray *resultItems = [NSMutableArray array];
    [resultItems addObject:self.contentItem];
    [resultItems addObjectsFromArray:self.items];
    self.activityInfo.items = resultItems;
    
    NSMutableArray *tempClazzIds = [NSMutableArray array];
    NSMutableArray *tempStudentIds = [NSMutableArray array];
    NSMutableArray *tempClazzNames = [NSMutableArray array];
    NSMutableArray *tempStudentNames = [NSMutableArray array];
    for (Clazz *tempObjc in self.clazzs) {
        
        [tempClazzIds addObject:@(tempObjc.classId)];
        [tempClazzNames addObject:tempObjc.name];
    }
    for (User *tempObjc in self.students) {
        
        [tempStudentIds addObject:@(tempObjc.userId)];
        [tempStudentNames addObject:tempObjc.nickname];
    }
    self.activityInfo.classIds = tempClazzIds;
    self.activityInfo.classNames = tempClazzNames;
    self.activityInfo.studentIds = tempStudentIds;
    self.activityInfo.studentNames = tempStudentNames;
    if (self.activityInfo.studentIds.count + self.activityInfo.classIds.count == 0) {
        [HUD showErrorWithMessage:@"活动参与对象不能为空"];
        return;
    }
    
    if (self.isCreateTask == 0) {
        [HUD showProgressWithMessage:@"正在新建活动"];
    } else {
        [HUD showProgressWithMessage:@"正在更新活动"];
    }
    WeakifySelf;
    [ManagerServce requestCreateActivity:self.activityInfo callback:^(Result *result, NSError *error) {
        if (error != nil) {
            if (weakSelf.isCreateTask) {
                [HUD showErrorWithMessage:@"新建活动失败"];
            } else {
                [HUD showErrorWithMessage:@"更新活动失败"];
            }
            return;
        }
        
        if (weakSelf.isCreateTask) {
            [HUD showWithMessage:@"新建活动成功"];
        } else {
            [HUD showWithMessage:@"更新活动成功"];
        }
        if (weakSelf.callBack) {
            weakSelf.callBack(NO);
        }
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark - 创建作业任务
- (void)createHomeworkTask{
    
    if (self.homework.title.length == 0) {
        [HUD showErrorWithMessage:@"作业标题不能为空"]; return;
    }
    if (self.contentItem.text.length == 0) {
        [HUD showErrorWithMessage:@"作业内容不能为空"]; return;
    }
    if (self.homework.fileInfos.parentFile == nil || self.homework.fileInfos.subFile == nil) {
        [HUD showErrorWithMessage:@"请选择位置"]; return;
    }
    NSMutableArray *resultItems = [NSMutableArray array];
    if (self.taskType == MIHomeworkTaskType_WordMemory) {
        
        if (self.wordsItem.words.count == 0) {
            [HUD showErrorWithMessage:@"单词个数不能为空"]; return;
        }
        [resultItems addObject:self.wordsItem];
    }
    if (self.taskType == MIHomeworkTaskType_FollowUp) {
        if (self.followItems.count == 0) {
            [HUD showErrorWithMessage:@"请添加跟读材料"]; return;
        }
    }
    [resultItems addObject:self.contentItem];
    [resultItems addObjectsFromArray:self.items];
    
    self.homework.tags = self.selectedTags;
    self.homework.formTag = self.selectFormTag;
    self.homework.items = resultItems;
    self.homework.answerItems = self.answerItems;
    self.homework.createTeacher = APP.currentUser;
    self.homework.otherItem = self.followItems;
    
    if (self.isCreateTask == 0) {
        [HUD showProgressWithMessage:@"正在新建作业"];
    } else {
        [HUD showProgressWithMessage:@"正在更新作业"];
    }
    WeakifySelf;
    [HomeworkService createHomework:self.homework
                           callback:^(Result *result, NSError *error) {
                               if (error != nil) {
                                   if (weakSelf.isCreateTask) {
                                       [HUD showErrorWithMessage:@"新建作业失败"];
                                   } else {
                                       [HUD showErrorWithMessage:@"更新作业失败"];
                                   }
                                   return;
                               }
                               
                               if (weakSelf.isCreateTask) {
                                   [HUD showWithMessage:@"新建作业成功"];
                               } else {
                                   [HUD showWithMessage:@"更新作业成功"];
                               }
                               if (weakSelf.callBack) {
                                   weakSelf.callBack(NO);
                               }
                               [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationKeyOfAddHomework object:nil];
                               [weakSelf.navigationController popViewControllerAnimated:YES];
                           }];
}

@end
