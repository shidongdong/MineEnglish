//
//  Error.h
// X5
//
//  Created by yebw on 2017/8/23.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const MURequestErrorDomain;

typedef NS_ENUM(NSInteger, MURequestErrorCode) {
    MURequestErrorUnexpectedResponseData = -1, // 结果解析失败
};

@interface Error : NSObject

+ (NSError *)errorWithResponseObject:(NSObject *)object;

+ (NSError *)errorWithUnexpectedResponseData;

@end
