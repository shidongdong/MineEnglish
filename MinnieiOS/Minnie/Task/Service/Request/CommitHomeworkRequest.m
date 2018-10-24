//
//  CommitHomeworkRequest.m
//  X5Teacher
//
//  Created by yebw on 2018/4/7.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "CommitHomeworkRequest.h"

@interface CommitHomeworkRequest()

@property (nonatomic, assign) NSInteger homeworkSessionId;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSString *videoUrl;

@end

@implementation CommitHomeworkRequest

- (instancetype)initWithImageUrl:(NSString *)imageUrl
                        videoUrl:(NSString *)videoUrl
               homeworkSessionId:(NSInteger)homeworkSessionId {
    self = [super init];
    if (self != nil) {
        _homeworkSessionId = homeworkSessionId;
        _imageUrl = imageUrl;
        _videoUrl = videoUrl;
    }
    
    return self;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@/homeworkTask/commitHomework", ServerProjectName];
}

- (id)requestArgument {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"id"] = @(self.homeworkSessionId);
    
    if (self.imageUrl.length > 0) {
        dict[@"imageUrl"] = self.imageUrl;
    }

    if (self.videoUrl.length > 0) {
        dict[@"videoUrl"] = self.videoUrl;
    }

    return dict;
}

@end
