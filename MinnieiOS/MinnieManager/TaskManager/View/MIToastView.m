//
//  MIToastView.m
//  Minnie
//
//  Created by songzhen on 2019/8/9.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import "MIToastView.h"

@interface MIToastView ()

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UILabel *titleView;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@property (copy, nonatomic) void (^actionBlock)(void);
@property (copy, nonatomic) void (^cancelactionBlock)(void);

@end


@implementation MIToastView

- (void)awakeFromNib{
    
    [super awakeFromNib];
    
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    self.sureBtn.layer.masksToBounds = YES;
    self.sureBtn.layer.cornerRadius = 20.0;
    self.sureBtn.layer.borderWidth = 0.5;
    self.sureBtn.layer.borderColor = [UIColor mainColor].CGColor;
    
    self.cancelBtn.layer.masksToBounds = YES;
    self.cancelBtn.layer.cornerRadius = 20.0;
    self.cancelBtn.layer.borderWidth = 0.5;
    self.cancelBtn.layer.borderColor = [UIColor mainColor].CGColor;
    
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.cornerRadius = 20.0;
    self.contentView.layer.borderWidth = 0.5;
    self.contentView.layer.borderColor = [UIColor separatorLineColor].CGColor;
}

- (IBAction)cancelAction:(id)sender {
    
    if (self.cancelactionBlock) {
        
        self.cancelactionBlock();
        
        if (self.superview) {
            [self removeFromSuperview];
        }
    }
}

- (IBAction)sureAction:(id)sender {
    
    if (self.actionBlock) {
        
        self.actionBlock();
        
        if (self.superview) {
            [self removeFromSuperview];
        }
    }
}


+ (void)setTitle:(NSString *)title
         confirm:(NSString *)confirm
          cancel:(NSString *)cancel
       superView:(UIView *)superView
    confirmBlock:(void (^)(void))confirmBlock
     cancelBlock:(void (^)(void))cancelBlock{
    
    MIToastView *toast = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MIToastView class]) owner:nil options:nil].lastObject;
    [superView addSubview:toast];
    
    [toast mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.mas_equalTo(superView);
    }];
    [toast setUpTitle:title confirm:confirm cancel:cancel superView:superView confirmBlock:confirmBlock cancelBlock:cancelBlock];
    
}

- (void)setUpTitle:(NSString *)title
           confirm:(NSString *)confirm
            cancel:(NSString *)cancel
         superView:(UIView *)superView
      confirmBlock:(void (^)(void))confirmBlock
       cancelBlock:(void (^)(void))cancelBlock{
    
    self.titleView.text = title;
    if (cancel.length) {
        
        [self.cancelBtn setTitle:cancel forState:UIControlStateNormal];
    }
    if (confirm.length) {
        
        [self.sureBtn setTitle:confirm forState:UIControlStateNormal];
    }
    self.actionBlock = confirmBlock;
    self.cancelactionBlock = cancelBlock;
}


@end
