//
//  NoticeMessage.h
//  X5
//
//  Created by yebw on 2017/12/5.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "User.h"
#import "NoticeMessageItem.h"

@interface NoticeMessage : MTLModel<MTLJSONSerializing>

@property (nonatomic, assign) NSUInteger messageId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) User *user;
@property (nonatomic, assign) long long time;
@property (nonatomic, assign) BOOL read; // 是否读过
@property (nonatomic, strong) NSArray<NoticeMessageItem *> *items;

@property (nonatomic, strong) NSArray *classIds;
@property (nonatomic, strong) NSArray *studentIds;

// UI使用
@property (nonatomic, assign) CGFloat cellHeight;

- (NSString *)jsonStringForUpload;

- (NSDictionary *)dictForUpload;

@end
