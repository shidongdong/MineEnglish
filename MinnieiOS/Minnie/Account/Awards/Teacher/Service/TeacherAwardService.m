//
//  AwardService.m
//  X5
//
//  Created by yebw on 2017/10/19.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "TeacherAwardService.h"
#import "AwardsRequest.h"
#import "GiveAwardRequest.h"
#import "ExchangeRequestsRequest.h"
#import "AddAwardRequest.h"
#import "UnexchangedRequestCountRequest.h"

@implementation TeacherAwardService

+ (BaseRequest *)requestAwardsWithCallback:(RequestCallback)callback {
    AwardsRequest *request = [[AwardsRequest alloc] init];
    
    request.objectKey = @"list";
    request.objectClassName = @"Award";
    
    [request setCallback:callback];
    [request start];
    
    return request;
}


+ (BaseRequest *)addAward:(NSDictionary *)awardInfo
                 callback:(RequestCallback)callback {
    AddAwardRequest *request = [[AddAwardRequest alloc] initWithInfos:awardInfo];
    
    [request setCallback:callback];
    [request start];
    
    return request;
}

+ (BaseRequest *)giveAwardWithId:(NSUInteger)requestId callback:(RequestCallback)callback {
    GiveAwardRequest *request = [[GiveAwardRequest alloc] initWithId:requestId];

    [request setCallback:callback];
    [request start];
    
    return request;
}

+ (BaseRequest *)requestExchangeRequestsWithState:(BOOL)exchanged
                                        callback:(RequestCallback)callback {
    ExchangeRequestsRequest *request = [[ExchangeRequestsRequest alloc] initWithExchangeState:(exchanged?1:0)];
    
    request.objectKey = @"list";
    request.objectClassName = @"ExchangeRecord";

    [request setCallback:callback];
    [request start];
    
    return request;
}

+ (BaseRequest *)requestExchangeRequestsWithMoreUrl:(NSString *)moreUrl
                                          callback:(RequestCallback)callback {
    ExchangeRequestsRequest *request = [[ExchangeRequestsRequest alloc] init];
    
    request.objectKey = @"list";
    request.objectClassName = @"ExchangeRecord";
    
    [request setCallback:callback];
    [request start];
    
    return request;
}

+ (BaseRequest *)requestUnexchangedRequestCountWithCallback:(RequestCallback)callback {
    UnexchangedRequestCountRequest *request = [[UnexchangedRequestCountRequest alloc] init];
    
    [request setCallback:callback];
    [request start];
    
    return request;
}

@end

