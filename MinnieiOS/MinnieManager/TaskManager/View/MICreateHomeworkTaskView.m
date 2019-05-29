//
//  MICreateHomeworkTaskView.m
//  MinnieManager
//
//  Created by songzhen on 2019/5/29.
//  Copyright © 2019 minnieedu. All rights reserved.
//


#import "MICreateHomeworkTaskView.h"

@interface MICreateHomeworkTaskView ()<
UITableViewDelegate,
UITableViewDataSource
>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation MICreateHomeworkTaskView

-(void)awakeFromNib{
    
    [super awakeFromNib];
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
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

- (void)updateData{
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView reloadData];
    self.topConstraint.constant = 150;
    self.bottomConstraint.constant = 150;
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    static NSString *identifier = @"createHomeworkTaskCellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.textLabel.textColor = [UIColor lightGrayColor];
    }
    cell.textLabel.text = @"测试";
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 80;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if (self.superview) {
        
        [self removeFromSuperview];
    }
}

#pragma mark - setter && getter
- (void)setTaskType:(MIHomeworkTaskType)taskType{

    _taskType = taskType;
    switch (_taskType) {
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

- (NSInteger)getRowCount{
    
    NSInteger count = 0;
    switch (self.taskType) {
        case MIHomeworkTaskType_notify:
        {
            // 位置、内容、添加附件、标签
            count = 1+1+1+2+1;
        }
            break;
        case MIHomeworkTaskType_FollowUp:
        {
            // 位置、标题、作业要求、添加材料、统计类型、提交时间、作业难度、选择时限、标签、分类标签
            count = 1+1+1+2+1+1+1+1+1+1;
        }
            break;
        case MIHomeworkTaskType_WordMemory:
        {
            // 位置、标题、作业要求、添加单词、播放时间间隔、统计类型、提交时间、选择作业难度、标签
            count = 1+1+1+1+1+1+1+1+1;
        }
            break;
        case MIHomeworkTaskType_GeneralTask:
        {
            // 位置、标题、作业要求、添加材料、添加答案、统计类型、提交时间、选择作业难度、选择时限、标签、类型标签
            count = 1+1+1+1+1+1+1+1+1;
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
@end
