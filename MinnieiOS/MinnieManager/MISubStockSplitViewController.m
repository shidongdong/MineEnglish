//
//  MISubStockSplitViewController.m
//  Minnie
//
//  Created by songzhen on 2019/7/1.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import "MISubStockSplitViewController.h"

@interface MISubStockSplitViewController ()

@end

@implementation MISubStockSplitViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor emptyBgColor];
    
    UINavigationController *masterNav = [[UINavigationController alloc] initWithRootViewController:self.stockMasterVC];
    
    _stockDetailVC = [[MIStockSecondViewController alloc] init];
    UINavigationController *detailNav = [[UINavigationController alloc] initWithRootViewController:_stockDetailVC];
    
    self.viewControllers = @[masterNav, detailNav];
}


- (void)showTaskListWithFoldInfo:(FileInfo * _Nullable)fileInfo folderIndex:(NSInteger)folder{
    
    [self.stockMasterVC showTaskListWithFoldInfo:fileInfo folderIndex:folder];
    
    if (self.stockDetailVC.navigationController.viewControllers.count > 1) {
        [self.stockDetailVC.navigationController popToRootViewControllerAnimated:NO];
    }
}

// yes 添加文件夹 no 添加文件
- (void)showEmptyViewWithIsFolder:(BOOL)isAddFolder folderIndex:(NSInteger)folder{
    
    [self.stockMasterVC showEmptyViewWithIsFolder:isAddFolder folderIndex:folder];
   
    if (self.stockDetailVC.navigationController.viewControllers.count > 1) {
        [self.stockDetailVC.navigationController popToRootViewControllerAnimated:NO];
    }
}


- (MITaskListViewController *)stockMasterVC{
    
    if (!_stockMasterVC) {
        
        _stockMasterVC = [[MITaskListViewController alloc] initWithNibName:NSStringFromClass([MITaskListViewController class]) bundle:nil];
        _stockMasterVC.parentVC = self;
        _stockMasterVC.addFolderCallBack = self.addFolderCallBack;
        
        WeakifySelf;
        _stockMasterVC.createTaskCallBack = ^(UIViewController * _Nullable VC, NSInteger createState) {
            
            if (createState == 0) {
                
                if (VC) {
                    [weakSelf.navigationController pushViewController:VC animated:YES];
                }
            } else if (createState == 1) {
              
                if (weakSelf.stockDetailVC.navigationController.viewControllers.count > 1) {
                    [weakSelf.stockDetailVC.navigationController popToRootViewControllerAnimated:NO];
                }
            }
            
            [weakSelf.stockDetailVC.navigationController popToRootViewControllerAnimated:NO];
        };
        
        _stockMasterVC.pushVCCallBack = ^(UIViewController *VC) {
            [weakSelf.stockDetailVC.navigationController popToRootViewControllerAnimated:NO];
            [weakSelf.stockDetailVC.navigationController pushViewController:VC animated:YES];
        };
    }
    return _stockMasterVC;
}

@end
