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
#import <SDWebImage/UIImageView+WebCache.h>
#import "Student.h"
#import "PublicService.h"

@interface StudentDetailViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, weak) IBOutlet UIImageView *avatarImageView;
@property (nonatomic, strong) UIImage *avatarImage;

@property (nonatomic, weak) IBOutlet UIView *contentView;
@property (nonatomic, weak) IBOutlet UITextField *nameTextField;
@property (nonatomic, weak) IBOutlet UITextField *phoneNumberTextField;
@property (nonatomic, weak) IBOutlet UITextField *classTextField;
@property (nonatomic, weak) IBOutlet UITextField *genderTextField;
@property (nonatomic, weak) IBOutlet UITextField *gradeTextField;
@property (weak, nonatomic) IBOutlet UITextField *workTextField;

@property (nonatomic, strong) BaseRequest *request;

@end

@implementation StudentDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.avatarImageView.layer.cornerRadius = 40.f;
    self.avatarImageView.layer.masksToBounds = YES;
    
    [self requestUserInfo];
}

- (void)requestUserInfo {
    [self.view showLoadingView];
    self.contentView.hidden = YES;
    
    WeakifySelf;
    self.request = [PublicService requestStudentInfoWithId:self.userId
                                                  callback:^(Result *result, NSError *error) {
                                                      StrongifySelf;
                                                      strongSelf.request = nil;
                                                      
                                                      if (error == nil) {
                                                          [strongSelf.view hideAllStateView];
                                                          
                                                          strongSelf.contentView.hidden = NO;
                                                          
                                                          Student *user = (Student *)(result.userInfo);
                                                          
                                                          if (user.avatarUrl != nil) {
                                                              [strongSelf.avatarImageView sd_setImageWithURL:[user.avatarUrl imageURLWithWidth:80.f]];
                                                          }
                                                          
                                                          strongSelf.phoneNumberTextField.text = user.username;
                                                          
                                                          if ([user.nickname isEqual:user.username] || user.nickname.length==0) {
                                                              strongSelf.nameTextField.text = nil;
                                                          } else {
                                                              strongSelf.nameTextField.text = user.nickname;
                                                          }
                                                          
                                                          strongSelf.classTextField.text = user.clazz.name;
                                                          
                                                          if (user.gender == 1) {
                                                              strongSelf.genderTextField.text = @"男";
                                                          } else if (user.gender == -1) {
                                                              strongSelf.genderTextField.text = @"女";
                                                          } else {
                                                              strongSelf.genderTextField.text = @"保密";
                                                          }
                                                          
                                                          strongSelf.gradeTextField.text = user.grade;
                                                          
                                                          
                                                          NSUInteger unfinshed = [user.homeworks[0] unsignedIntegerValue];
                                                          NSUInteger passed = [user.homeworks[1] unsignedIntegerValue];
                                                          NSUInteger goodJob = [user.homeworks[2] unsignedIntegerValue];
                                                          NSUInteger veryNice = [user.homeworks[3] unsignedIntegerValue];
                                                          NSUInteger great = [user.homeworks[4] unsignedIntegerValue];
                                                          NSUInteger perfect = [user.homeworks[5] unsignedIntegerValue];
                                                          NSUInteger hardworking = [user.homeworks[6] unsignedIntegerValue];
                                                          
                                                          NSUInteger totalCount = unfinshed + passed + goodJob + veryNice + great + perfect + hardworking;
                                                          
                                                          strongSelf.workTextField.text = [NSString stringWithFormat:@"%ld/%ld",totalCount - unfinshed ,totalCount];
                                                          
                                                      } else {
                                                          [strongSelf.view showFailureViewWithRetryCallback:^{
                                                              [weakSelf requestUserInfo];
                                                          }];
                                                      }
                                                  }];
}

- (void)dealloc {
    NSLog(@"%s", __func__);
    
    [self.request stop];
    [self.request clearCompletionBlock];
    self.request = nil;
}

@end


