//
//  EditStudentMarkView.m
//  MinnieStudent
//
//  Created by songzhen on 2019/5/7.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import "StudentAwardService.h"
#import "EditStudentMarkView.h"

@interface EditStudentMarkView ()
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@property (weak, nonatomic) IBOutlet UIButton *markBtn0;
@property (weak, nonatomic) IBOutlet UIButton *markBtn1;
@property (weak, nonatomic) IBOutlet UIButton *markBtn2;
@property (weak, nonatomic) IBOutlet UIButton *markBtn3;

@property (weak, nonatomic) IBOutlet UIImageView *selectImgV0;
@property (weak, nonatomic) IBOutlet UIImageView *selectImgV1;
@property (weak, nonatomic) IBOutlet UIImageView *selectImgV2;
@property (weak, nonatomic) IBOutlet UIImageView *selectImgV3;

@end

@implementation EditStudentMarkView

- (void)awakeFromNib{
    
    [super awakeFromNib];
    
    self.bgView.layer.cornerRadius = 20.0;
    self.bgView.layer.masksToBounds = YES;
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.35];
    
    self.cancelBtn.layer.cornerRadius = 10.0;
    self.cancelBtn.layer.masksToBounds = YES;
    self.cancelBtn.layer.borderWidth = 1.0;
    self.cancelBtn.layer.borderColor = [UIColor colorWithHex:0x0098FE].CGColor;
    
    self.sureBtn.layer.cornerRadius = 10.0;
    self.sureBtn.layer.masksToBounds = YES;
    
    
    self.markBtn0.layer.cornerRadius = 10.0;
    self.markBtn0.layer.masksToBounds = YES;
    self.markBtn0.layer.borderWidth = 1.0;
    self.markBtn0.layer.borderColor = [UIColor colorWithHex:0xDDDDDD].CGColor;
    
    self.markBtn1.layer.cornerRadius = 10.0;
    self.markBtn1.layer.masksToBounds = YES;
    self.markBtn1.layer.borderWidth = 1.0;
    self.markBtn1.layer.borderColor = [UIColor colorWithHex:0xDDDDDD].CGColor;
    
    self.markBtn2.layer.cornerRadius = 10.0;
    self.markBtn2.layer.masksToBounds = YES;
    self.markBtn2.layer.borderWidth = 1.0;
    self.markBtn2.layer.borderColor = [UIColor colorWithHex:0xDDDDDD].CGColor;
    
    self.markBtn3.layer.cornerRadius = 10.0;
    self.markBtn3.layer.masksToBounds = YES;
    self.markBtn3.layer.borderWidth = 1.0;
    self.markBtn3.layer.borderColor = [UIColor colorWithHex:0xDDDDDD].CGColor;
}
- (IBAction)cancelBtnAction:(id)sender {
    
    if (self.superview) {
      
        [self removeFromSuperview];
    }
}
- (IBAction)sureBtnAction:(id)sender {
    
    WeakifySelf;
    [StudentAwardService requestStudentLabelWithStudentId:self.userId studentLabel:self.stuLabel callback:^(Result *result, NSError *error) {

        if (error != nil) {
            [HUD showErrorWithMessage:@"编辑标注失败"];
            if (weakSelf.superview) {
                
                [weakSelf removeFromSuperview];
            }
            return ;
        }
        if (weakSelf.callback) {
            
            weakSelf.callback();
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationKeyOfStudentMarkChange object:nil];
        if (weakSelf.superview) {
            
            [weakSelf removeFromSuperview];
        }
    }];
}
- (IBAction)selectAction:(id)sender {
    
    UIButton *btn = sender;
    NSInteger label = btn.tag - 5000;
    self.stuLabel = label;
}


- (void)setStuLabel:(NSInteger)stuLabel{
    
    _stuLabel = stuLabel;
    switch (_stuLabel) {
        case 0:
            self.selectImgV0.image = [UIImage imageNamed:@"icon_choice"];
            self.selectImgV1.image = [UIImage imageNamed:@" "];
            self.selectImgV2.image = [UIImage imageNamed:@" "];
            self.selectImgV3.image = [UIImage imageNamed:@" "];
            break;
        case 1:
            self.selectImgV0.image = [UIImage imageNamed:@" "];
            self.selectImgV1.image = [UIImage imageNamed:@"icon_choice"];
            self.selectImgV2.image = [UIImage imageNamed:@" "];
            self.selectImgV3.image = [UIImage imageNamed:@" "];
            break;
        case 2:
            self.selectImgV0.image = [UIImage imageNamed:@" "];
            self.selectImgV1.image = [UIImage imageNamed:@" "];
            self.selectImgV2.image = [UIImage imageNamed:@"icon_choice"];
            self.selectImgV3.image = [UIImage imageNamed:@" "];
            break;
        case 3:
            self.selectImgV0.image = [UIImage imageNamed:@" "];
            self.selectImgV1.image = [UIImage imageNamed:@" "];
            self.selectImgV2.image = [UIImage imageNamed:@" "];
            self.selectImgV3.image = [UIImage imageNamed:@"icon_choice"];
            break;
        default:
            break;
    }
}

@end
