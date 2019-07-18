//
//  AwardService.h
//  X5
//
//  Created by yebw on 2017/10/19.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Award.h"
#import "BaseRequest.h"
#import "Result.h"

@interface TeacherAwardService : NSObject

+ (BaseRequest *)requestAwardsWithCallback:(RequestCallback)callback;

+ (BaseRequest *)giveAwardWithId:(NSUInteger)requestId callback:(RequestCallback)callback;

+ (BaseRequest *)addAward:(NSDictionary *)awardInfo callback:(RequestCallback)callback;

+ (BaseRequest *)requestExchangeRequestsWithState:(BOOL)exchanged
                                        callback:(RequestCallback)callback;

+ (BaseRequest *)requestExchangeRequestsWithMoreUrl:(NSString *)moreUrl
                                          callback:(RequestCallback)callback;

+ (BaseRequest *)requestUnexchangedRequestCountWithCallback:(RequestCallback)callback;

+ (BaseRequest *)requestexchangeAwardWithState:(NSInteger)state
                                      callback:(RequestCallback)callback;

// 获取礼品兑换列表(管理端)  state 0表示未兑换，1表示已兑换
+ (BaseRequest *)requestexchangeAwardByClassWithState:(NSInteger)state
                                             callback:(RequestCallback)callback;


@end

