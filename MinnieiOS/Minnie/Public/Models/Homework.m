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
             @"tags":@"tags",
             @"style":@"style",
             @"level":@"level",
             @"category":@"category",
             @"limitTimes":@"limitTimes",
             @"formTag":@"formTag",
             @"teremark":@"teremark",
             @"fileInfos":@"fileInfos",
             @"typeName":@"typeName",
             @"examType":@"examType"
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

+ (NSValueTransformer *)fileInfosJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[HomeworkFileDto class]];
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
            itemDict[@"audioCoverUrl"] = item.audioCoverUrl;
        } else if ([item.type isEqualToString:HomeworkItemTypeVideo]) {
            itemDict[@"videoUrl"] = item.videoUrl;
            itemDict[@"videoCoverUrl"] = item.videoCoverUrl;
        } else if ([item.type isEqualToString:HomeworkItemTypeImage]) {
            itemDict[@"imageUrl"] = item.imageUrl;
            itemDict[@"imageWidth"] = @(item.imageWidth);
            itemDict[@"imageHeight"] = @(item.imageHeight);
        } else if ([item.type isEqualToString:HomeworkItemTypeWord]) {
            
            itemDict[@"bgmusicUrl"] = item.bgmusicUrl;
            itemDict[@"palytime"] = @(item.palytime);
            
            NSMutableArray *words = [NSMutableArray array];
            dict[@"words"] = words;
            for (WordInfo *word in item.words) {
                NSMutableDictionary *wordDic = [NSMutableDictionary dictionary];
                wordDic[@"english"] = word.english;
                wordDic[@"chinese"] = @(word.chinese);
            }
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
        }else if ([item.type isEqualToString:HomeworkItemTypeAudio]) {
            itemDict[@"audioUrl"] = item.audioUrl;
            itemDict[@"audioCoverUrl"] = item.audioCoverUrl;
        }else if ([item.type isEqualToString:HomeworkItemTypeImage]) {
            itemDict[@"imageUrl"] = item.imageUrl;
            itemDict[@"imageWidth"] = @(item.imageWidth);
            itemDict[@"imageHeight"] = @(item.imageHeight);
        }
        
        [answserItems addObject:itemDict];
    }
    
    dict[@"tags"] = self.tags;
    dict[@"style"] = @(self.style);
    dict[@"level"] = @(self.level);
    dict[@"category"] = @(self.category);
    dict[@"limitTimes"] = @(self.limitTimes);
    dict[@"formTag"] = self.formTag;
    dict[@"teremark"] = self.teremark;
    dict[@"fileInfos"] = self.fileInfos;
    dict[@"typeName"] = self.typeName;
    dict[@"examType"] = @(self.examType);
    return dict;
}

@end

