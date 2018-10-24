//
//  HomeworkTitleTableViewCell.m
//  X5Teacher
//
//  Created by yebw on 2018/1/24.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "HomeworkTitleTableViewCell.h"
#import "UIColor+HEX.h"

NSString * const HomeworkTitleTableViewCellId = @"HomeworkTitleTableViewCellId";

@interface HomeworkTitleTableViewCell()

@property (nonatomic, weak) IBOutlet UIImageView *bgImageView;
@property (nonatomic, weak) IBOutlet UITextView *homeworkTextView;

@property (nonatomic, assign) CGFloat cellHeight;

@end

@implementation HomeworkTitleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.bgImageView.layer.borderWidth = 0.5f;
    self.bgImageView.layer.borderColor = [UIColor colorWithHex:0x0098FE].CGColor;
    self.bgImageView.layer.cornerRadius = 6.f;
    self.bgImageView.layer.masksToBounds = YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    UITextRange *selectedRange = [textView markedTextRange];
    UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
    if (position) {
        return;
    }
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGSize size = [textView sizeThatFits:CGSizeMake(screenWidth-36.f, MAXFLOAT)];
    CGFloat cellHeight = size.height + 51.f;
    
    if (self.cellHeight != cellHeight) {
        self.cellHeight = cellHeight;
        
        if (self.callback != nil) {
            self.callback(textView.text, YES);
        }
    } else {
        if (self.callback != nil) {
            self.callback(textView.text, NO);
        }
    }
}

- (void)setupWithText:(NSString *)text {
    self.homeworkTextView.text = text;
}

- (void)ajustTextView {
    [self.homeworkTextView scrollRangeToVisible:NSMakeRange(0, 1)];
}

+ (CGFloat)cellHeightWithText:(NSString *)text {
    static UITextView *textView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        textView = [[UITextView alloc] init];
        textView.font = [UIFont systemFontOfSize:14.f];
    });
    
    textView.text = text;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGSize size = [textView sizeThatFits:CGSizeMake(screenWidth-36.f, MAXFLOAT)];
    
    return size.height + 51.f;;
}

@end
