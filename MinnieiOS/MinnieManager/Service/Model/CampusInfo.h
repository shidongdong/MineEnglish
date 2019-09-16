//
//  CampusInfo.h
//  MinnieManager
//
//  Created by songzhen on 2019/7/16.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import <Mantle/Mantle.h>

NS_ASSUME_NONNULL_BEGIN

@interface CampusInfo : MTLModel<MTLJSONSerializing>

// 校区id
@property(nonatomic, assign) NSInteger campusId;
// 校区名称
@property(nonatomic, copy) NSString * campusName;

@end

NS_ASSUME_NONNULL_END
