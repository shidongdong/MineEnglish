//
//  EmojiInputView.h
//  X5
//
//  Created by yebw on 2017/12/10.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EmojiInputViewDelegate<NSObject>

- (void)emojiDidSelect:(NSString *)emojiText;

@end

extern CGFloat const EmojiInputViewHeight;

@interface EmojiInputView : UIView

@property (nonatomic, weak) IBOutlet id<EmojiInputViewDelegate> delegate;

@end
