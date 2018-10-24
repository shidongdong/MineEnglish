//
//  UpdateProfileRequest.h
//  X5
//
//  Created by yebw on 2017/12/8.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "BaseRequest.h"

@interface UpdateProfileRequest : BaseRequest

- (instancetype)initWithProfileDict:(NSDictionary *)dict;

@end
