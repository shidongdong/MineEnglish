//
//  ProgressHUD.h
//  X5
//
//  Created by yebw on 2017/10/9.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressHUD : UIView

+ (instancetype)sharedHUD;

- (void)showAnimatedInView:(UIView *)superView;

- (void)hideAnimated;

- (void)updateWithProgress:(CGFloat)progress text:(NSString *)text;

@end
