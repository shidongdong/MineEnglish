//
//  FindPasswordRequest.m
// X5
//
//  Created by yebw on 2017/8/24.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "FindPasswordRequest.h"
#import "NSString+MD5.h"

@interface FindPasswordRequest()

@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *code;

@end


@implementation FindPasswordRequest

- (instancetype)initWithPhoneNumber:(NSString *)phoneNumber
                           password:(NSString *)password
                               code:(NSString *)code {
    self = [super init];
    if (self != nil) {
        _phoneNumber = phoneNumber;
        _password = password;
        _code = code;
    }
    
    return self;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@/auth/findPassword", ServerProjectName];
}

- (id)requestArgument {
    NSString *passwordHash = [[[self.password stringByAppendingFormat:@".%@", @"minnie@2018"] md5] md5];
    NSInteger type = 0;
#if TEACHERSIDE
    type = 1;
#endif
    
    return @{@"type":@(type),
             @"phoneNumber":self.phoneNumber,
             @"password":passwordHash,
             @"smsCode":self.code};
}


@end


