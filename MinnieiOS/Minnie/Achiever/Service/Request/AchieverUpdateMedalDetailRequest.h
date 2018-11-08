//
//  AchieverUpdateMedalDetailRequest.h
//  Minnie
//
//  Created by 栋栋 施 on 2018/11/6.
//  Copyright © 2018年 minnieedu. All rights reserved.
//

#import "BaseRequest.h"

@interface AchieverUpdateMedalDetailRequest : BaseRequest

- (instancetype)initWithMedalId:(NSInteger)medalid
                      medalType:(NSString *)type
                           flag:(NSInteger)flag;

@end
