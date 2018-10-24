//
//  NSString+Qiniu.h
//  X5
//
//  Created by yebw on 2017/12/8.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString(Qiniu)

- (NSString *)imageUrlWithWidth:(CGFloat)width;

- (NSURL *)imageURLWithWidth:(CGFloat)width;

- (NSURL *)videoCoverUrlWithWidth:(CGFloat)width height:(CGFloat)height;

@end
