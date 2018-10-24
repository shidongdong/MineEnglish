//
//  CorrectHomeworkRequest.m
//  X5Teacher
//
//  Created by yebw on 2018/4/6.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "CorrectHomeworkRequest.h"

@interface CorrectHomeworkRequest()

@property (nonatomic, assign) NSInteger sessionId;
@property (nonatomic, assign) NSInteger score;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) NSInteger isRedo;
@property (nonatomic, assign) NSInteger isCircle;
@end

@implementation CorrectHomeworkRequest

- (instancetype)initWithScore:(NSInteger)score
                         text:(NSString *)text
                      canRedo:(NSInteger)bRedo
                   sendCircle:(NSInteger)bSend
            homeworkSessionId:(NSInteger)homeworkSessionId {
    self = [super init];
    if (self != nil) {
        _score = score;
        _text = text;
        _sessionId = homeworkSessionId;
        _isRedo = bRedo;
        _isCircle = bSend;
    }
    
    return self;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@/homeworkTask/correctHomework", ServerProjectName];
}

- (id)requestArgument {
    return @{@"id":@(self.sessionId),
             @"score":@(self.score),
             @"content":self.text,
             @"isRedo":@(self.isRedo),
             @"isCircle":@(self.isCircle),
             };
}

@end


