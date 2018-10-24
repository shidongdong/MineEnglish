//
//  TimePickerView.h
//  X5Teacher
//
//  Created by yebw on 2018/1/28.
//  Copyright © 2018年 netease. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TimePickerViewCallback)(NSString *);

@interface TimePickerView : UIView

+ (void)showInView:(UIView *)view
              date:(NSString *)date
          callback:(TimePickerViewCallback)callback;

@end
