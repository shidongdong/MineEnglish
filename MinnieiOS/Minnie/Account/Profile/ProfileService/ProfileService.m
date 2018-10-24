//
//  ProfileService.m
//  X5
//
//  Created by yebw on 2017/12/8.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "ProfileService.h"
#import "UpdateProfileRequest.h"

@implementation ProfileService


+ (BaseRequest *)updateAvatar:(NSString *)avatarUrl
                     callback:(RequestCallback)callback {
    NSDictionary *dict = @{@"avatarUrl":avatarUrl};
    
    UpdateProfileRequest *request = [[UpdateProfileRequest alloc] initWithProfileDict:dict];
    
    request.callback = callback;
    [request start];
    
    return request;
}

+ (BaseRequest *)updateNickname:(NSString *)nickname
                       callback:(RequestCallback)callback {
    NSDictionary *dict = @{@"nickname":nickname};
    
    UpdateProfileRequest *request = [[UpdateProfileRequest alloc] initWithProfileDict:dict];
    
    request.callback = callback;
    [request start];
    
    return request;
}

+ (BaseRequest *)updateProfile:(NSDictionary *)profileDict
                      callback:(RequestCallback)callback {
    UpdateProfileRequest *request = [[UpdateProfileRequest alloc] initWithProfileDict:profileDict];
    
    request.callback = callback;
    [request start];
    
    return request;
}

@end

