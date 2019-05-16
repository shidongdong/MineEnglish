//
//  EditStudentRemarkViewController.m
//  MinnieStudent
//
//  Created by songzhen on 2019/5/11.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import "StudentAwardService.h"
#import "EditStudentRemarkViewController.h"

@interface EditStudentRemarkViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation EditStudentRemarkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.textView.text = self.remark;
    [self.textView becomeFirstResponder];
    self.textView.layer.cornerRadius = 10.0;
    self.textView.layer.masksToBounds = YES;
    self.textView.layer.borderWidth = 1.0;
    self.textView.layer.borderColor = [UIColor colorWithHex:0xECECEC].CGColor;
}
- (IBAction)backAction:(id)sender {
    
    [self.textView resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)saveAction:(id)sender {
    WeakifySelf;
    [self.textView resignFirstResponder];
    [StudentAwardService requestStudentRemarkWithStudentId:self.userId stuRemark:self.textView.text callback:^(Result *result, NSError *error) {
        if (error != nil) {
            
            [HUD showErrorWithMessage:@"编辑备注失败"];
            return ;
        }
        [weakSelf.navigationController popViewControllerAnimated:YES];
        NSLog(@"result");
    }];
}

@end
