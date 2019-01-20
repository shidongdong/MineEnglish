//
//  SendWarnRequest.m
//  Minnie
//
//  Created by 栋栋 施 on 2019/1/18.
//  Copyright © 2019年 minnieedu. All rights reserved.
//

#import "SendWarnRequest.h"

@interface SendWarnRequest()

@property(nonatomic,assign)NSInteger studentId;

@end

@implementation SendWarnRequest

- (instancetype)initWithStudent:(NSInteger)studentId {
    self = [super init];
    if (self != nil) {
        _studentId = studentId;
    }
    return self;
}


- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPOST;
}

- (NSString *)requestUrl {
    
    return [NSString stringWithFormat:@"%@/user/addWarn", ServerProjectName];
}

- (id)requestArgument {
    return @{@"studentId":@(self.studentId)};
}

@end
