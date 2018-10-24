//
//  BaseRequest.h
// X5
//
//  Created by yebw on 2017/8/23.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>

#ifndef USING_MOCK_DATA
#define USING_MOCK_DATA 0
#endif

#ifndef ServerProjectName
#define ServerProjectName @""//@"enmobileserver"
#endif

@class Result;

typedef void (^RequestCallback)(Result *result, NSError *error);

@interface BaseRequest : YTKBaseRequest

@property (nonatomic, copy) NSString *responseParserClassName;

@property (nonatomic, copy) NSString *objectClassName;
@property (nonatomic, copy) NSString *objectKey;

@property (nonatomic, assign) BOOL authorizationNotNeeded;

@property (nonatomic, copy) RequestCallback callback;

+ (void)setToken:(NSString *)token;

- (BOOL)authorizationHeaderRequired;

- (Result *)parseResponse:(NSError **)error;

- (Result *)parseResponseUserInfo:(NSObject *)userInfo error:(NSError **)error;

@end

