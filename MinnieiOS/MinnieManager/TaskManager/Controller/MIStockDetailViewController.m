//
//  CSStockDetailViewController.m
//  CSCustomSplitViewController_Demo
//
//  Created by Huang Chusheng on 16/11/22.
//  Copyright © 2016年 Aaron. All rights reserved.
//

#import "SettingsViewController.h"
#import "MIStockDetailViewController.h"
#import "MIStockSplitViewController.h"
#import "Masonry.h"
@interface MIStockDetailViewController ()

@end

@implementation MIStockDetailViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor bgColor];
    
//    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
//    rightButton.backgroundColor = [UIColor redColor];
//    [rightButton setTitle:@"登录" forState:UIControlStateNormal];
//    [rightButton setTitle:@"返回" forState:UIControlStateSelected];
//    [rightButton addTarget:self action:@selector(rightButtonDidPress:) forControlEvents:UIControlEventTouchUpInside];
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
}

- (void)rightButtonDidPress:(UIButton *)button {
    button.selected = !button.selected;
    if (button.isSelected) {

        UIViewController *vc = [[UIViewController alloc] init];
        vc.view.backgroundColor = [UIColor blueColor];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        [self.customSplitViewController setDisplayMode:CSSplitDisplayModeDisplayPrimaryAndSecondary withAnimated:YES];
    }
}

- (void)addSubViewController:(UIViewController *)vc{
    
    // 先移除
    for (UIViewController *vc in self.childViewControllers) {
        [vc willMoveToParentViewController:nil];
        [vc removeFromParentViewController];
    }
        
    [vc removeFromParentViewController];
    [self addChildViewController:vc];
    [self.view addSubview:vc.view];
    [vc didMoveToParentViewController:self];
    
    [vc.view mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.left.equalTo(@0);
        make.bottom.equalTo(@0);
        make.width.equalTo(self.view.mas_width);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
