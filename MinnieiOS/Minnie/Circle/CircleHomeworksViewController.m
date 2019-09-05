//
//  CircleHomeworksViewController.m
//  X5
//
//  Created by yebw on 2017/12/12.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import <Masonry/Masonry.h>
#import "CircleViewController.h"
#import "CircleHomeworksViewController.h"

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
        if (self.clazz == 0)
        {
            self.circleChildController.bSkipAvater = YES;
        }
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


@end

