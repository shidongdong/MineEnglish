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
#import "StudentLabelRequest.h"
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

//学生图形标注（教师端）
+ (BaseRequest *)requestStudentLabelWithStudentId:(NSInteger)stuId
                                     studentLabel:(NSInteger)stuLabel
                                         callback:(RequestCallback)callback{
    
    StudentLabelRequest *request = [[StudentLabelRequest alloc] initWithId:stuId
                                                                  stuLabel:stuLabel];
    [request setCallback:callback];
    [request start];
    return request;
}

//学生信息详情添加备注（教师端）
+ (BaseRequest *)requestStudentRemarkWithStudentId:(NSInteger)stuId
                                         stuRemark:(NSString *)stuRemark
                                          callback:(RequestCallback)callback{
    
    StudentRemarkRequest *request = [[StudentRemarkRequest alloc] initWithId:stuId
                                                                   stuRemark:stuRemark];
    [request setCallback:callback];
    [request start];
    return request;
}

//学生星星增减记录（学生端）
+ (BaseRequest *)requestStarLogsWithPageNo:(NSUInteger)pageNo
                                   pageNum:(NSUInteger)pageNum
                                  callback:(RequestCallback)callback{
    
    StudentStarLogsRequest *request = [[StudentStarLogsRequest alloc] initWithPageNo:pageNo pageNum:pageNum];
    request.objectKey = @"list";
    request.objectClassName = @"StarLogs";
    [request setCallback:callback];
    [request start];
    return request;
}
@end

