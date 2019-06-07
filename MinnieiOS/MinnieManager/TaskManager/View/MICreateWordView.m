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
- (IBAction)englistTextfieldChanged:(id)sender {
    
    self.word.english = self.English.text;
}

- (IBAction)chineseTextfieldChanged:(id)sender {
    
    self.word.chinese = self.chinese.text;
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
