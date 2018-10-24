//
//  Result.h
// X5
//
//  Created by yebw on 2017/8/23.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Result : NSObject

@property (nonatomic, strong) NSObject *userInfo;

@property (nonatomic, strong) NSData *responseData;
@property (nonatomic, strong) NSHTTPURLResponse *response;

@end
