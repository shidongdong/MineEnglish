//
//  MIAuthorPreviewViewController.m
//  Minnie
//
//  Created by songzhen on 2019/8/14.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import "MIAuthorPreviewViewController.h"
//#import "MITeacherAuthorTableViewCell.h"

@interface MIAuthorPreviewViewController ()<
UITableViewDelegate,
UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MIAuthorPreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (self.authorManagerType == MIAuthorManagerTeacherPreviewType) {
        self.titleLabel.text = @"教师任务查看";
    } else if (self.authorManagerType == MIAuthorManagerHomeworkPreviewType) {
        self.titleLabel.text = @"作业查看";
    } else if (self.authorManagerType == MIAuthorManagerClassPreviewType) {
        self.titleLabel.text = @"班级信息查看";
    } else if (self.authorManagerType == MIAuthorManagerStudentPreviewType) {
        self.titleLabel.text = @"学生信息查看";
    }
    AuthorPreview *author = [[AuthorPreview alloc] init];
    author.name = self.titleLabel.text;
    author.state = YES;
    self.authorArray = (NSArray<AuthorPreview>*)@[author,author,author,author,author,author],
    
    self.tableView.tableFooterView = [UIView new];
}

- (IBAction)backAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.authorArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return MITeacherAuthorTableViewCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MITeacherAuthorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MITeacherAuthorTableViewCellId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MITeacherAuthorTableViewCell class]) owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    AuthorPreview *author = self.authorArray[indexPath.row];
    NSString *avatar = nil;
    if (self.authorManagerType == MIAuthorManagerTeacherPreviewType) {
        
        if (author.avatarUrl.length == 0) {
            avatar = @"attachment_placeholder";
        } else {
            avatar = author.avatarUrl;
        }
    }
    [cell setupTitle:author.name
                text:nil
               image:avatar
          authorType:self.authorManagerType
                type:2
               state:author.state];
    cell.stateBlock = ^(MIAuthorManagerType authorType, BOOL state) {
        
    };
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
