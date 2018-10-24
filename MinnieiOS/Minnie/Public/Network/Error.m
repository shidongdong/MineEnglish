//
//  Error.m
// X5
//
//  Created by yebw on 2017/8/23.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "Error.h"

NSString * const MURequestErrorDomain = @"MURequestErrorDomain";

@implementation Error

+ (NSError *)errorWithResponseObject:(NSObject *)object {
    NSError *error = nil;
    
    do {
        if (![object isKindOfClass:[NSDictionary class]]) {
            error = [[self class] errorWithCode:MURequestErrorUnexpectedResponseData];
            break;
        }
        
        NSDictionary *responseDict = (NSDictionary *)(object);
        if (responseDict[@"code"] == nil || ![responseDict[@"code"] isKindOfClass:[NSNumber class]]) {
            error = [[self class] errorWithCode:MURequestErrorUnexpectedResponseData];
            break;
        }
        
        NSInteger code = [(NSNumber *)(responseDict[@"code"]) integerValue];
        if (code != 0) {
            NSString *desc = (NSString *)(responseDict[@"message"]);
            error = [NSError errorWithDomain:MURequestErrorDomain
                                        code:code
                                    userInfo:@{NSLocalizedDescriptionKey: desc}];
            
            break;
        }
    } while(NO);
    
    return error;
}

+ (NSError *)errorWithUnexpectedResponseData {
    return [NSError errorWithDomain:MURequestErrorDomain
                               code:MURequestErrorUnexpectedResponseData
                           userInfo:@{NSLocalizedDescriptionKey: @"结果解析失败"}];
}

+ (NSError *)errorWithCode:(MURequestErrorCode)code {
    NSString *desc = [[self class] errorDescriptionWithCode:code];
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey: desc};

    return [NSError errorWithDomain:MURequestErrorDomain
                               code:code
                           userInfo:userInfo];
}


+ (NSString *)errorDescriptionWithCode:(MURequestErrorCode)code {
    return @"";
}

@end

