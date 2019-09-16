//
//  CSCustomSplitViewController.h
//  CSCustomSplitViewController-Demo
//
//  Created by Huang Chusheng on 16/11/23.
//  Copyright © 2016年 Aaron. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CSCustomSplitViewControllerDelegate;

typedef NS_ENUM(NSInteger, CSSplitDisplayMode) {
    CSSplitDisplayModeDisplayPrimaryAndSecondary,      // 展示primary和secondary
    CSSplitDisplayModeDisplaySecondaryAndAdditional,   // 展示secondary和additional
    CSSplitDisplayModeOnlyDisplayPrimary,              // 仅展示primary
};


@interface CSCustomSplitViewController : UIViewController

@property (nullable, nonatomic, weak) id <CSCustomSplitViewControllerDelegate> delegate;

@property (nullable, nonatomic, copy) NSArray<__kindof UIViewController *> *viewControllers;

@property (nonatomic, assign, readonly) CSSplitDisplayMode displayMode; // 当前展示状态

@property(nonatomic, assign) CGFloat primaryCloumnScale;   // 当同时显示时，主控制器的宽度占比 范围<> 默认

- (void)setDisplayMode:(CSSplitDisplayMode)displayMode withAnimated:(BOOL)animated; // 切换显示状态

@end

@protocol CSCustomSplitViewControllerDelegate <NSObject>

@optional
- (void)customSplitViewController:(CSCustomSplitViewController *_Nullable)svc willChangeToDisplayMode:(CSSplitDisplayMode)displayMode;

@end

@interface UIViewController (CSCustomSplitViewController)
@property (nullable, nonatomic, readonly, strong) CSCustomSplitViewController *customSplitViewController;
@end
