//
//  MIActivityStockSplitViewController.m
//  Minnie
//
//  Created by songzhen on 2019/7/3.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import "MIActivityStockSplitViewController.h"

@interface MIActivityStockSplitViewController ()

@end

@implementation MIActivityStockSplitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UINavigationController *masterNav = [[UINavigationController alloc] initWithRootViewController:self.stockMasterVC];
    _stockDetailVC = [[MIBaseDetailViewController alloc] init];
    UINavigationController *detailNav = [[UINavigationController alloc] initWithRootViewController:_stockDetailVC];
    
    self.viewControllers = @[masterNav, detailNav];
    self.view.backgroundColor = [UIColor emptyBgColor];
}

- (void)updateRankListWithActivityModel:(ActivityInfo *_Nullable)model index:(NSInteger)currentIndex{
    
    [self.stockMasterVC updateRankListWithActivityModel:model index:currentIndex];
    if (self.stockDetailVC.navigationController.viewControllers.count > 1) {
        [self.stockDetailVC.navigationController popToRootViewControllerAnimated:NO];
    }
}

- (void)createActivity{
    
    [self.stockMasterVC createActivity];
}

- (MIActivityRankListViewController *)stockMasterVC{
    
    if (!_stockMasterVC) {
        
        _stockMasterVC = [[MIActivityRankListViewController alloc] initWithNibName:NSStringFromClass([MIActivityRankListViewController class]) bundle:nil];
        _stockMasterVC.callback = self.createCallback;
        WeakifySelf;
        _stockMasterVC.pushVCCallback = ^(UIViewController * _Nullable VC) {
            [weakSelf.stockDetailVC.navigationController popToRootViewControllerAnimated:NO];
            [weakSelf.stockDetailVC.navigationController pushViewController:VC animated:YES];
        };
    }
    return _stockMasterVC;
}

@end
