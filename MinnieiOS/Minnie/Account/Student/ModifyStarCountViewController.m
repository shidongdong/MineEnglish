//
//  ModifyStarCountViewController.m
//  Minnie
//
//  Created by 栋栋 施 on 2019/3/7.
//  Copyright © 2019年 minnieedu. All rights reserved.
//

#import "ModifyStarCountViewController.h"
#import "PublicService.h"
@interface ModifyStarCountViewController ()<UITextFieldDelegate>

// 当前星星数量
@property (weak, nonatomic) IBOutlet UILabel *currentStarLabel;

// 更改星星数
@property (weak, nonatomic) IBOutlet UITextField *modifyStarTextField;

@property (weak, nonatomic) IBOutlet UIButton *increaseButton;

@property (weak, nonatomic) IBOutlet UIButton *decreaseButton;

// 更改原因
@property (weak, nonatomic) IBOutlet UITextField *modifyReasonTextField;

@end

@implementation ModifyStarCountViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.decreaseButton.layer.cornerRadius = 10.0f;
    self.decreaseButton.layer.borderColor = [UIColor colorWithHex:0x0098FE].CGColor;
    self.decreaseButton.layer.borderWidth = 1.0;
    self.currentStarLabel.text = [NSString stringWithFormat:@"%zd",self.starCount];
    
    
    self.increaseButton.layer.cornerRadius = 10.0f;
    self.increaseButton.layer.borderColor = [UIColor colorWithHex:0x0098FE].CGColor;
    self.increaseButton.layer.borderWidth = 1.0;
    
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)backPressed:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)decreasePressed:(id)sender {
    
    [self modifyStarCountIsAdd:NO];
}

- (IBAction)increasePressed:(UIButton *)sender {
    
    [self modifyStarCountIsAdd:YES];
}

- (void)modifyStarCountIsAdd:(BOOL)isAdd {
    
    [self.modifyStarTextField resignFirstResponder];
    [self.modifyReasonTextField resignFirstResponder];
    // 增减数量
    NSInteger count = [self.modifyStarTextField.text integerValue];
    if (self.modifyStarTextField.text.length == 0)
    {
        NSString *message = isAdd ? @"请填写要增加的星星数" :@"请填写要减少的星星数";
        [HUD showErrorWithMessage:message];
        return;
    }
    if (!isAdd) {
        
        if (count > self.starCount) {
            [HUD showErrorWithMessage:@"大于当前拥有星星数"];
            return;
        }
    }
    NSString *toastStr = isAdd ? @"确认将星星数增加" :@"确认将星星数减少";
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil
                                                                     message:[NSString stringWithFormat:@"%@：%@颗",toastStr,self.modifyStarTextField.text]
                                                              preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             
                                                         }];
    NSString *reason = self.modifyReasonTextField.text;
    if (self.modifyReasonTextField.text.length == 0) {
        reason = @"教师操作";
    }
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                              
                                                              [PublicService modifyStarCount:(isAdd ? count: -count)
                                                                                  forStudent:self.studentId
                                                                                      reason:reason
                                                                                    callback:^(Result *result, NSError *error) {
                                                                                        if (error != nil)
                                                                                        {
                                                                                            [HUD showErrorWithMessage:@"修改失败"];
                                                                                        }
                                                                                        else
                                                                                        {
                                                                                            [self.navigationController popViewControllerAnimated:YES];
                                                                                        }
                                                                                    }];
                                                          }];
    
    [alertVC addAction:cancelAction];
    [alertVC addAction:confirmAction];
    
    [self presentViewController:alertVC
                       animated:YES
                     completion:nil];
}


@end
