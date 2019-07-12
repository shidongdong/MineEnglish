//
//  MIStudentDetailViewController.m
//  MinnieManager
//
//  Created by songzhen on 2019/7/11.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import "MIStudentDetailViewController.h"

@interface MIStudentDetailViewController ()

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *rightLineView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImagV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (strong, nonatomic) User *student;

@end

@implementation MIStudentDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor emptyBgColor];
    
    self.iconImagV.layer.masksToBounds = YES;
    self.iconImagV.layer.cornerRadius = 12.0;
    
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)updateStudent:(User * _Nullable)student{
   
    self.student = student;
    if (student == nil) {
       
        self.headerView.hidden = YES;
        self.tableView.hidden = YES;
        self.rightLineView.hidden = YES;
    } else {
      
        self.headerView.hidden = NO;
        self.tableView.hidden = NO;
        self.rightLineView.hidden = NO;
        
        self.nameLabel.text = self.student.nickname;
        [self.iconImagV sd_setImageWithURL:[self.student.avatarUrl imageURLWithWidth:24] placeholderImage:[UIImage imageNamed: @"attachment_placeholder"]];
    }
}

#pragma mark -   UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 6;
    } else if (section == 2) {
        return 5;
    } else {
        return 6;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @" ";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"studentDetailCellId"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"studentDetailCellId"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.section == 0) {

        cell.textLabel.attributedText = [self setupContentTitle:@"综合评价:A" text:nil];
    } else if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            cell.textLabel.attributedText = [self setupContentTitle:@"待批改数：" text:nil];
        } else if (indexPath.row == 1) {
            cell.textLabel.attributedText = [self setupContentTitle:@"考试统计：" text:nil];
        } else if (indexPath.row == 2) {
            cell.textLabel.attributedText = [self setupContentTitle:@"获得勋章数：" text:nil];
        } else if (indexPath.row == 3) {
            cell.textLabel.attributedText = [self setupContentTitle:@"获得点赞数：" text:nil];
        } else if (indexPath.row == 4) {
            cell.textLabel.attributedText = [self setupContentTitle:@"星星数：" text:nil];
        } else {
            cell.textLabel.attributedText = [self setupContentTitle:@"兑换礼品数：" text:@"12/234星星"];
        }
    } else if (indexPath.section == 2) {
        
        if (indexPath.row == 0) {
            cell.textLabel.attributedText = [self setupContentTitle:@"本学期任务完成率：" text:nil];
        } else if (indexPath.row == 1) {
            cell.textLabel.attributedText = [self setupContentTitle:@"任务评价得分：" text:nil];
        } else if (indexPath.row == 2) {
            cell.textLabel.attributedText = [self setupContentTitle:@"优秀任务数：" text:nil];
        } else if (indexPath.row == 3) {
            cell.textLabel.attributedText = [self setupContentTitle:@"过期任务数：" text:nil];
        } else {
            cell.textLabel.attributedText = [self setupContentTitle:@"被分享次数：" text:nil];
        }
    } else {
        NSString *titleStr = [NSString stringWithFormat:@"%lu星任务数：",5 - indexPath.row];
        cell.textLabel.attributedText = [self setupContentTitle:titleStr text:@"122颗"];
    }
    return cell;
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

@end
