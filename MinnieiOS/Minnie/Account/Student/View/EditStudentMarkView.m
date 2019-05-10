//
//  EditStudentMarkView.m
//  MinnieStudent
//
//  Created by songzhen on 2019/5/7.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import "EditStudentMarkView.h"

@interface EditStudentMarkView ()
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@end

@implementation EditStudentMarkView

- (void)awakeFromNib{
    
    [super awakeFromNib];
    
    self.cancelBtn.layer.cornerRadius = 5.0;
    self.cancelBtn.layer.masksToBounds = YES;
    self.cancelBtn.layer.borderWidth = 1.0;
    self.cancelBtn.layer.borderColor = [UIColor blackColor].CGColor;
    
    self.sureBtn.layer.cornerRadius = 5.0;
    self.sureBtn.layer.masksToBounds = YES;
    self.sureBtn.layer.borderWidth = 1.0;
    self.sureBtn.layer.borderColor = [UIColor blackColor].CGColor;
    
}
- (IBAction)cancelBtnAction:(id)sender {
    
}
- (IBAction)sureBtnAction:(id)sender {
    
}


@end
