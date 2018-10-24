//
//  RegisterRequest.m
// X5
//
//  Created by yebw on 2017/8/23.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "RegisterRequest.h"
#import "NSString+MD5.h"
#import "Error.h"

@interface RegisterRequest()

@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *code;

@end

@implementation RegisterRequest

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
    return [NSString stringWithFormat:@"%@/auth/register", ServerProjectName];
}

- (id)requestArgument {
    NSString *passwordHash = [[[self.password stringByAppendingFormat:@".%@", @"minnie@2018"] md5] md5];
    NSInteger type = 0;
#if TEACHERSIDE
    type = 1;
#endif
    return @{@"type": @(type),
             @"username":self.phoneNumber,
             @"password":passwordHash,
             @"smsCode":self.code};
}

- (Result *)parseResponseUserInfo:(NSObject *)userInfo error:(NSError *__autoreleasing *)error {
    Result *result = nil;
    
    do {
        if (![userInfo isKindOfClass:[NSDictionary class]]) {
            *error = [Error errorWithUnexpectedResponseData];
            break;
        }
        
        NSObject *userDict = ((NSDictionary *)userInfo);
        if (![userDict isKindOfClass:[NSDictionary class]]) {
            *error = [Error errorWithUnexpectedResponseData];
            break;
        }
        
        NSError *error1 = nil;
#if TEACHERSIDE
        Teacher *user = [MTLJSONAdapter modelOfClass:[Teacher class] fromJSONDictionary:((NSDictionary *)userDict)
                                               error:&error1];
#else
        Student *user = [MTLJSONAdapter modelOfClass:[Student class] fromJSONDictionary:((NSDictionary *)userDict)
                                               error:&error1];
#endif
        
        result = [[Result alloc] init];
        result.userInfo = user;
        result.response = self.response;
        result.responseData = self.responseData;
    } while(NO);
    
    return result;
}

@end

