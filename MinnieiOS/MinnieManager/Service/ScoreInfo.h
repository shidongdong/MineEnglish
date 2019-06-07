//
//  ScoreInfo.h
//  MinnieManager
//
//  Created by songzhen on 2019/6/1.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import <Mantle/Mantle.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ScoreInfo <NSObject>

@end

@interface ScoreInfo : MTLModel<MTLJSONSerializing>

@property(nonatomic, copy) NSString * avatar;

@property(nonatomic, copy) NSString * nickName;

@property(nonatomic, assign) NSInteger score;

@property(nonatomic, assign) NSInteger userId;

@end


@interface ScoreInfoList : MTLModel<MTLJSONSerializing>

@property(nonatomic, copy) NSString * next;

@property(nonatomic, copy) NSArray<ScoreInfo>* list;

@end

NS_ASSUME_NONNULL_END
