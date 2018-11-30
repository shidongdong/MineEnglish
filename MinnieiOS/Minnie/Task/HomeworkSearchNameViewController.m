//
//  HomeworkSearchNameViewController.m
//  Minnie
//
//  Created by 栋栋 施 on 2018/11/29.
//  Copyright © 2018年 minnieedu. All rights reserved.
//

#import "HomeworkSearchNameViewController.h"
#import "HomeworkSessionsViewController.h"
@interface HomeworkSearchNameViewController ()

@property (nonatomic, strong) HomeworkSessionsViewController * homeworkClassesChildController;
@property (weak, nonatomic) IBOutlet UIView *containerView;


@end

@implementation HomeworkSearchNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initChildViewController];
    // Do any additional setup after loading the view from its nib.
}

- (void)initChildViewController
{
    self.homeworkClassesChildController = [[HomeworkSessionsViewController alloc] initWithNibName:NSStringFromClass([HomeworkSessionsViewController class]) bundle:nil];
    
    if (self.currentFliterType == 0)
    {
        self.homeworkClassesChildController.isUnfinished = YES;
        self.homeworkClassesChildController.bLoadConversion = YES;
    }
    else if (self.currentFliterType == 1)
    {
        self.homeworkClassesChildController.isUnfinished = NO;
        self.homeworkClassesChildController.bLoadConversion = NO;
    }
    else
    {
        self.homeworkClassesChildController.isUnfinished = YES;
        self.homeworkClassesChildController.bLoadConversion = NO;
    }
    self.homeworkClassesChildController.searchFliter = -1;
    
    [self addChildViewController:self.homeworkClassesChildController];
    
    [self.containerView addSubview:self.homeworkClassesChildController.view];
    [self addContraintsWithX:0 view:self.homeworkClassesChildController.view superView:self.containerView];
    
    [self.homeworkClassesChildController didMoveToParentViewController:self];
    
}


- (void)addContraintsWithX:(CGFloat)offsetX view:(UIView *)view superView:(UIView *)superView {
    view.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *leadingConstraint = [NSLayoutConstraint constraintWithItem:view
                                                                         attribute:NSLayoutAttributeLeading
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:superView
                                                                         attribute:NSLayoutAttributeLeading
                                                                        multiplier:1
                                                                          constant:offsetX];
    
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:view
                                                                       attribute:NSLayoutAttributeWidth
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:nil
                                                                       attribute:NSLayoutAttributeNotAnAttribute
                                                                      multiplier:1
                                                                        constant:ScreenWidth];
    
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:view
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:superView
                                                                     attribute:NSLayoutAttributeTop
                                                                    multiplier:1
                                                                      constant:0];
    
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:view
                                                                        attribute:NSLayoutAttributeBottom
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:superView
                                                                        attribute:NSLayoutAttributeBottom
                                                                       multiplier:1
                                                                         constant:0];
    
    [superView addConstraints:@[leadingConstraint, widthConstraint, topConstraint, bottomConstraint]];
}

#pragma mark - event

- (IBAction)cancel:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    if (textField.text.length > 0)
    {
        [self.homeworkClassesChildController requestSearchForName:textField.text];
    }
    
    return NO;
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
