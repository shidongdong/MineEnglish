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

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@property (weak, nonatomic) IBOutlet UIButton *markBtn0;
@property (weak, nonatomic) IBOutlet UIButton *markBtn1;
@property (weak, nonatomic) IBOutlet UIButton *markBtn2;
@property (weak, nonatomic) IBOutlet UIButton *markBtn3;

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
    
    if (self.superview) {
      
        [self removeFromSuperview];
    }
}
- (IBAction)sureBtnAction:(id)sender {
    
    int value = arc4random()%4;
    
    WeakifySelf;
    [StudentAwardService requestStudentLabelWithStudentId:self.userId studentLabel:value callback:^(Result *result, NSError *error) {

        if (error != nil) {
            return ;
        }
        if (weakSelf.superview) {
            
            [weakSelf removeFromSuperview];
        }
    }];
}


@end
