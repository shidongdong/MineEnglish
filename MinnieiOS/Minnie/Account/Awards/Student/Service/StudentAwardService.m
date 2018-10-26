//
//  AwardService.m
//  X5
//
//  Created by yebw on 2017/10/19.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "StudentAwardService.h"
#import "AwardsRequest.h"
#import "ExchangeAwardRequest.h"
#import "ExchangeRecordsRequest.h"
#import "StudentStarRankRequest.h"
@implementation StudentAwardService

+ (BaseRequest *)requestAwardsWithCallback:(RequestCallback)callback {
    AwardsRequest *request = [[AwardsRequest alloc] init];
    
    request.objectKey = @"list";
    request.objectClassName = @"Award";
    
    [request setCallback:callback];
    [request start];
    
    return request;
}

+ (BaseRequest *)exchangeAwardWithId:(NSUInteger)awardId callback:(RequestCallback)callback {
    ExchangeAwardRequest *request = [[ExchangeAwardRequest alloc] initWithId:awardId];
    
    [request setCallback:callback];
    [request start];
    
    return request;
}

+ (BaseRequest *)requestExchangeRecordsWithCallback:(RequestCallback)callback {
    ExchangeRecordsRequest *request = [[ExchangeRecordsRequest alloc] init];
    
    request.objectKey = @"list";
    request.objectClassName = @"ExchangeRecord";

    [request setCallback:callback];
    [request start];
    
    return request;
}

+ (BaseRequest *)requestStudentStarRankListWithCallback:(RequestCallback)callback
{
    StudentStarRankRequest *request = [[StudentStarRankRequest alloc] init];
    
    request.objectKey = @"list";
    request.objectClassName = @"StarRank";
    
    [request setCallback:callback];
    [request start];
    
    return request;
}


@end

