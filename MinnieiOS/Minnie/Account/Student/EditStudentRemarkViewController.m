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
}
- (IBAction)backAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)saveAction:(id)sender {
    WeakifySelf;
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
