//
//  MIScoreListViewController.m
//  
//
//  Created by songzhen on 2019/5/31.
//


#import "Result.h"
#import "ScoreInfo.h"
#import "ManagerServce.h"
#import "HomeworkSessionService.h"
#import "UIScrollView+Refresh.h"
#import "MIMoveHomeworkTaskView.h"
#import "MIScoreListTableViewCell.h"
#import "MIScoreListViewController.h"
#import "CSCustomSplitViewController.h"
#import "MICreateTaskViewController.h"
#import "HomeworkSessionViewController.h"

@interface MIScoreListViewController ()<
UITableViewDelegate,
UITableViewDataSource
>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *scoreListArray;

@property (nonatomic ,copy) NSString *nextUrl;

@property (nonatomic ,assign) BOOL *isLoadMore;

@end

@implementation MIScoreListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configureUI];
    [self requestScoreListIsLoadMore:NO];
}

-(void)configureUI{
    
    self.view.backgroundColor = [UIColor whiteColor];
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
    WeakifySelf;
    view.callback = ^{
        
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    view.homeworkIds = @[@(self.homework.homeworkId)];
    view.currentFileInfo = self.currentFileInfo;
    [[UIApplication sharedApplication].keyWindow addSubview:view];
}

- (IBAction)editTaskAction:(id)sender {

    MICreateTaskViewController *createVC = [[MICreateTaskViewController alloc] init];
    createVC.teacherSider = self.teacherSider;
    [createVC setupCreateHomework:self.homework currentFileInfo:self.currentFileInfo taskType:-1];
    WeakifySelf;
    createVC.callBack = ^(BOOL isDelete) {
        if (weakSelf.callBack) {
            weakSelf.callBack();
        }
    };
    [self.navigationController pushViewController:createVC animated:YES];
}

#pragma mark -
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
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
        ScoreInfo*model = self.scoreListArray[indexPath.row];
        [cell setupModel:model];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WeakifySelf;
    [HomeworkSessionService requestHomeworkSessionWithId:self.homework.homeworkId callback:^(Result *result, NSError *error) {
        if (error != nil) {
            return;
        }
        HomeworkSession *session = (HomeworkSession *)(result.userInfo);
        HomeworkSessionViewController *vc = [[HomeworkSessionViewController alloc] initWithNibName:@"HomeworkSessionViewController" bundle:nil];
        vc.homeworkSession = session;
        [vc setHidesBottomBarWhenPushed:YES];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
  
}
#pragma mark - 获取列表
- (void)requestScoreListIsLoadMore:(BOOL)isLoadMore{
    
    if (isLoadMore) {
        WeakifySelf;
        [ManagerServce requestScoreListByHomeworkId:self.homework.homeworkId nextUrl:nil callback:^(Result *result, NSError *error) {
            [self.tableView footerEndRefreshing];
            if (error) return;
            [weakSelf dealWithData:result isLoadMore:isLoadMore];
        }];
    } else {
        WeakifySelf;
        [ManagerServce requestScoreListByHomeworkId:self.homework.homeworkId nextUrl:self.nextUrl callback:^(Result *result, NSError *error) {
            
            [self.tableView footerEndRefreshing];
            if (error) return;
            [weakSelf dealWithData:result isLoadMore:isLoadMore];
        }];
    }
}

- (void)dealWithData:(Result *)result isLoadMore:(BOOL)isLoadMore{
    
    NSDictionary *dict = (NSDictionary *)(result.userInfo);
    NSArray *scoreList = (NSArray *)(dict[@"list"]);
    NSString *nextUrl = dict[@"next"];
    if (isLoadMore) {
        [self.scoreListArray addObjectsFromArray:scoreList];
    } else {
        [self.scoreListArray removeAllObjects];
        [self.scoreListArray addObjectsFromArray:scoreList];
    }
    self.nextUrl = nextUrl;
    if (self.nextUrl.length >0) {
        WeakifySelf;
        [self.tableView addInfiniteScrollingWithRefreshingBlock:^{
            
            [weakSelf requestScoreListIsLoadMore:YES];
        }];
    } else {
        [self.tableView removeFooter];
    }
    [self.tableView reloadData];
}

- (FileInfo *)currentFileInfo{
    
    if (!_currentFileInfo) {
        _currentFileInfo = [[FileInfo alloc] init];
    }
    return _currentFileInfo;
}

@end
