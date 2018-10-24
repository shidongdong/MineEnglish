//
//  NoticeMessage.m
//  X5
//
//  Created by yebw on 2017/12/5.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "NoticeMessage.h"
#import "NoticeMessageItem.h"

@implementation NoticeMessage

- (NSString *)jsonStringForUpload {
    NSDictionary *dict = [self dictForUpload];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict
                                                   options:0
                                                     error:nil];
    
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (NSDictionary *)dictForUpload {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSMutableArray *itemDicts = [NSMutableArray array];
    
    
    NSMutableDictionary *noticeMessageDict = [NSMutableDictionary dictionary];
    if (self.messageId > 0) {
        noticeMessageDict[@"id"] = @(self.messageId);
    }
    
    noticeMessageDict[@"title"] = self.title;
    
    // Items部分
    noticeMessageDict[@"items"] = itemDicts;
    for (NoticeMessageItem *item in self.items) {
        NSMutableDictionary *itemDict = [NSMutableDictionary dictionary];
        
        if ([item.type isEqualToString:NoticeMessageItemTypeText]) {
            itemDict[@"type"] = NoticeMessageItemTypeText;
            itemDict[@"text"] = item.text;
        } else {
            itemDict[@"type"] = NoticeMessageItemTypeImage;
            itemDict[@"imageUrl"] = item.imageUrl;
            itemDict[@"imageWidth"] = @(item.imageWidth);
            itemDict[@"imageHeight"] = @(item.imageHeight);
        }
        
        if (itemDict.count > 0) {
            [itemDicts addObject:itemDict];
        }
    }
    
    dict[@"noticeMessage"] = noticeMessageDict;
    
    if (self.classIds.count > 0) {
        dict[@"classIds"] = self.classIds;
    }
    
    if (self.studentIds.count > 0) {
        dict[@"studentIds"] = self.studentIds;
    }
    
    if (self.time > 0) {
        dict[@"sendTime"] = @((long long)(self.time));
    }
    
    return dict;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"messageId":@"id",
             @"title":@"title",
             @"user":@"user",
             @"time":@"time",
             @"items":@"items"
             };
}

+ (NSValueTransformer *)userJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[User class]];
}

+ (NSValueTransformer *)itemsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[NoticeMessageItem class]];
}

@end



