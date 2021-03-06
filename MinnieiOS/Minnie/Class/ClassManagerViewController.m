//
//  ClassManagerViewController.m
//  X5Teacher
//
//  Created by yebw on 2018/1/28.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "ClassManagerViewController.h"
#import "ClassEditTableViewCell.h"
#import "ClassScheduleAndStudentsTableViewCell.h"
#import "StudentsManageViewController.h"
#import "ScheduleEditViewController.h"
#import "TeacherService.h"
#import "TimePickerView.h"
#import "TextPickerView.h"
#import "StudentsTableViewCell.h"
#import "DeleteClassTableViewCell.h"
#import "FinishClassTableViewCell.h"
#import "ClassService.h"
#import "UIView+Load.h"

@interface ClassManagerViewController ()<UITableViewDataSource, UITableViewDelegate> {
}

@property (nonatomic, weak) IBOutlet UITableView *classTableView;
@property (nonatomic, weak) IBOutlet UIButton *rightButton;

@property (nonatomic, strong) NSArray *teachers;

@property (nonatomic, assign) BOOL reloadWhenAppeard;

@property (nonatomic, assign) BOOL detailRequested;
@property (nonatomic, strong) Clazz *clazz;

@end

@implementation ClassManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.classTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    [self registerCellNibs];
    
    [self requestTeachers];
    
    if (self.classId > 0) {
        self.rightButton.hidden = YES;
        [self.rightButton setTitle:@"保存" forState:UIControlStateNormal];
    } else {
        [self.rightButton setTitle:@"新建" forState:UIControlStateNormal];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(shouldReloadWhenAppeard)
                                                 name:kNotificationKeyOfDeleteClassStudents
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(shouldReloadWhenAppeard)
                                                 name:kNotificationKeyOfAddClassStudents
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(shouldReloadWhenAppeard)
                                                 name:kNotificationKeyOfUpdateSchedule
                                               object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    NSLog(@"%s", __func__);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.reloadWhenAppeard) {
        [self.classTableView reloadData];
        
        self.reloadWhenAppeard = NO;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.classId > 0 && !self.detailRequested) {
        [self requestClassDetail];
    }
}

- (Clazz *)clazz {
    if (_clazz == nil) {
        _clazz = [[Clazz alloc] init];
    }
    
    return _clazz;
}

- (void)registerCellNibs {
    [self.classTableView registerNib:[UINib nibWithNibName:@"ClassEditTableViewCell" bundle:nil] forCellReuseIdentifier:ClassEditTableViewCellId];
    
    [self.classTableView registerNib:[UINib nibWithNibName:@"ClassScheduleAndStudentsTableViewCell" bundle:nil] forCellReuseIdentifier:ClassScheduleAndStudentsTableViewCellId];
    
    [self.classTableView registerNib:[UINib nibWithNibName:@"StudentsTableViewCell" bundle:nil] forCellReuseIdentifier:StudentsTableViewCellId];
    
    [self.classTableView registerNib:[UINib nibWithNibName:@"DeleteClassTableViewCell" bundle:nil] forCellReuseIdentifier:DeleteClassTableViewCellId];
    
    [self.classTableView registerNib:[UINib nibWithNibName:@"FinishClassTableViewCell" bundle:nil] forCellReuseIdentifier:FinishClassTableViewCellId];
}

- (void)requestClassDetail {
    self.classTableView.hidden = YES;
    [self.classTableView.superview showLoadingView];
    
    [ClassService requestClassWithId:self.classId callback:^(Result *result, NSError *error) {
        if (error != nil) {
            WeakifySelf;
            [self.classTableView.superview showFailureViewWithRetryCallback:^{
                StrongifySelf;
                [strongSelf requestClassDetail];
            }];
            
            return;
        }
        
        self.rightButton.hidden = NO;
        self.clazz = (Clazz *)(result.userInfo);
        
        [self.classTableView.superview hideAllStateView];
        self.classTableView.hidden = NO;
        [self.classTableView reloadData];
        
        if (self.clazz.isFinished) {
            [self updateFinishedClassUI];
        }
        
        self.detailRequested = YES;
    }];
}

- (void)requestTeachers {
    [TeacherService requestTeachersWithCallback:^(Result *result, NSError *error) {
        if (error != nil) {
            [HUD showErrorWithMessage:@"获取教师列表失败"];
            return;
        }
        
        [HUD hideAnimated:NO];
        
        NSDictionary *dict = (NSDictionary *)(result.userInfo);
        NSArray *teachers = (NSArray *)(dict[@"list"]);
        if (teachers.count > 0) {
            self.teachers = teachers;
        }
    }];
}

- (void)updateFinishedClassUI {
    self.rightButton.hidden = YES;
}

- (void)shouldReloadWhenAppeard {
    self.reloadWhenAppeard = YES;
}

- (IBAction)saveButtonPressed:(id)sender {
    BOOL valid = NO;
    do {
        // 检查必要的内容
        if (self.clazz.name.length == 0) {
            [HUD showErrorWithMessage:@"请输入班级名称"];
            break;
        }
        
        if (self.clazz.startTime.length == 0) {
            [HUD showErrorWithMessage:@"请选择上课时间"];
            break;
        }
        
        if (self.clazz.endTime.length == 0) {
            [HUD showErrorWithMessage:@"请选择下课时间"];
            break;
        }
        
        if (self.clazz.location.length == 0) {
            [HUD showErrorWithMessage:@"请选择上课地点"];
            break;
        }
        
        if (self.clazz.teacher == nil) {
            [HUD showErrorWithMessage:@"请选择任课教师"];
            break;
        }
        
        if (self.clazz.maxStudentsCount == 0) {
            [HUD showErrorWithMessage:@"请选择课堂最多学生人数"];
            break;
        }
        
        if (self.clazz.dates.count == 0) {
            [HUD showErrorWithMessage:@"请设置课表"];
            break;
        }
        
        valid = YES;
    } while(NO);
    
    if (valid) {
        NSDictionary *dict = [self.clazz dictionaryForUpload];
        if (dict != nil) {
            [HUD showProgressWithMessage:@"正在保存..."];
            [ClassService createOrUpdateClass:dict
                                     callback:^(Result *result, NSError *error) {
                                         if (error != nil) {
                                             [HUD showErrorWithMessage:@"保存失败"];
                                             
                                             return;
                                         }
                                         
                                         [HUD showWithMessage:@"保存成功"];
                                         
                                         [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationKeyOfAddClass
                                                                                             object:nil];
                                         
                                         [self.navigationController popViewControllerAnimated:YES];
                                     }];
        }
    }
}

- (IBAction)deleteButtonPressed:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确认删除该班级"
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                         }];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"删除"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                              [HUD showProgressWithMessage:@"正在删除..."];
                                                              [ClassService deleteClassWithId:self.clazz.classId
                                                                                     callback:^(Result *result, NSError *error) {
                                                                                         if (error != nil) {
                                                                                             [HUD showErrorWithMessage:@"删除失败"];
                                                                                             return;
                                                                                         }
                                                                                         
                                                                                         [HUD showWithMessage:@"删除成功"];
                                                                                         [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationKeyOfDeleteClass object:nil];
                                                                                         [self.navigationController popToRootViewControllerAnimated:YES];
                                                                                     }];
                                                          }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:confirmAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)finishButtonPressed:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"该班级确认结课？"
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                         }];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                              
                                                              
                                                              [HUD showProgressWithMessage:@"正在结课..."];
                                                              self.clazz.isFinished = YES;
                                                              NSDictionary *dict = [self.clazz dictionaryForUpload];
                                                              
                                                              [ClassService createOrUpdateClass:dict
                                                                                       callback:^(Result *result, NSError *error) {
                                                                                           if (error != nil) {
                                                                                               [HUD showErrorWithMessage:@"结课失败"];
                                                                                               return;
                                                                                           }
                                                                                           
                                                                                           [HUD showWithMessage:@"结课成功"];
                                                                                           [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationKeyOfDeleteClass object:nil];
                                                                                           [self.navigationController popToRootViewControllerAnimated:YES];
                                                                                       }];
                                                          }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:confirmAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    
    if (indexPath.section == 0) {
        ClassEditTableViewCell *editCell = [tableView dequeueReusableCellWithIdentifier:ClassEditTableViewCellId forIndexPath:indexPath];
        
        [editCell setupWithClass:self.clazz];
        
        __weak ClassEditTableViewCell *weakCell = editCell;
        
        WeakifySelf;
        editCell.nameChangedCallback = ^(NSString *name) {
            weakSelf.clazz.name = name;
        };
        
        editCell.locationChangedCallback = ^(NSString *location) {
            weakSelf.clazz.location = location;
        };
        
        editCell.selectStartTimeCallback = ^{
            [weakCell.classNameTextField resignFirstResponder];
            [weakCell.classLocationTextField resignFirstResponder];
            
            [TimePickerView showInView:weakSelf.navigationController.view
                                  date:weakSelf.clazz.startTime
                              callback:^(NSString *time) {
                                  weakSelf.clazz.startTime = time;
                                  [weakCell.startTimeButton setTitle:time forState:UIControlStateNormal];
                              }];
        };
        
        editCell.selectEndTimeCallback = ^{
            [weakCell.classNameTextField resignFirstResponder];
            [weakCell.classLocationTextField resignFirstResponder];
            
            [TimePickerView showInView:weakSelf.navigationController.view
                                  date:weakSelf.clazz.endTime
                              callback:^(NSString *time) {
                                  weakSelf.clazz.endTime = time;
                                  [weakCell.endTimeButton setTitle:time forState:UIControlStateNormal];
                              }];
        };
        
        editCell.selectTeacherCallback = ^{
            [weakCell.classNameTextField resignFirstResponder];
            [weakCell.classLocationTextField resignFirstResponder];
            
            if (weakSelf.teachers.count == 0) {
                [weakSelf requestTeachers];
                return;
            }
            
            NSMutableArray *teacherNames = [NSMutableArray array];
            NSInteger selectedIndex = 0;
            for (Teacher *teacher in weakSelf.teachers) {
                [teacherNames addObject:teacher.nickname];
                if (teacher.userId == weakSelf.clazz.teacher.userId) {
                    selectedIndex = [weakSelf.teachers indexOfObject:teacher];
                }
            }
            
            [TextPickerView showInView:weakSelf.navigationController.view contents:teacherNames selectedIndex:selectedIndex callback:^(NSString *name) {
                NSInteger index = [teacherNames indexOfObject:name];
                weakSelf.clazz.teacher = weakSelf.teachers[index];
                weakCell.classTeacherTextField.text = name;
            }];
        };
        
        editCell.selectClassTypeCallback = ^{
            [weakCell.classNameTextField resignFirstResponder];
            [weakCell.classLocationTextField resignFirstResponder];
            
            NSInteger index = weakSelf.clazz.isTrial ? 0 : 1;
            [TextPickerView showInView:weakSelf.navigationController.view
                              contents:@[@"试听课", @"正式课堂"]
                         selectedIndex:index
                              callback:^(NSString *name) {
                                  BOOL isTrial = [name isEqualToString:@"试听课"];
                                  weakSelf.clazz.isTrial = isTrial;
                                  weakCell.classTypeTextField.text = name;
                              }];
        };
        
        editCell.selectStudentsCountCallback = ^{
            [weakCell.classNameTextField resignFirstResponder];
            [weakCell.classLocationTextField resignFirstResponder];
            
            NSArray *contents = @[@"12", @"18", @"20", @"26"];
            NSInteger index = 0;
            if (weakSelf.clazz.maxStudentsCount > 0) {
                NSString *number = [NSString stringWithFormat:@"%zd", weakSelf.clazz.maxStudentsCount];
                if ([contents containsObject:number]) {
                    index = [contents indexOfObject:number];
                }
            }
            
            [TextPickerView showInView:weakSelf.navigationController.view
                              contents:contents
                         selectedIndex:index
                              callback:^(NSString *number) {
                                  NSInteger count = [number integerValue];
                                  weakSelf.clazz.maxStudentsCount = count;
                                  weakCell.classStudentsTextField.text = number;
                              }];
        };
        
        cell = editCell;
    } else if (indexPath.section == 1) {
        ClassScheduleAndStudentsTableViewCell *ssCell = [tableView dequeueReusableCellWithIdentifier:ClassScheduleAndStudentsTableViewCellId forIndexPath:indexPath];
        
        [ssCell setupWithClass:self.clazz];
        
        WeakifySelf;
        ssCell.managerScheduleCallback = ^{
            ScheduleEditViewController *vc = [[ScheduleEditViewController alloc] initWithNibName:@"ScheduleEditViewController" bundle:nil];
            vc.clazz = weakSelf.clazz;
            [weakSelf.navigationController pushViewController:vc animated:YES];
            
        };
        
        ssCell.managerStudentsCallback = ^{
            if (!APP.currentUser.canManageStudents) {
                [HUD showErrorWithMessage:@"无操作权限"];
                
                return;
            }
            
            StudentsManageViewController *vc = [[StudentsManageViewController alloc] initWithNibName:@"StudentsManageViewController" bundle:nil];
            vc.clazz = weakSelf.clazz;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        
        cell = ssCell;
    } else if (indexPath.section == 2) {
        StudentsTableViewCell *studentsCell = [tableView dequeueReusableCellWithIdentifier:StudentsTableViewCellId forIndexPath:indexPath];
        
        [studentsCell setupWithStudents:self.clazz.students];
        
        cell = studentsCell;
    } else if (indexPath.section == 3) {
        DeleteClassTableViewCell *deleteCell = [tableView dequeueReusableCellWithIdentifier:DeleteClassTableViewCellId forIndexPath:indexPath];
        
        WeakifySelf;
        deleteCell.callback = ^{
            [weakSelf deleteButtonPressed:nil];
        };
        
        cell = deleteCell;
    } else if (indexPath.section == 4) {
        FinishClassTableViewCell *finishCell = [tableView dequeueReusableCellWithIdentifier:FinishClassTableViewCellId forIndexPath:indexPath];
        
        WeakifySelf;
        finishCell.callback = ^{
            [weakSelf finishButtonPressed:nil];
        };
        
        cell = finishCell;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0.f;
    
    if (indexPath.section == 0) {
        height = ClassEditTableViewCellHeight;
    } else if (indexPath.section == 1) {
        height = ClassScheduleAndStudentsTableViewCellHeight - ((self.classId>0||self.clazz.isFinished)?0:44.f);
    } else if (indexPath.section == 2) {
        if (self.clazz.isFinished) {
            height = 0.f;
        } else {
            height = [StudentsTableViewCell cellHeightWithStudents:self.clazz.students];
        }
    } else if (indexPath.section == 3) {
        height = DeleteClassTableViewCellHeight;
    } else if (indexPath.section == 4) { // j
        height = FinishClassTableViewCellHeight;
    }
    
    return height;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.classId>0 && _clazz==nil) {
        return 0;
    }
    
    if (self.clazz.classId > 0) {
        return 4 + (self.clazz.isFinished?0:1);
    }
    
    return 3;
}

@end




