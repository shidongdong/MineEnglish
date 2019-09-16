//
//  HomeworkConfirmView.m
//  Minnie
//
//  Created by songzhen on 2019/6/27.
//  Copyright © 2019 minnieedu. All rights reserved.
//
#import "Homework.h"
#import "PushManager.h"
#import "NSDate+YYAdd.h"
#import "HomeworkSendLog.h"
#import "HomeworkService.h"
#import "HomeworkConfirmView.h"
#import "HomeworkSendHistoryHeaderView.h"
#import "HomeworkSendHisTableViewCell.h"

@interface HomeworkConfirmView ()<
UITableViewDelegate,
UITableViewDataSource
>{
    HomeworkSendLog *_sendData;
}


@property (weak, nonatomic) IBOutlet UITableView *tableView;

// 要发送的作业
@property (nonatomic, strong) NSArray *homeworks;

// 接收作业的班级
@property (nonatomic, strong) NSArray *classes;

// 接收作业的学生
@property (nonatomic, strong) NSArray *students;

// 负责此次作业的老师
@property (nonatomic, strong) Teacher *teacher;

@property (nonatomic, strong) NSDate *dateTime;


@end

@implementation HomeworkConfirmView

- (void)awakeFromNib{
   
    [super awakeFromNib];
    // Do any additional setup after loading the view from its nib.
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HomeworkSendHisTableViewCell class]) bundle:nil] forCellReuseIdentifier:HomeworkSendHisTableViewCellId];

    _sendData = [[HomeworkSendLog alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)setupConfirmViewHomeworks:(NSArray *)homeworks
                          classes:(NSArray *)classes
                         students:(NSArray *)students
                          teacher:(Teacher *)teacher{
    
    self.homeworks = homeworks;
    self.classes = classes;
    self.students = students;
    self.teacher = teacher;
    
    // 处理发送数据
    NSMutableArray *homeworkTitles = [NSMutableArray array];
    for (Homework *homework in self.homeworks) {
        [homeworkTitles addObject:homework.title];
    }
    NSMutableArray *classNames = [NSMutableArray array];
    for (Clazz *clazz in self.classes) {
        if (clazz.name.length) {
            [classNames addObject:clazz.name];
        }
    }
    NSMutableArray *studentNames = [NSMutableArray array];
    for (User *student in self.students) {
        if (student.nickname.length){
            [studentNames addObject:student.nickname];
        }else if (student.username.length) {
            [studentNames addObject:student.username];
        }
    }
    _sendData.homeworkTitles = homeworkTitles;
    _sendData.studentNames = studentNames;
    _sendData.classNames = classNames;
    if (self.teacher.nickname.length){
        _sendData.teacherName = self.teacher.nickname;
    }else if (self.teacher.username.length) {
        _sendData.teacherName = self.teacher.username;
    }
}

- (IBAction)cancelAction:(id)sender {
    
    if (self.cancelCallBack) {
        self.cancelCallBack();
    }
}

- (IBAction)sureAction:(id)sender {
   
    [self sendHomeworkWithTeacher:self.teacher date:nil];
}

- (void)sendHomeworkWithTeacher:(Teacher *)teacher date:(NSDate *)date {
    
    [HUD showProgressWithMessage:@"正在发送作业"];
    NSMutableArray *homeworkIds = [NSMutableArray array];
    for (Homework *homework in self.homeworks) {
        [homeworkIds addObject:@(homework.homeworkId)];
    }
    
    NSMutableArray *classIds = [NSMutableArray array];
    for (Clazz *clazz in self.classes) {
        [classIds addObject:@(clazz.classId)];
    }
    
    NSMutableArray *studentIds = [NSMutableArray array];
    for (User *student in self.students) {
        [studentIds addObject:@(student.userId)];
    }
    
    WeakifySelf;
    [HomeworkService sendHomeworkIds:homeworkIds
                            classIds:classIds
                          studentIds:studentIds
                           teacherId:teacher.userId
                                date:date
                            callback:^(Result *result, NSError *error) {
                                if (error != nil) {
                                    [HUD showErrorWithMessage:@"作业发送失败"];
                                    return;
                                }
                                
                                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationKeyOfSendHomework object:nil];
                                
                                if (studentIds.count > 0) {
                                    [PushManager pushText:@"你有新的作业" toUsers:studentIds date:date];
                                }
                                
                                if (classIds.count > 0) {
                                    [PushManager pushText:@"你有新的作业" toClasses:classIds date:date];
                                }
                                [HUD showWithMessage:@"作业发送成功"];
                                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationKeyOfHomeworkSendSuccess object:nil];
                                
                                if (weakSelf.successCallBack) {
                                    weakSelf.successCallBack();
                                }
                            }];
}

#pragma mark - UITableViewDataSource && UITableViewDelagete
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [HomeworkSendHisTableViewCell calculateCellHightForData:_sendData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeworkSendHisTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:HomeworkSendHisTableViewCellId forIndexPath:indexPath];
    cell.lineView.hidden = YES;
    [cell setContentData:_sendData];
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headerView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([HomeworkSendHistoryHeaderView class]) owner:nil options:nil] firstObject];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
