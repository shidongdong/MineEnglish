//
//  FullfillProfileViewController.m
//  X5
//
//  Created by yebw on 2017/9/17.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "StudentDetailViewController.h"
#import "Utils.h"
#import "UIView+Load.h"
#import "Student.h"
#import "PublicService.h"
#import "StudentDetailCell.h"
#import "StudentDetailHeaderCell.h"

@interface StudentDetailViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,UITableViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *mTableView;
@property (nonatomic, strong) NSArray * titleArray;
@property (nonatomic, strong) Student * user;

@property (nonatomic, strong) BaseRequest *request;

@end

@implementation StudentDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleArray = @[@"姓名:",@"电话号码:",@"班级:",@"性别:",@"年级",@"作业完成率:",@"该学生未完成的任务:"];
    
    [self registerNibCell];
    
    [self requestUserInfo];
}

- (void)registerNibCell
{
    [self.mTableView registerNib:[UINib nibWithNibName:@"StudentDetailCell" bundle:nil] forCellReuseIdentifier:StudentDetailCellId];
    
    [self.mTableView registerNib:[UINib nibWithNibName:@"StudentDetailHeaderCell" bundle:nil] forCellReuseIdentifier:StudentDetailHeaderCellId];
    
}

- (void)requestUserInfo {
    [self.view showLoadingView];
    self.mTableView.hidden = YES;
    
    WeakifySelf;
    self.request = [PublicService requestStudentInfoWithId:self.userId
                                                  callback:^(Result *result, NSError *error) {
                                                      StrongifySelf;
                                                      strongSelf.request = nil;
                                                      
                                                      if (error == nil) {
                                                          [strongSelf.view hideAllStateView];
                                                          
                                                          strongSelf.mTableView.hidden = NO;
                                                          
                                                          strongSelf.user = (Student *)(result.userInfo);
                                                          
                                                          [strongSelf.mTableView reloadData];
                                                          
                                                      } else {
                                                          [strongSelf.view showFailureViewWithRetryCallback:^{
                                                              [weakSelf requestUserInfo];
                                                          }];
                                                      }
                                                  }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return 140;
    }
    else if (indexPath.row == 7)
    {
        return 64.0;
    }
    else
    {
        return 80.0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        StudentDetailHeaderCell * cell = [tableView dequeueReusableCellWithIdentifier:StudentDetailHeaderCellId forIndexPath:indexPath];
        [cell setHeaderURL:self.user.avatarUrl];
        return cell;
    }
    else
    {
        NSString * content;
        StudentDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:StudentDetailCellId forIndexPath:indexPath];
        if (indexPath.row == 1)
        {
            if ([self.user.nickname isEqual:self.user.username] || self.user.nickname.length==0) {
                content = nil;
            } else {
                content = self.user.nickname;
            }
        }
        else if (indexPath.row == 2)
        {
            content = self.user.username;
        }
        else if (indexPath.row == 3)
        {
            content = self.user.clazz.name;
        }
        else if (indexPath.row == 4)
        {
            if (self.user.gender == 1) {
                content = @"男";
            } else if (self.user.gender == -1) {
                content = @"女";
            } else {
                content = @"保密";
            }
        }
        else if (indexPath.row == 5)
        {
            content = self.user.grade;
        }
        else if (indexPath.row == 6)
        {
            NSUInteger unfinshed = [self.user.homeworks[0] unsignedIntegerValue];
            NSUInteger passed = [self.user.homeworks[1] unsignedIntegerValue];
            NSUInteger goodJob = [self.user.homeworks[2] unsignedIntegerValue];
            NSUInteger veryNice = [self.user.homeworks[3] unsignedIntegerValue];
            NSUInteger great = [self.user.homeworks[4] unsignedIntegerValue];
            NSUInteger perfect = [self.user.homeworks[5] unsignedIntegerValue];
            NSUInteger hardworking = [self.user.homeworks[6] unsignedIntegerValue];
            
            NSUInteger totalCount = unfinshed + passed + goodJob + veryNice + great + perfect + hardworking;
            
            content = [NSString stringWithFormat:@"%ld/%ld",totalCount - unfinshed ,totalCount];
        }
        else
        {
            
        }
        [cell setCellTitle:[self.titleArray objectAtIndex:indexPath.row - 1] withContent:content];
        return cell;
    }
    
}

- (void)dealloc {
    NSLog(@"%s", __func__);
    
    [self.request stop];
    [self.request clearCompletionBlock];
    self.request = nil;
}

@end


