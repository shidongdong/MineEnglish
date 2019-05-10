//
//  ModifyStarRequest.m
//  Minnie
//
//  Created by 栋栋 施 on 2019/3/8.
//  Copyright © 2019年 minnieedu. All rights reserved.
//

#import "ModifyStarRequest.h"

@interface ModifyStarRequest()

@property (nonatomic, assign) NSInteger studentId;
@property (nonatomic, assign) NSInteger starCount;
@property (nonatomic, copy) NSString *editReason;
@end

@implementation ModifyStarRequest

- (instancetype)initWithStudentId:(NSInteger)studentId starCount:(NSInteger)count reason:(NSString *)reason{
    self = [super init];
    if (self != nil) {
        _studentId = studentId;
        _starCount = count;
        _editReason = reason;
    }
    
    return self;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@/user/editStar", ServerProjectName];
}

- (id)requestArgument {
    return @{@"studentId":@(self.studentId),
             @"starCount":@(self.starCount),
             @"editReason":self.editReason};
}

@end
