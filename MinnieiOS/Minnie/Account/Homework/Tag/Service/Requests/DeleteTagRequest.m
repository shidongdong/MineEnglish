//
//  DeleteTagRequest.m
//  X5Teacher
//
//  Created by yebw on 2017/12/20.
//  Copyright © 2017年 netease. All rights reserved.
//

#import "DeleteTagRequest.h"

@interface DeleteTagRequest()

@property (nonatomic, copy) NSArray<NSString *> *homeworkTags;

@end

@implementation DeleteTagRequest

- (instancetype)initWithTags:(NSArray<NSString *> *)tags {
    self = [super init];
    if (self != nil) {
        _homeworkTags = tags;
    }
    
    return self;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@/homework/deleteTags", ServerProjectName];
}

- (id)requestArgument {
    return @{@"tags": self.homeworkTags};
}

@end

