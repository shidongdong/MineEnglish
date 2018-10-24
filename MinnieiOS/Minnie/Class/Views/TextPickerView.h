//
//  TimePickerView.h
//  X5Teacher
//
//  Created by yebw on 2018/1/28.
//  Copyright © 2018年 netease. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TextPickerViewCallback)(NSString *);

@interface TextPickerView : UIView

+ (void)showInView:(UIView *)view
          contents:(NSArray<NSString *> *)contents
     selectedIndex:(NSInteger)index
          callback:(TextPickerViewCallback)callback;

@end
