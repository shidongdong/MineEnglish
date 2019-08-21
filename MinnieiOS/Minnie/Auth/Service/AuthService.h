//
//  AuthService.h
// X5
//
//  Created by yebw on 2017/8/23.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "BaseRequest.h"

@interface AuthService : NSObject

+ (BaseRequest *)askForSMSCodeWithPhoneNumber:(NSString *)phoneNumber
                                     callback:(RequestCallback)callback;

+ (BaseRequest *)verifySMSCodeWithPhoneNumber:(NSString *)phoneNumber
                                         code:(NSString *)code
                                     callback:(RequestCallback)callback;

+ (BaseRequest *)registerWithPhoneNumber:(NSString *)phoneNumber
                                password:(NSString *)password
                                    code:(NSString *)code
                                callback:(RequestCallback)callback;

+ (BaseRequest *)loginWithPhoneNumber:(NSString *)phoneNumber
                             password:(NSString *)password
                             callback:(RequestCallback)callback;

+ (BaseRequest *)findPasswordWithPhoneNumber:(NSString *)phoneNumber
                                    password:(NSString *)password
                                        code:(NSString *)code
                                    callback:(RequestCallback)callback;

+ (BaseRequest *)resetPasswordWithPassword:(NSString *)password
                               newPassword:(NSString *)newPassword
                               phoneNumber:(NSString *)phoneNumber
                                  callback:(RequestCallback)callback;

+ (BaseRequest *)logoutWithCallback:(RequestCallback)callback;

@end

