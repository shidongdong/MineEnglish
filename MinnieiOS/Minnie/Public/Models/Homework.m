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
             @"examType":@"examType",
             @"otherItem":@"otherItem"
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

+ (NSValueTransformer *)otherItemJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[HomeworkItem class]];
}

+ (NSValueTransformer *)answerItemsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[HomeworkAnswerItem class]];
}

+ (NSValueTransformer *)fileInfosJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[HomeworkFileDto class]];
}


- (NSDictionary *)dictionaryForUpload {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    // 表示是更新的
    if (self.homeworkId > 0) {
        dict[@"id"] = @(self.homeworkId);
    }
    
    dict[@"title"] = self.title;
    dict[@"createTeacher"] = @{@"id":@(self.createTeacher.userId)};
    
    
    NSMutableArray *otherItems = [NSMutableArray array];
    for (HomeworkItem *item in self.otherItem) {
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
        }
        [otherItems addObject:itemDict];
    } dict[@"otherItem"] = otherItems;
    
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
            
            NSMutableArray *words = [NSMutableArray array];
            for (WordInfo *word in item.words) {
                NSMutableDictionary *wordDic = [NSMutableDictionary dictionary];
                wordDic[@"english"] = word.english;
                wordDic[@"chinese"] = word.chinese;
                [words addObject:wordDic];
            }
            itemDict[@"words"] = words;
            itemDict[@"bgmusicUrl"] = item.bgmusicUrl;
            itemDict[@"playTime"] = @(item.playTime);
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
    NSDictionary *parentFile;
    if (self.fileInfos.parentFile.parentId == 0) {
        parentFile = @{@"id":@(self.fileInfos.parentFile.fileId),
                       @"fileName":self.fileInfos.parentFile.fileName,
                       @"depth":@(self.fileInfos.parentFile.depth)
                                     };
    } else {
        
        parentFile = @{@"id":@(self.fileInfos.parentFile.fileId),
                       @"fileName":self.fileInfos.parentFile.fileName,
                       @"parentId":@(self.fileInfos.parentFile.parentId),
                       @"depth":@(self.fileInfos.parentFile.depth)
                                     };
    }
    
    NSDictionary *subFile = @{@"id":@(self.fileInfos.subFile.fileId),
                              @"fileName":self.fileInfos.subFile.fileName,
                              @"parentId":@(self.fileInfos.subFile.parentId),
                              @"depth":@(self.fileInfos.subFile.depth)
                                 };
   
    dict[@"fileInfos"] = @{@"parentFile":parentFile,@"subFile":subFile};
    
    dict[@"tags"] = self.tags;
    dict[@"style"] = @(self.style);
    dict[@"level"] = @(self.level);
    dict[@"category"] = @(self.category);
    dict[@"limitTimes"] = @(self.limitTimes);
    dict[@"formTag"] = self.formTag;
    dict[@"teremark"] = self.teremark;
    dict[@"typeName"] = self.typeName;
    dict[@"examType"] = @(self.examType);
    
    return dict;
}

@end

