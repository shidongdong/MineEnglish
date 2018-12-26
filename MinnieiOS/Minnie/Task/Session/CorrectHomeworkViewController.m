//
//  CorrectHomeworkViewController.m
//  X5Teacher
//
//  Created by yebw on 2018/2/6.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "CorrectHomeworkViewController.h"
#import "HomeworkSessionService.h"
#import "CorrectHomeworkScoreTableViewCell.h"
#import "CorrectHomeworkCommentTableViewCell.h"
#import "CorrectHomeworkHisCommentTableViewCell.h"
#import "CorrectHomeworkAddCommentViewController.h"
@interface CorrectHomeworkViewController ()<UITableViewDelegate,UITableViewDataSource,CorrectHomeworkAddCommentViewControllerDelegate>

@property (nonatomic, weak) IBOutlet UITableView * mTableView;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint * tableViewBottomLayoutConstraint;

@property (nonatomic, assign) NSInteger currentScore; //评分
@property (nonatomic, strong) NSString * commentText; //评语
@property (nonatomic, assign) NSInteger m_circle;     //分享到朋友圈
@property (nonatomic, strong) NSMutableArray * commentTags; //常用评论列表

@end

@implementation CorrectHomeworkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentScore = -1;
    self.commentTags = [NSMutableArray array];
    [self registerCellNibs];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardFrameWillChange:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
    
    [self requestCommentTags];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
   // [self.textView becomeFirstResponder];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    NSLog(@"%s", __func__);
}


- (void)requestCommentTags
{
    
}

- (void)registerCellNibs
{
    [self.mTableView registerNib:[UINib nibWithNibName:@"CorrectHomeworkScoreTableViewCell" bundle:nil] forCellReuseIdentifier:CorrectHomeworkScoreTableViewCellId];
    [self.mTableView registerNib:[UINib nibWithNibName:@"CorrectHomeworkCommentTableViewCell" bundle:nil] forCellReuseIdentifier:CorrectHomeworkCommentTableViewCellId];
    [self.mTableView registerNib:[UINib nibWithNibName:@"CorrectHomeworkHisCommentTableViewCell" bundle:nil] forCellReuseIdentifier:CorrectHomeworkHisCommentTableViewCellId];
}

- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)confirmButtonPressed:(id)sender {
    if (self.currentScore == -1) {
        [HUD showErrorWithMessage:@"请先评分"];
        return;
    }
    
    /* 评语非必选项
    if (self.commentText.length == 0)
    {
        [HUD showErrorWithMessage:@"请先输入评语"];
        return;
    }
    */
    
    if (self.commentText.length > 40)
    {
        [HUD showErrorWithMessage:@"评语最多输入40字"];
        return;
    }
    
    NSString *reviewText = [self.commentText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    
    [HUD showProgressWithMessage:@"正在评分..."];
    
    [HomeworkSessionService correctHomeworkSessionWithId:self.homeworkSession.homeworkSessionId
                                                   score:self.currentScore
                                                    redo:0
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
                                                        self.homeworkSession.isRedo = 0;
                                                        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationKeyOfCorrectHomework object:nil userInfo:@{@"HomeworkSession":self.homeworkSession}];
                                                        
                                                        [self.navigationController popToRootViewControllerAnimated:YES];
                                                    }
                                                }];

}


- (void)keyboardFrameWillChange:(NSNotification *)notification {
    NSValue *endValue = notification.userInfo[UIKeyboardFrameEndUserInfoKey];
    CGRect kbFrame = [endValue CGRectValue];
    
    if (kbFrame.origin.y >= ScreenHeight) {
        self.tableViewBottomLayoutConstraint.constant = 0;
    } else {
        self.tableViewBottomLayoutConstraint.constant = kbFrame.size.height;
    }
    
    [UIView animateWithDuration:0.45f
                     animations:^{
                         [self.view layoutIfNeeded];
                     } completion:^(BOOL finished) {
                     }];
}

#pragma mark - UITableViewDelegate && Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 2)
    {
        return 0.1;
    }
    return 10.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return (ScreenWidth - 24 - 4 * 10) / 5 + 20 + 10 + 39;
    }
    else if (indexPath.section == 1)
    {
        return CorrectHomeworkCommentTableViewCellHeight;
    }
    else
    {
        return [CorrectHomeworkHisCommentTableViewCell heightWithTags:self.commentTags];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     UITableViewCell *cell = nil;
    WeakifySelf;
    if (indexPath.section == 0)
    {
        CorrectHomeworkScoreTableViewCell * scoreCell = [tableView dequeueReusableCellWithIdentifier:CorrectHomeworkScoreTableViewCellId forIndexPath:indexPath];
        [scoreCell setScoreCallback:^(NSInteger score)
        {
            weakSelf.currentScore = score;
        }];
        [scoreCell setShareCallback:^(NSInteger bShare)
        {
            weakSelf.m_circle = bShare;
        }];
        cell = scoreCell;
    }
    else if (indexPath.section == 1)
    {
        CorrectHomeworkCommentTableViewCell * commentCell = [tableView dequeueReusableCellWithIdentifier:CorrectHomeworkCommentTableViewCellId forIndexPath:indexPath];
        [commentCell setCommentCallback:^(NSString * text) {
            weakSelf.commentText = text;
        }];
        cell = commentCell;
    }
    else
    {
        CorrectHomeworkHisCommentTableViewCell * addCommentCell = [tableView dequeueReusableCellWithIdentifier:CorrectHomeworkHisCommentTableViewCellId forIndexPath:indexPath];
        [addCommentCell setAddCommentCallback:^{
            CorrectHomeworkAddCommentViewController * addCommentVc = [[CorrectHomeworkAddCommentViewController alloc] init];
            addCommentVc.delegate = weakSelf;
            [weakSelf.navigationController pushViewController:addCommentVc animated:YES];
        }];
        [addCommentCell setClickCommentCallback:^(NSString * tag) {
            weakSelf.commentText = tag;
            
            CorrectHomeworkCommentTableViewCell * commentCell = (CorrectHomeworkCommentTableViewCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
            [commentCell setupCommentInfo:tag];
        }];
        
        cell = addCommentCell;
    }
    return cell;
}

#pragma mark - CorrectHomeworkAddCommentViewControllerDelegate

- (void)addComment:(NSString *)info
{
    
}

@end



