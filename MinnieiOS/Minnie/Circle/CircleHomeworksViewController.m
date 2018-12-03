//
//  CircleHomeworksViewController.m
//  X5
//
//  Created by yebw on 2017/12/12.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "CircleHomeworksViewController.h"
#import "CircleViewController.h"
#import <Masonry/Masonry.h>
#if TEACHERSIDE
#import "ClassManagerViewController.h"
#endif

@interface CircleHomeworksViewController ()

@property (nonatomic, weak) IBOutlet UIView *containerView;
@property (nonatomic, strong) CircleViewController *circleChildController;

@end

@implementation CircleHomeworksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.clazz != 0) {
        self.customTitleLabel.text = self.clazz.name;
    } else {
        if (APP.currentUser.userId == self.userId) {
            self.customTitleLabel.text = @"我发布的";
        }
        else
        {
            self.customTitleLabel.text = self.userName;
        }
    }

    if (self.circleChildController == nil) {
        self.circleChildController = [[CircleViewController alloc] initWithNibName:NSStringFromClass([CircleViewController class]) bundle:nil];
        self.circleChildController.userId = self.userId;
        self.circleChildController.classId = self.clazz.classId;
    }
    
    [self addChildViewController:self.circleChildController];
    [self.containerView addSubview:self.circleChildController.view];
    [self.circleChildController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.containerView);
    }];
    [self.circleChildController didMoveToParentViewController:self];
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

//- (IBAction)classManagerButtonPressed:(id)sender {
//#if TEACHERSIDE
//    if (!APP.currentUser.canManageClasses) {
//        [HUD showErrorWithMessage:@"无操作权限"];
//
//        return;
//    }
//
//    ClassManagerViewController *vc = [[ClassManagerViewController alloc] initWithNibName:@"ClassManagerViewController" bundle:nil];
//    vc.classId = self.clazz.classId;
//    [self.navigationController pushViewController:vc animated:YES];
//
//#endif
//}

@end

