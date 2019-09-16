//
//  MIEidtFileView.m
//  MinnieManager
//
//  Created by songzhen on 2019/6/2.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import "MIEidtFileView.h"

@interface MIEidtFileView ()

@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation MIEidtFileView

- (void)awakeFromNib{
    
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 20.f;
}

- (IBAction)renameAction:(id)sender {
    
    if (self.renameCallBack) {
        self.renameCallBack();
    }
    if (self.superview) {
        
        [self removeFromSuperview];
    }
}

- (IBAction)deleteAction:(id)sender {
    if (self.deleteCallback) {
        self.deleteCallback();
    }
    if (self.superview) {
        
        [self removeFromSuperview];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if (self.superview) {
        
        [self removeFromSuperview];
    }
}

@end
