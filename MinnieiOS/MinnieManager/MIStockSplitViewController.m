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
    [masterNav setNavigationBarHidden:YES animated:NO];
    
    _stockDetailVC = [[MIStockDetailViewController alloc] init];
    UINavigationController *detailNav = [[UINavigationController alloc] initWithRootViewController:_stockDetailVC];
    [detailNav setNavigationBarHidden:YES animated:NO];
    
    _stockMasterVC.secondDetailVC = _stockDetailVC;
    self.viewControllers = @[masterNav, detailNav];
    
    WeakifySelf;
    _stockMasterVC.cloumnSacleCallBack = ^(NSInteger primaryCloumnScale) {

        if (weakSelf.primaryCloumnScale != primaryCloumnScale) {
            
            weakSelf.primaryCloumnScale = primaryCloumnScale;
            [weakSelf setDisplayMode:CSSplitDisplayModeDisplayPrimaryAndSecondary withAnimated:NO];
        }
    };
}
- (void)updatePrimaryCloumnScale:(NSInteger)offset{
    
    UIViewController *vc = self.parentViewController;
    while (1) {
        if ([vc isKindOfClass:[CSCustomSplitViewController  class]]) {
            break;
        } else {
            vc = vc.parentViewController;
        }
    }
    if ([vc isKindOfClass:[CSCustomSplitViewController  class]]) {
        
        CSCustomSplitViewController *detailVC = (CSCustomSplitViewController *)vc;
        if (detailVC.primaryCloumnScale != offset) {
            
            detailVC.primaryCloumnScale = offset;
            [detailVC setDisplayMode:CSSplitDisplayModeDisplayPrimaryAndSecondary withAnimated:NO];
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
