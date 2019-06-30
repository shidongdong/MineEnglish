//
//  CSStockSplitViewController.m
//  CSCustomSplitViewController_Demo
//
//  Created by Huang Chusheng on 16/11/21.
//  Copyright © 2016年 Aaron. All rights reserved.
//

#import "MIStockSplitViewController.h"
#import "MIMasterViewController.h"
#import "MIStockSecondViewController.h"

@interface MIStockSplitViewController ()
@property (nonatomic, strong) MIMasterViewController *stockMasterVC;
@property (nonatomic, strong) MIStockSecondViewController *stockDetailVC;

@end

@implementation MIStockSplitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _stockMasterVC = [[MIMasterViewController alloc] init];
    UINavigationController *masterNav = [[UINavigationController alloc] initWithRootViewController:_stockMasterVC];
    
    _stockDetailVC = [[MIStockSecondViewController alloc] init];
    UINavigationController *detailNav = [[UINavigationController alloc] initWithRootViewController:_stockDetailVC];

    self.viewControllers = @[masterNav, detailNav];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
