//
//  MIRealTimeTasksStockSplitViewController.m
//  MinnieManager
//
//  Created by songzhen on 2019/7/8.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import "MIStockSecondViewController.h"
#import "MIReaTimTasStockSplitViewController.h"
#import "HomeworkSessionsContainerViewController.h"

@interface MIReaTimTasStockSplitViewController ()

@property (nonatomic, strong) HomeworkSessionsContainerViewController *stockMasterVC;
@property (nonatomic, strong) MIStockSecondViewController *stockDetailVC;
@end

@implementation MIReaTimTasStockSplitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _stockMasterVC = [[HomeworkSessionsContainerViewController alloc] initWithNibName:NSStringFromClass([HomeworkSessionsContainerViewController class]) bundle:nil];
    UINavigationController *masterNav = [[UINavigationController alloc] initWithRootViewController:_stockMasterVC];
    [masterNav setNavigationBarHidden:YES animated:NO];

    _stockDetailVC = [[MIStockSecondViewController alloc] init];
    UINavigationController *detailNav = [[UINavigationController alloc] initWithRootViewController:_stockDetailVC];
    [detailNav setNavigationBarHidden:YES animated:NO];

    
    WeakifySelf;
    _stockMasterVC.pushVCCallBack = ^(UIViewController *vc) {
        [weakSelf.stockDetailVC.navigationController popToRootViewControllerAnimated:YES];
        [weakSelf.stockDetailVC.navigationController pushViewController:vc animated:YES];
    };
    _stockMasterVC.exchangeCallBack = ^{
        [weakSelf.stockDetailVC.navigationController popToRootViewControllerAnimated:YES];
    };
    
    self.viewControllers = @[masterNav, detailNav];
    self.view.backgroundColor = [UIColor emptyBgColor];
}

- (void)updateHomeworkSessionWithTeacher:(Teacher *_Nullable)teacher{
    
    if (teacher == nil) {
       
        self.stockMasterVC.view.hidden = YES;
    } else {
     
        self.stockMasterVC.view.hidden = NO;
        [self.stockMasterVC updateHomeworkSessionWithTeacher:teacher];
    }
    [self.stockDetailVC.navigationController popToRootViewControllerAnimated:YES];
}


@end
