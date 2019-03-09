//
//  FileUploaderService.m
//  Minnie
//
//  Created by 栋栋 施 on 2019/3/1.
//  Copyright © 2019年 minnieedu. All rights reserved.
//

#import "FileUploaderService.h"
#import "AskQNTokenRequest.h"
@implementation FileUploaderService

+ (BaseRequest *)askForQNUploadTokenWithCallback:(RequestCallback)callback
{
    AskQNTokenRequest *request = [[AskQNTokenRequest alloc] init];
    request.objectClassName = @"QNTokenModel";
    [request setCallback:callback];
    [request start];
    return request;
}

@end
