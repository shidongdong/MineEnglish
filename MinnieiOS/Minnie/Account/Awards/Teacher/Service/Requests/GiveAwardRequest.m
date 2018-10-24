//
//  ExchangeAwardRequest.m
//  X5
//
//  Created by yebw on 2017/10/19.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "GiveAwardRequest.h"

@interface GiveAwardRequest()

@property (nonatomic, assign) NSUInteger awardRequestId;

@end

@implementation GiveAwardRequest

- (instancetype)initWithId:(NSUInteger)awardRequestId {
    self = [super init];
    if (self != nil) {
        self.awardRequestId = awardRequestId;
    }
    
    return self;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@/award/giveAward", ServerProjectName];
}

- (id)requestArgument {
    return @{@"id":@(self.awardRequestId)};
}

@end

