//
//  TeacherClassesViewController.m
//  MinnieTeacher
//
//  Created by yebw on 2018/5/27.
//  Copyright © 2018年 minnieedu. All rights reserved.
//

#import "TeacherClassesViewController.h"
#import "ClassesViewController.h"
#import <Masonry/Masonry.h>

@interface TeacherClassesViewController ()

@property (nonatomic, weak) IBOutlet UIView *containerView;
@property (nonatomic, strong) ClassesViewController *classesChildController;

@end

@implementation TeacherClassesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.classesChildController == nil) {
        self.classesChildController = [[ClassesViewController alloc] initWithNibName:NSStringFromClass([ClassesViewController class]) bundle:nil];
        self.classesChildController.isManageMode = NO;
        self.classesChildController.isUnfinished = YES;
    }

    [self addChildViewController:self.classesChildController];
    [self.containerView addSubview:self.classesChildController.view];
    [self.classesChildController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.containerView);
    }];
    [self.classesChildController didMoveToParentViewController:self];
}

@end
