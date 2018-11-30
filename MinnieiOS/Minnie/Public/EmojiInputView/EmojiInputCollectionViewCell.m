//
//  EmojiInputCollectionViewCell.m
//  X5Teacher
//
//  Created by yebw on 2018/3/4.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "EmojiInputCollectionViewCell.h"

NSString * const EmojiInputCollectionViewCellId = @"EmojiInputCollectionViewCellId";

@interface EmojiInputCollectionViewCell()

@property (nonatomic, strong) NSArray *emojis;
@property (nonatomic, copy) EmojiInputCollectionViewCellPressCallback callback;

@end

@implementation EmojiInputCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setupWithEmojis:(NSArray *)emojis
               callback:(EmojiInputCollectionViewCellPressCallback)callback {
    self.emojis = emojis;
    self.callback = callback;
    
    for (NSInteger index=0; index<MIN(emojis.count, 32); index++) {
        UIButton *btn = (UIButton *)[self viewWithTag:index+10];
        UILabel * textLabel = (UILabel *)[self viewWithTag:index+20];
        textLabel.text = emojis[index];
        [btn setEnabled:YES];
    }
    
    if (emojis.count < 32) {
        for (NSInteger index=emojis.count; index<32; index++) {
            UIButton *btn = (UIButton *)[self viewWithTag:index+10];
            UILabel *textLabel = (UILabel *)[self viewWithTag:index+20];
            textLabel.text = @"";
            [btn setEnabled:NO];
        }
    }
}

- (IBAction)emojiButtonPressed:(id)sender {
    if (self.callback != nil) {
        UIButton *btn = (UIButton *)sender;
        NSInteger index = btn.tag - 10;
        NSString *text = self.emojis[index];

        self.callback(text);
    }
}

@end

