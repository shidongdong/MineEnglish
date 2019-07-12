//
//  MICamManStockSplitViewController.m
//  MinnieManager
//
//  Created by songzhen on 2019/7/8.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import "MIStockSecondViewController.h"
#import "MICampusManagerViewController.h"
#import "MICamManStockSplitViewController.h"

@interface MICamManStockSplitViewController ()

@property (nonatomic, strong) MICampusManagerViewController *stockMasterVC;
@property (nonatomic, strong) MIStockSecondViewController *stockDetailVC;


@end

@implementation MICamManStockSplitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _stockMasterVC = [[MICampusManagerViewController alloc] initWithNibName:@"MICampusManagerViewController" bundle:nil];
    UINavigationController *masterNav = [[UINavigationController alloc] initWithRootViewController:_stockMasterVC];
    [masterNav setNavigationBarHidden:YES animated:NO];
    
    _stockDetailVC = [[MIStockSecondViewController alloc] init];
    UINavigationController *detailNav = [[UINavigationController alloc] initWithRootViewController:_stockDetailVC];
    [detailNav setNavigationBarHidden:YES animated:NO];
    
    self.viewControllers = @[masterNav, detailNav];
    self.view.backgroundColor = [UIColor emptyBgColor];
}

@end
