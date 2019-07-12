//
//  UIViewController+PrimaryCloumnScale.m
//  Minnie
//
//  Created by songzhen on 2019/6/24.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import "CSCustomSplitViewController.h"
#import "UIViewController+PrimaryCloumnScale.h"

@implementation UIViewController (PrimaryCloumnScale)

- (void)updatePrimaryCloumnScale:(NSInteger)offset{
    
#if MANAGERSIDE
    
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
            [detailVC setDisplayMode:CSSplitDisplayModeDisplayPrimaryAndSecondary withAnimated:YES];
        }
    }
    
#endif
}

@end
