//
//  AchieverUpdateMedalDetailRequest.h
//  Minnie
//
//  Created by 栋栋 施 on 2018/11/6.
//  Copyright © 2018年 minnieedu. All rights reserved.
//

#import "BaseRequest.h"
#import "UserMedalDto.h"
@interface AchieverUpdateMedalDetailRequest : BaseRequest

- (instancetype)initWithMedalData:(UserMedalDetail *)data atMedalIndex:(NSInteger)index;

@end
