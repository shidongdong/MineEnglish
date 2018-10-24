//
//  TimePickerView.h
//  X5Teacher
//
//  Created by yebw on 2018/1/28.
//  Copyright © 2018年 netease. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DatePickerViewCallback)(NSDate *date);

@interface DatePickerView : UIView

+ (void)showInView:(UIView *)view
              date:(NSDate *)date
          callback:(DatePickerViewCallback)callback;

@end
