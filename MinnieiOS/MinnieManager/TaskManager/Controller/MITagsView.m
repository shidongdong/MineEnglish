//
//  MITagsView.m
//  Minnie
//
//  Created by songzhen on 2019/7/3.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import "MITagsView.h"
#import "Constants.h"
#import "TagService.h"
#import "Application.h"
#import "CreateTagView.h"
#import "MITagsViewController.h"
#import "TagCollectionViewCell.h"
#import "HomeworkSessionService.h"
#import "MIEqualSpaceFlowLayout.h"
#import "CSCustomSplitViewController.h"


@interface MITagsView () <
UICollectionViewDataSource,
MIEqualSpaceFlowLayoutDelegate
>

@property (nonatomic, strong) NSArray<NSString *> *tags;
@property (nonatomic, strong) NSMutableArray<NSString *> *selectedTags;
@property (nonatomic, strong) BaseRequest *tagsRequest;

@property (nonatomic, strong) UICollectionView *tagsCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *addButton;


@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@property (weak, nonatomic) IBOutlet UILabel *deleteCountLabel;
@property (weak, nonatomic) IBOutlet UIView *footView;

@property (weak, nonatomic) IBOutlet UICollectionView *tagsCollectionContainerView;

@end

@implementation MITagsView


- (void)awakeFromNib{
    
    [super awakeFromNib];
    self.deleteCountLabel.layer.cornerRadius = 10.5;
    self.deleteCountLabel.layer.masksToBounds = YES;;
    
    self.selectedTags = [NSMutableArray array];
    self.deleteButton.enabled = NO;
    
    [self addContentView];
}
- (IBAction)backAction:(id)sender {
   
    if (self.tagsCallBack) {
        self.tagsCallBack();
    }
}

- (void)setType:(TagsType)type{
    
    _type = type;
    [self requestData];
}
#pragma mark - IBActions

- (IBAction)addButtonPressed:(id)sender {
    
    //判断相同标签不能创建
    WeakifySelf;
    [CreateTagView showInSuperView:[UIApplication sharedApplication].keyWindow
                          callback:^(NSString *tag) {
                              [CreateTagView hideAnimated:YES];
                              
                              for (NSString * tmpTag in self.tags)
                              {
                                  if ([tag isEqualToString:tmpTag])
                                  {
                                      if (self.type == TagsCommentType)
                                      {
                                          [HUD showWithMessage:@"无法创建相同的评语"];
                                      }
                                      else
                                      {
                                          [HUD showWithMessage:@"无法创建相同的标签"];
                                      }
                                      
                                      return;
                                  }
                              }
                              
                              if (self.type == TagsHomeworkFormType)
                              {
                                  [HUD showProgressWithMessage:@"正在添加标签"];
                                  [TagService createFormTag:tag callback:^(Result *result, NSError *error) {
                                      if (error != nil) {
                                          [HUD showErrorWithMessage:@"添加标签失败"];
                                          return;
                                      }
                                      
                                      [HUD hideAnimated:NO];
                                      
                                      NSMutableArray *tags = [NSMutableArray arrayWithArray:weakSelf.tags];
                                      if (tags.count == 0) {
                                          [weakSelf hideAllStateView];
                                          weakSelf.tagsCollectionView.hidden = NO;
                                      }
                                      
                                      [tags addObject:tag];
                                      weakSelf.tags = tags;
                                      
                                      [weakSelf.tagsCollectionView reloadData];
                                      
                                      [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationKeyOfAddFormTags object:nil];
                                  }];
                                  
                              }
                              else if (self.type == TagsHomeworkTipsType)
                              {
                                  [HUD showProgressWithMessage:@"正在添加标签"];
                                  [TagService createTag:tag
                                               callback:^(Result *result, NSError *error) {
                                                   if (error != nil) {
                                                       [HUD showErrorWithMessage:@"添加标签失败"];
                                                       return;
                                                   }
                                                   
                                                   [HUD hideAnimated:NO];
                                                   
                                                   NSMutableArray *tags = [NSMutableArray arrayWithArray:weakSelf.tags];
                                                   if (tags.count == 0) {
                                                       [weakSelf hideAllStateView];
                                                       weakSelf.tagsCollectionView.hidden = NO;
                                                   }
                                                   
                                                   [tags addObject:tag];
                                                   weakSelf.tags = tags;
                                                   
                                                   [weakSelf.tagsCollectionView reloadData];
                                                   
                                                   [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationKeyOfAddTags object:nil];
                                               }];
                              }
                              else
                              {
                                  [HUD showProgressWithMessage:@"正在添加评语"];
                                  [HomeworkSessionService addHomeworkSessionComment:tag callback:^(Result *result, NSError *error) {
                                      if (error != nil) {
                                          [HUD showErrorWithMessage:@"添加评语失败"];
                                          return;
                                      }
                                      
                                      [HUD hideAnimated:NO];
                                      
                                      NSMutableArray *tags = [NSMutableArray arrayWithArray:weakSelf.tags];
                                      if (tags.count == 0) {
                                          [weakSelf hideAllStateView];
                                          weakSelf.tagsCollectionView.hidden = NO;
                                      }
                                      
                                      [tags addObject:tag];
                                      weakSelf.tags = tags;
                                      
                                      [weakSelf.tagsCollectionView reloadData];
                                      
                                      [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationKeyOfAddTags object:nil];
                                  }];
                              }
                          }];
}


- (IBAction)deleteButtonPressed:(id)sender {
    
    if (self.type == TagsHomeworkFormType)
    {
        [HUD showProgressWithMessage:@"正在删除标签"];
        [TagService deleteFormTags:self.selectedTags callback:^(Result *result, NSError *error) {
            if (error != nil) {
                [HUD showErrorWithMessage:@"删除标签失败"];
                return;
            }
            
            [HUD hideAnimated:NO];
            
            NSMutableArray *tags = [NSMutableArray arrayWithArray:self.tags];
            NSMutableIndexSet *indexes = [NSMutableIndexSet indexSet];
            for (NSString *tag in self.selectedTags) {
                NSInteger index = [self.tags indexOfObject:tag];
                [indexes addIndex:index];
            }
            [tags removeObjectsAtIndexes:indexes];
            self.tags = tags;
            
            [self.selectedTags removeAllObjects];
            
            if (tags.count == 0) {
                [self showEmptyViewWithImage:nil title:@"暂无标签" linkTitle:nil linkClickCallback:nil];
                self.tagsCollectionView.hidden = YES;
            }
            
            [self.tagsCollectionView reloadData];
            
            self.deleteCountLabel.text = [NSString stringWithFormat:@"%zd", self.selectedTags.count];
            self.deleteButton.enabled = NO;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationKeyOfDeleteFormTags object:nil];
        }];
    }
    else if (self.type == TagsHomeworkTipsType)
    {
        [HUD showProgressWithMessage:@"正在删除标签"];
        [TagService deleteTags:self.selectedTags callback:^(Result *result, NSError *error) {
            if (error != nil) {
                [HUD showErrorWithMessage:@"删除标签失败"];
                return;
            }
            
            [HUD hideAnimated:NO];
            
            NSMutableArray *tags = [NSMutableArray arrayWithArray:self.tags];
            NSMutableIndexSet *indexes = [NSMutableIndexSet indexSet];
            for (NSString *tag in self.selectedTags) {
                NSInteger index = [self.tags indexOfObject:tag];
                [indexes addIndex:index];
            }
            [tags removeObjectsAtIndexes:indexes];
            self.tags = tags;
            
            [self.selectedTags removeAllObjects];
            
            if (tags.count == 0) {
                [self showEmptyViewWithImage:nil title:@"暂无标签" linkTitle:nil linkClickCallback:nil];
                self.tagsCollectionView.hidden = YES;
            }
            
            [self.tagsCollectionView reloadData];
            
            self.deleteCountLabel.text = [NSString stringWithFormat:@"%zd", self.selectedTags.count];
            self.deleteButton.enabled = NO;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationKeyOfDeleteTags object:nil];
        }];
    }
    else
    {
        [HUD showProgressWithMessage:@"正在删除评语"];
        [HomeworkSessionService  delHomeworkSessionComment:self.selectedTags callback:^(Result *result, NSError *error) {
            if (error != nil) {
                [HUD showErrorWithMessage:@"删除评语失败"];
                return;
            }
            
            [HUD hideAnimated:NO];
            
            NSMutableArray *tags = [NSMutableArray arrayWithArray:self.tags];
            NSMutableIndexSet *indexes = [NSMutableIndexSet indexSet];
            for (NSString *tag in self.selectedTags) {
                NSInteger index = [self.tags indexOfObject:tag];
                [indexes addIndex:index];
            }
            [tags removeObjectsAtIndexes:indexes];
            self.tags = tags;
            
            [self.selectedTags removeAllObjects];
            
            if (tags.count == 0) {
                [self showEmptyViewWithImage:nil title:@"暂无评语" linkTitle:nil linkClickCallback:nil];
                self.tagsCollectionView.hidden = YES;
            }
            
            [self.tagsCollectionView reloadData];
            
            self.deleteCountLabel.text = [NSString stringWithFormat:@"%zd", self.selectedTags.count];
            self.deleteButton.enabled = NO;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationKeyOfDeleteTags object:nil];
        }];
    }
}

#pragma mark - Private Methods
- (void)requestData {
    if (self.tagsRequest != nil) {
        return;
    }
    
    self.tagsCollectionView.hidden = YES;
    [self showLoadingView];
    
    WeakifySelf;
    
    if (self.type == TagsHomeworkFormType)
    {
        self.tagsRequest = [TagService requestFormTagsWithCallback:^(Result *result, NSError *error) {
            StrongifySelf;
            
            strongSelf.tagsRequest = nil;
            
            // 显示失败页面
            if (error != nil) {
                __weak typeof(strongSelf) wk = strongSelf;
                [strongSelf showFailureViewWithRetryCallback:^{
                    [wk requestData];
                }];
                
                return;
            }
            
            NSArray *tags = (NSArray *)(result.userInfo);
            if (tags.count == 0) {
                [strongSelf showEmptyViewWithImage:nil
                                                                         title:@"暂无标签"
                                                                     linkTitle:nil
                                                             linkClickCallback:nil];
            } else {
                strongSelf.tags = tags;
                [strongSelf hideAllStateView];
                strongSelf.tagsCollectionView.hidden = NO;
                [strongSelf.tagsCollectionView reloadData];
            }
        }];
    }
    else if (self.type == TagsHomeworkTipsType)
    {
        self.tagsRequest = [TagService requestTagsWithCallback:^(Result *result, NSError *error) {
            StrongifySelf;
            
            strongSelf.tagsRequest = nil;
            
            // 显示失败页面
            if (error != nil) {
                __weak typeof(strongSelf) wk = strongSelf;
                [strongSelf showFailureViewWithRetryCallback:^{
                    [wk requestData];
                }];
                
                return;
            }
            
            NSArray *tags = (NSArray *)(result.userInfo);
            if (tags.count == 0) {
                [strongSelf showEmptyViewWithImage:nil
                                             title:@"暂无标签"
                                         linkTitle:nil
                                 linkClickCallback:nil];
            } else {
                strongSelf.tags = tags;
                
                [strongSelf hideAllStateView];
                strongSelf.tagsCollectionView.hidden = NO;
                [strongSelf.tagsCollectionView reloadData];
            }
        }];
    }
    else
    {
        self.tagsRequest = [HomeworkSessionService searchHomeworkSessionCommentWithCallback:^(Result *result, NSError *error) {
            StrongifySelf;
            
            strongSelf.tagsRequest = nil;
            // 显示失败页面
            if (error != nil) {
                
                __weak typeof(strongSelf) wk = strongSelf;
                [strongSelf showFailureViewWithRetryCallback:^{
                    [wk requestData];
                }];
                return;
            }
            
            NSArray *tags = (NSArray *)(result.userInfo);
            if (tags.count == 0) {
                [strongSelf showEmptyViewWithImage:nil
                                             title:@"暂无评语"
                                         linkTitle:nil
                                 linkClickCallback:nil];
            } else {
                strongSelf.tags = tags;
                
                [strongSelf hideAllStateView];
                strongSelf.tagsCollectionView.hidden = NO;
                [strongSelf.tagsCollectionView reloadData];
            }
        }];
    }
    
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
    [cell setChoice:[self.selectedTags containsObject:tag]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    
    NSString *tag = self.tags[indexPath.item];
    TagCollectionViewCell *cell = (TagCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    if ([self.selectedTags containsObject:tag]) {
        [self.selectedTags removeObject:tag];
        [cell setChoice:NO];
    } else {
        [self.selectedTags addObject:tag];
        [cell setChoice:YES];
    }
    
    self.deleteCountLabel.text = [NSString stringWithFormat:@"%zd", self.selectedTags.count];
    self.deleteButton.enabled = self.selectedTags.count>0;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *tag = self.tags[indexPath.row];
    CGSize itemSize = [TagCollectionViewCell cellSizeWithTag:tag];
    // 标签长度大于屏幕
    CGFloat collectionWidth = 375;
    if (itemSize.width > collectionWidth -30) {
        
        itemSize.width = collectionWidth - 30;
    }
    return itemSize;
}

- (void)addContentView{
    
    CGFloat collectionWidth = 375;
    MIEqualSpaceFlowLayout *flowLayout = [[MIEqualSpaceFlowLayout alloc] initWithCollectionViewWidth:collectionWidth];
    flowLayout.delegate = self;
    self.tagsCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kNaviBarHeight, collectionWidth, ScreenHeight - 100 - kNaviBarHeight - 44) collectionViewLayout:flowLayout];
    self.tagsCollectionView.backgroundColor = [UIColor whiteColor];
    self.tagsCollectionView.delegate = self;
    self.tagsCollectionView.dataSource = self;
    [self addSubview:self.tagsCollectionView];
    [self.tagsCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([TagCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:TagCollectionViewCellId];
}

@end
