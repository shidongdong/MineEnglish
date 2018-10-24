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

@end

