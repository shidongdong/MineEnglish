//
//  HUD.h
//
//  Created by yebw on 13-4-29.
//  Modified by yebw on 16/11/9

#import <Foundation/Foundation.h>

typedef void(^HUDCancelCallback)(void);

@interface HUD : NSObject

// 显示提示性文本，2s自动消失
+ (void)showWithMessage:(NSString *)message;

// 显示Loading状态提示, 不会自动消失, 需要写在发起任务语句之前, 如果cancelCallback不为空，那么有一个取消按钮
+ (void)showProgressWithMessage:(NSString *)message;
+ (void)showProgressWithMessage:(NSString *)message
                 cancelCallback:(HUDCancelCallback)cancelCallback;

// 显示错误信息
+ (void)showErrorWithMessage:(NSString *)message;

// 隐藏当前的HUD
+ (void)hideAnimated:(BOOL)animated;

@end
