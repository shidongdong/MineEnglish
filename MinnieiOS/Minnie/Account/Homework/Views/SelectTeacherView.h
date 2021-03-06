//
//  SelectTeacherView.h
//  X5Teacher
//
//  Created by yebw on 2018/2/4.
//  Copyright © 2018年 netease. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectTeacherViewSendCallback)(NSInteger teacherId, NSDate *sendDate);

@interface SelectTeacherView : UIView

+ (void)showInSuperView:(UIView *)superView
               teachers:(NSArray *)teachers
               callback:(SelectTeacherViewSendCallback)callback;

+ (void)hideAnimated:(BOOL)animated;


@end
