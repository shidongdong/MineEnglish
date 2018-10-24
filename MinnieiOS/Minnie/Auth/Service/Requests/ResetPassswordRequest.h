//
//  ResetPasssword.h
//  X5Teacher
//
//  Created by yebw on 2018/3/25.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "BaseRequest.h"

@interface ResetPassswordRequest : BaseRequest

- (instancetype)initWithOldPassword:(NSString *)oldPassword
                        newPassword:(NSString *)newPassword;

@end
