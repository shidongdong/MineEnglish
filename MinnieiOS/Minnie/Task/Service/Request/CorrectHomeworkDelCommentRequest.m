//
//  CorrectHomeworkDelCommentRequest.m
//  Minnie
//
//  Created by 栋栋 施 on 2018/12/26.
//  Copyright © 2018年 minnieedu. All rights reserved.
//

#import "CorrectHomeworkDelCommentRequest.h"

@interface CorrectHomeworkDelCommentRequest()

@property(nonatomic,strong)NSArray<NSString *> * comments;

@end

@implementation CorrectHomeworkDelCommentRequest

- (instancetype)initWithDeleteHomeworkComments:(NSArray<NSString *> *)comment
{
    self = [super init];
    if (self != nil) {
        _comments = comment;
    }
    return self;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@/homework/deleteComments", ServerProjectName];
}

- (id)requestArgument {
    
    return @{@"comments":self.comments};
}

@end
