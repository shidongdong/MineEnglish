//
//  CorrectHomeworkAddCommentViewController.m
//  Minnie
//
//  Created by 栋栋 施 on 2018/12/25.
//  Copyright © 2018年 minnieedu. All rights reserved.
//

#import "CorrectHomeworkAddCommentViewController.h"
#import "UITextView+Placeholder.h"

@interface CorrectHomeworkAddCommentViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *mTextView;

@end

@implementation CorrectHomeworkAddCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mTextView.placeholder = @"输入常用评语，最多20字";
    self.mTextView.placeholderColor = [UIColor colorWithHex:0xCCCCCC];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)finishPressed:(id)sender {
    
    [self.mTextView resignFirstResponder];
    
    //添加常用评语的请求
    
    if (_delegate && [_delegate respondsToSelector:@selector(addComment:)])
    {
        [_delegate addComment:self.mTextView.text];
    }
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView.text.length > 19 && text.length > 0)
    {
        return NO;
    }
    if ([text isEqualToString:@"\n"]) {
        [self.mTextView resignFirstResponder];
        return NO;
    }
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
