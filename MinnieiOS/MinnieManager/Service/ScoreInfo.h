//
//  ScoreInfo.h
//  MinnieManager
//
//  Created by songzhen on 2019/6/1.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import <Mantle/Mantle.h>

NS_ASSUME_NONNULL_BEGIN

@interface ScoreInfo : MTLModel

@property(nonatomic, copy) NSString * avatar;

@property(nonatomic, copy) NSString * nickName;

@property(nonatomic, assign) NSInteger score;

@property(nonatomic, assign) NSInteger userId;

@end

NS_ASSUME_NONNULL_END
