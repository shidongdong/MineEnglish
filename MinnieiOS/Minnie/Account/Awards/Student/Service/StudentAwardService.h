//
//  AwardService.h
//  X5
//
//  Created by yebw on 2017/10/19.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Award.h"
#import "ExchangeRecord.h"
#import "BaseRequest.h"
#import "Result.h"

@interface StudentAwardService : NSObject

+ (BaseRequest *)requestAwardsWithCallback:(RequestCallback)callback;

+ (BaseRequest *)exchangeAwardWithId:(NSUInteger)award callback:(RequestCallback)callback;

+ (BaseRequest *)requestExchangeRecordsWithCallback:(RequestCallback)callback;

//获取星星排行榜
+ (BaseRequest *)requestStudentStarRankListWithCallback:(RequestCallback)callback;

@end
