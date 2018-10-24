//
//  HomeworkItem.m
//  X5Teacher
//
//  Created by yebw on 2018/1/28.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "HomeworkItem.h"

NSString * const HomeworkItemTypeText = @"text";
NSString * const HomeworkItemTypeVideo = @"video";
NSString * const HomeworkItemTypeAudio = @"audio";
NSString * const HomeworkItemTypeImage = @"image";

@interface HomeworkItem()
@end

@implementation HomeworkItem

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"type":@"type",
             @"text":@"text",
             @"audioUrl":@"audioUrl",
             @"audioDuration":@"audioDuration",
             @"videoUrl":@"videoUrl",
             @"videoCoverUrl":@"videoCoverUrl",
             @"imageUrl":@"imageUrl",
             @"imageWidth":@"imageWidth",
             @"imageHeight":@"imageHeight"
             };
}

@end

