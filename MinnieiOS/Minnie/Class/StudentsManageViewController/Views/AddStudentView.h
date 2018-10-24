//
//  AddStudentView.h
//  X5Teacher
//
//  Created by yebw on 2018/1/7.
//  Copyright © 2018年 netease. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ConfirmAddStudentClickCallback)(NSString *phoneNumber);

@interface AddStudentView : UIView

+ (void)showInSuperView:(UIView *)superView
               callback:(ConfirmAddStudentClickCallback)callback;

+ (void)hideAnimated:(BOOL)animated;

@end

