//
//  MIReadingTaskViewController.m
//  Minnie
//
//  Created by songzhen on 2019/6/9.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import "MIReadingTaskViewController.h"

@interface MIReadingTaskViewController ()

@property (weak, nonatomic) IBOutlet UIButton *rerecordBtn;
@property (weak, nonatomic) IBOutlet UIButton *startRecordBtn;
@property (weak, nonatomic) IBOutlet UILabel *startRecordLabel;

@property (weak, nonatomic) IBOutlet UIButton *myRecordBtn;

@end

@implementation MIReadingTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
