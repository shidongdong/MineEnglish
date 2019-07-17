//
//  MITeacherDetailViewController.m
//  MinnieManager
//
//  Created by songzhen on 2019/7/10.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import "TeacherService.h"
#import "MIScoreListViewController.h"
#import "TeacherEditViewController.h"
#import "MITeacherOnlineTableViewCell.h"
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

@property (weak, nonatomic) IBOutlet UIButton *onlineButton;

@property (nonatomic,strong) Teacher *teacher;

@property (nonatomic,strong) TeacherDetail *teacherDetail;

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
    
    self.onlineButton.layer.cornerRadius = 4.0;
    
    self.titleArray = @[@"在线时长",@"任务批改总览",@"上课班级",@"任务评分统计"];
    
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
        self.view.backgroundColor = [UIColor whiteColor];
        self.tableView.backgroundColor = [UIColor whiteColor];
        
        self.nameLabel.text = self.teacher.nickname;
        [self.iconImageV sd_setImageWithURL:[self.teacher.avatarUrl imageURLWithWidth:24] placeholderImage:[UIImage imageNamed: @"attachment_placeholder"]];
        
        // 请求用户信息
        [self requestDetail];
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
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 3;
    } else if (section == 2) {
        return 2;
    } else {
        return 5;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return MITeacherOnlineTableViewCellHeight;
    } else if (indexPath.section == 1) {
        return 30;
    } else if (indexPath.section == 2) {
        return 44;
    } else {
        return 44;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        MITeacherOnlineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MITeacherOnlineTableViewCellId];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MITeacherOnlineTableViewCell class]) owner:nil options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    } else if (indexPath.section == 1) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"teacherDetailCellId"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"studentDetailCellId"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (indexPath.row == 0) {
            cell.textLabel.attributedText = [self setupContentTitle:@"待批改数：" text:@"122"];
        } else if (indexPath.row == 1) {
            cell.textLabel.attributedText = [self setupContentTitle:@"未提交数：" text:@"345"];
        } else {
            cell.textLabel.attributedText = [self setupContentTitle:@"已批次数：" text:@"今日222/本周44/本月9867"];
        }
        return cell;
    } else {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellId"];
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.textColor = [UIColor normalColor];
            cell.detailTextLabel.textColor = [UIColor colorWithHex:0x666666];
        }
        if (indexPath.section == 2) {
            
            cell.textLabel.text = @"3年A班";
            cell.detailTextLabel.text = @"20人";
        } else {
            
            cell.textLabel.text = @"第三周第五个任务";
            cell.detailTextLabel.text = @"2.5/3星";
        }
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headerView =  [[UIView alloc] init];
    headerView.backgroundColor = [UIColor whiteColor];
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, kColumnThreeWidth - 40, 40)];
    timeLabel.textAlignment = NSTextAlignmentLeft;
    timeLabel.font = [UIFont boldSystemFontOfSize:14];
    timeLabel.textColor = [UIColor normalColor];
    [headerView addSubview:timeLabel];

    timeLabel.text = self.titleArray[section];
    
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 40;
}


- (NSAttributedString *)setupContentTitle:(NSString *)title text:(NSString *)text{
    if (text.length == 0) {
        text = @"";
    }
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",title,text]];
    [attStr setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} range:NSMakeRange(0, attStr.length)];
    [attStr setAttributes:@{NSForegroundColorAttributeName: [UIColor detailColor],
                            NSFontAttributeName:[UIFont systemFontOfSize:14]}
                    range:NSMakeRange(title.length, attStr.length - title.length)];
    return attStr;
    
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

- (void)requestDetail{
    // 1496
    [TeacherService getTeacherDetailWithId:self.teacher.userId callback:^(Result *result, NSError *error) {
        
        NSLog(@"%@",result);
    }];
}

@end
