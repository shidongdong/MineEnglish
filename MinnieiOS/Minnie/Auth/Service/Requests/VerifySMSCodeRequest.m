//
//  VerifySMSCodeRequest.m
//  X5Teacher
//
//  Created by yebw on 2017/12/21.
//  Copyright © 2017年 netease. All rights reserved.
//

#import "VerifySMSCodeRequest.h"

@interface VerifySMSCodeRequest()

@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, copy) NSString *code;

@end

@implementation VerifySMSCodeRequest

- (instancetype)initWithPhoneNumber:(NSString *)phoneNumber code:(NSString *)code {
    self = [super init];
    if (self != nil) {
        _phoneNumber = phoneNumber;
        _code = code;
    }
    
    return self;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@/auth/verifySMSCode", ServerProjectName];
}

- (id)requestArgument {
    return @{@"phoneNumber":_phoneNumber, @"smsCode":_code};
}

@end
