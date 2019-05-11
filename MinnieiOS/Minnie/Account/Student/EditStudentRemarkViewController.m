//
//  EditStudentRemarkViewController.m
//  MinnieStudent
//
//  Created by songzhen on 2019/5/10.
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
//    self.textView.text = self.remark;
}
- (IBAction)backAction:(id)sender {
   
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)saveAction:(id)sender {
    
    [StudentAwardService requestStudentRemarkWithStudentId:self.userId stuRemark:self.textView.text callback:^(Result *result, NSError *error) {
        
        NSLog(@"result");
    }];
}

@end
