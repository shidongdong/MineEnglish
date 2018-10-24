//
//  NSString+Qiniu.m
//  X5
//
//  Created by yebw on 2017/12/8.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "NSString+Qiniu.h"

@implementation NSString(Qiniu)

- (NSString *)imageUrlWithWidth:(CGFloat)width {
    NSURL *url = [NSURL URLWithString:self];
    if (url == nil) {
        return nil;
    }
    
//    if (![url.host.lowercaseString containsString:@".zhengminyi.com"]) {
//        return self;
//    }
    
    if ([self containsString:@"?"]) {
        return self;
    }

    NSString *result = nil;
    
    width = width * [UIScreen mainScreen].scale;

    NSString *query = url.query;
    if (query.length > 0) {
        result = [self stringByAppendingFormat:@"&imageView2/2/w/%.f", width];
    } else {
        result = [self stringByAppendingFormat:@"?imageView2/2/w/%.f", width];
    }
    
    return result;
}

- (NSURL *)imageURLWithWidth:(CGFloat)width {
    return [NSURL URLWithString:[self imageUrlWithWidth:width]];
}

- (NSURL *)videoCoverUrlWithWidth:(CGFloat)width height:(CGFloat)height {
    NSString *coverUrl = nil;
    if ([self containsString:@"?"]) {
        return nil;
    }
    
//    if (![self containsString:@"file.zhengminyi.com"]) {
//        return nil;
//    }
    
//    width = width * [UIScreen mainScreen].scale;
//    height = height * [UIScreen mainScreen].scale;
//
//    coverUrl = [self stringByAppendingFormat:@"?vframe/jpg/offset/1/w/%.f/h/%.f", width, height];
    
    // 视频封面压缩很丑，暂时不压缩
    coverUrl = [self stringByAppendingString:@"?vframe/jpg/offset/1"];

    return [NSURL URLWithString:coverUrl];
}

@end
