//
//  AuthService.m
// X5
//
//  Created by yebw on 2017/8/23.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "AuthService.h"
#import "SMSCodeRequest.h"
#import "RegisterRequest.h"
#import "LoginRequest.h"
#import "FindPasswordRequest.h"
#import "LogoutRequest.h"
#import "VerifySMSCodeRequest.h"
#import "ResetPassswordRequest.h"

@implementation AuthService

+ (BaseRequest *)askForSMSCodeWithPhoneNumber:(NSString *)phoneNumber
                                     callback:(RequestCallback)callback {
    SMSCodeRequest *request = [[SMSCodeRequest alloc] initWithPhoneNumber:phoneNumber];
    
    [request setCallback:callback];
    [request start];
    
    return request;
}

+ (BaseRequest *)verifySMSCodeWithPhoneNumber:(NSString *)phoneNumber code:(NSString *)code callback:(RequestCallback)callback {
    VerifySMSCodeRequest *request = [[VerifySMSCodeRequest alloc] initWithPhoneNumber:phoneNumber code:code];
    
    [request setCallback:callback];
    [request start];
    
    return request;
}

+ (BaseRequest *)registerWithPhoneNumber:(NSString *)phoneNumber
                                password:(NSString *)password
                                    code:(NSString *)code
                                callback:(RequestCallback)callback {
    RegisterRequest *request = [[RegisterRequest alloc] initWithPhoneNumber:phoneNumber
                                                                   password:password
                                                                       code:code];
    
    [request setCallback:callback];
    [request start];
    
    return request;
}

+ (BaseRequest *)loginWithPhoneNumber:(NSString *)phoneNumber
                             password:(NSString *)password
                             callback:(RequestCallback)callback {
    LoginRequest *request = [[LoginRequest alloc] initWithPhoneNumber:phoneNumber
                                                             password:password];
    
    [request setCallback:callback];
    [request start];
    
    return request;
}

+ (BaseRequest *)findPasswordWithPhoneNumber:(NSString *)phoneNumber
                                    password:(NSString *)password
                                        code:(NSString *)code
                                    callback:(RequestCallback)callback {
    FindPasswordRequest *request = [[FindPasswordRequest alloc] initWithPhoneNumber:phoneNumber
                                                                           password:password
                                                                               code:code];
    
    request.authorizationNotNeeded = YES;
    
    [request setCallback:callback];
    [request start];
    
    return request;
}

+ (BaseRequest *)resetPasswordWithPassword:(NSString *)password
                               newPassword:(NSString *)newPassword
                                  callback:(RequestCallback)callback {
    ResetPassswordRequest *request = [[ResetPassswordRequest alloc] initWithOldPassword:password newPassword:newPassword];
    
    [request setCallback:callback];
    [request start];
    
    return request;
}

+ (BaseRequest *)logoutWithCallback:(RequestCallback)callback {
    LogoutRequest *request = [[LogoutRequest alloc] init];
    
    [request setCallback:callback];
    [request start];
    
    return request;
}

@end


