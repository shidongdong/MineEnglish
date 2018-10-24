//
//  LogoutRequest.m
//  X5
//
//  Created by yebw on 2017/8/28.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "LogoutRequest.h"

@implementation LogoutRequest

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@/auth/logout", ServerProjectName];
}

@end
