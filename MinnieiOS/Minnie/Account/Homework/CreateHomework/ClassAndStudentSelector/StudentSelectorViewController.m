//
//  StudentSelectorViewController.m
//  X5Teacher
//
//  Created by yebw on 2017/12/27.
//  Copyright © 2017年 netease. All rights reserved.
//

#import "StudentSelectorViewController.h"
#import "StudentSelectorTableViewCell.h"
#import "StudentService.h"
#import "UIView+Load.h"

@interface StudentSelectorViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *studentsTableView;

@property (nonatomic, strong) NSMutableArray<User *> *students;

@property (nonatomic, strong) NSMutableDictionary *studentDict;
@property (nonatomic, strong) NSArray *sortedKeys;

@property (nonatomic, strong) BaseRequest *studentsRequest;

@end

@implementation StudentSelectorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.students = [NSMutableArray array];
    if (self.selectedStudents == nil) {
        self.selectedStudents = [NSMutableArray array];
    }
    
    [self registerCellNibs];
    
    [self requestStudents];
}

- (void)dealloc {
    [self.studentsRequest clearCompletionBlock];
    [self.studentsRequest stop];
    self.studentsRequest = nil;
    
    NSLog(@"%s", __func__);
}

- (void)registerCellNibs {
    [self.studentsTableView registerNib:[UINib nibWithNibName:@"StudentSelectorTableViewCell" bundle:nil] forCellReuseIdentifier:StudentSelectorTableViewCellId];
}

- (void)unselectAll {
    [self.selectedStudents removeAllObjects];
    [self.studentsTableView reloadData];
}

- (void)requestStudents {
    if (self.studentsRequest != nil) {
        return;
    }
    
    [self.view showLoadingView];
    self.studentsTableView.hidden = YES;
    
    WeakifySelf;
    if (!self.classStateMode) {
        self.studentsRequest = [StudentService requestStudentsWithFinishState:0
                                                                     callback:^(Result *result, NSError *error) {
                                                                         StrongifySelf;
                                                                         [strongSelf handleRequestResult:result error:error];
                                                                     }];
    } else {
        self.studentsRequest = [StudentService requestStudentsWithClassState:self.inClass
                                                                    callback:^(Result *result, NSError *error) {
                                                                        StrongifySelf;
                                                                        [strongSelf handleRequestResult:result error:error];
                                                                    }];
    }
    
}

- (void)handleRequestResult:(Result *)result error:(NSError *)error {
    self.studentsRequest = nil;
    
    [self.view hideAllStateView];
    
    if (error != nil) {
        WeakifySelf;
        [self.view showFailureViewWithRetryCallback:^{
            [weakSelf requestStudents];
        }];
        
        return;
    }
    
    NSDictionary *dict = (NSDictionary *)(result.userInfo);
    NSArray *students = (NSArray *)(dict[@"list"]);
    
    // 停止加载
    self.studentsTableView.hidden = students.count==0;
    
    
    if (students.count > 0) {
        self.studentsTableView.hidden = NO;
        
        [self.students addObjectsFromArray:students];
        [self sortStudents];
        [self.studentsTableView reloadData];
    } else {
        [self.view showEmptyViewWithImage:nil
                                    title:@"暂无学生"
                            centerYOffset:0
                                linkTitle:nil
                        linkClickCallback:nil];
    }
}

+ (NSString *)getFirstLetterFromString:(NSString *)string {
    NSMutableString *str = [NSMutableString stringWithString:string];
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
    NSString *strPinYin = [str capitalizedString];
    
    return [strPinYin substringToIndex:1];
}

- (void)sortStudents {
    if (self.studentDict == nil) {
        self.studentDict = [NSMutableDictionary dictionary];
    }
    
    for (User *student in self.students) {
        NSString *strFirstLetter = [[self class] getFirstLetterFromString:student.nickname];
        if (self.studentDict[strFirstLetter] != nil) {
            [self.studentDict[strFirstLetter] addObject:student];
        } else {
            NSMutableArray *group = [NSMutableArray arrayWithObject:student];
            [self.studentDict setObject:group forKey:strFirstLetter];
        }
    }
    
    NSArray *keys = [self.studentDict.allKeys sortedArrayUsingSelector:@selector(compare:)];
    self.sortedKeys = keys;
}

#pragma mark - UITableViewDataSource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.sortedKeys[section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *key = self.sortedKeys[section];
    NSArray *group = self.studentDict[key];
    
    return group.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *key = self.sortedKeys[indexPath.section];
    NSArray *group = self.studentDict[key];
    User *student = group[indexPath.row];
    
    StudentSelectorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:StudentSelectorTableViewCellId forIndexPath:indexPath];
    [cell setupWithStudent:student];
    [cell setChoice:[self.selectedStudents containsObject:student]];
    [cell setReviewMode:self.reviewMode];
    
    return cell;
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.sortedKeys;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [self.sortedKeys indexOfObject:title];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.studentDict.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return StudentSelectorTableViewCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSString *key = self.sortedKeys[indexPath.section];
    User *student = self.studentDict[key][indexPath.row];
    
    if (self.reviewMode) {
        if (self.previewCallback != nil) {
            self.previewCallback(student.userId);
        }
        
        return;
    }
    
    StudentSelectorTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([self.selectedStudents containsObject:student]) {
        [self.selectedStudents removeObject:student];
        [cell setChoice:NO];
    } else {
        [self.selectedStudents addObject:student];
        [cell setChoice:YES];
    }
    
    if (self.selectCallback != nil) {
        self.selectCallback(self.selectedStudents.count);
    }
}

@end




