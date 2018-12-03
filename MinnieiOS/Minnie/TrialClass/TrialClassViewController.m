//
//  TrialClassViewController.m
//  MinnieStudent
//
//  Created by yebw on 2018/4/12.
//  Copyright © 2018年 minnieedu. All rights reserved.
//

#import "TrialClassViewController.h"
#import "EnrollTrialClassView.h"
#import "TrialClassService.h"
#import "AlertView.h"
#import "PushManager.h"
#import "LoadViewController.h"
#import "AuthService.h"
#import "LoginViewController.h"
#import "IMManager.h"
#import "PortraitNavigationController.h"
#import "AppDelegate.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface TrialClassViewController ()

@property (nonatomic, weak) IBOutlet UIButton *nextButton;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *grade;
@property (nonatomic, assign) NSInteger gender;
@property (weak, nonatomic) IBOutlet UIImageView *firstImageView;
@property (weak, nonatomic) IBOutlet UIImageView *secondImageView;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *contentViewHeight;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *image1ViewHeight;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *image2ViewHeight;

@property (nonatomic, assign) BOOL bFirstDown;
@property (nonatomic, assign) BOOL bSecondDown;

@end

@implementation TrialClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    UIImage *image1 = [UIImage imageNamed:@"首页1.png"];
//    UIImage *image2 = [UIImage imageNamed:@"首页2.png"];
    
    [self.firstImageView sd_setImageWithURL:[NSURL URLWithString:@"http://api.minniedu.com:8888/main.png"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        self.image1ViewHeight.constant = ScreenWidth * image.size.height / image.size.width;
        self.bFirstDown = YES;
        [self checkDownloadFinish];
    }];
    
    [self.secondImageView sd_setImageWithURL:[NSURL URLWithString:@"http://api.minniedu.com:8888/main_detail.png"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        self.image2ViewHeight.constant = ScreenWidth * image.size.height / image.size.width;
        self.bSecondDown = YES;
        [self checkDownloadFinish];
    }];
    

    
    
    self.nextButton.layer.cornerRadius = 6.f;
    self.nextButton.layer.masksToBounds = YES;
    self.nextButton.backgroundColor = nil;
    [self.nextButton setBackgroundImage:[Utils imageWithColor:[UIColor colorWithRed:0 green:0x98/255.f blue:0xFE/255.f alpha:1.f]] forState:UIControlStateNormal];
    [self.nextButton setBackgroundImage:[Utils imageWithColor:[UIColor colorWithRed:0 green:0x98/255.f blue:0xFE/255.f alpha:.8f]] forState:UIControlStateHighlighted];
    [self.nextButton setBackgroundImage:[Utils imageWithColor:[UIColor colorWithRed:0xDD/255.f green:0xDD/255.f blue:0xDD/255.f alpha:1.f]] forState:UIControlStateDisabled];
    
    Student *user = APP.currentUser;
    if (user.enrollState == 1) {
        [self.nextButton setTitle:@"报名审核中，请耐心等待..." forState:UIControlStateNormal];
    }
}

- (void)checkDownloadFinish
{
    if (self.bFirstDown && self.bSecondDown)
    {
        self.contentViewHeight.constant = self.image1ViewHeight.constant + self.image2ViewHeight.constant + 100;
    }
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    Student *user = APP.currentUser;
    if (user.enrollState == 1) {
        [self showEnrolledAlertView];
    }
}

- (void)showEnrolledAlertView {
    [self.nextButton setTitle:@"报名审核中，请耐心等待..." forState:UIControlStateNormal];
    
    [AlertView showInView:self.view
                withImage:[UIImage imageNamed:@"pop_img_welcome"]
                    title:@"欢迎加入minnie英文教室"
                  message:@"你目前已报名, 请等待教师回复"
                   action:@"知道啦"
           actionCallback:^{
           }];
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

- (IBAction)exitButtonPressed:(id)sender {
    [AuthService logoutWithCallback:^(Result *result, NSError *error) {
        //新增 by shidongdong
        AppDelegate * app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [app removeRemoteNotification];
        Application.sharedInstance.currentUser = nil;
        [[IMManager sharedManager] logout];
        
        [APP clearData];
        NSString *nibName = nil;
#if TEACHERSIDE
        nibName = @"LoginViewController_Teacher";
#else
        nibName = @"LoginViewController_Student";
#endif
        LoginViewController *loginVC = [[LoginViewController alloc] initWithNibName:nibName bundle:nil];
        
        PortraitNavigationController *loginNC = [[PortraitNavigationController alloc] initWithRootViewController:loginVC];
        self.view.window.rootViewController = loginNC;
    }];
}

- (IBAction)nextButtonPressed:(id)sender {
    Student *user = APP.currentUser;
    if (user.enrollState == 1)
    {
        return;
    }
    
    [EnrollTrialClassView showInSuperView:self.view
                                 callback:^(NSString *name,
                                            NSString *grade,
                                            NSInteger gender) {
                                     self.name = name;
                                     self.grade = grade;
                                     self.gender = gender;
                                     
                                     [self showEnrollAlert];
                                 }];
}

- (void)showEnrollAlert {
    NSString *message = @"是否报名？确认后我们将通过电话联系您，请保持电话畅通";
    
    [AlertView showInView:self.view
                withImage:[UIImage imageNamed:@"pop_img_welcome"]
                    title:@"确认"
                  message:message
                  action1:@"取消"
          action1Callback:^{
          }
                  action2:@"确认"
          action2Callback:^{
              [HUD showProgressWithMessage:@"正在报名..."];
              [TrialClassService enrollWithName:self.name
                                          grade:self.grade
                                         gender:self.gender
                                       callback:^(Result *result, NSError *error) {
                                           if (error != nil) {
                                               [HUD showErrorWithMessage:@"报名失败"];
                                           } else {
                                               [HUD showWithMessage:@"报名成功"];
                                               
                                               NSString *gender = self.gender==1?@"男孩":@"女孩";
                                               NSString *text = [NSString stringWithFormat:@"%@的%@ %@(%@) 报名", self.grade, gender, self.name, APP.currentUser.username];

                                               [PushManager pushText:text
                                                             toUsers:@[]
                                                         addChannels:@[@"SuperManager"]];
                                               
                                               [EnrollTrialClassView hideAnimated:YES];
                                               
                                               Student *user = APP.currentUser;
                                               user.clazz = nil;
                                               user.enrollState = 1;
                                               APP.currentUser = user;
                                               
                                               [self showEnrolledAlertView];
                                           }
                                       }];
          }];
}

@end



