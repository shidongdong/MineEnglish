//
//  MICreateHomeworkTaskView.m
//  MinnieManager
//
//  Created by songzhen on 2019/5/29.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import "DatePickerView.h"
#import "MIExpandPickerView.h"
#import "ChooseDatePickerView.h"
#import "TagsViewController.h"
#import "HomeworkTagsTableViewCell.h"
#import "MIAddTypeTableViewCell.h"
#import "MITitleTypeTableViewCell.h"
#import "MICreateHomeworkTaskView.h"
#import "MIInPutTypeTableViewCell.h"
#import "MISegmentTypeTableViewCell.h"
#import "MIExpandSelectTypeTableViewCell.h"

#import <objc/runtime.h>
#import <AVKit/AVKit.h>
#import "FileUploader.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>


@interface MICreateHomeworkTaskView ()<
UITableViewDelegate,
UITableViewDataSource,
ChooseDatePickerViewDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
UIDocumentPickerDelegate
>
@property (copy, nonatomic) NSString *homeworkTitle;
@property (copy, nonatomic) NSString *homeworkContent;
@property (copy, nonatomic) NSString *homeworkMarks;    //批改标注
@property (copy, nonatomic) NSString *activityReq;      //活动要求

@property (assign, nonatomic) NSInteger leftRowCount;

@property (weak, nonatomic) IBOutlet UITableView *leftTableView;
@property (weak, nonatomic) IBOutlet UITableView *rightTableView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) NSMutableArray *selectedTags;

@property (nonatomic, strong) NSMutableArray *createTypeArray;

@property (nonatomic, strong) Homework *homework;   // 为空创建作业

@property (nonatomic,assign) MIHomeworkTaskType taskType;
@end

@implementation MICreateHomeworkTaskView

-(void)awakeFromNib{
    
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.leftTableView.separatorColor = [UIColor clearColor];
    self.rightTableView.separatorColor = [UIColor clearColor];
    
    self.leftTableView.delegate = self;
    self.leftTableView.dataSource = self;
    self.rightTableView.delegate = self;
    self.rightTableView.dataSource = self;
    
    [self registerCellNibs];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}
- (void)keyboardWillChangeFrame:(NSNotification *)notification{
    
    CGRect keyboredBeginFrame = [notification.userInfo[@"UIKeyboardFrameBeginUserInfoKey"] CGRectValue];
    CGRect keyboredEndFrame = [notification.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    CGFloat duration = [notification.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
    NSLog(@"begin:%@ , end:%@" , NSStringFromCGRect(keyboredBeginFrame) , NSStringFromCGRect(keyboredEndFrame));
    
//    CGFloat changeHeight = 266;
    //动画修改对应的视图位置
    [UIView animateWithDuration:duration delay:1.0 options:UIViewAnimationOptionCurveEaseIn animations:^{

        CGFloat yDistance = fabs(keyboredBeginFrame.origin.y - keyboredEndFrame.origin.y);
        NSLog(@"%f", yDistance);
        if (!floor(yDistance)) {
            return;
        }
        // 键盘弹出或变化
        if (keyboredBeginFrame.origin.y > keyboredEndFrame.origin.y || (keyboredBeginFrame.size.height != yDistance)) {

//            self.topConstraint.constant -= changeHeight;
//            self.bottomConstraint.constant += changeHeight;
        }//键盘收起
        else{

//            self.topConstraint.constant += changeHeight;
//            self.bottomConstraint.constant -= changeHeight;
        }
    } completion:nil];
}

- (void)setupCreateHomework:(Homework *_Nullable)homework taskType:(MIHomeworkTaskType)taskType{
    
//    self.topConstraint.constant = 132;
//    self.bottomConstraint.constant = 132;
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

- (IBAction)closeAction:(id)sender {
   
    if (self.superview) {
        
        [self removeFromSuperview];
    }
}
- (IBAction)sendAction:(id)sender {
   
    if (self.callBack) {
        self.callBack();
    }
    if (self.superview) {
        
        [self removeFromSuperview];
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
                weakSelf.homeworkMarks = text;
                
                if (heightChanged) {
                    [weakTableView beginUpdates];
                    [weakTableView endUpdates];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakContentCell ajustTextView];
                    });
                }
            };
            [contentCell setupWithText:self.homeworkMarks
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
//                TagsViewController *tagsVC = [[TagsViewController alloc] initWithNibName:@"TagsViewController" bundle:nil];
//                tagsVC.type = TagsHomeworkTipsType;
//                [weakSelf.navigationController pushViewController:tagsVC animated:YES];
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
                //                TagsViewController *tagsVC = [[TagsViewController alloc] initWithNibName:@"TagsViewController" bundle:nil];
                //                tagsVC.type = TagsHomeworkTipsType;
                //                [weakSelf.navigationController pushViewController:tagsVC animated:YES];
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
                //                TagsViewController *tagsVC = [[TagsViewController alloc] initWithNibName:@"TagsViewController" bundle:nil];
                //                tagsVC.type = TagsHomeworkTipsType;
                //                [weakSelf.navigationController pushViewController:tagsVC animated:YES];
            }];
            
            cell = tagsCell;
        }
            break;
        case MIHomeworkCreateContentType_Add:
        {
            MIAddTypeTableViewCell *contentCell = [tableView dequeueReusableCellWithIdentifier:MIAddTypeTableViewCellId forIndexPath:indexPath];
            contentCell.addCallback = ^(BOOL isAdd) {
                
            };
            [contentCell setupWithCreateType:createType];
            cell = contentCell;
        }
            break;
        case MIHomeworkCreateContentType_Delete:
        {
            MIAddTypeTableViewCell *contentCell = [tableView dequeueReusableCellWithIdentifier:MIAddTypeTableViewCellId forIndexPath:indexPath];
            contentCell.addCallback = ^(BOOL isAdd) {
                
            };
            [contentCell setupWithCreateType:createType];
            cell = contentCell;
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
        {
            rowHeight = MIExpandSelectTypeTableViewCellHeight;
        }
            break;
        case MIHomeworkCreateContentType_Title:
        {
            rowHeight = [MIInPutTypeTableViewCell cellHeightWithText:self.homeworkTitle];
        }
            break;
        case MIHomeworkCreateContentType_Content:
        {
            rowHeight = [MIInPutTypeTableViewCell cellHeightWithText:self.homeworkContent];
        }
            break;
        case MIHomeworkCreateContentType_MarkingRemarks:
        {
            rowHeight = [MIInPutTypeTableViewCell cellHeightWithText:self.homeworkMarks];
        }
            break;
        case MIHomeworkCreateContentType_ActivityReq:
        {
            rowHeight = [MIInPutTypeTableViewCell cellHeightWithText:self.activityReq];
        }
            break;
        case MIHomeworkCreateContentType_StatisticalType:
        {
            rowHeight = MISegmentTypeTableViewCellHeight;
        }
            break;
        case MIHomeworkCreateContentType_CommitTime:
        {
            rowHeight = MISegmentTypeTableViewCellHeight;
        }
            break;
        case MIHomeworkCreateContentType_HomeworkDifficulty:
        {
            rowHeight = MISegmentTypeTableViewCellHeight;
        }
            break;
        case MIHomeworkCreateContentType_WordsTimeInterval:
        {
            rowHeight = MIExpandSelectTypeTableViewCellHeight;
        }
            break;
        case MIHomeworkCreateContentType_AddWords:
        {
            rowHeight = MITitleTypeTableViewCellHeight;
        }
            break;
        case MIHomeworkCreateContentType_Materials:
        {
            rowHeight = MITitleTypeTableViewCellHeight;
        }
            break;
        case MIHomeworkCreateContentType_Answer:
        {
            rowHeight = MITitleTypeTableViewCellHeight;
        }
            break;
        case MIHomeworkCreateContentType_AddCovers:
        {
            rowHeight = MITitleTypeTableViewCellHeight;
        }
            break;
        case MIHomeworkCreateContentType_AddBgMusic:
        {
            rowHeight = MITitleTypeTableViewCellHeight;
        }
            break;
        case MIHomeworkCreateContentType_AddFollowMaterials:
        {
            rowHeight = MITitleTypeTableViewCellHeight;
        }
            break;
        case MIHomeworkCreateContentType_ExaminationType:
        {
            rowHeight = MISegmentTypeTableViewCellHeight;
        }
            break;
        case MIHomeworkCreateContentType_TimeLimit:
        {
            rowHeight = MIExpandSelectTypeTableViewCellHeight;
        }
            break;
        case MIHomeworkCreateContentType_ActivityStartTime:
        {
            rowHeight = MIExpandSelectTypeTableViewCellHeight;
        }
            break;
        case MIHomeworkCreateContentType_ActivityEndTime:
        {
            rowHeight = MIExpandSelectTypeTableViewCellHeight;
        }
            break;
        case MIHomeworkCreateContentType_VideoTimeLimit:
        {
            rowHeight = MIExpandSelectTypeTableViewCellHeight;
        }
            break;
        case MIHomeworkCreateContentType_CommitCount:
        {
            rowHeight = MISegmentTypeTableViewCellHeight;
        }
            break;
        case MIHomeworkCreateContentType_Label:
        {
            rowHeight = [HomeworkTagsTableViewCell heightWithTags:@[] typeTitle:@"任务类型(单选)"] + 45;
        }
            break;
        case MIHomeworkCreateContentType_TypeLabel:
        {
            rowHeight = [HomeworkTagsTableViewCell heightWithTags:@[] typeTitle:@"分类标签(多选)"] + 45;
        }
            break;
        case MIHomeworkCreateContentType_ActivityParticipant:
        {
            rowHeight = [HomeworkTagsTableViewCell heightWithTags:@[] typeTitle:@"活动参与对象:"] + 45;
        }
            break;
        case MIHomeworkCreateContentType_Add:
        {
            rowHeight = MIAddTypeTableViewCellHeight;
        }
            break;
        case MIHomeworkCreateContentType_Delete:
        {
            rowHeight = MIAddTypeTableViewCellHeight;
        }
            break;
        default:
            break;
    }
    return rowHeight;
}

#pragma mark - ChooseDatePickerViewDelegate
- (void)finishSelectDate:(NSInteger)seconds{
    
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self resignFirstResponder];
    if (self.superview) {
        [self removeFromSuperview];
    }
}

#pragma mark - 添加材料
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
    
//    [self.navigationController presentViewController:alertVC
//                                            animated:YES
//                                          completion:nil];
}

- (void)addFileItem:(NSArray *)allowedUTIs withHomeworkItem:(HomeworkItem *)item
{
//    self.isAddingAnswerItem = NO;
    UIDocumentPickerViewController * picker = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:allowedUTIs inMode:UIDocumentPickerModeImport];
    picker.delegate = self;
    
//    objc_setAssociatedObject(picker , &keyOfPickerDocument, item, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
//    [self.navigationController presentViewController:picker animated:YES completion:nil];
}

- (void)addVideoItem {
//    self.isAddingAnswerItem = NO;
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.mediaTypes = @[(NSString *)kUTTypeMovie];
    
//    [self.navigationController presentViewController:picker animated:YES completion:nil];
}

- (void)addImageItem {
//    self.isAddingAnswerItem = NO;
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.mediaTypes = @[(NSString *)kUTTypeImage];
    
//    [self.navigationController presentViewController:picker animated:YES completion:nil];
}

@end
