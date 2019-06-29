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


+ (NSValueTransformer *)itemsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[HomeworkItem class]];
}

+ (NSValueTransformer *)coverItemsJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[HomeworkItem class]];
}

//+ (NSValueTransformer *)studentIdsJSONTransformer {
//    return [MTLJSONAdapter arrayTransformerWithModelClass:[NSString class]];
//}
//+ (NSValueTransformer *)classIdsJSONTransformer {
//    return [MTLJSONAdapter arrayTransformerWithModelClass:[NSString class]];
//}
//
//+ (NSValueTransformer *)studentNamesJSONTransformer {
//    return [MTLJSONAdapter arrayTransformerWithModelClass:[NSString class]];
//}
//+ (NSValueTransformer *)classNamesJSONTransformer {
//    return [MTLJSONAdapter arrayTransformerWithModelClass:[NSString class]];
//}

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

- (ActivityInfo *)newActInfo{
    
    ActivityInfo *tempActInfo = [[ActivityInfo alloc] init];
    tempActInfo.activityId = self.activityId;
    tempActInfo.title = self.title;
    tempActInfo.items = (NSArray<HomeworkItem*> *)[self newItemsWithArray:self.items];
    tempActInfo.createTime = self.createTime;
    tempActInfo.submitNum = self.submitNum;
    tempActInfo.limitTimes = self.limitTimes;
    tempActInfo.startTime = self.startTime;
    tempActInfo.endTime = self.endTime;
    tempActInfo.actCoverUrl = self.actCoverUrl;
    tempActInfo.studentIds = [self newStrArray:self.studentIds];
    tempActInfo.classIds = [self newStrArray:self.classIds];
    tempActInfo.studentNames = [self newStrArray:self.studentNames];
    tempActInfo.classNames = [self newStrArray:self.classNames];
    tempActInfo.status = self.status;
    tempActInfo.cellHeight = self.cellHeight;
    return tempActInfo;
}

- (NSArray *)newStrArray:(NSArray *)array{
    
    NSMutableArray *tempStrs = [NSMutableArray array];
    for (NSString * str in array) {
        NSString *tempStr = [NSString stringWithString:str];
        [tempStrs addObject:tempStr];
    }
    return tempStrs;
}

- (NSArray *)newItemsWithArray:(NSArray *)items{
    
    NSMutableArray *tempItems = [NSMutableArray array];
    for (HomeworkItem *item in items) {
        
        HomeworkItem *tempItem = [[HomeworkItem alloc] init];
        tempItem.type = item.type;
        tempItem.text = item.text;
        tempItem.audioUrl = item.audioUrl;
        tempItem.audioCoverUrl = item.audioCoverUrl;
        tempItem.videoUrl = item.videoUrl;
        tempItem.videoCoverUrl = item.videoCoverUrl;
        tempItem.imageUrl = item.imageUrl;
        tempItem.imageWidth = item.imageWidth;
        tempItem.imageHeight = item.imageHeight;
        tempItem.itemTime = item.itemTime;
        
        NSMutableArray *tempWords = [NSMutableArray array];
        for (WordInfo *word in item.words) {
            WordInfo *tempWord = [[WordInfo alloc] init];
            tempWord.english = word.english;
            tempWord.chinese = word.chinese;
            [tempWords addObject:tempWord];
        }
        tempItem.words = (NSArray<WordInfo>*)tempWords;
        
        tempItem.bgmusicUrl = item.bgmusicUrl;
        tempItem.playtime = item.playtime;
        [tempItems addObject:tempItem];
    }
    return tempItems;
}
@end

@implementation ActivityRankInfo

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{@"actTimes":@"actTimes",
             @"actUrl":@"actUrl",
             @"avatar":@"avatar",
             @"userId":@"userId",
             @"nickName":@"nickName",
             @"isOk":@"isOk",
             @"actId":@"actId"
             };
}

@end


@implementation ActivityRankListInfo

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{@"okRank":@"okRank",
             @"checkRank":@"checkRank"};
}

+ (NSValueTransformer *)okRankJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[ActivityRankInfo class]];
}

+ (NSValueTransformer *)checkRankJSONTransformer {
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
