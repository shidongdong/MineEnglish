//
//  MICreateWordView.m
//  MinnieManager
//
//  Created by songzhen on 2019/6/6.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import "MICreateWordView.h"

@interface MICreateWordView ()
@property (weak, nonatomic) IBOutlet UITextField *English;
@property (weak, nonatomic) IBOutlet UITextField *chinese;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (strong, nonatomic) WordInfo *word;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@end

@implementation MICreateWordView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    self.sureBtn.layer.borderWidth = 0.5;
    self.sureBtn.layer.borderColor = [UIColor mainColor].CGColor;
    
    self.cancelBtn.layer.borderWidth = 0.5;
    self.cancelBtn.layer.borderColor = [UIColor mainColor].CGColor;
    
}

- (IBAction)cancelAction:(id)sender {
    if (self.superview) {
        [self removeFromSuperview];
    }
}
- (IBAction)sureAction:(id)sender {
 
    [self.English resignFirstResponder];
    [self.chinese resignFirstResponder];
    if (self.word.english.length == 0) {
        [HUD showErrorWithMessage:@"请输入英文单词"];
        return;
    }
    if (self.word.chinese.length == 0) {
        [HUD showErrorWithMessage:@"请输入中文意思"];
        return;
    }
    if (self.callback) {
        self.callback(self.word);
    }
    if (self.superview) {
        [self removeFromSuperview];
    }
}

- (IBAction)textFieldChanged:(UITextField *)sender {
    self.word.english = sender.text;
}
- (IBAction)chineseTextFieldChanged:(UITextField *)sender {
       self.word.chinese = sender.text;
}
- (IBAction)englishAction:(id)sender {
    UITextField *textField = sender;
    self.word.english = textField.text;
}

- (IBAction)chineseAction:(id)sender {
    UITextField *textField = sender;
    self.word.chinese = textField.text;
}

- (WordInfo *)word{
    
    if (!_word) {
        _word = [[WordInfo alloc] init];
    }
    return _word;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.English resignFirstResponder];
    [self.chinese resignFirstResponder];

}

@end
