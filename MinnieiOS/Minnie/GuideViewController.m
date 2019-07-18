//
//  GuideViewController.m
//  MinnieStudent
//
//  Created by 栋栋 施 on 2018/12/10.
//  Copyright © 2018年 minnieedu. All rights reserved.
//

#import "GuideViewController.h"
#import "Masonry.h"
#import "AppDelegate+ConfigureUI.h"
#import "LoginViewController.h"
#import "PortraitNavigationController.h"
#import "PublicService.h"
#import "TrialClassViewController.h"
@interface GuideViewController ()

@property(nonatomic,strong)UIScrollView * mScrollView;

@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _mScrollView = [[UIScrollView alloc] init];
    _mScrollView.contentSize = CGSizeMake(ScreenWidth * 3, ScreenHeight);
    _mScrollView.pagingEnabled = YES;
    _mScrollView.scrollEnabled = NO;
    [self.view addSubview:_mScrollView];
    [_mScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    for (int i = 0; i < 3; i++)
    {
        UIImageView * bgImageView = [[UIImageView alloc] init];
        bgImageView.userInteractionEnabled = YES;
        bgImageView.frame = CGRectMake(ScreenWidth * i, 0, ScreenWidth, ScreenHeight);
        NSString * imageName = [NSString stringWithFormat:@"load背景0%d",i+1];
        bgImageView.image = [UIImage imageNamed:imageName];
        [_mScrollView addSubview:bgImageView];
        
        UIImageView * contentImageView = [[UIImageView alloc] init];
        NSString * contentImageName = [NSString stringWithFormat:@"load%d",i+1];
        contentImageView.image = [UIImage imageNamed:contentImageName];
        [bgImageView addSubview:contentImageView];
        [contentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(bgImageView.mas_centerX);
            make.centerY.equalTo(bgImageView.mas_centerY);
            make.width.mas_equalTo(ScreenWidth * 0.9);
            make.height.mas_equalTo(ScreenWidth * 0.9 * 932 / 650);
        }];
        
        UIButton * nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [nextBtn addTarget:self action:@selector(nextClick:) forControlEvents:UIControlEventTouchUpInside];
        nextBtn.layer.borderWidth = 1.0;
        nextBtn.layer.borderColor = [UIColor colorWithHex:0xFFFFFF].CGColor;
        nextBtn.layer.cornerRadius = 8.0;
        if (i == 2)
        {
            [nextBtn setTitle:@"都知道了" forState:UIControlStateNormal];
        }
        else
        {
            [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        }
        nextBtn.tag = 100 + i;
        [bgImageView addSubview:nextBtn];
        [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(140, 40));
            make.bottom.equalTo(bgImageView.mas_bottom).with.offset(-0.05 * ScreenHeight);
            make.centerX.equalTo(bgImageView.mas_centerX);
        }];
    }
    
    // Do any additional setup after loading the view.
}

- (void)nextClick:(UIButton *)btn
{
    NSInteger index = btn.tag - 100;
    
    if (index == 2)
    {
        APP.userGuide = YES;
        
        if (APP.currentUser.token.length == 0 ||
            APP.currentUser.nickname.length==0 ||
            APP.currentUser.avatarUrl.length == 0) {
            NSString *nibName = nil;
#if TEACHERSIDE
            nibName = @"LoginViewController_Teacher";
#else
            nibName = @"LoginViewController_Student";
#endif
            LoginViewController *loginVC = [[LoginViewController alloc] initWithNibName:nibName bundle:nil];
            
            PortraitNavigationController *loginNC = [[PortraitNavigationController alloc] initWithRootViewController:loginVC];
            
            [self.view.window setRootViewController:loginNC];
        } else {
            NSInteger userId = APP.currentUser.userId;
            [PublicService requestUserInfoWithId:userId
                                        callback:^(Result *result, NSError *error) {
                                            BOOL shouldToHome = YES;
                                            if (error == nil) {
#if TEACHERSIDE
                                                Teacher *userInfo = (Teacher *)(result.userInfo);
#else
                                                Student *userInfo = (Student *)(result.userInfo);
                                                
                                                if (userInfo.clazz.classId==0 || userInfo.enrollState==1) { // 有班级信息
                                                    shouldToHome = NO;
                                                }
#endif
                                                userInfo.token = APP.currentUser.token;
                                                APP.currentUser = userInfo;
                                            } else {
#if TEACHERSIDE
#else
                                                Student *userInfo = (Student *)(APP.currentUser);
                                                if (userInfo.clazz.classId==0 || userInfo.enrollState==1) { // 有班级信息
                                                    shouldToHome = NO;
                                                }
#endif
                                            }
                                            
                                            if (shouldToHome) {
                                                AppDelegate * delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                                                [delegate toHome];
                                            } else {
#if TEACHERSIDE
#else
                                                TrialClassViewController *clzzVC = [[TrialClassViewController alloc] initWithNibName:NSStringFromClass([TrialClassViewController class]) bundle:nil];
                                                
                                                [self.view.window setRootViewController:clzzVC];
#endif
                                            }
                                        }];
        }
    }
    else
    {
        [_mScrollView setContentOffset:CGPointMake((index + 1) * ScreenWidth, 0) animated:YES];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
