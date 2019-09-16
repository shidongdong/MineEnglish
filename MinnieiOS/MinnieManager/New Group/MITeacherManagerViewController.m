//
//  MITeacherManagerViewController.m
//  MinnieManager
//
//  Created by songzhen on 2019/7/8.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import "MIStockSecondViewController.h"
#import "MITeacherDetailViewController.h"
#import "MITeacherManagerViewController.h"

@interface MITeacherManagerViewController ()

@property (nonatomic, strong) MITeacherDetailViewController *stockMasterVC;
@property (nonatomic, strong) MIStockSecondViewController *stockDetailVC;

@end

@implementation MITeacherManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor emptyBgColor];
    
    UINavigationController *masterNav = [[UINavigationController alloc] initWithRootViewController:self.stockMasterVC];
    [masterNav setNavigationBarHidden:YES animated:NO];
    
    _stockDetailVC = [[MIStockSecondViewController alloc] init];
    UINavigationController *detailNav = [[UINavigationController alloc] initWithRootViewController:_stockDetailVC];
    [detailNav setNavigationBarHidden:YES animated:NO];
    self.viewControllers = @[masterNav, detailNav];
}


- (void)updateTeacher:(Teacher * _Nullable)teacher{
  
    [self.stockMasterVC updateTeacher:teacher];
    if (teacher == nil) {
        
        [self.stockDetailVC.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (MITeacherDetailViewController *)stockMasterVC{
    
    if (!_stockMasterVC) {
        
        _stockMasterVC = [[MITeacherDetailViewController alloc] init];
        WeakifySelf;
        _stockMasterVC.pushCallBack = ^(UIViewController * _Nonnull vc) {
          
            [weakSelf.stockDetailVC.navigationController popToRootViewControllerAnimated:YES];
            [weakSelf.stockDetailVC.navigationController pushViewController:vc animated:YES];
        };
    }
    return _stockMasterVC;
}

@end
