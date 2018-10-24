//
//  Homework.m
//  X5
//
//  Created by yebw on 2017/9/17.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "Homework.h"

@implementation Homework

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"homeworkId":@"id",
             @"createTeacher":@"createTeacher",
             @"title":@"title",
             @"items":@"items",
             @"answerItems":@"answerItems",
             @"createTime":@"createTime",
             @"tags":@"tags"
             };
}

+ (NSValueTransformer *)createTeacherJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[Teacher class]];
}

+ (NSValueTransformer *)correctTeacherJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[Teacher class]];
}

+ (NSValueTransformer *)itemsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[HomeworkItem class]];
}

+ (NSValueTransformer *)answerItemsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[HomeworkAnswerItem class]];
}

- (NSDictionary *)dictionaryForUpload {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    // 表示是更新的
    if (self.homeworkId > 0) {
        dict[@"id"] = @(self.homeworkId);
    }
    
    dict[@"title"] = self.title;
    
    dict[@"createTeacher"] = @{@"id":@(self.createTeacher.userId)};
    
    NSMutableArray *items = [NSMutableArray array];
    dict[@"items"] = items;
    for (HomeworkItem *item in self.items) {
        NSMutableDictionary *itemDict = [NSMutableDictionary dictionary];
        itemDict[@"type"] = item.type;
        if ([item.type isEqualToString:HomeworkItemTypeText]) {
            itemDict[@"text"] = item.text;
        } else if ([item.type isEqualToString:HomeworkItemTypeAudio]) {
            itemDict[@"audioUrl"] = item.audioUrl;
            itemDict[@"audioDuration"] = @(item.audioDuration);
        } else if ([item.type isEqualToString:HomeworkItemTypeVideo]) {
            itemDict[@"videoUrl"] = item.videoUrl;
            itemDict[@"videoCoverUrl"] = item.videoCoverUrl;
        } else if ([item.type isEqualToString:HomeworkItemTypeImage]) {
            itemDict[@"imageUrl"] = item.imageUrl;
            itemDict[@"imageWidth"] = @(item.imageWidth);
            itemDict[@"imageHeight"] = @(item.imageHeight);
        }
        
        [items addObject:itemDict];
    }
    
    NSMutableArray *answserItems = [NSMutableArray array];
    dict[@"answerItems"] = answserItems;
    for (HomeworkAnswerItem *item in self.answerItems) {
        NSMutableDictionary *itemDict = [NSMutableDictionary dictionary];
        itemDict[@"type"] = item.type;
        if ([item.type isEqualToString:HomeworkItemTypeVideo]) {
            itemDict[@"videoUrl"] = item.videoUrl;
            itemDict[@"videoCoverUrl"] = item.videoCoverUrl;
        } else if ([item.type isEqualToString:HomeworkItemTypeImage]) {
            itemDict[@"imageUrl"] = item.imageUrl;
            itemDict[@"imageWidth"] = @(item.imageWidth);
            itemDict[@"imageHeight"] = @(item.imageHeight);
        }
        
        [answserItems addObject:itemDict];
    }
    
    dict[@"tags"] = self.tags;
    
    return dict;
}

@end

