//
//  MITeachStatisticsStockSplitViewController.m
//  MinnieManager
//
//  Created by songzhen on 2019/7/8.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import "MIZeroMessagesViewController.h"
#import "MIStudentRecordViewController.h"
#import "MIStudentDetailViewController.h"
#import "MITeaStaStockSplitViewController.h"

@interface MITeaStaStockSplitViewController ()

@property (nonatomic, strong) MIStudentDetailViewController *stockMasterVC;
@property (nonatomic, strong) MIStudentRecordViewController *stockDetailVC;

// 零分动态
@property (nonatomic, strong) MIZeroMessagesViewController * zeroMessagesVC;

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
   
    if (student != nil) {
        self.stockMasterVC.view.hidden = NO;
        self.stockDetailVC.view.hidden = NO;
        [self.stockDetailVC updateStudentRecordWithStudentId:student.userId];
        [self.stockMasterVC updateStudent:student];
        [self hiddenZeroMessages];
    } else {
     
        self.stockMasterVC.view.hidden = YES;
        self.stockDetailVC.view.hidden = YES;
        self.zeroMessagesVC.view.hidden = NO;
        [self.zeroMessagesVC updateZeroMessages];
        [self.navigationController pushViewController:self.zeroMessagesVC animated:YES];
    }
}

- (void)hiddenZeroMessages{
    [self.navigationController popViewControllerAnimated:YES];
}
- (MIZeroMessagesViewController *)zeroMessagesVC{
    
    if (!_zeroMessagesVC) {
        _zeroMessagesVC = [[MIZeroMessagesViewController alloc] initWithNibName:NSStringFromClass([MIZeroMessagesViewController class]) bundle:nil];
    }
    return _zeroMessagesVC;
}

@end
