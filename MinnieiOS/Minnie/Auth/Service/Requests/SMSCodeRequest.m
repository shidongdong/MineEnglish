//
//  SMSCodeRequest.m
// X5
//
//  Created by yebw on 2017/8/23.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "SMSCodeRequest.h"

@interface SMSCodeRequest()

@property (nonatomic, copy) NSString *phoneNumber;

@end

@implementation SMSCodeRequest

- (instancetype)initWithPhoneNumber:(NSString *)phoneNumber {
    self = [super init];
    if (self != nil) {
        _phoneNumber = phoneNumber;
    }
    
    return self;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@/auth/sendSMSCode", ServerProjectName];
}

- (id)requestArgument {
    return @{@"phoneNumber":_phoneNumber};
}

@end


