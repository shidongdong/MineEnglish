//
//  StarRank.h
//  Minnie
//
//  Created by 栋栋 施 on 2018/10/26.
//  Copyright © 2018年 minnieedu. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface StarRank : MTLModel<MTLJSONSerializing>

@property(nonatomic,assign)NSInteger starCount;
@property(nonatomic,strong)NSString * avatar;
@property(nonatomic,assign)NSInteger userId;
@property(nonatomic,strong)NSString * nickName;

@end
