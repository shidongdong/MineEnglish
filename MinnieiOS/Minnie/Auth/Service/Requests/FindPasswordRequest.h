//
//  FindPasswordRequest.h
// X5
//
//  Created by yebw on 2017/8/24.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "BaseRequest.h"

@interface FindPasswordRequest : BaseRequest

- (instancetype)initWithPhoneNumber:(NSString *)phoneNumber
                           password:(NSString *)password
                               code:(NSString *)code;

@end
