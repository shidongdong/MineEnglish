//
//  UserRequest.h
//  X5
//
//  Created by yebw on 2017/12/8.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "BaseRequest.h"
#import "User.h"

@interface UserRequest : BaseRequest

- (instancetype)initWithUserId:(NSInteger)userId;

@end
