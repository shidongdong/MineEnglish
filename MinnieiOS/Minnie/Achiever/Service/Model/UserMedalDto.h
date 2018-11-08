//
//  UserMedalDto.h
//  Minnie
//
//  Created by 栋栋 施 on 2018/11/6.
//  Copyright © 2018年 minnieedu. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface UserMedalDto : MTLModel<MTLJSONSerializing>

@property(nonatomic, assign)NSInteger achieverid;
@property(nonatomic, assign)NSInteger firstFlag;
@property(nonatomic, assign)NSInteger sencondFlag;
@property(nonatomic, assign)NSInteger thirdFlag;
@property(nonatomic, strong)NSString * medalType;

@end
