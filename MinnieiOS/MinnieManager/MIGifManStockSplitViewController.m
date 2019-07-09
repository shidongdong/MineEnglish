//
//  MIGifManStockSplitViewController.m
//  MinnieManager
//
//  Created by songzhen on 2019/7/8.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import "TeacherAwardsViewController.h"
#import "MIStockSecondViewController.h"
#import "MIGifManStockSplitViewController.h"
#import "ExchangeRequestsViewController.h"

@interface MIGifManStockSplitViewController ()

@property (nonatomic, strong) TeacherAwardsViewController *stockMasterVC;
//@property (nonatomic, strong) MIStockSecondViewController *stockDetailVC;
@property (nonatomic, strong) ExchangeRequestsViewController *stockDetailVC;


@end

@implementation MIGifManStockSplitViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    _stockMasterVC = [[TeacherAwardsViewController alloc] initWithNibName:@"TeacherAwardsViewController" bundle:nil];
    UINavigationController *masterNav = [[UINavigationController alloc] initWithRootViewController:_stockMasterVC];
    [masterNav setNavigationBarHidden:YES animated:NO];
    
    _stockDetailVC = [[ExchangeRequestsViewController alloc] initWithNibName:@"ExchangeRequestsViewController" bundle:nil];
    [_stockDetailVC setExchanged:NO];
    UINavigationController *detailNav = [[UINavigationController alloc] initWithRootViewController:_stockDetailVC];
    [detailNav setNavigationBarHidden:YES animated:NO];
    
    self.viewControllers = @[masterNav, detailNav];
    self.view.backgroundColor = [UIColor emptyBgColor];
}

- (void)updateAwards{
    
    [_stockMasterVC updateAwards];
}

- (void)updateExchangeAwardsList{
    
    UINavigationController *nav = ((UINavigationController *)self.viewControllers[1]);
    if ([nav.viewControllers.lastObject isKindOfClass:[ExchangeRequestsViewController class]]) {
        return;
    }
    ExchangeRequestsViewController *vc = [[ExchangeRequestsViewController alloc] initWithNibName:@"ExchangeRequestsViewController" bundle:nil];
    [vc setExchanged:NO];
    [self.stockDetailVC.navigationController pushViewController:vc animated:NO];
}
@end
