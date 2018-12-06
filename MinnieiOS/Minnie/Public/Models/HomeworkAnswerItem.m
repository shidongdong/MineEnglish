//
//  HomeworkAnswerItem.m
//  X5Teacher
//
//  Created by yebw on 2018/1/28.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "HomeworkAnswerItem.h"

NSString * const HomeworkAnswerItemTypeVideo = @"video";
NSString * const HomeworkAnswerItemTypeImage = @"image";

@interface HomeworkAnswerItem()
@end

@implementation HomeworkAnswerItem

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"type":@"type",
             @"videoUrl":@"videoUrl",
             @"videoCoverUrl":@"videoCoverUrl",
             @"audioUrl":@"audioUrl",
             @"audioCoverUrl":@"audioCoverUrl",
             @"imageUrl":@"imageUrl",
             @"imageWidth":@"imageWidth",
             @"imageHeight":@"imageHeight",
             @"itemTime":@"itemTime"
             };
}

@end

