//
//  MIScoreListViewController.m
//  
//
//  Created by songzhen on 2019/5/31.
//

#import "MIMoveHomeworkTaskView.h"
#import "MICreateHomeworkTaskView.h"
#import "MIScoreListTableViewCell.h"
#import "MIScoreListViewController.h"

@interface MIScoreListViewController ()<
UITableViewDelegate,
UITableViewDataSource
>

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (strong, nonatomic) NSMutableArray *scoreListArray;

@end

@implementation MIScoreListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configureUI];
}

-(void)configureUI{
    
    self.view.backgroundColor = [UIColor bgColor];
    self.scoreListArray = [NSMutableArray array];
    
    UIView *footrView = [[UIView alloc] init];
    footrView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = footrView;
    _tableView.cellLayoutMarginsFollowReadableWidth = NO;
}

- (IBAction)backAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)moveTaskAction:(id)sender {
    
    MIMoveHomeworkTaskView *view = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MIMoveHomeworkTaskView class]) owner:nil options:nil].lastObject;
    view.frame = [UIScreen mainScreen].bounds;
    view.isMultiple = NO;
    view.callback = ^(NSInteger index) {
        if (index == 1) {// 选择一级文件
            
        } else {
            
        }
    };
    [[UIApplication sharedApplication].keyWindow addSubview:view];
}

- (IBAction)editTaskAction:(id)sender {
    
    MICreateHomeworkTaskView *createTaskView =  [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MICreateHomeworkTaskView class]) owner:nil options:nil].lastObject;
    createTaskView.frame = [UIScreen mainScreen].bounds;
    createTaskView.callBack = ^{
        
    };
    [createTaskView setupCreateHomework:nil taskType:MIHomeworkTaskType_notify];
    [[UIApplication sharedApplication].keyWindow addSubview:createTaskView];
    
}


#pragma mark -
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 15;
    return self.scoreListArray.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return MIScoreListTableViewCellHeight;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MIScoreListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MIScoreListTableViewCellId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MIScoreListTableViewCell class]) owner:nil options:nil] lastObject];
    }
    //    MIParticipateModel *model = self.uploadArray[indexPath.row];
    //    [cell setupWithModel:model];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}


@end
