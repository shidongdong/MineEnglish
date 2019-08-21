//
//  AuthRequest.h
//  MinnieStudent
//
//  Created by songzhen on 2019/8/21.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import "Result.h"
#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark -  2.1.1    注册（学生端）
@interface AuthRequest : BaseRequest

@end

@interface RegisterRequest : BaseRequest

- (instancetype)initWithPhoneNumber:(NSString *)phoneNumber
                           password:(NSString *)password
                               code:(NSString *)code;

@end


#pragma mark - 2.1.2    登录（学生端，老师端,IPAD端）
@interface LoginRequest : BaseRequest

- (instancetype)initWithPhoneNumber:(NSString *)phoneNumber
                           password:(NSString *)password;

@end


#pragma mark - 2.1.3    请求发送验证码（学生端，教师端）
@interface SMSCodeRequest : BaseRequest

- (instancetype)initWithPhoneNumber:(NSString *)phoneNumber;

@end

#pragma mark - 2.1.4    验证验证码（学生端，教师端）
@interface VerifySMSCodeRequest : BaseRequest

- (instancetype)initWithPhoneNumber:(NSString *)phoneNumber
                               code:(NSString *)code;

@end


#pragma mark - 2.1.5    修改密码 （学生端，教师端）
@interface ResetPassswordRequest : BaseRequest

- (instancetype)initWithOldPassword:(NSString *)oldPassword
                        newPassword:(NSString *)newPassword
                        phoneNumber:(NSString *)phoneNumber;

@end



#pragma mark - 2.1.6    找密码 （学生端）
@interface FindPasswordRequest : BaseRequest

- (instancetype)initWithPhoneNumber:(NSString *)phoneNumber
                           password:(NSString *)password
                               code:(NSString *)code;

@end

#pragma mark - 2.1.8    注销（学生端，教师端）
@interface LogoutRequest : BaseRequest

@end


NS_ASSUME_NONNULL_END
