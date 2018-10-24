//
//  UIColor+HEX.h
//  X5
//
//  Created by yebw on 2017/9/10.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor(HEX)

+ (UIColor*)colorWithHex:(NSInteger)hexValue;
+ (UIColor*)colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue;

@end
