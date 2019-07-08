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

@interface MIGifManStockSplitViewController ()

@property (nonatomic, strong) TeacherAwardsViewController *stockMasterVC;
@property (nonatomic, strong) MIStockSecondViewController *stockDetailVC;


@end

@implementation MIGifManStockSplitViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _stockMasterVC = [[TeacherAwardsViewController alloc] initWithNibName:@"TeacherAwardsViewController" bundle:nil];
    UINavigationController *masterNav = [[UINavigationController alloc] initWithRootViewController:_stockMasterVC];
    
    _stockDetailVC = [[MIStockSecondViewController alloc] init];
    UINavigationController *detailNav = [[UINavigationController alloc] initWithRootViewController:_stockDetailVC];
    
    self.viewControllers = @[masterNav, detailNav];
    self.view.backgroundColor = [UIColor emptyBgColor];
}

@end
