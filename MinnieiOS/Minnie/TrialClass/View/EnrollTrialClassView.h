//
//  EnrollTrialView.h
//  X5Teacher
//
//  Created by yebw on 2018/2/4.
//  Copyright © 2018年 netease. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^EnrollTrialViewConfirmCallback)(NSString *name,
                                              NSString *grade,
                                              NSInteger gender);

@interface EnrollTrialClassView : UIView

+ (void)showInSuperView:(UIView *)superView
               callback:(EnrollTrialViewConfirmCallback)callback;

+ (void)hideAnimated:(BOOL)animated;


@end

