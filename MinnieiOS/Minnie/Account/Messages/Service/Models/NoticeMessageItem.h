//
//  NoticeMessageItem.h
//  X5
//
//  Created by yebw on 2017/9/19.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import <Mantle/Mantle.h>
#import <UIKit/UIKit.h>
#import "ImageTextAttachment.h"

extern NSString * const NoticeMessageItemTypeText;
extern NSString * const NoticeMessageItemTypeImage;

@interface NoticeMessageItem : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy) NSString *type; // "image" or "text"
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, assign) CGFloat imageWidth;
@property (nonatomic, assign) CGFloat imageHeight;

// UI使用
@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, strong) ImageTextAttachment *attachment;

@end
