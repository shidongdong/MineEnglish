//
//  ExchangeRequestsRequest.m
//  X5
//
//  Created by yebw on 2017/10/19.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "ExchangeRequestsRequest.h"

@interface ExchangeRequestsRequest()

@property (nonatomic, assign) BOOL exchangeState;
@property (nonatomic, copy) NSString *nextUrl;

@end

@implementation ExchangeRequestsRequest

- (instancetype)initWithExchangeState:(NSInteger)state {
    self = [super init];
    if (self != nil) {
        _exchangeState = state;
    }
    
    return self;
}

- (instancetype)initWithNextUrl:(NSString *)nextUrl {
    self = [super init];
    if (self != nil) {
        _nextUrl = nextUrl;
    }
    
    return self;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (NSString *)requestUrl {
    if (self.nextUrl != nil) {
        return self.nextUrl;
    }
    
    return [NSString stringWithFormat:@"%@/award/exchangeRequestRecords", ServerProjectName];
}

- (id)requestArgument {
    if (self.nextUrl != nil) {
        return nil;
    }

    return @{@"state":@(self.exchangeState?1:0)};
}

@end




@interface ExchangeAwardListRequest()

@property (nonatomic, assign) NSUInteger state;

@end

@implementation ExchangeAwardListRequest

- (instancetype)initWithState:(NSUInteger)state{
    
    self = [super init];
    if (self != nil) {
        self.state = state;
    }
    
    return self;
    
}
- (id)requestArgument {
    return @{@"state":@(self.state)};
}

- (YTKRequestMethod)requestMethod{
    
    return YTKRequestMethodGET;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@/award/exchangeAwardList", ServerProjectName];
}

@end
