//
//  Application.m
// X5
//
//  Created by yebw on 2017/8/23.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "Application.h"
#import "User.h"
#import "HomeworkSession.h"
static NSString * KeyOfVideoDownloadNetworkSetting = @"KeyOfVideoDownloadNetworkSetting";
static NSString * KeyOfCurrentUser = @"KeyOfCurrentUser";
static NSString * KeyOfLastLoginUsername = @"KeyOfLastLoginUsername";
static NSString * KeyOfClassIdAlertShown = @"KeyOfClassIdAlertShown";
static NSString * KeyOfUnfinishHomeWorkSession = @"KeyOfUnfinishHomeWorkSession";
static NSString * KeyOfFinishHomeWorkSession = @"KeyOfFinishHomeWorkSession";
static NSString * KeyOfUnCommitHomeWorkSession = @"KeyOfUnCommitHomeWorkSession";
static NSString * KeyOfCircleList = @"KeyOfCircleList";
static NSString * KeyOfUserGuide = @"KeyOfUserGuide";
@interface Application() {
#if TEACHERSIDE
    Teacher *_currentUser;
#else
    Student *_currentUser;
#endif
}

@end

@implementation Application

+ (instancetype)sharedInstance {
    static Application *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[Application alloc] init];
    });
    
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        [[NSUserDefaults standardUserDefaults] registerDefaults:@{KeyOfVideoDownloadNetworkSetting:@(0)}];
    }
    
    return self;
}

#if TEACHERSIDE
- (Teacher *)currentUser
#else
- (Student *)currentUser
#endif
{
    if (_currentUser == nil) {
        NSData *data = [[NSUserDefaults standardUserDefaults] dataForKey:KeyOfCurrentUser];
        if (data.length > 0) {
            _currentUser = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        }
    }

    return _currentUser;
}

#if TEACHERSIDE
- (void)setCurrentUser:(Teacher *)user
#else
- (void)setCurrentUser:(Student *)user
#endif
{
    _currentUser = user;
    
    NSData *data = nil;
    if (user != nil) {
        data = [NSKeyedArchiver archivedDataWithRootObject:user];
    }
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:KeyOfCurrentUser];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//用户指引
- (void)setUserGuide:(BOOL)userGuide
{
    [[NSUserDefaults standardUserDefaults] setObject:@(userGuide) forKey:KeyOfUserGuide];
}

- (BOOL)userGuide
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:KeyOfUserGuide] boolValue];
}

- (NSString *)lastLoginUsename {
    return [[NSUserDefaults standardUserDefaults] objectForKey:KeyOfLastLoginUsername];
}

- (void)setLastLoginUsename:(NSString *)lastLoginUsename {
    if (lastLoginUsename.length == 0) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:KeyOfLastLoginUsername];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:lastLoginUsename forKey:KeyOfLastLoginUsername];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setVideoDownloadNetworkSetting:(NSInteger)videoDownloadNetworkSetting {
    [[NSUserDefaults standardUserDefaults] setInteger:videoDownloadNetworkSetting forKey:KeyOfVideoDownloadNetworkSetting];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSInteger)videoDownloadNetworkSetting {
    return [[NSUserDefaults standardUserDefaults] integerForKey:KeyOfVideoDownloadNetworkSetting];
}

- (void)setClassIdAlertShown:(NSInteger)classIdAlertShown {
    [[NSUserDefaults standardUserDefaults] setInteger:classIdAlertShown forKey:KeyOfClassIdAlertShown];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSInteger)classIdAlertShown {
    return [[NSUserDefaults standardUserDefaults] integerForKey:KeyOfClassIdAlertShown];
}

//清缓存
- (void)clearData
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:KeyOfUnfinishHomeWorkSession];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:KeyOfFinishHomeWorkSession];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:KeyOfCircleList];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

//存首页未完成的内容
- (void)setUnfinishHomeworkSessionList:(NSArray *)unfinishHomeworkSessionList
{
    for (HomeworkSession * homework in unfinishHomeworkSessionList)
    {
        homework.conversation = nil;
    }

    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:unfinishHomeworkSessionList];
    
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:KeyOfUnfinishHomeWorkSession];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


//取首页未完成的内容
- (NSArray *)unfinishHomeworkSessionList
{
    NSData * data = [[NSUserDefaults standardUserDefaults] objectForKey:KeyOfUnfinishHomeWorkSession];
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

//存首页完成的内容
- (void)setFinishHomeworkSessionList:(NSArray *)finishHomeworkSessionList
{
    
    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:finishHomeworkSessionList];
    
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:KeyOfFinishHomeWorkSession];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


//取首页未完成的内容
- (NSArray *)finishHomeworkSessionList
{
    NSData * data = [[NSUserDefaults standardUserDefaults] objectForKey:KeyOfFinishHomeWorkSession];
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}


//存首页未提交完成的内容
- (void)setUnCommitHomeworkSessionList:(NSArray *)unCommitHomeworkSessionList
{
    
    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:unCommitHomeworkSessionList];
    
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:KeyOfUnCommitHomeWorkSession];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


//取首页未提交的内容
- (NSArray *)unCommitHomeworkSessionList
{
    NSData * data = [[NSUserDefaults standardUserDefaults] objectForKey:KeyOfUnCommitHomeWorkSession];
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

//朋友圈
- (void)setCircleList:(NSArray *)circleList
{
    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:circleList];
    
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:KeyOfCircleList];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSArray *)circleList
{
    NSData * data = [[NSUserDefaults standardUserDefaults] objectForKey:KeyOfCircleList];
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

@end
