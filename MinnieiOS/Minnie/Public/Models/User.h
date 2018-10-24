//
//  User.h
// X5
//
//  Created by yebw on 2017/8/23.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface User : MTLModel<MTLJSONSerializing>

@property (nonatomic, assign) NSInteger userId; // 用户id
@property (nonatomic, copy) NSString *username; // 用户名，目前和电话号码一致
@property (nonatomic, copy) NSString *nickname; // 用户昵称
@property (nonatomic, copy) NSString *phoneNumber; // 电话号码
@property (nonatomic, copy) NSString *avatarUrl; // 用户头像
@property (nonatomic, assign) NSInteger gender; // 用户性别: -1女 0保密 1男

@property (nonatomic, copy) NSString *token;

@end

