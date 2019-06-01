//
//  MIMoveHomeworkTaskView.m
//  MinnieManager
//
//  Created by songzhen on 2019/5/31.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import "MIMoveHomeworkTaskView.h"

@interface MIMoveHomeworkTaskView ()

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UILabel *homeworkTitle;
@property (weak, nonatomic) IBOutlet UILabel *locationTextLabel;

@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@property (weak, nonatomic) IBOutlet UIView *oneSelectBgView;
@property (weak, nonatomic) IBOutlet UIView *twoSelectBgView;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moveConstraint;

@end

@implementation MIMoveHomeworkTaskView

-(void)awakeFromNib{
    
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
    
    self.oneSelectBgView.layer.masksToBounds = YES;
    self.oneSelectBgView.layer.cornerRadius = 20.0;
    self.oneSelectBgView.layer.borderWidth = 0.5;
    self.oneSelectBgView.layer.borderColor = [UIColor separatorLineColor].CGColor;
    
    self.twoSelectBgView.layer.masksToBounds = YES;
    self.twoSelectBgView.layer.cornerRadius = 20.0;
    self.twoSelectBgView.layer.borderWidth = 0.5;
    self.twoSelectBgView.layer.borderColor = [UIColor separatorLineColor].CGColor;
    
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.cornerRadius = 20.0;
    self.contentView.layer.borderWidth = 0.5;
    self.contentView.layer.borderColor = [UIColor separatorLineColor].CGColor;
}

- (void)setIsMultiple:(BOOL)isMultiple{
    
    _isMultiple = isMultiple;
    if (isMultiple) {
        
        self.homeworkTitle.hidden = YES;
        self.locationLabel.hidden = YES;
        self.locationTextLabel.hidden = YES;
        self.moveConstraint.constant = 20;
    } else {
        
        self.homeworkTitle.hidden = NO;
        self.locationLabel.hidden = NO;
        self.locationTextLabel.hidden = NO;
        self.moveConstraint.constant = 104;
    }
}

- (IBAction)cancelAction:(id)sender {
    if (self.superview) {
        
        [self removeFromSuperview];
    }
}
- (IBAction)sureAction:(id)sender {
    if (self.superview) {
        
        [self removeFromSuperview];
    }
}

- (IBAction)oneSelectViewAction:(id)sender {
    
    if (self.callback) {
        self.callback(1);
    }
}
- (IBAction)twoSelectViewAction:(id)sender {
    if (self.callback) {
        self.callback(2);
    }
}

@end
