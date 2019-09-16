//
//  MIClassViewController.m
//  MinnieManager
//
//  Created by songzhen on 2019/7/12.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import "ClassService.h"
#import "ClassTableViewCell.h"
#import "UIScrollView+Refresh.h"
#import "MIClassDetailViewController.h"
#import "PinyinHelper.h"
#import "HanyuPinyinOutputFormat.h"

@interface MIClassDetailViewController ()<
UITableViewDataSource,
UITableViewDelegate
>

@property (nonatomic, strong) NSString *nextUrl;
@property (nonatomic, strong) NSMutableArray <Clazz *> *classes;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger currentIndex;


@end

@implementation MIClassDetailViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.currentIndex = -1;
    self.tableView= [[UITableView alloc] initWithFrame:CGRectMake(0, 0, (ScreenWidth - kRootModularWidth)/2.0, ScreenHeight - 64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [UIView new];
    self.view.backgroundColor = [UIColor unSelectedColor];
    self.tableView.backgroundColor = [UIColor unSelectedColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _classes = [NSMutableArray array];
    [self.tableView registerNib:[UINib nibWithNibName:@"ClassTableViewCell" bundle:nil] forCellReuseIdentifier:ClassTableViewCellId];
    
    [self requestClasses];
}

- (void)updateClassInfo {
   
    [self resetSelectIndex];
    [self.tableView headerBeginRefreshing];
}

- (void)resetSelectIndex{
    
    self.currentIndex = -1;
    [self.tableView reloadData];
}

- (void)requestClasses {

    if (self.classes.count == 0) {
        [self.view showLoadingView];
        self.tableView.hidden = YES;
    }
    WeakifySelf;
    [ClassService requestNewClassesWithFinishState:0
                                     campusName:self.campusInfo.campusName
                                       callback:^(Result *result, NSError *error) {
                                           StrongifySelf;
                                           [strongSelf handleRequestResult:result
                                                                isLoadMore:NO
                                                                     error:error];
                                       }];
}

- (void)loadMoreClasses {

    WeakifySelf;
    [ClassService requestClassesWithNextUrl:self.nextUrl
                                   callback:^(Result *result, NSError *error) {
                                       StrongifySelf;
                                       [strongSelf handleRequestResult:result
                                                            isLoadMore:YES
                                                                 error:error];
                                   }];
}


- (void)handleRequestResult:(Result *)result
                 isLoadMore:(BOOL)isLoadMore
                      error:(NSError *)error {
    
    self.currentIndex = -1;
    if (self.delegate && [self.delegate respondsToSelector:@selector(classDetailViewControllerClickedIndex:clazz:)]) {
        
        [self.delegate classDetailViewControllerClickedIndex:self.currentIndex clazz:nil];
    }
    
    [self.view hideAllStateView];
    
    NSDictionary *dictionary = (NSDictionary *)(result.userInfo);
    NSString *nextUrl = dictionary[@"next"];
    NSArray *classes = dictionary[@"list"];
    
    if (isLoadMore) {
        [self.tableView footerEndRefreshing];
        self.tableView.hidden = NO;
        
        if (error != nil) {
            return;
        }
        
        if (classes.count > 0) {
            [self.classes addObjectsFromArray:[self sortClasses:classes]];
        }
        
        if (nextUrl.length == 0) {
            [self.tableView removeFooter];
        }
        
        [self.tableView reloadData];
    } else {
        // 停止加载
        [self.tableView headerEndRefreshing];
        self.tableView.hidden = classes.count==0;
        
        if (error != nil) {
            if (classes.count > 0) {
                [TIP showText:@"加载失败" inView:self.view];
            } else {
                WeakifySelf;
                [self.view showFailureViewWithRetryCallback:^{
                    [weakSelf requestClasses];
                }];
            }
            
            return;
        }
        
        [self.classes removeAllObjects];
        self.nextUrl = nil;
        
        if (classes.count > 0) {
            self.tableView.hidden = NO;
            
            [self.classes addObjectsFromArray:[self sortClasses:classes]];
            [self.tableView reloadData];
            
            [self.tableView addPullToRefreshWithTarget:self
                                             refreshingAction:@selector(requestClasses)];
            
            if (nextUrl.length > 0) {
                WeakifySelf;
                [self.tableView addInfiniteScrollingWithRefreshingBlock:^{
                    [weakSelf loadMoreClasses];
                }];
            } else {
                [self.tableView removeFooter];
            }
        } else {
            WeakifySelf;
            [self.view showEmptyViewWithImage:nil
                                        title:@"暂无班级"
                                centerYOffset:0
                                    linkTitle:nil
                            linkClickCallback:nil
                                retryCallback:^{
                                    
                                    [weakSelf requestClasses];
                                }];
        }
    }
    
    self.nextUrl = nextUrl;
}

- (NSArray *)sortClasses:(NSArray *)classes {
    
    NSMutableArray *tempClasses = [NSMutableArray arrayWithArray:classes];
    HanyuPinyinOutputFormat *outputFormat=[[HanyuPinyinOutputFormat alloc] init];
    [outputFormat setToneType:ToneTypeWithoutTone];
    [outputFormat setVCharType:VCharTypeWithV];
    [outputFormat setCaseType:CaseTypeUppercase];
    [tempClasses enumerateObjectsUsingBlock:^(Clazz * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *pinyin = [[PinyinHelper toHanyuPinyinStringWithNSString:obj.name withHanyuPinyinOutputFormat:outputFormat withNSString:@" "] uppercaseString];
        obj.pinyinName = pinyin;
        
    }];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"pinyinName" ascending:YES];
    NSArray *array = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [tempClasses sortUsingDescriptors:array];
    return tempClasses;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.classes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ClassTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ClassTableViewCellId forIndexPath:indexPath];
    
    Clazz *clazz = self.classes[indexPath.row];
    [cell setupWithClass:clazz];
    [cell updateSelectState:(self.currentIndex == indexPath.row) ? YES : NO];
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ClassTableViewCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    self.currentIndex = indexPath.row;
    [tableView reloadData];
    
    Clazz *clazz = self.classes[indexPath.row];
    if (self.delegate && [self.delegate respondsToSelector:@selector(classDetailViewControllerClickedIndex:clazz:)]) {
        
        [self.delegate classDetailViewControllerClickedIndex:indexPath.row clazz:clazz];
    }
}

@end
