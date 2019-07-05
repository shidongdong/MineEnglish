//
//  MICreateFolderView.m
//  MinnieManager
//
//  Created by songzhen on 2019/5/28.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import "MICreateFolderView.h"

@interface MICreateFolderView ()

@property (nonatomic, copy) NSString *titleName;

@property (nonatomic, copy) NSString *fileName;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UIButton *knownBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgTopConstraint;


@property (nonatomic, assign) BOOL isDelete;

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
    
    self.sureBtn.layer.masksToBounds = YES;
    self.sureBtn.layer.cornerRadius = 12;
    
    self.knownBtn.layer.masksToBounds = YES;
    self.knownBtn.layer.cornerRadius = 12;
    [self  addObserverOfKeyBoardChanged];
}

- (void)setupCreateFile:(NSString *)title fileName:(NSString *_Nullable)fileName{
    
    self.isDelete = NO;
    self.titleName = title;
    self.fileName = fileName;
    
    self.sureBtn.hidden = NO;
    self.cancelBtn.hidden = NO;
    self.knownBtn.hidden = YES;
    self.textField.hidden = NO;
    self.detailLabel.hidden = YES;
    self.sureBtn.backgroundColor = [UIColor mainColor];
    [self.sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    
    self.cancelBtn.layer.borderWidth = 0.5;
    self.cancelBtn.layer.borderColor = [UIColor mainColor].CGColor;
    [self.cancelBtn setTitleColor:[UIColor mainColor] forState:UIControlStateNormal];
}

- (void)setupDeleteFile:(NSString *)fileName{
   
    self.isDelete = YES;
    self.titleName = @"删除文件夹";
    self.detailLabel.text = fileName;
    self.sureBtn.hidden = NO;
    self.cancelBtn.hidden = NO;
    self.knownBtn.hidden = YES;
    self.textField.hidden = YES;
    self.detailLabel.hidden = NO;
    self.sureBtn.backgroundColor = [UIColor redColor];
    [self.sureBtn setTitle:@"删除" forState:UIControlStateNormal];
    
    self.cancelBtn.layer.borderWidth = 0.5;
    self.cancelBtn.layer.borderColor = [UIColor redColor].CGColor;
    [self.cancelBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
}

- (void)setupDeleteError:(NSString *)text{
    
    self.isDelete = NO;
    self.titleName = @"无法删除";
    self.detailLabel.text = text;
    self.sureBtn.hidden = YES;
    self.cancelBtn.hidden = YES;
    self.knownBtn.hidden = NO;
    self.textField.hidden = YES;
    self.detailLabel.hidden = NO;
    
}
- (IBAction)cancelAction:(id)sender {

    if (self.superview) {
        [self removeFromSuperview];
    }
}

- (IBAction)sureAction:(id)sender {
  
    if (_isDelete) {
     
        if (self.sureCallBack) {
            self.sureCallBack(self.detailLabel.text);
        }
    } else {
       
        NSString *name = _textField.text;
        if (name.length == 0) {
            [HUD showErrorWithMessage:@"文件名不能为空"];
            return;
        }
        if (self.sureCallBack) {
            self.sureCallBack(name);
        }
    }
    if (self.superview) {
        [self removeFromSuperview];
    }
}

- (IBAction)knownAction:(id)sender {

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


- (void)addObserverOfKeyBoardChanged {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification{
    
    //取出键盘动画的时间
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];

    WeakifySelf;
    [UIView animateWithDuration:duration animations:^{
        
        weakSelf.bgTopConstraint.constant = (ScreenHeight - 200)/2.0 - keyboardFrame.size.height/3.0;
    }];
}
#pragma mark --键盘收回
- (void)keyboardDidHide:(NSNotification *)notification{
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    WeakifySelf;
    [UIView animateWithDuration:duration animations:^{
        
        weakSelf.bgTopConstraint.constant = (ScreenHeight - 200)/2.0 ;
    }];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
