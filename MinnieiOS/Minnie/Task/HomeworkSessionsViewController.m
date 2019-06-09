//
//  UnfinishedHomeworksViewController.m
//  X5
//
//  Created by yebw on 2017/8/27.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "ActivityInfo.h"
#import "ManagerServce.h"
#import "MIActivityBannerView.h"
#import "HomeworkSessionsViewController.h"
#import "HomeworkSessionViewController.h"
#import "HomeworkSessionTableViewCell.h"
#import "HomeworkSessionService.h"
#import "UIView+Load.h"
#import "UIScrollView+Refresh.h"
#import "IMManager.h"
#import "NetworkStateErrorView.h"
#import <AFNetworking/AFNetworking.h>
#import "AppDelegate.h"
#if TEACHERSIDE || MANAGERSIDE
#else
#import "MISutdentActDetailViewController.h"
#endif

@interface HomeworkSessionsViewController ()<
UITableViewDataSource,
UITableViewDelegate,
MIActivityBannerViewDelegate
>
{
}
//   作业状态 0：待批改；1已完成；2未提交
@property (nonatomic, assign) NSInteger mState;

@property (nonatomic, weak) IBOutlet UITableView *homeworkSessionsTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;

// 作业会话请求
@property (nonatomic, strong) BaseRequest *homeworkSessionsRequest;
// 作业会话列表
@property (nonatomic, strong) NSMutableArray <HomeworkSession *> *homeworkSessions;
@property (nonatomic, strong) NSString *nextUrl;

@property (nonatomic, assign) BOOL shouldReloadWhenAppeard;
@property (nonatomic, assign) BOOL shouldReloadTableWhenAppeard;
// 查询会话列表
@property (nonatomic, strong) NSArray *queriedConversations;
//名字搜索条件 只有在搜索页使用
@property (nonatomic, strong) NSString * searchFilterName;
//目前只有学生端处理
@property (nonatomic, strong) NSMutableArray * unReadHomeworkSessions;
@property (nonatomic, strong) NSMutableArray * noHandleNotications;

// banner 只显示在学生端，未完成
@property (nonatomic, strong) NSArray *bannerArray;
@property (nonatomic, strong) MIActivityBannerView *bannerView;

@end

@implementation HomeworkSessionsViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self != nil) {
        _homeworkSessions = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.unReadHomeworkSessions = [[NSMutableArray alloc] init];
    self.noHandleNotications = [[NSMutableArray alloc] init];
    //先读出缓存中的数据
    [self.homeworkSessions removeAllObjects];
    [self registerCellNibs];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 12.f)];
    self.homeworkSessionsTableView.tableFooterView = footerView;
    
    
    [self setupRequestState];
#if TEACHERSIDE
#else
    [self requestGetActivityList];
#endif
    
    if (self.searchFliter != -1)
    {
        [self setupAndLoadConversations];
        [self requestHomeworkSessions];
    }
    [self addNotificationObservers];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.shouldReloadWhenAppeard) {
        self.shouldReloadWhenAppeard = NO;
        
        if (self.homeworkSessions.count > 0) {
            [self.homeworkSessionsTableView headerBeginRefreshing];
        } else {
            [self requestHomeworkSessions];
        }
    } else {
        if (self.shouldReloadTableWhenAppeard) {
            self.shouldReloadTableWhenAppeard = NO;
            [self updateUI];
        }
    }
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self.homeworkSessionsRequest clearCompletionBlock];
    [self.homeworkSessionsRequest stop];
    self.homeworkSessionsRequest = nil;
    
    NSLog(@"%s", __func__);
}

#pragma mark - Public Methods

- (void)requestSearchForName:(NSString *)name
{
    self.searchFilterName = name;

    [self requestHomeworkSessions];
}

- (void)requestSearchForSorceAtIndex:(NSInteger)index
{

    self.searchFliter = index;
    
    [self requestHomeworkSessions];
}

#pragma mark - Private Methods

- (void)reloadUnReadMessage:(NSNotification *)notication
{
    //开启子线程做数据处理，避免数据交叉
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSInteger unReadCount = [[notication.userInfo objectForKey:@"unReadCount"] integerValue];
        NSInteger homeworkSessionId = [[notication.userInfo objectForKey:@"homeworkSessionId"] integerValue];
        AVIMMessage * message = [notication.userInfo objectForKey:@"lastMessage"];
        BOOL bExist = NO;  //有可能有些作业需要下拉加载才能请求出来
        //遍历请求下来的数组
        for (HomeworkSession * session in self.homeworkSessions)
        {
            if (session.homeworkSessionId == homeworkSessionId)
            {
                bExist = YES;
                session.unreadMessageCount = unReadCount;
                if (unReadCount == 0)
                {
                    //一般由点击事件产生,需要在重新进入页面的时候
                    [self.unReadHomeworkSessions removeObject:session];
                    self.shouldReloadTableWhenAppeard = YES;
                    
                }
                else
                {
                    
                    if (![self.unReadHomeworkSessions containsObject:session])
                    {
                        [self.unReadHomeworkSessions addObject:session];
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self reloadTableViewForNewMessage:message];
                    });
                }
                break;
            }
        }
//        dispatch_async(dispatch_get_main_queue(), ^{
//            NSInteger tabbarCount = self.unReadHomeworkSessions.count + self.noHandleNotications.count;
//            AppDelegate * appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
          //  [appDel showTabBarBadgeNum:tabbarCount atIndex:0];
//        });

    });
}

- (void)setupRequestState
{   // 学生端：未完成、已完成
    // 老师端：待批改、已完成、未提交
    if (self.isUnfinished)// 进行中
    {
        if (self.bLoadConversion)
        {//   作业状态 0：待批改；1已完成；2未提交
            self.mState = 0;
        }
        else
        {
            self.mState = 2;
        }
    }
    else
    {
        self.mState = 1;
    }
}

- (void)registerCellNibs {
    [self.homeworkSessionsTableView registerNib:[UINib nibWithNibName:@"FinishedHomeworkSessionTableViewCell" bundle:nil] forCellReuseIdentifier:FinishedHomeworkSessionTableViewCellId];
//    [self.homeworkSessionsTableView registerNib:[UINib nibWithNibName:@"UnfinishedHomeworkSessionTableViewCell" bundle:nil] forCellReuseIdentifier:UnfinishedHomeworkSessionTableViewCellId];
    [self.homeworkSessionsTableView registerNib:[UINib nibWithNibName:@"UnfinishedStudentHomeworkSessionTableViewCell" bundle:nil] forCellReuseIdentifier:UnfinishedStudentHomeworkSessionTableViewCellId];
}
#pragma mark -
#pragma mark - 添加观察者 && 处理事件
- (void)addNotificationObservers {
    
    // 编辑标注后刷新列表
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadForDoubleTabClick) name:kNotificationKeyOfStudentMarkChange object:nil];
    // 双击tab刷新作业列表
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadForDoubleTabClick)
                                                 name:kNotificationKeyOfTabBarDoubleClick
                                               object:nil];
    // 后台唤起重新刷新任务列表
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadWhenAppeared:)
                                                 name:kNotificationKeyOfRefreshHomeworkSession
                                               object:nil];
    // 未读消息个数通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadUnReadMessage:)
                                                 name:kIMManagerClientUnReadMessageCountNotification
                                               object:nil];
    // 下线通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(imOffline:)
                                                 name:kIMManagerClientOfflineNotification
                                               object:nil];
    // 上线通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(imOnline:)
                                                 name:kIMManagerClientOnlineNotification
                                               object:nil];
    // 接收到会话消息通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(lastMessageDidChange:)
                                                 name:kIMManagerContentMessageDidReceiveNotification
                                               object:nil];
    // 发送消息成功通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(lastMessageDidChange:)
                                                 name:kIMManagerContentMessageDidSendNotification
                                               object:nil];
    // 教师删除一个班级
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadWhenAppeared:)
                                                 name:kNotificationKeyOfDeleteClass
                                               object:nil];
    // 教师端发送一个作业
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadWhenAppeared:)
                                                 name:kNotificationKeyOfSendHomework
                                               object:nil];
     // 教师端删除学生
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadWhenAppeared:)
                                                 name:kNotificationKeyOfDeleteClassStudents
                                               object:nil];
    // 教师批改作业
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadWhenHomeworkCorrected:)
                                                 name:kNotificationKeyOfCorrectHomework
                                               object:nil];
    // 学生重做作业
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadWhenAppeared:)
                                                 name:kNotificationKeyOfRedoHomework
                                               object:nil];
    // 教师端添加一个作业
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadWhenAppeared:)
                                                 name:kNotificationKeyOfAddHomework
                                               object:nil];
    // 推送唤起程序刷新作业新任务列表
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(apnsRefreshHomeworkSession:)
                                                 name:kNotificationKeyOfApnsNewHomeworkSession
                                               object:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(apnsRefreshHomeworkSession:)
//                                                 name:kNotificationKeyOfApnsFinishHomeworkSession
//                                               object:nil];
}

- (void)setupAndLoadConversations {
    if (!self.isUnfinished)
    {
        return;
    }
    //不需要加载
    if (!self.bLoadConversion)
    {
        return;
    }
    
    NSString *userId = [NSString stringWithFormat:@"%@", @(APP.currentUser.userId)];
    [[IMManager sharedManager] setupWithClientId:userId callback:^(BOOL success,  NSError * error) {
        if (!success) {
            return;
        }
        [self loadConversations];
    }];
}

#pragma mark -
#pragma mark - 查询消息会话，并最后一条消息内容
- (void)loadConversations {
   
    if (!self.homeworkSessions) {
        return;
    }
    NSDate *startTime = [NSDate date];
    AVIMClient *client = [IMManager sharedManager].client;
    NSMutableArray *queryArr = [NSMutableArray array];
    NSArray *homeworkSessions = self.homeworkSessions;
    for (HomeworkSession *homeworkSession in homeworkSessions) {
        NSString *name = [NSString stringWithFormat:@"%ld",(long)homeworkSession.homeworkSessionId];
        AVIMConversationQuery *query = [client conversationQuery];
        [query whereKey:@"name" equalTo:name];
        [queryArr addObject:query];
    }
    // 通过组合的方式，根据唯一homeworkSessionId，查询指定作业的消息会话内容，明确会话数量，减少耗时
    AVIMConversationQuery *conversation = [AVIMConversationQuery orQueryWithSubqueries:queryArr];
    // 缓存 先走网络查询，发生网络错误的时候，再从本地查询
    conversation.cachePolicy = kAVIMCachePolicyCacheElseNetwork;
    // 设置查询选项，指定返回对话的最后一条消息
    conversation.option = AVIMConversationQueryOptionWithMessage;
    // 每条作业 homeworkSessionId唯一 限制查询数量，减少耗时
    conversation.limit = homeworkSessions.count;
    [conversation findConversationsWithCallback:^(NSArray<AVIMConversation *> * _Nullable conversations, NSError * _Nullable error) {
        if (error) return ;
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.queriedConversations = conversations;
            [self mergeAndReload];
        });
        NSLog(@" ======= 会话数:%@ 耗时%.fms", @(conversations.count), [[NSDate date] timeIntervalSinceDate:startTime]*1000);
    }];
}
- (void)reloadForDoubleTabClick
{
    if (self.homeworkSessions.count > 0) {
        [self.homeworkSessionsTableView headerBeginRefreshing];
    } else {
        [self requestHomeworkSessions];
    }
}

- (void)mergeAndReload {
    // 进行一个排序
    if (self.homeworkSessions.count == 0) {
        return;
    }
    for (HomeworkSession *homeworkSession in self.homeworkSessions) {
       
        for (AVIMConversation *conversation in self.queriedConversations) {
            
            if ([conversation.name integerValue] == homeworkSession.homeworkSessionId) {
                homeworkSession.conversation = conversation;
                homeworkSession.unreadMessageCount = conversation.unreadMessagesCount;
                
                AVIMMessage *message = conversation.lastMessage;
                if ([message isKindOfClass:[AVIMTextMessage class]]) {
                    homeworkSession.lastSessionContent = ((AVIMTextMessage *)message).text;
                } else if ([message isKindOfClass:[AVIMAudioMessage class]]) {
                    homeworkSession.lastSessionContent = @"[音频]";
                } else if ([message isKindOfClass:[AVIMVideoMessage class]]) {
                    homeworkSession.lastSessionContent = @"[视频]";
                } else if ([message isKindOfClass:[AVIMImageMessage class]]) {
                    homeworkSession.lastSessionContent = @"[图片]";
                }
#if TEACHERSIDE
                homeworkSession.shouldColorLastSessionContent = message.ioType == AVIMMessageIOTypeOut;
#else
                homeworkSession.shouldColorLastSessionContent = message.ioType == AVIMMessageIOTypeIn;
                
                if (homeworkSession.updateTime == 0 && message != nil)
                {
                    [self updateHomeworkSessionModifiedTime:homeworkSession];
                }
#endif
                break;
            }
        }
        if (homeworkSession.conversation.lastMessageAt != nil) {
            homeworkSession.sortTime = [homeworkSession.conversation.lastMessageAt timeIntervalSince1970] * 1000;
            
        } else {
            homeworkSession.sortTime = homeworkSession.updateTime;
        }
    }
    self.homeworkSessions = [self handleRepeat:self.homeworkSessions];
    [self updateUI];
}

// 消息去重
- (NSMutableArray *)handleRepeat:(NSArray *)homework{
    
    NSMutableArray *resultArrM = [NSMutableArray array];
    for (HomeworkSession *session in homework) {
        if (![resultArrM containsObject:session]) {
            [resultArrM addObject:session];
        }
    }
    return resultArrM;
}

- (void)updateHomeworkSessionModifiedTime:(HomeworkSession *)homeworkSession
{
    [HomeworkSessionService updateHomeworkSessionModifiedTimeWithId:homeworkSession.homeworkSessionId
                                                           callback:^(Result *result, NSError *error) {
                                                           }];
}

- (void)apnsRefreshHomeworkSession:(NSNotification *)notification
{
    if (self.homeworkSessions.count > 0) {
        [self.homeworkSessionsTableView headerBeginRefreshing];
    } else {
        [self requestHomeworkSessions];
    }
}

- (void)reloadWhenAppeared:(NSNotification *)notification {
    self.shouldReloadWhenAppeard = YES;
}

- (void)reloadWhenHomeworkCorrected:(NSNotification *)notification {
    if (!self.isUnfinished) {
        self.shouldReloadWhenAppeard = YES;
        
        return;
    }
    
    if (!self.bLoadConversion) {
        self.shouldReloadWhenAppeard = YES;
        
        return;
    }
    
    HomeworkSession *session = notification.userInfo[@"HomeworkSession"];
    if (session == nil) {
        return;
    }
    
    BOOL found = NO;
    for (HomeworkSession *s in self.homeworkSessions) {
        if (s.homeworkSessionId == session.homeworkSessionId) {
            [self.homeworkSessions removeObject:s];
            found = YES;
            break;
        }
    }
    
    if (found) {
        self.shouldReloadTableWhenAppeard = YES;
    }
}

- (void)imOnline:(NSNotification *)notification {
    [self.homeworkSessionsTableView setTableHeaderView:nil];
}

- (void)imOffline:(NSNotification *)notification {
    if (self.homeworkSessionsTableView.tableHeaderView != nil) {
        return;
    }
    
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus != AFNetworkReachabilityStatusNotReachable) {
        [self.homeworkSessionsTableView setTableHeaderView:nil];
        
        return ;
    }
    
    NetworkStateErrorView *errorView = [[[NSBundle mainBundle] loadNibNamed:@"NetworkStateErrorView" owner:nil options:0] lastObject];
    
    self.homeworkSessionsTableView.tableHeaderView = errorView;
}

- (void)lastMessageDidChange:(NSNotification *)notification {
   
    if (!self.isUnfinished) {
        return ;
    }
    AVIMMessage *message = (AVIMMessage *)(notification.userInfo)[@"message"];
    [self reloadTableViewForNewMessage:message];
}


- (void)reloadTableViewForNewMessage:(AVIMMessage *)message
{
    NSDictionary *attributes = ((AVIMTypedMessage *)message).attributes;
#if TEACHERSIDE
#else
    if (attributes[@"score"] != nil && [attributes[@"score"] integerValue]>=0) {
        if (self.homeworkSessions.count > 0) {
            [self.homeworkSessionsTableView headerBeginRefreshing];
        } else {
            [self requestHomeworkSessions];
        }
        return ;
    }
#endif
    
    // 更新新消息内容
    AVIMConversation *messageConversation = [[IMManager sharedManager].client conversationForId:message.conversationId];
    NSString *homeworkSessionId = messageConversation.name;
    // 当前会话已存在
    BOOL bExit = NO;
    for (HomeworkSession *homeworkSession in self.homeworkSessions) {
        if (homeworkSession.homeworkSessionId == homeworkSessionId.integerValue) {
            if (homeworkSession.conversation == nil) {
                homeworkSession.conversation = messageConversation;
            }
            [self loadConversations];
            bExit = YES;
            break;
        }
    }
    
    if (!bExit) {
        
        if (attributes[@"score"] == nil  && self.bLoadConversion) {
            // 会话消息不存在
            [HomeworkSessionService requestHomeworkSessionWithId:homeworkSessionId.integerValue callback:^(Result *result, NSError *error) {
                if (error != nil) {
                    return;
                }
                HomeworkSession *session = (HomeworkSession *)(result.userInfo);
                [self.homeworkSessions addObject:session];
                [self loadConversations];
            }];
        }
    }
}

#pragma mark -
#pragma mark - 获取作业列表  加载更多  处理请求作业列表结果
- (void)requestHomeworkSessions {
   
    if (self.homeworkSessionsRequest != nil) {
        return;
    }
    if (self.homeworkSessions.count == 0) {
        [self.view showLoadingView];
        self.homeworkSessionsTableView.hidden = YES;
    }
    WeakifySelf;
    if (self.searchFliter == -1) //-1 表示是按名字搜索
    {
        if ([self.searchFilterName length] == 0)
        {
            return;
        }
        WeakifySelf;
        self.homeworkSessionsRequest = [HomeworkSessionService searchHomeworkSessionWithName:self.searchFilterName forState:self.mState callback:^(Result *result, NSError *error) {
            StrongifySelf;
            [strongSelf handleRequestResult:result isLoadMore:NO error:error];
        }];
        
    }
    else if (self.searchFliter == 0) // 0 按时间
    {
        self.homeworkSessionsRequest = [HomeworkSessionService requestHomeworkSessionsWithFinishState:self.mState
                                                                                             callback:^(Result *result, NSError *error) {
                                                                                                 StrongifySelf;
                                                                                                 [strongSelf handleRequestResult:result
                                                                                                                      isLoadMore:NO error:error];
                                                                                             }];
    }
    else
    {
        // searchFliter  1 按作业 2 按人
        // mState        0：待批改；1已完成；2未提交
       WeakifySelf;
#if TEACHERSIDE
        self.homeworkSessionsRequest = [HomeworkSessionService searchHomeworkSessionWithType:self.searchFliter forState:self.mState callback:^(Result *result, NSError *error) {
            
            StrongifySelf;
            [strongSelf handleRequestResult:result isLoadMore:NO error:error];
        }];
#else
        self.homeworkSessionsRequest = [HomeworkSessionService searchHomeworkSessionWithScore:self.searchFliter - 1 callback:^(Result *result, NSError *error) {
            
            StrongifySelf;
            [strongSelf handleRequestResult:result isLoadMore:NO error:error];
            
        }];
#endif
    }
}
- (void)loadMoreHomeworkSessions {
   
    if (self.homeworkSessionsRequest != nil) {
        return;
    }
    WeakifySelf;
    if (self.searchFliter == -1) //-1 表示是按名字搜索
    {
        self.homeworkSessionsRequest = [HomeworkSessionService searchHomeworkSessionWithNameWithNextUrl:self.nextUrl callback:^(Result *result, NSError *error) {
            StrongifySelf;
            [strongSelf handleRequestResult:result
                                 isLoadMore:YES                    error:error];
        }];
    }
    else if (self.searchFliter == 0) // 0 按时间
    {
        self.homeworkSessionsRequest = [HomeworkSessionService requestHomeworkSessionsWithNextUrl:self.nextUrl
                                                                                         callback:^(Result *result, NSError *error) {
                                                                                             StrongifySelf;
                                                                                             [strongSelf handleRequestResult:result
                                                                                                                  isLoadMore:YES                    error:error];
                                                                                         }];
    }
    else
    {
        
        // searchFliter  1 按作业 2 按人
        // mState        0：待批改；1已完成；2未提交
#if TEACHERSIDE
        self.homeworkSessionsRequest = [HomeworkSessionService searchHomeworkSessionWithTypeWithNextUrl:self.nextUrl callback:^(Result *result, NSError *error) {
            StrongifySelf;
            [strongSelf handleRequestResult:result isLoadMore:YES error:error];
        }];
#else
        self.homeworkSessionsRequest = [HomeworkSessionService searchHomeworkSessionWithScoreWithNextUrl:self.nextUrl callback:^(Result *result, NSError *error) {
            
            StrongifySelf;
            [strongSelf handleRequestResult:result isLoadMore:YES error:error];
            
        }];
#endif
    }
}

- (void)handleRequestResult:(Result *)result
                 isLoadMore:(BOOL)isLoadMore
                      error:(NSError *)error {
    [self.homeworkSessionsRequest clearCompletionBlock];
    self.homeworkSessionsRequest = nil;
    
    [self.view hideAllStateView];
    
    NSDictionary *dictionary = (NSDictionary *)(result.userInfo);
    NSString *nextUrl = dictionary[@"next"];
    NSArray *homeworkSessions = dictionary[@"list"];
    
    if (isLoadMore) {
        [self.homeworkSessionsTableView footerEndRefreshing];
        self.homeworkSessionsTableView.hidden = NO;
        
        if (error != nil) {
            return;
        }
        
        if (homeworkSessions.count > 0) {
            // 去重
            NSMutableArray *sessions = [NSMutableArray array];
            for (HomeworkSession *session in homeworkSessions) {
                BOOL exists = NO;
                for (HomeworkSession *s in self.homeworkSessions) {
                    if (s.homeworkSessionId == session.homeworkSessionId) {
                        exists = YES;
                        break;
                    }
                }
                if (!exists) {
                    [sessions addObject:session];
                }
            }
            
            [self.homeworkSessions addObjectsFromArray:sessions];
        }
        [self loadConversations];
        if (nextUrl.length == 0) {
            [self.homeworkSessionsTableView removeFooter];
        }
        
    } else {
        // 停止加载
        [self.homeworkSessionsTableView headerEndRefreshing];
        self.homeworkSessionsTableView.hidden = homeworkSessions.count==0;
        
        if (error != nil) {
            if (homeworkSessions.count > 0) {
                [TIP showText:@"加载失败" inView:self.view];
            } else {
                WeakifySelf;
                [self.view showFailureViewWithRetryCallback:^{
                    [weakSelf requestHomeworkSessions];
                }];
            }
            
            return;
        }
        
        [self.homeworkSessions removeAllObjects];
        self.nextUrl = nil;
        
        if (homeworkSessions.count > 0) {
            self.homeworkSessionsTableView.hidden = NO;
            
            [self.homeworkSessions addObjectsFromArray:homeworkSessions];
            [self loadConversations];
            [self.homeworkSessionsTableView addPullToRefreshWithTarget:self
                                                      refreshingAction:@selector(pullToRefresh)];
            
            if (nextUrl.length > 0) {
                WeakifySelf;
                [self.homeworkSessionsTableView addInfiniteScrollingWithRefreshingBlock:^{
                    [weakSelf loadMoreHomeworkSessions];
                }];
            } else {
                [self.homeworkSessionsTableView removeFooter];
            }
        } else {
            UIImage *image = self.isUnfinished?[UIImage imageNamed:@"缺省插画_无作业"]:nil;
            NSString *text = nil;
            
#if TEACHERSIDE
            text = self.isUnfinished?@"好棒！所有作业都批改完了！":@"还没有批改过的作业~";
#else
            text = self.isUnfinished?@"好棒！所有作业都完成了！\n去同学圈看看大家做得怎么样":@"还没有完成过作业";
#endif
            
            WeakifySelf;
            [self.view showEmptyViewWithImage:image
                                        title:text
                                centerYOffset:0
                                    linkTitle:nil
                            linkClickCallback:nil
                                retryCallback:^{
                                    [weakSelf requestHomeworkSessions];
                                }];
        }
    }
    self.nextUrl = nextUrl;
}
- (void)pullToRefresh{
    
#if TEACHERSIDE || MANAGERSIDE
    [self requestHomeworkSessions];
#else
    [self requestGetActivityList];
#endif
}

#pragma mark - 获取活动列表
- (void)requestGetActivityList{
    WeakifySelf;
    [ManagerServce requestGetActivityListWithCallback:^(Result *result, NSError *error) {
        
        NSDictionary *dict = (NSDictionary *)result.userInfo;
        NSArray *list = dict[@"list"];
        
        ActivityInfo *act2 = [[ActivityInfo alloc] init];
        act2.activityId = 9;
        act2.actCoverUrl = @"http://res.zhengminyi.com/FtlXAfzMJPI6YyO3fiQQUcVw9LQT";
        HomeworkItem *textItem2 = [[HomeworkItem alloc] init];
        textItem2.type = @"text";
        textItem2.text = @"测试测试测试测试测哈哈哈哈啊哈哈👌试测试测测哈哈哈哈啊哈哈👌试测试测试测哈哈哈哈啊哈哈👌试测试测试测哈哈哈哈啊哈哈👌试测试测试试测试测试";
        
        HomeworkItem *textItem3 = [[HomeworkItem alloc] init];
        textItem3.type = @"video";
        textItem3.videoUrl = @"http://file.zhengminyi.com/mBa6QMBfbOttwEAqplMNPoD.mp4";
        
        HomeworkItem *textItem4 = [[HomeworkItem alloc] init];
        textItem4.type = @"image";
        textItem4.imageUrl = @"http://res.zhengminyi.com/FtlXAfzMJPI6YyO3fiQQUcVw9LQT";
      
        act2.items = @[textItem2,textItem3,textItem4];
        
        ActivityInfo *act1 = [[ActivityInfo alloc] init];
        act1.activityId = 11;
        act1.actCoverUrl = @"http://res.zhengminyi.com/FtlXAfzMJPI6YyO3fiQQUcVw9LQT";
        HomeworkItem *textItem = [[HomeworkItem alloc] init];
        textItem.type = @"text";
        textItem.text = @"测试测试测试测试测试测试测试测试测试";
        act1.items = @[textItem];
    
//        list = @[act1,act2];
        weakSelf.bannerArray = list;
        if (weakSelf.mState == 0) {
            weakSelf.topConstraint.constant = 124;
            [weakSelf.view addSubview:weakSelf.bannerView];
            weakSelf.bannerView.imagesGroup = list;
        } else {
            weakSelf.topConstraint.constant = 0;
            if (weakSelf.bannerView.superview) {
                [weakSelf.bannerView removeFromSuperview];
            }
        }
    }];
}

#pragma mark - MIActivityBannerViewDelegate
- (void)bannerView:(MIActivityBannerView *)bannerView didSelectItemAtIndex:(NSInteger)index{
    
#if TEACHERSIDE || MANAGERSIDE
#else
    ActivityInfo *actInfo = self.bannerArray[index];
    MISutdentActDetailViewController *stuActDetailVC = [[MISutdentActDetailViewController alloc] initWithNibName:NSStringFromClass([MISutdentActDetailViewController class]) bundle:nil];
    stuActDetailVC.actInfo = actInfo;
    [stuActDetailVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:stuActDetailVC animated:YES];
    
#endif
}

#pragma mark -
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.homeworkSessions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= self.homeworkSessions.count) {
        return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Empty"];
    }
    
    HomeworkSessionTableViewCell *cell = nil;
    
    if (self.isUnfinished) {
//#if TEACHERSIDE
//        cell = [tableView dequeueReusableCellWithIdentifier:UnfinishedHomeworkSessionTableViewCellId forIndexPath:indexPath];
//#else
        cell = [tableView dequeueReusableCellWithIdentifier:UnfinishedStudentHomeworkSessionTableViewCellId forIndexPath:indexPath];
//#endif
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:FinishedHomeworkSessionTableViewCellId forIndexPath:indexPath];
    }
    
    HomeworkSession *homeworkSession = self.homeworkSessions[indexPath.row];
    [cell setupWithHomeworkSession:homeworkSession];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= self.homeworkSessions.count) {
        return 0.f;
    }
    
    HomeworkSession *session = self.homeworkSessions[indexPath.row];
    CGFloat height = [HomeworkSessionTableViewCell cellHeightWithHomeworkSession:session
                                                                        finished:!self.isUnfinished];
    
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row >= self.homeworkSessions.count) {
        return ;
    }
    AVIMClientStatus status = [IMManager sharedManager].client.status;
    if (status == AVIMClientStatusNone ||
        status == AVIMClientStatusClosed ||
        status == AVIMClientStatusPaused) {
        NSString *userId = [NSString stringWithFormat:@"%@", @(APP.currentUser.userId)];
        [[IMManager sharedManager] setupWithClientId:userId callback:^(BOOL success,  NSError * error) {
            if (!success) {
                return;
            }
        }];
    }
    if (status != AVIMClientStatusOpened) {
        [HUD showErrorWithMessage:@"IM服务暂不可用，请稍后再试"];
        
        return ;
    }
    
    HomeworkSession *session = self.homeworkSessions[indexPath.row];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.homeworkSessionsTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//    });
    
    HomeworkSessionViewController *vc = [[HomeworkSessionViewController alloc] initWithNibName:@"HomeworkSessionViewController" bundle:nil];
    vc.homeworkSession = session;
    [vc setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 更新UI
- (void)updateUI{
    
    if (self.homeworkSessions.count == 0) {
        UIImage *image = self.isUnfinished?[UIImage imageNamed:@"缺省插画_无作业"]:nil;
        NSString *text = nil;
        
#if TEACHERSIDE
        if (self.isUnfinished)
        {
            text = self.bLoadConversion? @"好棒！所有作业都批改完了！":@"还有没作业的提交~";
        }
        else
        {
            text = @"还没有批改过的作业~";
        }
#else
        text = self.isUnfinished?@"好棒！所有作业都完成了！\n去同学圈看看大家做得怎么样":@"还没有完成过作业";
#endif
        
        WeakifySelf;
        [self.view showEmptyViewWithImage:image
                                    title:text
                            centerYOffset:0
                                linkTitle:nil
                        linkClickCallback:nil
                            retryCallback:^{
                                [weakSelf requestHomeworkSessions];
                            }];
    } else {
        [self.view hideAllStateView];
        self.homeworkSessionsTableView.hidden = NO;
    }
    
    [self.homeworkSessionsTableView reloadData];
}

#pragma mark - setter && getter
- (MIActivityBannerView *)bannerView
{
    if (!_bannerView) {
        _bannerView = [[MIActivityBannerView alloc] initWithFrame:CGRectMake(0, 12, ScreenWidth, 110)];
        _bannerView.delegate = self;
        _bannerView.backgroundColor = [UIColor bgColor];
    }
    return _bannerView;
}
@end



