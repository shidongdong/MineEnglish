//
//  SearchHomeworkViewController.m
//  X5Teacher
//
//  Created by yebw on 2018/2/4.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "SearchHomeworkViewController.h"
#import "HomeworkService.h"
#import "TagService.h"
#import "UIView+Load.h"
#import "UIScrollView+Refresh.h"
#import "TagCollectionViewCell.h"
#import "HomeworkTableViewCell.h"
#import "TIP.h"
#import "ClassAndStudentSelectorController.h"

@interface SearchHomeworkViewController ()<UITextFieldDelegate, UITableViewDataSource,UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, weak) IBOutlet UITextField *searchTextField;

@property (nonatomic, weak) IBOutlet UIView *tagsView;
@property (nonatomic, weak) IBOutlet UICollectionView *tagsCollectionView;
@property (nonatomic, weak) IBOutlet UIView *homeworksView;
@property (nonatomic, weak) IBOutlet UITableView *homeworksTableView;

@property (nonatomic, strong) NSArray *tags;

@property (nonatomic, strong) NSMutableArray *homeworks;
@property (nonatomic, copy) NSString *nextUrl;

@property (nonatomic, strong) BaseRequest *searchRequest;

@end

@implementation SearchHomeworkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.homeworks = [NSMutableArray array];
    
    self.homeworksTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self registerCellNibs];
    
    [self requestTags];
}

- (void)dealloc {
    [self.searchRequest clearCompletionBlock];
    [self.searchRequest stop];
    self.searchRequest = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    NSLog(@"%s", __func__);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.searchTextField becomeFirstResponder];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textDidChange:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - Private Methods

- (void)registerCellNibs {
    [self.homeworksTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HomeworkTableViewCell class]) bundle:nil] forCellReuseIdentifier:HomeworkTableViewCellId];
    
    [self.tagsCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([TagCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:TagCollectionViewCellId];
}

- (void)requestTags {
    [TagService requestTagsWithCallback:^(Result *result, NSError *error) {
        if (error == nil) {
            self.tags = (NSArray *)(result.userInfo);
            
            [self.tagsCollectionView reloadData];
            
            if (self.searchTextField.text.length == 0) {
                self.homeworksView.hidden = YES;
                self.tagsView.hidden = NO;
            } else {
                self.homeworksView.hidden = NO;
                self.tagsView.hidden = YES;
            }
        }
    }];
}

- (void)textDidChange:(NSNotification *)notification {
    [self.searchRequest stop];
    
    if (self.searchTextField.text.length == 0) {
        self.tagsView.hidden = NO;
        self.homeworksView.hidden = YES;
    } else {
        self.tagsView.hidden = YES;
        [self.homeworks removeAllObjects];
        self.nextUrl = nil;
        [self.homeworksTableView reloadData];
        self.homeworksView.hidden = NO;
        [self.homeworksView hideAllStateView];
        self.homeworksTableView.hidden = YES;
    }
}

- (void)searchWithKeyword:(NSString *)keyword {
    self.tagsView.hidden = YES;
    self.homeworksView.hidden = NO;
    
    [self.homeworksView showLoadingView];
    
    WeakifySelf;
    self.searchRequest = [HomeworkService searchHomeworkWithKeyword:keyword
                                                           callback:^(Result *result, NSError *error) {
                                                               [weakSelf handleSearchResult:result error:error];
                                                           }];
}

- (void)loadMoreHomeworks {
    if (self.searchRequest != nil) {
        return;
    }
    
    WeakifySelf;
    self.searchRequest = [HomeworkService searchHomeworkWithNextUrl:self.nextUrl
                                                           callback:^(Result *result, NSError *error) {
                                                               [weakSelf handleSearchResult:result error:error];
                                                           }];
}


- (void)handleSearchResult:(Result *)result error:(NSError *)error {
    self.searchRequest = nil;
    
    [self.homeworksView hideAllStateView];
    
    NSDictionary *dictionary = (NSDictionary *)(result.userInfo);
    NSString *nextUrl = dictionary[@"next"];
    NSArray *homeworks = dictionary[@"list"];
    
    BOOL isLoadMore = self.nextUrl.length > 0;
    if (isLoadMore) {
        [self.homeworksTableView footerEndRefreshing];
        self.homeworksTableView.hidden = NO;
        
        if (error != nil) {
            return;
        }
        
        if (homeworks.count > 0) {
            [self.homeworks addObjectsFromArray:homeworks];
        }
        
        if (nextUrl.length == 0) {
            [self.homeworksTableView removeFooter];
        }
        
        [self.homeworksTableView reloadData];
    } else {
        // 停止加载
        [self.homeworksTableView headerEndRefreshing];
        self.homeworksTableView.hidden = homeworks.count==0;
        
        if (error != nil) {
            if (homeworks.count > 0) {
                [TIP showText:@"加载失败" inView:self.view];
            } else {
                WeakifySelf;
                [self.homeworksView showFailureViewWithRetryCallback:^{
                    NSString *keyword = [weakSelf.searchTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                    [weakSelf searchWithKeyword:keyword];
                }];
            }
            
            return;
        }
        
        if (homeworks.count > 0) {
            self.homeworksTableView.hidden = NO;
            
            [self.homeworks addObjectsFromArray:homeworks];
            [self.homeworksTableView reloadData];
            
            if (nextUrl.length > 0) {
                WeakifySelf;
                [self.homeworksTableView addInfiniteScrollingWithRefreshingBlock:^{
                    [weakSelf loadMoreHomeworks];
                }];
            } else {
                [self.homeworksTableView removeFooter];
            }
        } else {
            [self.homeworksView showEmptyViewWithImage:nil
                                                 title:@"无相关作业"
                                         centerYOffset:0
                                             linkTitle:nil
                                     linkClickCallback:nil];
        }
    }
    
    self.nextUrl = nextUrl;
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    [self.searchRequest stop];
    
    NSString *keyword = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (keyword.length > 0) {
        [self searchWithKeyword:keyword];
    }
    
    return NO;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.homeworks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeworkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HomeworkTableViewCellId forIndexPath:indexPath];
    
    Homework *homework = self.homeworks[indexPath.row];
    
    [cell setupWithHomework:homework];
    [cell updateWithEditMode:NO selected:NO];
    
    WeakifySelf;
    [cell setSendCallback:^{
        ClassAndStudentSelectorController *vc = [[ClassAndStudentSelectorController alloc] init];
        vc.homeworks = @[homework];
        [weakSelf presentViewController:vc animated:YES completion:nil];
    }];
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Homework *homework = self.homeworks[indexPath.row];
    return [HomeworkTableViewCell cellHeightWithHomework:homework];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.tags.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TagCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:TagCollectionViewCellId
                                                                            forIndexPath:indexPath];
    NSString *tag = self.tags[indexPath.row];
    
    [cell setupWithTag:tag];
    [cell setChoice:NO];
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *tag = self.tags[indexPath.row];
    return [TagCollectionViewCell cellSizeWithTag:tag];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout*)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(16, 12, 16, 12);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout*)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 12;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout*)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 12;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    
    NSString *tag = self.tags[indexPath.item];
    self.searchTextField.text = tag;
    
    [self textFieldShouldReturn:self.searchTextField];
}

@end

