//
//  DeleteFormTagsRequest.m
//  Minnie
//
//  Created by 栋栋 施 on 2018/11/19.
//  Copyright © 2018年 minnieedu. All rights reserved.
//

#import "DeleteFormTagsRequest.h"

@interface DeleteFormTagsRequest()

@property (nonatomic, copy) NSArray<NSString *> *homeworkFromTags;

@end

@implementation DeleteFormTagsRequest

- (instancetype)initWithFormTags:(NSArray<NSString *> *)formtags {
    self = [super init];
    if (self != nil) {
        _homeworkFromTags = formtags;
    }
    
    return self;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@/homework/deleteFormtags", ServerProjectName];
}

- (id)requestArgument {
    return @{@"tags": self.homeworkFromTags};
}

@end
