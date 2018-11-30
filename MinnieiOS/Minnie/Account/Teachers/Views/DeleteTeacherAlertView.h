//
//  ExchangeAwardView.h
//  X5
//
//  Created by yebw on 2017/9/19.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Teacher.h"

typedef void(^SendDeleteTeacherCodeClickCallback)(void);
typedef void(^ConfirmDeleteClickCallback)(NSString *);

@interface DeleteTeacherAlertView : UIView

+ (void)showDeleteTeacherAlertView:(UIView *)superView
                           teacher:(Teacher *)teacher
                  sendCodeCallback:(SendDeleteTeacherCodeClickCallback)sendCodeCallback
                   confirmCallback:(ConfirmDeleteClickCallback)confirmCallback;

+ (void)showDeleteClassAlertView:(UIView *)superView
                           class:(Clazz *)classinfo
                sendCodeCallback:(SendDeleteTeacherCodeClickCallback)sendCodeCallback
                 confirmCallback:(ConfirmDeleteClickCallback)confirmCallback;

+ (void)hideAnimated:(BOOL)animated;

@end

