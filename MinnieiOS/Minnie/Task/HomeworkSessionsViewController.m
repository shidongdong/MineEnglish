//
//  UnfinishedHomeworksViewController.m
//  X5
//
//  Created by yebw on 2017/8/27.
//  Copyright © 2017年 mfox. All rights reserved.
//

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
@interface HomeworkSessionsViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSInteger mState;
    
}
@property (nonatomic, weak) IBOutlet UITableView *homeworkSessionsTableView;

@property (nonatomic, strong) BaseRequest *homeworkSessionsRequest;

@property (nonatomic, strong) NSMutableArray <HomeworkSession *> *homeworkSessions;
@property (nonatomic, strong) NSString *nextUrl;

@property (nonatomic, assign) BOOL shouldReloadWhenAppeard;
@property (nonatomic, assign) BOOL shouldReloadTableWhenAppeard;

@property (nonatomic, strong) NSArray *queriedConversations;

@property (nonatomic, strong) NSString * searchFilterName;   //名字搜索条件 只有在搜索也使用

//目前只有学生端处理
@property (nonatomic, strong) NSMutableArray * unReadHomeworkSessions;
@property (nonatomic, strong) NSMutableArray * noHandleNotications;

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
//   缓存无效 建议后期再考虑
//    if (self.isUnfinished)
//    {
//        if (self.bLoadConversion)
//        {
//            [self.homeworkSessions addObjectsFromArray:APP.unfinishHomeworkSessionList];
//        }
//        else
//        {
//            [self.homeworkSessions addObjectsFromArray:APP.unCommitHomeworkSessionList];
//        }
//    }
//    else
//    {
//        [self.homeworkSessions addObjectsFromArray:APP.finishHomeworkSessionList];
//    }
    
    
    [self registerCellNibs];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 12.f)];
    self.homeworkSessionsTableView.tableFooterView = footerView;
    
    [self setupRequestState];
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
            }

            [self.homeworkSessionsTableView reloadData];
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
//        if (!bExist)
//        {
//            BOOL bHandle = NO;
//            
//            for (NSNotification * noHandleNoti in self.noHandleNotications)
//            {
//                NSInteger noHandleHomeworkSessionId = [[noHandleNoti.userInfo objectForKey:@"homeworkSessionId"] integerValue];
//                
//                if (noHandleHomeworkSessionId == homeworkSessionId)
//                {
//                    NSInteger noHandleindex = [self.noHandleNotications indexOfObject:noHandleNoti];
//                    [self.noHandleNotications replaceObjectAtIndex:noHandleindex withObject:notication];
//                    bHandle = YES;
//                    break;
//                }
//                
//            }
//            
//            
//            if (!bHandle)
//            {
//                [self.noHandleNotications addObject:notication];
//            }
//            
//        }
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSInteger tabbarCount = self.unReadHomeworkSessions.count + self.noHandleNotications.count;
            
            AppDelegate * appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
          //  [appDel showTabBarBadgeNum:tabbarCount atIndex:0];
            
        });

    });

    
    
    
}

- (void)setupRequestState
{
    if (self.isUnfinished)
    {
        if (self.bLoadConversion)
        {
            mState = 0;
        }
        else
        {
            mState = 2;
        }
    }
    else
    {
        mState = 1;
    }
}

- (void)registerCellNibs {
    [self.homeworkSessionsTableView registerNib:[UINib nibWithNibName:@"FinishedHomeworkSessionTableViewCell" bundle:nil] forCellReuseIdentifier:FinishedHomeworkSessionTableViewCellId];
    [self.homeworkSessionsTableView registerNib:[UINib nibWithNibName:@"UnfinishedHomeworkSessionTableViewCell" bundle:nil] forCellReuseIdentifier:UnfinishedHomeworkSessionTableViewCellId];
    [self.homeworkSessionsTableView registerNib:[UINib nibWithNibName:@"UnfinishedStudentHomeworkSessionTableViewCell" bundle:nil] forCellReuseIdentifier:UnfinishedStudentHomeworkSessionTableViewCellId];
}

- (void)addNotificationObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadForDoubleTabClick)
                                                 name:kNotificationKeyOfTabBarDoubleClick
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadWhenAppeared:)
                                                 name:kNotificationKeyOfRefreshHomeworkSession
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadUnReadMessage:)
                                                 name:kIMManagerClientUnReadMessageCountNotification
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(imOffline:)
                                                 name:kIMManagerClientOfflineNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(imOnline:)
                                                 name:kIMManagerClientOnlineNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(lastMessageDidChange:)
                                                 name:kIMManagerContentMessageDidReceiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(lastMessageDidChange:)
                                                 name:kIMManagerContentMessageDidSendNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadWhenAppeared:)
                                                 name:kNotificationKeyOfDeleteClass
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadWhenAppeared:)
                                                 name:kNotificationKeyOfSendHomework
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadWhenAppeared:)
                                                 name:kNotificationKeyOfDeleteClassStudents
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadWhenHomeworkCorrected:)
                                                 name:kNotificationKeyOfCorrectHomework
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadWhenAppeared:)
                                                 name:kNotificationKeyOfRedoHomework
                                               object:nil];
    
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

- (void)loadConversations {
    if (!self.isUnfinished) {
        return;
    }

//    if (!self.bLoadConversion)
//    {
//        return;
//    }
    
    NSDate *startTime = [NSDate date];
    
    AVIMClient *client = [IMManager sharedManager].client;
    
    AVIMConversationQuery *query1 = [client conversationQuery];
    [query1 whereKey:@"taskfinished" equalTo:@(NO)];
    
    AVIMConversationQuery *query2 = [client conversationQuery];
    [query2 whereKeyDoesNotExist:@"taskfinished"];
    
//    AVIMConversationQuery *query3 = [client conversationQuery];
//    [query3 whereKey:@"name" equalTo:@"12169"];
    
    AVIMConversationQuery *query = [AVIMConversationQuery orQueryWithSubqueries:@[query1,query2]];
    
    query.cachePolicy = kAVIMCachePolicyNetworkElseCache;
    query.option = AVIMConversationQueryOptionWithMessage;
    query.limit = 1000;
    
    [query findConversationsWithCallback:^(NSArray * conversations, NSError *error) {
        NSLog(@"会话数:%@ 耗时%.fms", @(conversations.count), [[NSDate date] timeIntervalSinceDate:startTime]*1000);
        
        self.queriedConversations = conversations;
        [self mergeAndReload];
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

//        [self.homeworkSessions sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
//            HomeworkSession *session1 = (HomeworkSession *)obj1;
//            HomeworkSession *session2 = (HomeworkSession *)obj2;
//
//            if (session1.sortTime > session2.sortTime) {
//                return NSOrderedAscending;
//            } else if (session1.sortTime < session2.sortTime) {
//                return NSOrderedDescending;
//            }
//
//            return NSOrderedSame;
//        }];
    //
    
    [self.homeworkSessionsTableView reloadData];
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
    
//    if (!self.bLoadConversion)
//    {
//        return;
//    }
    
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
    
    AVIMConversation *messageConversation = nil;
    for (AVIMConversation *conversation in self.queriedConversations) {
        if ([conversation.conversationId isEqualToString:message.conversationId]) {
            messageConversation = conversation;
            break;
        }
    }
    
    if (messageConversation == nil) {
        messageConversation = [[IMManager sharedManager].client conversationForId:message.conversationId];
        if (messageConversation != nil) {
            NSMutableArray *array = [NSMutableArray arrayWithArray:self.queriedConversations];
            [array insertObject:messageConversation atIndex:0];
            
            self.queriedConversations = array;
        }
    }
    
    if (messageConversation == nil) {
        return;
    }
    
    NSInteger homeworkSessionId = [messageConversation.name integerValue];
    HomeworkSession *session = nil;
    for (HomeworkSession *homeworkSession in self.homeworkSessions) {
        if (homeworkSession.homeworkSessionId == homeworkSessionId) {
            if (homeworkSession.conversation == nil) {
                homeworkSession.conversation = messageConversation;
            }
            
            session = homeworkSession;
            
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
#endif
            
            if (APP.currentIMHomeworkSessionId ==0 || APP.currentIMHomeworkSessionId != homeworkSession.homeworkSessionId) {
                // homeworkSession.unreadMessageCount++;
            }
            
            if (homeworkSession.conversation.lastMessageAt != nil) {
                homeworkSession.sortTime = [homeworkSession.conversation.lastMessageAt timeIntervalSince1970]*1000;
            } else {
                //                if (homeworkSession.updateTime == 0) {
                //                    homeworkSession.sortTime = [[NSDate date] timeIntervalSince1970] * 1000;
                //                } else {
                homeworkSession.sortTime = homeworkSession.updateTime;
                //                }
            }
            
            break;
        }
    }
    
    if (session != nil) {
        if (attributes[@"score"] == nil) {
            [self.homeworkSessionsTableView reloadData];
        }
    } else {
        if (attributes[@"score"] == nil && !self.bLoadConversion) {
            [HomeworkSessionService requestHomeworkSessionWithId:homeworkSessionId callback:^(Result *result, NSError *error) {
                if (error != nil) {
                    return;
                }
                
                HomeworkSession *session = (HomeworkSession *)(result.userInfo);
                BOOL exists = NO;
                for (HomeworkSession *s in self.homeworkSessions) {
                    if (s.homeworkSessionId == session.homeworkSessionId) {
                        exists = YES;
                        break;
                    }
                }
                
                if (!exists) {
                    // session.unreadMessageCount++;
                    
                    if (messageConversation.lastMessageAt != nil) {
                        session.sortTime = [messageConversation.lastMessageAt timeIntervalSince1970] * 1000;
                    } else {
                        //                        if (session.updateTime == 0) {
                        //                            session.sortTime = [[NSDate date] timeIntervalSince1970] * 1000;
                        //                        } else {
                        session.sortTime = session.updateTime;
                        //                        }
                    }
                    
                    AVIMMessage *message = messageConversation.lastMessage;
                    if ([message isKindOfClass:[AVIMTextMessage class]]) {
                        session.lastSessionContent = ((AVIMTextMessage *)message).text;
                    } else if ([message isKindOfClass:[AVIMAudioMessage class]]) {
                        session.lastSessionContent = @"[音频]";
                    } else if ([message isKindOfClass:[AVIMVideoMessage class]]) {
                        session.lastSessionContent = @"[视频]";
                    } else if ([message isKindOfClass:[AVIMImageMessage class]]) {
                        session.lastSessionContent = @"[图片]";
                    }
                    
#if TEACHERSIDE
                    session.shouldColorLastSessionContent = message.ioType == AVIMMessageIOTypeOut;
#else
                    session.shouldColorLastSessionContent = message.ioType == AVIMMessageIOTypeIn;
#endif
                    
                    [self.homeworkSessions addObject:session];
                    [self.view hideAllStateView];
                    self.homeworkSessionsTableView.hidden = NO;
                    [self.homeworkSessionsTableView reloadData];
                }
            }];
        }
    }
}

- (void)requestHomeworkSessions {
    if (self.homeworkSessionsRequest != nil) {
        return;
    }
    
    if (self.homeworkSessions.count == 0) {
        [self.view showLoadingView];
        self.homeworkSessionsTableView.hidden = YES;
    }
    
    if (self.queriedConversations.count == 0 &&
        self.isUnfinished &&
        [IMManager sharedManager].client.status==AVIMClientStatusOpened) {
        [self loadConversations];
    }
    
    WeakifySelf;
    
    if (self.searchFliter == -1)
    {
        if ([self.searchFilterName length] == 0)
        {
            return;
        }
        
        WeakifySelf;
        self.homeworkSessionsRequest = [HomeworkSessionService searchHomeworkSessionWithName:self.searchFilterName forState:mState callback:^(Result *result, NSError *error) {
            StrongifySelf;
            [strongSelf handleRequestResult:result isLoadMore:NO error:error];
        }];
        
    }
    else if (self.searchFliter == 0)
    {
        self.homeworkSessionsRequest = [HomeworkSessionService requestHomeworkSessionsWithFinishState:mState
                                                                                             callback:^(Result *result, NSError *error) {
                                                                                                 StrongifySelf;
                                                                                                 [strongSelf handleRequestResult:result
                                                                                                                      isLoadMore:NO error:error];
                                                                                             }];
    }
    else
    {
       WeakifySelf;
#if TEACHERSIDE
        self.homeworkSessionsRequest = [HomeworkSessionService searchHomeworkSessionWithType:self.searchFliter forState:mState callback:^(Result *result, NSError *error) {
            
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
    if (self.searchFliter == -1)
    {
        self.homeworkSessionsRequest = [HomeworkSessionService searchHomeworkSessionWithNameWithNextUrl:self.nextUrl callback:^(Result *result, NSError *error) {
            StrongifySelf;
            [strongSelf handleRequestResult:result
                                 isLoadMore:YES                    error:error];
        }];
    }
    else if (self.searchFliter == 0)
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
        [self mergeAndReload];
        
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
            [self mergeAndReload];
            
            [self.homeworkSessionsTableView addPullToRefreshWithTarget:self
                                                      refreshingAction:@selector(requestHomeworkSessions)];
            
            if (nextUrl.length > 0) {
                WeakifySelf;
                [self.homeworkSessionsTableView addInfiniteScrollingWithRefreshingBlock:^{
                    [weakSelf loadMoreHomeworkSessions];
                }];
            } else {
                [self.homeworkSessionsTableView removeFooter];
            }
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.homeworkSessionsTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
            });
            
            //把内容存起来
//            if (self.isUnfinished)
//            {
//                if (self.bLoadConversion)
//                {
//                    APP.unfinishHomeworkSessionList = self.homeworkSessions;
//                }
//                else
//                {
//                    APP.unCommitHomeworkSessionList = self.homeworkSessions;
//                }
//            }
//            else
//            {
//                APP.finishHomeworkSessionList = self.homeworkSessions;
//            }
            
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
#if TEACHERSIDE
        cell = [tableView dequeueReusableCellWithIdentifier:UnfinishedHomeworkSessionTableViewCellId forIndexPath:indexPath];
#else
        cell = [tableView dequeueReusableCellWithIdentifier:UnfinishedStudentHomeworkSessionTableViewCellId forIndexPath:indexPath];
#endif
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
//    if (session.unreadMessageCount > 0) {
//        session.unreadMessageCount = 0; // 点击进去就算已读
//        [self.unReadHomeworkSessions removeObject:session];
//        NSInteger tabbarCount = self.unReadHomeworkSessions.count + self.noHandleNotications.count;
//        AppDelegate * appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//        [appDel showTabBarBadgeNum:tabbarCount atIndex:0];
//    }
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.homeworkSessionsTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    });
    
    HomeworkSessionViewController *vc = [[HomeworkSessionViewController alloc] initWithNibName:@"HomeworkSessionViewController" bundle:nil];
    vc.homeworkSession = session;
    [vc setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:vc animated:YES];
}

@end



