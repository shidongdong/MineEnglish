//
//  ResetPasssword.m
//  X5Teacher
//
//  Created by yebw on 2018/3/25.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "ResetPassswordRequest.h"
#import "NSString+MD5.h"

@interface ResetPassswordRequest()

@property (nonatomic, copy) NSString *oldPassword;
@property (nonatomic, copy) NSString *password;

@end


@implementation ResetPassswordRequest

- (instancetype)initWithOldPassword:(NSString *)oldPassword
                        newPassword:(NSString *)newPassword {
    self = [super init];
    if (self != nil) {
        _oldPassword = oldPassword;
        _password = newPassword;
    }
    
    return self;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@/auth/changePassword", ServerProjectName];
}

- (id)requestArgument {
    NSString *oldPasswordHash = [[[self.oldPassword stringByAppendingFormat:@".%@", @"minnie@2018"] md5] md5];
    
    NSString *passwordHash = [[[self.password stringByAppendingFormat:@".%@", @"minnie@2018"] md5] md5];
    
    return @{@"oldPassword":oldPasswordHash,
             @"newPassword":passwordHash,
             @"username":APP.currentUser.phoneNumber,
             };
}

@end

