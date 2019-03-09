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

@property (weak, nonatomic) IBOutlet UILabel *currentStarLabel;
@property (weak, nonatomic) IBOutlet UITextField *modifyStarTextField;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@end

@implementation ModifyStarCountViewController

- (IBAction)savePressed:(UIButton *)sender {
    
    [self.modifyStarTextField resignFirstResponder];
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil
                                                                     message:[NSString stringWithFormat:@"确认将星星修改为：%@",self.modifyStarTextField.text]
                                                              preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                         style:UIAlertActionStyleCancel
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                           
                                                       }];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             [PublicService modifyStarCount:[self.modifyStarTextField.text integerValue] forStudent:self.studentId callback:^(Result *result, NSError *error) {
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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.saveButton.layer.cornerRadius = 10.0f;
    self.saveButton.layer.borderColor = [UIColor colorWithHex:0x0098FE].CGColor;
    self.saveButton.layer.borderWidth = 1.0;
    self.currentStarLabel.text = [NSString stringWithFormat:@"%zd",self.starCount];
    
    // Do any additional setup after loading the view from its nib.
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
