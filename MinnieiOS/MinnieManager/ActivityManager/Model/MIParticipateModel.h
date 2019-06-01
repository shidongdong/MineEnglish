//
//  MIParticipateModel.h
//  MinnieManager
//
//  Created by songzhen on 2019/5/31.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MIParticipateModel : NSObject

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSString *icon;

@property (nonatomic, strong) NSString *time;

@property (nonatomic, assign) NSInteger state;

@end

NS_ASSUME_NONNULL_END
