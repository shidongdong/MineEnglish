//
//  LoginRequest.h
// X5
//
//  Created by yebw on 2017/8/23.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "BaseRequest.h"

@interface LoginRequest : BaseRequest

- (instancetype)initWithPhoneNumber:(NSString *)phoneNumber
                           password:(NSString *)password;

@end
