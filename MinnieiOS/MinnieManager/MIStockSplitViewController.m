//
//  CSStockSplitViewController.m
//  CSCustomSplitViewController_Demo
//
//  Created by Huang Chusheng on 16/11/21.
//  Copyright © 2016年 Aaron. All rights reserved.
//

#import "MIStockSplitViewController.h"
#import "MIStockMasterViewController.h"
#import "MIStockDetailViewController.h"

@interface MIStockSplitViewController ()
@property (nonatomic, strong) MIStockMasterViewController *stockMasterVC;
@property (nonatomic, strong) MIStockDetailViewController *stockDetailVC;

@end

@implementation MIStockSplitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _stockMasterVC = [[MIStockMasterViewController alloc] init];
    UINavigationController *masterNav = [[UINavigationController alloc] initWithRootViewController:_stockMasterVC];
    
    _stockDetailVC = [[MIStockDetailViewController alloc] init];
    UINavigationController *detailNav = [[UINavigationController alloc] initWithRootViewController:_stockDetailVC];
    _stockMasterVC.secondDetailVC = _stockDetailVC;
    
    
    self.viewControllers = @[masterNav, detailNav];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
