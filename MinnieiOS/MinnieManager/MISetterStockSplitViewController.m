//
//  MISetterStockSplitViewController.m
//  MinnieManager
//
//  Created by songzhen on 2019/7/8.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import "SettingsViewController.h"
#import "MIStockSecondViewController.h"
#import "MISetterStockSplitViewController.h"

@interface MISetterStockSplitViewController ()

@property (nonatomic, strong) SettingsViewController *stockMasterVC;
@property (nonatomic, strong) MIStockSecondViewController *stockDetailVC;


@end

@implementation MISetterStockSplitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _stockMasterVC = [[SettingsViewController alloc] initWithNibName:NSStringFromClass([SettingsViewController class]) bundle:nil];
    _stockMasterVC.hiddenBackBtn = YES;

    UINavigationController *masterNav = [[UINavigationController alloc] initWithRootViewController:_stockMasterVC];
    
    _stockDetailVC = [[MIStockSecondViewController alloc] init];
    UINavigationController *detailNav = [[UINavigationController alloc] initWithRootViewController:_stockDetailVC];
    
    self.viewControllers = @[masterNav, detailNav];
    self.view.backgroundColor = [UIColor emptyBgColor];
    
    WeakifySelf;
    _stockMasterVC.pushCallBack = ^(UIViewController * _Nullable VC) {
        [weakSelf.stockDetailVC.navigationController popToRootViewControllerAnimated:NO];
        [weakSelf.stockDetailVC.navigationController pushViewController: VC animated:YES];
    };
}

@end
