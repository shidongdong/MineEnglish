//
//  MITeachStatisticsStockSplitViewController.m
//  MinnieManager
//
//  Created by songzhen on 2019/7/8.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import "MIStudentRecordViewController.h"
#import "MIStudentDetailViewController.h"
#import "MITeaStaStockSplitViewController.h"

@interface MITeaStaStockSplitViewController ()

@property (nonatomic, strong) MIStudentDetailViewController *stockMasterVC;
@property (nonatomic, strong) MIStudentRecordViewController *stockDetailVC;

@end

@implementation MITeaStaStockSplitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _stockMasterVC = [[MIStudentDetailViewController alloc] initWithNibName:NSStringFromClass([MIStudentDetailViewController class]) bundle:nil];
    UINavigationController *masterNav = [[UINavigationController alloc] initWithRootViewController:_stockMasterVC];
    [masterNav setNavigationBarHidden:YES animated:NO];
    
    _stockDetailVC = [[MIStudentRecordViewController alloc] init];
    UINavigationController *detailNav = [[UINavigationController alloc] initWithRootViewController:_stockDetailVC];
    [detailNav setNavigationBarHidden:YES animated:NO];
    
    self.viewControllers = @[masterNav, detailNav];
    self.view.backgroundColor = [UIColor emptyBgColor];
}

- (void)updateStudent:(User * _Nullable)student{
    
    [self.stockMasterVC updateStudent:student];
}

@end
