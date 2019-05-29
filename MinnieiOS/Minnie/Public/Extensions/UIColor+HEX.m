//
//  UIColor+HEX.m
//  X5
//
//  Created by yebw on 2017/9/10.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "UIColor+HEX.h"

@implementation UIColor(HEX)

+ (UIColor*)colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue
{
    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0
                           green:((float)((hexValue & 0xFF00) >> 8))/255.0
                            blue:((float)(hexValue & 0xFF))/255.0 alpha:alphaValue];
}

+ (UIColor*)colorWithHex:(NSInteger)hexValue
{
    return [UIColor colorWithHex:hexValue alpha:1.0];
}

+ (UIColor *)mainColor{
    
    return [UIColor colorWithHex:0x0098FE];
}

+ (UIColor*)normalColor{
    
    return [UIColor colorWithHex:0x333333];
}

+ (UIColor*)detailColor{
    
    return [UIColor colorWithHex:0x999999];
}

+ (UIColor*)separatorLineColor{
    
    return [UIColor colorWithHex:0xCCCCCC];
}

+ (UIColor*)bgColor{
    
    return [UIColor colorWithHex:0xEEEEEE];
}

@end
