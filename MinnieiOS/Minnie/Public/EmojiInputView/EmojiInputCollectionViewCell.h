//
//  EmojiInputCollectionViewCell.h
//  X5Teacher
//
//  Created by yebw on 2018/3/4.
//  Copyright © 2018年 netease. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const EmojiInputCollectionViewCellId;

typedef void(^EmojiInputCollectionViewCellPressCallback)(NSString *);

@interface EmojiInputCollectionViewCell : UICollectionViewCell

- (void)setupWithEmojis:(NSArray *)emojis
               callback:(EmojiInputCollectionViewCellPressCallback)callback;

@end

