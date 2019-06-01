//
//  ActivityInfo.m
//  MinnieManager
//
//  Created by songzhen on 2019/6/1.
//  Copyright © 2019 minnieedu. All rights reserved.
//  活动内容

#import "ActivityInfo.h"

@implementation ActivityInfo

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{@"activityId":@"id",
             @"title":@"title",
             @"items":@"items",
             @"createTime":@"createTime",
             @"submitNum":@"submitNum",
             @"limitTimes":@"limitTimes",
             @"startTime":@"startTime",
             @"endTime":@"endTime",
             @"actCoverUrl":@"actCoverUrl",
             @"studentIds":@"studentIds",
             @"classIds":@"classIds",
             @"studentNames":@"studentNames",
             @"classNames":@"classNames",
             @"status":@"status"
             };
}

- (NSDictionary *)dictionaryForUpload {
   
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    // 表示是更新的
    if (self.activityId > 0) {
        dict[@"id"] = @(self.activityId);
    }
    
    dict[@"title"] = self.title;
    
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
    dict[@"createTime"] = self.createTime;
    dict[@"submitNum"] = @(self.submitNum);
    dict[@"limitTimes"] = @(self.limitTimes);
    dict[@"startTime"] = self.startTime;
    dict[@"endTime"] = self.endTime;
    dict[@"actCoverUrl"] = self.actCoverUrl;
    dict[@"studentIds"] = self.studentIds;
    dict[@"classIds"] = self.classIds;
    dict[@"studentNames"] = self.studentNames;
    dict[@"classNames"] = self.classNames;
    dict[@"status"] = @(self.status);
    return dict;
}

@end

@implementation ActivityRankInfo

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{@"actTimes":@"actTimes",
             @"actUrl":@"actUrl",
             @"avatar":@"avatar",
             @"userId":@"userId",
             @"nickName":@"nickName",
             @"isOk":@"isOk"
             };
}

@end


@implementation ActivityRankListInfo

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{@"okRank":@"okRank",
             @"checkRank":@"checkRank"
             };
}

+ (NSValueTransformer *)fileInfoJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[ActivityRankInfo class]];
}

+ (NSValueTransformer *)subFileListJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[ActivityRankInfo class]];
}

@end

@implementation ActLogsInfo

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{@"logId":@"id",
             @"actTimes":@"actTimes",
             @"actUrl":@"actUrl",
             @"actId":@"actId",
             @"isOk":@"isOk",
             @"upTime":@"upTime"
             };
}

@end
