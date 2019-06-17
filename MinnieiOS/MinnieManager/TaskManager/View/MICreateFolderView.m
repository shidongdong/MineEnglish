//
//  MICreateFolderView.m
//  MinnieManager
//
//  Created by songzhen on 2019/5/28.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import "MICreateFolderView.h"

@interface MICreateFolderView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@end

@implementation MICreateFolderView

- (void)awakeFromNib{
    
    [super awakeFromNib];
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 12;
    
    self.textField.layer.masksToBounds = YES;
    self.textField.layer.cornerRadius = 12;
    self.textField.layer.borderWidth = 0.5;
    self.textField.layer.borderColor = [UIColor separatorLineColor].CGColor;
    
    self.cancelBtn.layer.masksToBounds = YES;
    self.cancelBtn.layer.cornerRadius = 12;
    self.cancelBtn.layer.borderWidth = 0.5;
    self.cancelBtn.layer.borderColor = [UIColor mainColor].CGColor;
    
    self.sureBtn.layer.masksToBounds = YES;
    self.sureBtn.layer.cornerRadius = 12;
    self.sureBtn.layer.borderWidth = 0.5;
    self.sureBtn.layer.borderColor = [UIColor mainColor].CGColor;
}

- (IBAction)cancelAction:(id)sender {

    if (self.superview) {
        [self removeFromSuperview];
    }
}

- (IBAction)sureAction:(id)sender {
   
    NSString *name = _textField.text;
    if (name.length == 0) {
        name = @"未命名文件夹";
    }
    if (self.sureCallBack) {
        self.sureCallBack(name);
    }
    if (self.superview) {
        [self removeFromSuperview];
    }
}
- (IBAction)textFieldChangeedAction:(id)sender {
  
    NSString *name = [self.textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (name.length > 8) {
        [HUD showErrorWithMessage:@"昵称长度小于8个字符"];
        self.textField.text = [name substringToIndex:8];
    }
}

- (void)setTitleName:(NSString *)titleName{
    
    _titleName = titleName;
    self.titleLabel.text = _titleName;
}

- (void)setFileName:(NSString *)fileName{
    
    _fileName = fileName;
    self.textField.text = _fileName;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.textField resignFirstResponder];
}

@end
