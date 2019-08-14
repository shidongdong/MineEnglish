//
//  MITeacherAuthorViewController.m
//  Minnie
//
//  Created by songzhen on 2019/8/13.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import "AuthService.h"
#import "TeacherService.h"
#import "DeleteTeacherAlertView.h"
#import "MITeacherAuthorTableViewCell.h"
#import "MITeacherAuthorViewController.h"
#import "MIAuthorPreviewViewController.h"
#import "ResetPasswordViewController.h"


@interface MITeacherAuthorViewController ()<
UITableViewDelegate,
UITableViewDataSource>

@property (strong, nonatomic) NSArray *dataArray;

@property (weak, nonatomic) IBOutlet UITableView *tableview;

/**
    操作员         操作对象
 0: 管理员->       普通老师
 1: 超级管理员->    普通老师
 2: 超级管理员->    超级管理员
    超级管理员->    管理员
 
 */
@property (assign, nonatomic) NSInteger authorType;

@property (strong, nonatomic) Teacher *tempTeacher;

@end

@implementation MITeacherAuthorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.authorType = self.teacher.authority;
    
    self.tempTeacher = [[Teacher alloc] init];
    self.tempTeacher.userId = self.teacher.userId;
    self.tempTeacher.nickname = self.teacher.nickname;
    self.tempTeacher.phoneNumber = self.teacher.phoneNumber;
    self.tempTeacher.type = self.teacher.type;
    self.tempTeacher.authority = self.teacher.authority;
    
    self.tempTeacher.canManageHomeworks = self.teacher.canManageHomeworks;
    self.tempTeacher.canManageClasses = self.teacher.canManageClasses;
    self.tempTeacher.canManageStudents = self.teacher.canManageStudents;
    self.tempTeacher.canCreateRewards = self.teacher.canCreateRewards;
    self.tempTeacher.canExchangeRewards = self.teacher.canExchangeRewards;
    self.tempTeacher.canCreateNoticeMessage = self.teacher.canCreateNoticeMessage;
    
    self.dataArray = [self getDataArray];
    [self.tableview reloadData];
    self.tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
}

- (NSInteger)authorType{
    
    if (APP.currentUser.authority == TeacherAuthoritySuperManager) {
        
        if (self.tempTeacher.authority == TeacherAuthorityManager ||
            self.tempTeacher.authority == TeacherAuthoritySuperManager
            ) {
            return 2;
        } else {
            return 1;
        }
    }
    return 0;
}
- (NSArray *)getDataArray{
    
    NSArray *array;
    if (self.authorType == 0) {
        /**
         type:  0 输入 text:内容文本
         1 展开
         2 switch state:
         3 查看
         4 删除
         */
        array = @[@[@{@"title":@"姓名",
                      @"authorType":@(MIAuthorManagerNameType),
                      @"type":@(0)},
                    @{@"title":@"手机号码",
                      @"authorType":@(MIAuthorManagerPhoneNumType),
                      @"type":@(0)},
                    @{@"title":@"教师类型",
                      @"authorType":@(MIAuthorManagerTeacherType),
                      @"type":@(1)},
                    ],
                  @[@{@"title":@"班级信息查看",
                      @"authorType":@(MIAuthorManagerClassPreviewType),
                      @"type":@(3)},
                    @{@"title":@"学生信息查看",
                      @"authorType":@(MIAuthorManagerStudentPreviewType),
                      @"type":@(3)}
                    ],
                  @[@{@"title":@"修改密码",
                      @"authorType":@(MIAuthorManagerPasswordType),
                      @"type":@(3)}
                    ]
                  ];
    } else if (self.authorType == 1) {
       
        array = @[@[@{@"title":@"姓名",
                      @"authorType":@(MIAuthorManagerNameType),
                      @"type":@(0)},
                    @{@"title":@"手机号码",
                      @"authorType":@(MIAuthorManagerPhoneNumType),
                      @"type":@(0)},
                    @{@"title":@"教师类型",
                      @"authorType":@(MIAuthorManagerTeacherType),
                      @"type":@(1)},
                    @{@"title":@"权限设置",
                      @"authorType":@(MIAuthorManagerAuthorType),
                      @"type":@(1)},
                    ],
                  @[@{@"title":@"班级信息查看",
                      @"authorType":@(MIAuthorManagerClassPreviewType),
                      @"type":@(3)},
                    @{@"title":@"学生信息查看",
                      @"authorType":@(MIAuthorManagerStudentPreviewType),
                      @"type":@(3)}
                    ],
                  @[@{@"title":@"修改密码",
                      @"authorType":@(MIAuthorManagerPasswordType),
                      @"type":@(3)}
                    ]
                  ];
    } else {
        
        array = @[@[@{@"title":@"姓名",
                      @"authorType":@(MIAuthorManagerNameType),
                      @"type":@(0)},
                    @{@"title":@"手机号码",
                      @"authorType":@(MIAuthorManagerPhoneNumType),
                      @"type":@(0)},
                    @{@"title":@"教师类型",
                      @"authorType":@(MIAuthorManagerTeacherType),
                      @"type":@(1)},
                    @{@"title":@"权限设置",
                      @"authorType":@(MIAuthorManagerAuthorType),
                      @"type":@(1)},
                    ],
                  @[@{@"title":@"教师管理（新建/编辑/删除）",
                      @"authorType":@(MIAuthorManagerTeacherEditType),
                      @"type":@(2)},
                    @{@"title":@"教师查看",
                      @"authorType":@(MIAuthorManagerTeacherPreviewType),
                      @"type":@(3)},
                    @{@"title":@"作业库管理",
                      @"authorType":@(MIAuthorManagerHomeworkType),
                      @"type":@(2)},
                    @{@"title":@"作业查看",
                      @"authorType":@(MIAuthorManagerHomeworkPreviewType),
                      @"type":@(3)},
                    @{@"title":@"活动管理",
                      @"authorType":@(MIAuthorManagerActivityType),
                      @"type":@(2)},
                    ],
                  @[@{@"title":@"校区管理（新建/编辑/删除）",
                      @"authorType":@(MIAuthorManagerCampusType),
                      @"type":@(2)},
                    @{@"title":@"班级信息查看",
                      @"authorType":@(MIAuthorManagerClassPreviewType),
                      @"type":@(3)},
                    @{@"title":@"学生管理（编辑/删除)",
                      @"authorType":@(MIAuthorManagerStudentManagerType),
                      @"type":@(2)},
                    @{@"title":@"学生信息查看",
                      @"authorType":@(MIAuthorManagerStudentPreviewType),
                      @"type":@(3)}
                    ],
                  @[@{@"title":@"礼品管理",
                      @"authorType":@(MIAuthorManagerGiftsType),
                      @"type":@(2)},
                    @{@"title":@"礼品兑换",
                      @"authorType":@(MIAuthorManagerGiftsExchangeType),
                      @"type":@(2)}
                    ],
                  @[@{@"title":@"创建消息",
                      @"authorType":@(MIAuthorManagerMessageType),
                      @"type":@(2)}
                    ]
                  ];
    }
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:array];
    if (self.authorType > 0 && self.tempTeacher.userId != 0) {
        
        NSArray *delete = @[@{@"title":@"删除",
                              @"authorType":@(MIAuthorManagerDeleteType),
                              @"type":@(4)}
                            ];
       
        [tempArray addObject:delete];
    }
    return tempArray;
}

- (IBAction)backAction:(id)sender {
    
#if MANAGERSIDE
    if (self.successCallBack) {
        self.successCallBack();
    }
#else
    [self.navigationController popViewControllerAnimated:YES];
#endif
    
}
- (IBAction)saveAction:(id)sender {

    NSMutableDictionary *changedInfos = [NSMutableDictionary dictionary];
    
    // 校验信息合法性
    NSString *errorTip = nil;
    do {
        NSString *nickname = [self.tempTeacher.nickname stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (nickname.length < 2 || nickname.length > 10) {
            errorTip = @"姓名格式不正确";
            break;
        }
        
        
        NSString *phoneNumber = [self.tempTeacher.phoneNumber stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (phoneNumber.length != 11) {
            errorTip = @"手机号格式不正确";
            break;
        }
        
        
        if (self.teacher == nil || ![self.teacher.nickname isEqualToString:nickname]) {
            changedInfos[@"nickname"] = nickname;
        }
        
        if (self.teacher == nil || ![self.teacher.phoneNumber isEqualToString:phoneNumber]) {
            changedInfos[@"phoneNumber"] = phoneNumber;
            
            if (self.teacher == nil) {
                changedInfos[@"username"] = phoneNumber;
            }
        }
        
        if (self.teacher == nil || (self.teacher.type != self.tempTeacher.type)) {
          
            changedInfos[@"type"] = @(self.tempTeacher.type);
        }
        
        if (self.teacher == nil || self.teacher.authority != self.tempTeacher.authority) {
            
            changedInfos[@"authority"] = @(self.tempTeacher.authority);
        }
        changedInfos[@"canManageHomeworks"] = @(self.tempTeacher.canManageHomeworks);
        changedInfos[@"canManageClasses"] = @(self.tempTeacher.canManageClasses);
        changedInfos[@"canManageStudents"] = @(self.tempTeacher.canManageStudents);
        changedInfos[@"canCreateRewards"] = @(self.tempTeacher.canCreateRewards);
        changedInfos[@"canExchangeRewards"] = @(self.tempTeacher.canExchangeRewards);
        changedInfos[@"canCreateNoticeMessage"] = @(self.tempTeacher.canCreateNoticeMessage);
    } while(NO);
    
    if (errorTip.length > 0) {
        
#if MANAGERSIDE
        [TIP showText:errorTip inView:self.view];
#else
        [TIP showText:errorTip inView:self.navigationController.view];
#endif
        return;
    }
    
    if (self.teacher != nil && changedInfos.count == 0) {
#if MANAGERSIDE
        [TIP showText:@"没有信息修改" inView:self.view];
#else
        [TIP showText:@"没有信息修改" inView:self.navigationController.view];
#endif
        return;
    }
    
    if (self.teacher != nil) {
        [HUD showProgressWithMessage:@"正在更新"];
        changedInfos[@"id"] = @(self.teacher.userId);
        WeakifySelf;
        [TeacherService updateTeacherWithInfos:changedInfos
                                      callback:^(Result *result, NSError *error) {
                                          if (error != nil) {
                                              [HUD showErrorWithMessage:@"更新失败"];
                                          } else {
                                              [HUD showWithMessage:@"更新成功"];
                                              [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationKeyOfUpdateTeacher
                                                                                                  object:nil];
#if MANAGERSIDE
                                              if (weakSelf.successCallBack) {
                                                  weakSelf.successCallBack();
                                              }
#else
                                              [weakSelf.navigationController popViewControllerAnimated:YES];
#endif
                                              
#if TEACHERSIDE | MANAGERSIDE
                                              if (self.teacher.userId == APP.currentUser.userId) {
                                                  self.teacher.token = APP.currentUser.token;
                                                  APP.currentUser = self.teacher;
                                                  
                                                  [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationKeyOfProfileUpdated object:nil];
                                              }
#endif
                                          }
                                      }];
    } else {
        WeakifySelf;
        [HUD showProgressWithMessage:@"正在创建"];
        [TeacherService createTeacherWithInfos:changedInfos
                                      callback:^(Result *result, NSError *error) {
                                          if (error != nil) {
                                              [HUD showErrorWithMessage:@"创建失败"];
                                          } else {
                                              [HUD showWithMessage:@"创建成功"];
                                              [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationKeyOfAddTeacher
                                                                                                  object:nil];
#if MANAGERSIDE
                                              if (weakSelf.successCallBack) {
                                                  weakSelf.successCallBack();
                                              }
#else
                                              [weakSelf.navigationController popViewControllerAnimated:YES];
#endif
                                          }
                                      }];
    }
}

#pragma mark -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray *tempArr = self.dataArray[section];
    return tempArr.count;
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
    
    NSArray *tempArr = self.dataArray[indexPath.section];
    NSDictionary *tempDic = tempArr[indexPath.row];
    NSNumber *type = tempDic[@"type"];
    NSNumber *authorType = tempDic[@"authorType"];
    
    NSString *text;
    BOOL switchState = NO;
    
    if (authorType.integerValue == MIAuthorManagerNameType) {
        
        text = self.tempTeacher.nickname;
    } else if (authorType.integerValue == MIAuthorManagerPhoneNumType) {
        text = self.tempTeacher.phoneNumber;
    } else if (authorType.integerValue == MIAuthorManagerTeacherType) {
       
        text = (self.tempTeacher.type == TeacherTypeAssistant) ? @"助教" : @"教师";
    } else if (authorType.integerValue == MIAuthorManagerAuthorType) {
        
        if (self.tempTeacher.authority == TeacherAuthoritySuperManager) {
            
            text = @"超级管理员";
        } else if (self.tempTeacher.authority == TeacherAuthorityManager) {
            
            text = @"管理员";
        } else {
            
            text = @"普通教师";
        }
    } else if (authorType.integerValue == MIAuthorManagerTeacherEditType) {
         switchState = YES;
    } else if (authorType.integerValue == MIAuthorManagerHomeworkType) {
         switchState = YES;
    } else if (authorType.integerValue == MIAuthorManagerActivityType) {
         switchState = YES;
    } else if (authorType.integerValue == MIAuthorManagerCampusType) {
         switchState = YES;
    } else if (authorType.integerValue == MIAuthorManagerStudentManagerType) {
         switchState = YES;
    } else if (authorType.integerValue == MIAuthorManagerGiftsType) {
         switchState = YES;
    } else if (authorType.integerValue == MIAuthorManagerGiftsExchangeType) {
         switchState = YES;
    } else if (authorType.integerValue == MIAuthorManagerMessageType) {
         switchState = YES;
    }
    
    [cell setupTitle:tempDic[@"title"]
                text:text
               image:nil
          authorType:authorType.integerValue
                type:type.integerValue
               state:switchState];
    
    cell.authorBlock = ^(MIAuthorManagerType authorType) {
        
        if (authorType == MIAuthorManagerTeacherType) {
            
            [self selectTeacherType];
        } else if (authorType == MIAuthorManagerAuthorType) {
            [self setTeacherAuthorType];
        } else if (authorType == MIAuthorManagerTeacherPreviewType ||
                   authorType == MIAuthorManagerHomeworkPreviewType ||
                   authorType == MIAuthorManagerClassPreviewType ||
                   authorType == MIAuthorManagerStudentPreviewType) {
            
            [self toAuthorPreview:authorType];
        } else if (authorType == MIAuthorManagerPasswordType) {
            
            ResetPasswordViewController *resetPasswordVC = [[ResetPasswordViewController alloc] initWithNibName:[[ResetPasswordViewController class] description] bundle:nil];
            [self.navigationController pushViewController:resetPasswordVC animated:YES];
        }
    };
    cell.stateBlock = ^(MIAuthorManagerType authorType, BOOL state) {
        
        if (authorType == MIAuthorManagerTeacherEditType) {
            self.tempTeacher.canManagerTeachers = state;
        } else if (authorType == MIAuthorManagerHomeworkType) {
            
            self.tempTeacher.canManageHomeworks = state;
        } else if (authorType == MIAuthorManagerActivityType) {
           
            self.tempTeacher.canManagerActivity = state;
        } else if (authorType == MIAuthorManagerCampusType) {
            
            self.tempTeacher.canManageClasses = state;
            self.tempTeacher.canManagerCampus = state;
        } else if (authorType == MIAuthorManagerStudentManagerType) {
            
            self.tempTeacher.canManageStudents = state;
        } else if (authorType == MIAuthorManagerGiftsType) {
            
            self.tempTeacher.canCreateRewards = state;
        } else if (authorType == MIAuthorManagerGiftsExchangeType) {
            
            self.tempTeacher.canExchangeRewards = state;
        } else if (authorType == MIAuthorManagerMessageType) {
            self.tempTeacher.canCreateNoticeMessage = state;
        }
    };
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray *tempArr = self.dataArray[indexPath.section];
    NSDictionary *tempDic = tempArr[indexPath.row];
    NSInteger authorType = ((NSNumber *)tempDic[@"authorType"]).integerValue;
    
    if (authorType == MIAuthorManagerTeacherPreviewType ||
        authorType == MIAuthorManagerHomeworkPreviewType ||
        authorType == MIAuthorManagerClassPreviewType ||
        authorType == MIAuthorManagerStudentPreviewType) {
        
        [self toAuthorPreview:authorType];
    } else if (authorType == MIAuthorManagerPasswordType) {
        
        ResetPasswordViewController *resetPasswordVC = [[ResetPasswordViewController alloc] initWithNibName:[[ResetPasswordViewController class] description] bundle:nil];
        [self.navigationController pushViewController:resetPasswordVC animated:YES];
    } else if (authorType == MIAuthorManagerDeleteType) {
        
        [self deleteTeacher];
    }
}
- (void)toAuthorPreview:(MIAuthorManagerType)authorType{
    
    MIAuthorPreviewViewController *authorPreviewVC = [[MIAuthorPreviewViewController alloc] initWithNibName:NSStringFromClass([MIAuthorPreviewViewController class]) bundle:nil];
    authorPreviewVC.authorManagerType = authorType;
    [self.navigationController pushViewController:authorPreviewVC animated:YES];
}

- (void)selectTeacherType{
    // 适配ipad版本
    UIAlertControllerStyle alertStyle;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        alertStyle = UIAlertControllerStyleActionSheet;
    } else {
        alertStyle = UIAlertControllerStyleAlert;
    }
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"选择教师类型"
                                                                     message:nil
                                                              preferredStyle:alertStyle];
    UIAlertAction *teacherAction = [UIAlertAction actionWithTitle:@"教师"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                              self.tempTeacher.type = TeacherTypeTeacher;
                                                              [self.tableview reloadData];
                                                          }];
    
    UIAlertAction *assistantAction = [UIAlertAction actionWithTitle:@"助教"
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction * _Nonnull action) {
                                                                self.tempTeacher.type = TeacherTypeAssistant;
                                                                [self.tableview reloadData];
                                                            }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                           style:UIAlertActionStyleDestructive
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                         }];
    
    [alertVC addAction:teacherAction];
    [alertVC addAction:assistantAction];
    [alertVC addAction:cancelAction];
#if MANAGERSIDE
    
    [self.view.window.rootViewController presentViewController:alertVC
                                                      animated:YES
                                                    completion:nil];
#else
    
    [self.navigationController presentViewController:alertVC
                                            animated:YES
                                          completion:nil];
    
#endif
}

- (void)setTeacherAuthorType{
    
    // 适配ipad版本
    UIAlertControllerStyle alertStyle;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        alertStyle = UIAlertControllerStyleActionSheet;
    } else {
        alertStyle = UIAlertControllerStyleAlert;
    }
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"选择教师权限"
                                                                     message:nil
                                                              preferredStyle:alertStyle];
    UIAlertAction *superManagerAction = [UIAlertAction actionWithTitle:@"超级管理员"
                                                                 style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction * _Nonnull action) {
                                                                   
                                                                   if (self.tempTeacher.authority == TeacherAuthoritySuperManager) {
                                                                       return ;
                                                                   }
                                                                   self.tempTeacher.authority = TeacherAuthoritySuperManager;
                                                                   self.dataArray = [self getDataArray];
                                                                   [self.tableview reloadData];
                                                               }];
    
    UIAlertAction *managerAction = [UIAlertAction actionWithTitle:@"管理员"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                            
                                                              if (self.tempTeacher.authority == TeacherAuthorityManager) {
                                                                  return ;
                                                              }
                                                              self.tempTeacher.authority = TeacherAuthorityManager;;
                                                              self.dataArray = [self getDataArray];
                                                              [self.tableview reloadData];
                                                          }];
    
    UIAlertAction *teacherAction = [UIAlertAction actionWithTitle:@"普通教师"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                              
                                                              if (self.tempTeacher.authority == TeacherAuthorityTeacher) {
                                                                  return ;
                                                              }
                                                              self.tempTeacher.authority = TeacherAuthorityTeacher;;
                                                              self.dataArray = [self getDataArray];
                                                              [self.tableview reloadData];
                                                          }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                           style:UIAlertActionStyleDestructive
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                         }];
    
    [alertVC addAction:superManagerAction];
    [alertVC addAction:managerAction];
    [alertVC addAction:teacherAction];
    [alertVC addAction:cancelAction];
    
#if MANAGERSIDE
    
    [self.view.window.rootViewController presentViewController:alertVC
                                                      animated:YES
                                                    completion:nil];
#else
    
    [self.navigationController presentViewController:alertVC
                                            animated:YES
                                          completion:nil];
#endif
    
}

- (void)deleteTeacher{
    
    User *currentUser = [Application sharedInstance].currentUser;
    currentUser.phoneNumber = @"13606505546";
    
    UIView *parentView = self.navigationController.view;
#if MANAGERSIDE
    parentView = self.view;
#endif
    WeakifySelf;
    [DeleteTeacherAlertView showDeleteTeacherAlertView:parentView
                                               teacher:self.teacher
                                      sendCodeCallback:^{
                                          [AuthService askForSMSCodeWithPhoneNumber:currentUser.phoneNumber
                                                                           callback:^(Result *result, NSError *error) {
                                                                           }];
                                      }
                                       confirmCallback:^(NSString *code) {
                                           [AuthService verifySMSCodeWithPhoneNumber:currentUser.phoneNumber
                                                                                code:code
                                                                            callback:^(Result *result, NSError *error) {
                                                                                if (error != nil) {
                                                                                    [HUD showErrorWithMessage:@"验证码错误"];
                                                                                    
                                                                                    return;
                                                                                }
                                                                                
                                                                                [weakSelf doDelete];
                                                                            }];
                                       }];
}

- (void)doDelete {
    [HUD showProgressWithMessage:@"正在删除"];
    WeakifySelf;
    [TeacherService deleteTeacherWithId:self.teacher.userId
                               callback:^(Result *result, NSError *error) {
                                   if (error != nil) {
                                       [HUD showErrorWithMessage:@"删除失败"];
                                   } else {
                                       [HUD showWithMessage:@"已删除"];
                                       
                                       [DeleteTeacherAlertView hideAnimated:YES];
                                       
                                       [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationKeyOfDeleteTeacher
                                                                                           object:nil];
#if MANAGERSIDE
                                       if (weakSelf.successCallBack) {
                                           weakSelf.successCallBack();
                                       }
#else
                                       [weakSelf.navigationController popViewControllerAnimated:YES];
#endif
                                   }
                               }];
}

- (void)updateSwitchsAfterAuthorityChanged {
    if (self.tempTeacher.authority == TeacherAuthoritySuperManager) {

    } else if (self.tempTeacher.authority == TeacherAuthorityManager) {
    } else {
    }
}
@end
