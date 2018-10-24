//
//  VerifySMSCodeRequest.h
//  X5Teacher
//
//  Created by yebw on 2017/12/21.
//  Copyright © 2017年 netease. All rights reserved.
//

#import "BaseRequest.h"

@interface VerifySMSCodeRequest : BaseRequest

- (instancetype)initWithPhoneNumber:(NSString *)phoneNumber
                               code:(NSString *)code;

@end
