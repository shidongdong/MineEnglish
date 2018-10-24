//
//  CheckAppVerRequest.h
//  MinnieStudent
//
//  Created by 栋栋 施 on 2018/9/13.
//  Copyright © 2018年 minnieedu. All rights reserved.
//

#import "BaseRequest.h"

@interface CheckAppVerRequest : BaseRequest

- (instancetype)initWithVersion:(NSString *)version  withType:(NSString *)type;

@end
