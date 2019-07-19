//
//  MIStockDetailViewController.m
//  MinnieManager
//
//  Created by songzhen on 2019/7/19.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import "MIStockDetailViewController.h"

@interface MIStockDetailViewController ()

@end

@implementation MIStockDetailViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor emptyBgColor];
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
