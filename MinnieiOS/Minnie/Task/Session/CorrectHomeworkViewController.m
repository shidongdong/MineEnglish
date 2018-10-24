//
//  CorrectHomeworkViewController.m
//  X5Teacher
//
//  Created by yebw on 2018/2/6.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "CorrectHomeworkViewController.h"
#import "HomeworkSessionService.h"

@interface CorrectHomeworkViewController ()<UITextViewDelegate>

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;

@property (nonatomic, weak) IBOutlet UIView *passView;
@property (nonatomic, weak) IBOutlet UIButton *passButton;
@property (nonatomic, weak) IBOutlet UIView *goodJobView;
@property (nonatomic, weak) IBOutlet UIButton *goodJobButton;
@property (nonatomic, weak) IBOutlet UIView *veryNiceView;
@property (nonatomic, weak) IBOutlet UIButton *veryNiceButton;
@property (nonatomic, weak) IBOutlet UIView *greatView;
@property (nonatomic, weak) IBOutlet UIButton *greateButton;
@property (nonatomic, weak) IBOutlet UIView *perfectView;
@property (nonatomic, weak) IBOutlet UIButton *perfectButton;
@property (nonatomic, weak) IBOutlet UIView *veryHardWorkingView;
@property (nonatomic, weak) IBOutlet UIButton *veryHardWorkingButton;

@property (nonatomic, weak) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIView *shareCircleView;
@property (weak, nonatomic) IBOutlet UILabel *shareCircleLabel;
@property (weak, nonatomic) IBOutlet UIView *redoView;
@property (weak, nonatomic) IBOutlet UILabel *redoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *redoSelectView;
@property (weak, nonatomic) IBOutlet UIImageView *shareCircleSelectView;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *scrollViewBottomLayoutConstraint;

@property (nonatomic, assign) NSInteger currentScore;
@property (nonatomic, assign) NSInteger m_redo;
@property (nonatomic, assign) NSInteger m_circle;
@end

@implementation CorrectHomeworkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentScore = -1;
    self.scrollView.contentSize =CGSizeMake([UIScreen mainScreen].bounds.size.width, 532);
    
    [self resetScoreViews];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardFrameWillChange:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
}

- (void)resetScoreViews {
    self.passView.backgroundColor = [UIColor whiteColor];
    self.goodJobView.backgroundColor = [UIColor whiteColor];
    self.veryNiceView.backgroundColor = [UIColor whiteColor];
    self.greatView.backgroundColor = [UIColor whiteColor];
    self.perfectView.backgroundColor = [UIColor whiteColor];
    self.veryHardWorkingView.backgroundColor = [UIColor whiteColor];
    
    [self.passButton setTitleColor:[UIColor colorWithHex:0x28C4B7] forState:UIControlStateNormal];
    [self.goodJobButton setTitleColor:[UIColor colorWithHex:0x00CE00] forState:UIControlStateNormal];
    [self.veryNiceButton setTitleColor:[UIColor colorWithHex:0x0098FE] forState:UIControlStateNormal];
    [self.greateButton setTitleColor:[UIColor colorWithHex:0xFFC600] forState:UIControlStateNormal];
    [self.perfectButton setTitleColor:[UIColor colorWithHex:0xFF4858] forState:UIControlStateNormal];
    [self.veryHardWorkingButton setTitleColor:[UIColor colorWithHex:0xB248FF] forState:UIControlStateNormal];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
   // [self.textView becomeFirstResponder];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    NSLog(@"%s", __func__);
}

- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)sendFriendCircleAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    if (sender.selected)
    {
        self.shareCircleSelectView.hidden = NO;
        self.shareCircleView.backgroundColor = [UIColor colorWithHex:0x00CE00];
        self.shareCircleLabel.textColor = [UIColor whiteColor];
    }
    else
    {
        self.shareCircleSelectView.hidden = YES;
        self.shareCircleView.backgroundColor = [UIColor whiteColor];
        self.shareCircleLabel.textColor = [UIColor blackColor];
    }
    self.m_circle = sender.selected;
}

- (IBAction)redoAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    if (sender.selected)
    {
        self.redoSelectView.hidden = NO;
        self.redoView.backgroundColor = [UIColor colorWithHex:0x00CE00];
        self.redoLabel.textColor = [UIColor whiteColor];
    }
    else
    {
        self.redoSelectView.hidden = YES;
        self.redoView.backgroundColor = [UIColor whiteColor];
        self.redoLabel.textColor = [UIColor blackColor];
    }
    
    self.m_redo = sender.selected;
}

- (IBAction)confirmButtonPressed:(id)sender {
    if (self.currentScore == -1) {
        [HUD showErrorWithMessage:@"请先评分"];
        return;
    }
    
    if (self.textView.text.length == 0)
    {
        [HUD showErrorWithMessage:@"请先输入评语"];
        return;
    }
    
    if (self.textView.text.length > 40)
    {
        [HUD showErrorWithMessage:@"评语最多输入20字"];
        return;
    }
    
    NSString *reviewText = [self.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    
    [HUD showProgressWithMessage:@"正在评分..."];
    
    [HomeworkSessionService correctHomeworkSessionWithId:self.homeworkSession.homeworkSessionId
                                                   score:self.currentScore
                                                    redo:self.m_redo
                                              sendCircle:self.m_circle
                                                    text:reviewText
                                                callback:^(Result *result, NSError *error) {
                                                    if (error != nil) {
                                                        if (error.code == 202) {
                                                            [HUD showErrorWithMessage:@"学生未提交作业"];
                                                        } else {
                                                            [HUD showErrorWithMessage:@"评分失败"];
                                                        }
                                                    } else {
                                                        [HUD showWithMessage:@"评分成功"];
                                                        
                                                        self.homeworkSession.reviewText = reviewText;
                                                        self.homeworkSession.score = self.currentScore;
                                                        self.homeworkSession.isRedo = self.m_redo;
                                                        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationKeyOfCorrectHomework object:nil userInfo:@{@"HomeworkSession":self.homeworkSession}];
                                                        
                                                        [self.navigationController popToRootViewControllerAnimated:YES];
                                                    }
                                                }];

}

- (IBAction)scoreButtonPressed:(id)sender {
    UIButton *button = (UIButton *)sender;
    if (button.tag == self.currentScore) {
        return;
    }
    
    [self resetScoreViews];
    
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if (button.tag == 1) {
        self.passView.backgroundColor = [UIColor colorWithHex:0x28C4B7];
    } else if (button.tag == 2) {
        self.goodJobView.backgroundColor = [UIColor colorWithHex:0x00CE00];
    } else if (button.tag == 3) {
        self.veryNiceView.backgroundColor = [UIColor colorWithHex:0x0098FE];
    } else if (button.tag == 4) {
        self.greatView.backgroundColor = [UIColor colorWithHex:0xFFC600];
    } else if (button.tag == 5) {
        self.perfectView.backgroundColor = [UIColor colorWithHex:0xFF4858];
    } else if (button.tag == 6) {
        self.veryHardWorkingView.backgroundColor = [UIColor colorWithHex:0xB248FF];
    }
    
    self.currentScore = button.tag;
    if (button.tag == 6)
    {
        self.currentScore = 0;
    }
}

- (void)keyboardFrameWillChange:(NSNotification *)notification {
    NSValue *endValue = notification.userInfo[UIKeyboardFrameEndUserInfoKey];
    CGRect kbFrame = [endValue CGRectValue];
    
    if (kbFrame.origin.y >= ScreenHeight) {
        self.scrollViewBottomLayoutConstraint.constant = 0;
    } else {
        self.scrollViewBottomLayoutConstraint.constant = kbFrame.size.height;
    }
    
    [UIView animateWithDuration:0.45f
                     animations:^{
                         [self.view layoutIfNeeded];
                     } completion:^(BOOL finished) {
                     }];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView.text.length > 39 && text.length > 0)
    {
        return NO;
    }
    if ([text isEqualToString:@"\n"]) {
        [self.textView resignFirstResponder];
        return NO;
    }
    return YES;
}

@end



