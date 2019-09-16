//
//  AuthRequest.m
//  MinnieStudent
//
//  Created by songzhen on 2019/8/21.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import "User.h"
#import "Error.h"
#import "Student.h"
#import "AuthRequest.h"
#import "NSString+MD5.h"
#import <Mantle/Mantle.h>

@implementation AuthRequest

@end


#pragma mark -  2.1.1    注册（学生端）
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
#if TEACHERSIDE | MANAGERSIDE
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
#if TEACHERSIDE | MANAGERSIDE
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


#pragma mark - 2.1.2    登录（学生端，老师端,IPAD端）
@interface LoginRequest()

@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, copy) NSString *password;

@end

@implementation LoginRequest

- (instancetype)initWithPhoneNumber:(NSString *)phoneNumber
                           password:(NSString *)password {
    self = [super init];
    if (self != nil) {
        _phoneNumber = phoneNumber;
        _password = password;
    }
    
    return self;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@/auth/login", ServerProjectName];
}

- (id)requestArgument {
    NSString *passwordHash = [[[self.password stringByAppendingFormat:@".%@", @"minnie@2018"] md5] md5];
    NSInteger type = 0;
#if TEACHERSIDE
    type = 1;
#elif MANAGERSIDE
    
    type = 3;
    type = 1;
#endif
    return @{@"type": @(type),
             @"username":self.phoneNumber,
             @"password":passwordHash};
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
#if TEACHERSIDE | MANAGERSIDE
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



#pragma mark - 2.1.3    请求发送验证码（学生端，教师端）
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

#pragma mark - 2.1.4    验证验证码（学生端，教师端）
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


#pragma mark - 2.1.5    修改密码 （学生端，教师端）
@interface ResetPassswordRequest()

@property (nonatomic, copy) NSString *oldPassword;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *phoneNumber;

@end


@implementation ResetPassswordRequest

- (instancetype)initWithOldPassword:(NSString *)oldPassword
                        newPassword:(NSString *)newPassword
                        phoneNumber:(NSString *)phoneNumber{
    self = [super init];
    if (self != nil) {
        _oldPassword = oldPassword;
        _password = newPassword;
        _phoneNumber = phoneNumber;
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
             @"username":_phoneNumber,
             };
}

@end



#pragma mark - 2.1.6    找密码 （学生端）
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
#if TEACHERSIDE | MANAGERSIDE
    type = 1;
#endif
    
    return @{@"type":@(type),
             @"phoneNumber":self.phoneNumber,
             @"password":passwordHash,
             @"smsCode":self.code};
}


@end



#pragma mark - 2.1.8    注销（学生端，教师端）
@implementation LogoutRequest

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@/auth/logout", ServerProjectName];
}

@end
