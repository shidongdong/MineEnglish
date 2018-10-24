//
//  ExchangeAwardRequest.m
//  X5
//
//  Created by yebw on 2017/10/19.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "ExchangeAwardRequest.h"

@interface ExchangeAwardRequest()

@property (nonatomic, assign) NSUInteger awardId;

@end

@implementation ExchangeAwardRequest

- (instancetype)initWithId:(NSUInteger)awardId {
    self = [super init];
    if (self != nil) {
        self.awardId = awardId;
    }
    
    return self;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@/award/exchange", ServerProjectName];
}

- (id)requestArgument {
    return @{@"id":@(self.awardId), @"count":@(1)};
}

@end

