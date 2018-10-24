//
//  ExchangeRecordsRequest.m
//  X5
//
//  Created by yebw on 2017/10/19.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "ExchangeRecordsRequest.h"

@implementation ExchangeRecordsRequest

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@/award/exchangeRequestRecords", ServerProjectName];
}

@end
