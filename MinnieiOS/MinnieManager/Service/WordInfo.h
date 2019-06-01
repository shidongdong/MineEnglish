//
//  WordInfo.h
//  MinnieManager
//
//  Created by songzhen on 2019/6/1.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import <Mantle/Mantle.h>

@protocol WordInfo <NSObject>

@end

NS_ASSUME_NONNULL_BEGIN

@interface WordInfo : MTLModel<MTLJSONSerializing>

// 英文释义
@property (nonatomic, copy) NSString *english;
// 中文释义
@property (nonatomic, assign) NSInteger chinese;

@end

NS_ASSUME_NONNULL_END
