//
//  AlertView.h
//  AlertDemo
//
//  Created by yebingwei on 2017/9/17.
//  Copyright © 2017年 netease. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AlertActionCallback)(void);

@interface AlertView : UIView

+ (instancetype)showInView:(UIView *)superView
                 withImage:(UIImage *)image
                     title:(NSString *)title
                   message:(NSString *)message
                    action:(NSString *)action
            actionCallback:(AlertActionCallback)callback;

+ (instancetype)showInView:(UIView *)superView
                 withImage:(UIImage *)image
                     title:(NSString *)title
                   message:(NSString *)message
                   action1:(NSString *)action1
           action1Callback:(AlertActionCallback)callback1
                   action2:(NSString *)action2
           action2Callback:(AlertActionCallback)callback2;

@end
