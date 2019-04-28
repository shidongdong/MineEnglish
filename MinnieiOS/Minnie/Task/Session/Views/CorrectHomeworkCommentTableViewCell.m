//
//  CorrectHomeworkCommentTableViewCell.m
//  Minnie
//
//  Created by 栋栋 施 on 2018/12/24.
//  Copyright © 2018年 minnieedu. All rights reserved.
//

#import "CorrectHomeworkCommentTableViewCell.h"

NSString * const CorrectHomeworkCommentTableViewCellId = @"CorrectHomeworkCommentTableViewCellId";
CGFloat const CorrectHomeworkCommentTableViewCellHeight = 120.f;

@interface CorrectHomeworkCommentTableViewCell()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *mTextView;

@end

@implementation CorrectHomeworkCommentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.mTextView.delegate = self;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupCommentInfo:(NSString *)info
{
    self.mTextView.text = info;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView.text.length > 39 && text.length > 0)
    {
        return NO;
    }
    if ([text isEqualToString:@"\n"]) {
        [self.mTextView resignFirstResponder];
        return NO;
    }
    if (self.commentCallback)
    {
        self.commentCallback(textView.text);
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (self.commentCallback)
    {
        self.commentCallback(textView.text);
    }
}


@end
