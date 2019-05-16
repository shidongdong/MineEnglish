//
//  ModifyStarCountView.m
//  MinnieStudent
//
//  Created by songzhen on 2019/5/14.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import "PublicService.h"
#import "ModifyStarCountView.h"

@interface ModifyStarCountView ()
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@property (weak, nonatomic) IBOutlet UILabel *starCountLabel;

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;


@property (nonatomic, assign) NSInteger starCount;

@property (nonatomic, assign) NSInteger studentId;

@property (nonatomic, copy) NSString *reason;



@end

@implementation ModifyStarCountView


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
}

- (IBAction)cancelAction:(id)sender {
    
    if (self.superview) {
        
        [self removeFromSuperview];
    }
}

- (IBAction)sureAction:(id)sender {
    
    WeakifySelf;
    [PublicService modifyStarCount:self.starCount
                        forStudent:self.studentId
                            reason:self.reason
                          callback:^(Result *result, NSError *error) {
                              if (error != nil)
                              {
                                  [HUD showErrorWithMessage:@"修改失败"];
                              } else {
                                  [HUD showErrorWithMessage:@"修改成功"];
                                  if (weakSelf.callback) {
                                      
                                      weakSelf.callback();
                                  }
                              }
                              if (weakSelf.superview) {
                                  
                                  [weakSelf removeFromSuperview];
                              }
                          }];
}

- (void)updateWithStarCount:(NSInteger)starCount
                  studentId:(NSInteger)studentId
                     reason:(NSString *)reason
                      isAdd:(BOOL)isAdd{
   
    self.starCount = isAdd ? starCount : -starCount;
    self.studentId = studentId;
    self.reason = reason;
    
    NSString *descrStr = isAdd ? @"确认将星星数增加" :@"确认将星星数减少";
    self.descLabel.text = descrStr;
    
    NSString *count;
    if (isAdd) {
        count = [NSString stringWithFormat:@"+%ld颗",(long)starCount];
    } else {
        count = [NSString stringWithFormat:@"-%ld颗",(long)starCount];
    }
    self.starCountLabel.text = count;
}

@end
