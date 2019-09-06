//
//  MIAuthorPreviewViewController.m
//  Minnie
//
//  Created by songzhen on 2019/8/14.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import "ClassService.h"
#import "ManagerServce.h"
#import "TeacherService.h"
#import "UIView+Load.h"
#import "MIAuthorPreviewViewController.h"

@interface MIAuthorPreviewViewController ()<
UITableViewDelegate,
UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableSet *authorSet;

@property (nonatomic, strong) NSArray *teachers;

@property (nonatomic, strong) NSArray *parentFiles;

@property (nonatomic, strong) NSArray *classes;

@end

@implementation MIAuthorPreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.authorSet = [NSMutableSet setWithArray:self.authorArray];
    
    self.tableView.tableFooterView = [UIView new];

    if (self.authorManagerType == MIAuthorManagerRealTimeTaskPreviewType){
        self.titleLabel.text = @"实时任务查看";
    } else if (self.authorManagerType == MIAuthorManagerTeacherPreviewType) {
        self.titleLabel.text = @"教师任务查看";
    } else if (self.authorManagerType == MIAuthorManagerHomeworkPreviewType) {
        self.titleLabel.text = @"作业查看";
    } else if (self.authorManagerType == MIAuthorManagerClassPreviewType) {
        self.titleLabel.text = @"班级信息查看";
    } else if (self.authorManagerType == MIAuthorManagerStudentPreviewType) {
        self.titleLabel.text = @"学生信息查看";
    }
    [self requestData];
}

- (IBAction)backAction:(id)sender {
#if MANAGERSIDE
    if (self.closeViewCallBack) {
        self.closeViewCallBack();
    }
#else
    [self.navigationController popViewControllerAnimated:YES];
#endif
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.authorManagerType == MIAuthorManagerRealTimeTaskPreviewType) {// 实时任务查看
        
        return self.teachers.count;
    } else if (self.authorManagerType == MIAuthorManagerTeacherPreviewType) {// 教师任务查看
       
        return self.teachers.count;
    } else if (self.authorManagerType == MIAuthorManagerHomeworkPreviewType) {//作业查看
       
        return self.parentFiles.count;
    } else if (self.authorManagerType == MIAuthorManagerClassPreviewType) {//班级信息查看
      
        return self.classes.count;
    } else if (self.authorManagerType == MIAuthorManagerStudentPreviewType) {//学生信息查看
       
        return self.classes.count;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return MITeacherAuthorTableViewCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MITeacherAuthorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MITeacherAuthorTableViewCellId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MITeacherAuthorTableViewCell class]) owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSString *title;
    BOOL state;
    NSString *avatar = nil;
    
    if (self.authorManagerType == MIAuthorManagerRealTimeTaskPreviewType) {// 实时任务查看
        
        Teacher *teacher = self.teachers[indexPath.row];
        title = teacher.nickname;
        state = teacher.lookTasks;
        
        if (teacher.avatarUrl.length == 0) {
            avatar = @"attachment_placeholder";
        } else {
            avatar = teacher.avatarUrl;
        }
    } else if (self.authorManagerType == MIAuthorManagerTeacherPreviewType) {// 教师任务查看
 
        Teacher *teacher = self.teachers[indexPath.row];
        title = teacher.nickname;
        state = teacher.lookTeachers;
        
        if (teacher.avatarUrl.length == 0) {
            avatar = @"attachment_placeholder";
        } else {
            avatar = teacher.avatarUrl;
        }
    } else if (self.authorManagerType == MIAuthorManagerHomeworkPreviewType) {//作业查看
      
        FileInfo *file = self.parentFiles[indexPath.row];
        title = file.fileName;
        state = file.canLookFile;
        
    } else if (self.authorManagerType == MIAuthorManagerClassPreviewType) {//班级信息查看
       
        Clazz *clazz = self.classes[indexPath.row];
        title = clazz.name;
        state = clazz.canLookClass;
    } else {//学生信息查看
        
        Clazz *clazz = self.classes[indexPath.row];
        title = clazz.name;
        state = clazz.canLookStudent;
    }
    
    [cell setAuthority:self.selectAuthority];
    [cell setupTitle:title
                text:nil
               image:avatar
          authorType:self.authorManagerType
                type:2
               state:state];
    
    cell.currentIndex = indexPath.row;
    __weak MITeacherAuthorTableViewCell *weakCell = cell;
    WeakifySelf;
    cell.stateBlock = ^(MIAuthorManagerType authorType, BOOL state) {
        [weakSelf updateAuthorData:authorType state:state index:weakCell.currentIndex];
    };
    return cell;
}


- (void)updateAuthorData:(MIAuthorManagerType)authorType state:(BOOL)state index:(NSInteger)index{
    
    if (authorType == MIAuthorManagerRealTimeTaskPreviewType) {// 实时任务查看
        
        Teacher *teacher = self.teachers[index];
        teacher.lookTasks = state;
        if (state == 1) {
            [self.authorSet addObject:@(teacher.userId)];
        } else {
            [self.authorSet removeObject:@(teacher.userId)];
        }
    } else if (authorType == MIAuthorManagerTeacherPreviewType) {// 教师任务查看
        
        Teacher *teacher = self.teachers[index];
        teacher.lookTeachers = state;
        if (state == 1) {
            [self.authorSet addObject:@(teacher.userId)];
        } else {
            [self.authorSet removeObject:@(teacher.userId)];
        }
    } else if (authorType == MIAuthorManagerHomeworkPreviewType) {//作业查看
        
        FileInfo *file = self.parentFiles[index];
        file.canLookFile = state;
        if (state == 1) {
            [self.authorSet addObject:@(file.fileId)];
        } else {
            [self.authorSet removeObject:@(file.fileId)];
        }
        
    } else if (authorType == MIAuthorManagerClassPreviewType) {//班级信息查看
        
        Clazz *clazz = self.classes[index];
        clazz.canLookClass = state;
        if (state == 1) {
            [self.authorSet addObject:@(clazz.classId)];
        } else {
            [self.authorSet removeObject:@(clazz.classId)];
        }
    } else if (authorType == MIAuthorManagerStudentPreviewType) {//学生信息查看
        
        Clazz *clazz = self.classes[index];
        clazz.canLookStudent = state;
        if (state == 1) {
            [self.authorSet addObject:@(clazz.classId)];
        } else {
            [self.authorSet removeObject:@(clazz.classId)];
        }
    }
    if (self.editCallBack) {
        self.editCallBack([self.authorSet allObjects]);
    }
}


#pragma mark -
- (void)requestData{
   
    if (self.classes.count == 0) {
        [self.view showLoadingView];
    }
    
    if (self.authorManagerType == MIAuthorManagerRealTimeTaskPreviewType) {// 实时任务查看
        [TeacherService getAllTeacherWithCallback:^(Result *result, NSError *error) {
            [self handleRest:result error:error];
        }];
    } else if (self.authorManagerType == MIAuthorManagerTeacherPreviewType) {// 教师任务查看
        [TeacherService getAllTeacherWithCallback:^(Result *result, NSError *error) {
            [self handleRest:result error:error];
        }];
    } else if (self.authorManagerType == MIAuthorManagerHomeworkPreviewType) {//作业查看
        
        [ManagerServce requestAllParentFileListWithCallback:^(Result *result, NSError *error) {
            
            [self handleRest:result error:error];
        }];
    } else if (self.authorManagerType == MIAuthorManagerClassPreviewType) {//班级信息查看
        
        [ClassService requestAllClassesWithCallback:^(Result *result, NSError *error) {
            
            [self handleRest:result error:error];
        }];
    } else if (self.authorManagerType == MIAuthorManagerStudentPreviewType) {//学生信息查看
    
        [ClassService requestAllClassesWithCallback:^(Result *result, NSError *error) {
            [self handleRest:result error:error];
        }];
    }
}


- (void)handleRest:(Result *)result error:(NSError *)error{
   
    [self.view hideAllStateView];
    if (error) {
        [self.view showFailureViewWithRetryCallback:^{
            [self requestData];
        }];
        return;
    }
    NSDictionary *dict = (NSDictionary *)(result.userInfo);
    NSArray *array = (NSArray *)(dict[@"list"]);
    if (array.count == 0) {
        [self.view showEmptyViewWithImage:nil
                                    title:@"列表为空"
                            centerYOffset:0
                                linkTitle:nil
                        linkClickCallback:nil
                            retryCallback:^{
                                [self requestData];
                            }];
        [self.tableView reloadData];
        return;
    }

    if (self.authorManagerType == MIAuthorManagerRealTimeTaskPreviewType) {// 实时任务查看
        
        NSMutableArray *tempTeachers = [NSMutableArray array];
        for (Teacher *teacher in array) {
            
            BOOL isContent =[self.authorSet containsObject:@(teacher.userId)];
            teacher.lookTasks = isContent;
            
            // 超级管理员列表为所有教师 管理员列表为所有普通教师
            if (self.selectAuthority == TeacherAuthoritySuperManager) {
                [tempTeachers addObject:teacher];
            } else {
                
                if (teacher.authority !=  TeacherAuthoritySuperManager) {
                    [tempTeachers addObject:teacher];
                }
            }
        }
        self.teachers = tempTeachers;
        
    } else if (self.authorManagerType == MIAuthorManagerTeacherPreviewType) {// 教师任务查看
        
        NSMutableArray *tempTeachers = [NSMutableArray array];
        for (Teacher *teacher in array) {
            
            BOOL isContent =[self.authorSet containsObject:@(teacher.userId)];
            teacher.lookTeachers = isContent;
            
            // 超级管理员列表为所有教师 管理员列表为所有普通教师
            if (self.selectAuthority == TeacherAuthoritySuperManager) {
                [tempTeachers addObject:teacher];
            } else {
               
                if (teacher.authority !=  TeacherAuthoritySuperManager) {
                    [tempTeachers addObject:teacher];
                }
            }
        }
        self.teachers = tempTeachers;
        
    } else if (self.authorManagerType == MIAuthorManagerHomeworkPreviewType) {//作业查看
    
        for (FileInfo *file in array) {
            BOOL isContent =[self.authorSet containsObject:@(file.fileId)];
            file.canLookFile = isContent;
        }
        self.parentFiles = array;
        
    } else if (self.authorManagerType == MIAuthorManagerClassPreviewType) {//班级信息查看

        for (Clazz *clazz in array) {
            BOOL isContent =[self.authorSet containsObject:@(clazz.classId)];
            clazz.canLookClass = isContent;
        }
        self.classes = array;
    } else if (self.authorManagerType == MIAuthorManagerStudentPreviewType) {//学生信息查看
        
        for (Clazz *clazz in array) {
            BOOL isContent =[self.authorSet containsObject:@(clazz.classId)];
            clazz.canLookStudent = isContent;
        }
        self.classes = array;
    }
    [self.tableView reloadData];
}

@end
