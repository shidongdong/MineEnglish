//
//  ModifyStarCountViewController.m
//  Minnie
//
//  Created by 栋栋 施 on 2019/3/7.
//  Copyright © 2019年 minnieedu. All rights reserved.
//

#import "PublicService.h"
#import "ModifyStarCountView.h"
#import "ModifyStarCountViewController.h"

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
    
    self.currentStarLabel.text = [NSString stringWithFormat:@"%zd",self.starCount];
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.modifyStarTextField resignFirstResponder];
    [self.modifyReasonTextField resignFirstResponder];
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
    NSString *reason = self.modifyReasonTextField.text;
    if (self.modifyReasonTextField.text.length == 0) {
        reason = @"教师操作";
    }
    // 编辑星星数量
    ModifyStarCountView *starView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ModifyStarCountView class]) owner:nil options:nil] lastObject];
    [starView updateWithStarCount:count
                        studentId:self.studentId
                           reason:reason
                            isAdd:isAdd];
    WeakifySelf;
    starView.callback = ^{
       
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    [self.view addSubview:starView];
}


@end
