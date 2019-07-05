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

@property (nonatomic,assign) UIDatePickerMode pickerMode;

// 年月日
+ (void)showInView:(UIView *)view
              date:(NSDate *)date
          callback:(DatePickerViewCallback)callback;

// 年月日时分
+ (void)showInView:(UIView *)view
              dateTime:(NSDate *)dateTime
          callback:(DatePickerViewCallback)callback;

- (void)setPickerStyle;

@end
