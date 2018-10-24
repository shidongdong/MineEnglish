//
//  NoticeMessageItem.m
//  X5
//
//  Created by yebw on 2017/9/19.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "NoticeMessageItem.h"

NSString * const NoticeMessageItemTypeText = @"text";
NSString * const NoticeMessageItemTypeImage = @"image";

@implementation NoticeMessageItem

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"type":@"type",
             @"text":@"text",
             @"imageWidth":@"imageWidth",
             @"imageHeight":@"imageHeight",
             @"imageUrl":@"imageUrl"
             };
}

@end
