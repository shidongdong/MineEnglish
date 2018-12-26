//
//  CorrectHomeworkAddCommentRequest.m
//  Minnie
//
//  Created by 栋栋 施 on 2018/12/26.
//  Copyright © 2018年 minnieedu. All rights reserved.
//

#import "CorrectHomeworkAddCommentRequest.h"

@interface CorrectHomeworkAddCommentRequest()

@property(nonatomic,strong)NSString * comment;

@end

@implementation CorrectHomeworkAddCommentRequest


- (instancetype)initWithAddHomeworkComment:(NSString *)comment
{
    self = [super init];
    if (self != nil) {
        _comment = comment;
    }
    return self;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@/homework/addComment", ServerProjectName];
}

- (id)requestArgument {
    
    return @{@"comment":self.comment};
}

@end
