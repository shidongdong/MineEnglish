//
//  ProfileService.h
//  X5
//
//  Created by yebw on 2017/12/8.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequest.h"
#import "Result.h"

@interface ProfileService : NSObject

+ (BaseRequest *)updateAvatar:(NSString *)avatarUrl
                     callback:(RequestCallback)callback;

+ (BaseRequest *)updateNickname:(NSString *)nickname
                       callback:(RequestCallback)callback;

+ (BaseRequest *)updateProfile:(NSDictionary *)profileDict
                      callback:(RequestCallback)callback;

@end

