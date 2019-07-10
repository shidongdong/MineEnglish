//
//  MITeacherDetailViewController.m
//  MinnieManager
//
//  Created by songzhen on 2019/7/10.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import "MIScoreListViewController.h"
#import "TeacherEditViewController.h"
#import "MISecondReaTimeTaskTableViewCell.h"
#import "MITeacherDetailViewController.h"

@interface MITeacherDetailViewController ()<
UITableViewDelegate,
UITableViewDataSource
>
@property (weak, nonatomic) IBOutlet UIImageView *iconImageV;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *setButton;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *rightLineView;

@property (nonatomic,strong) Teacher *teacher;

@property (nonatomic,strong) NSArray *titleArray;

@end

@implementation MITeacherDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.iconImageV.layer.masksToBounds = YES;
    self.iconImageV.layer.cornerRadius = 12.0;
    
    self.setButton.layer.masksToBounds = YES;
    self.setButton.layer.cornerRadius = 4.0;
    self.setButton.layer.borderWidth = 1.0;
    self.setButton.layer.borderColor = [UIColor mainColor].CGColor;
    self.titleArray = @[@"在线时长",@"任务批改总览",@"上课班级",@"任务评分统计"];
    
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = footerView;
}

- (void)updateTeacher:(Teacher *_Nullable)teacher{
   
    self.teacher = teacher;
    if (teacher == nil) {
        
        self.headerView.hidden = YES;
        self.rightLineView.hidden = YES;
        self.tableView.hidden = YES;
        self.view.backgroundColor = [UIColor emptyBgColor];
    } else {
        self.headerView.hidden = NO;
        self.tableView.hidden = NO;
        self.rightLineView.hidden = NO;
        self.view.backgroundColor = [UIColor unSelectedColor];
        self.tableView.backgroundColor = [UIColor unSelectedColor];
        
        self.nameLabel.text = self.teacher.nickname;
        [self.iconImageV sd_setImageWithURL:[self.teacher.avatarUrl imageURLWithWidth:24] placeholderImage:[UIImage imageNamed: @"attachment_placeholder"]];
        
        // 请求用户信息
    }
}
- (IBAction)setAction:(id)sender {
    
    UIViewController *rootVC = self.view.window.rootViewController;
    TeacherEditViewController *editVC = [[TeacherEditViewController alloc] initWithNibName:@"TeacherEditViewController" bundle:nil];
    editVC.teacher = self.teacher;
    
    UIView *bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [rootVC.view addSubview:bgView];
    [bgView addSubview:editVC.view];
    [rootVC addChildViewController:editVC];
    [editVC didMoveToParentViewController:rootVC];
    editVC.view.frame = CGRectMake((ScreenWidth - 375.0)/2.0, 50, 375, ScreenHeight - 100);
    
    editVC.cancelCallBack = ^{
        if (bgView.superview) {
            [bgView removeFromSuperview];
        }
    };
    editVC.successCallBack = ^{
        if (bgView.superview) {
            [bgView removeFromSuperview];
        }
    };
}

#pragma mark -   UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.titleArray[section];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MISecondReaTimeTaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MISecondReaTimeTaskTableViewCellId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MISecondReaTimeTaskTableViewCell class]) owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.section == 3) {
       
        MIScoreListViewController *scoreListVC = [[MIScoreListViewController alloc] initWithNibName:NSStringFromClass([MIScoreListViewController class]) bundle:nil];
        scoreListVC.editTaskCallBack = ^{
        };
        scoreListVC.cancelCallBack = ^{
        };
        if (self.pushCallBack) {
            self.pushCallBack(scoreListVC);
        }
    }
}

@end
