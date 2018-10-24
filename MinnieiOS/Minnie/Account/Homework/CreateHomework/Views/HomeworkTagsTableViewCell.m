//
//  HomeworkTagsTableViewCell.m
//  X5Teacher
//
//  Created by yebw on 2018/1/24.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "HomeworkTagsTableViewCell.h"
#import "TagCollectionViewCell.h"
#import "CustomCollectionView.h"

NSString * const HomeworkTagsTableViewCellId = @"HomeworkTagsTableViewCellId";

@interface HomeworkTagsTableViewCell()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) IBOutlet CustomCollectionView *tagsCollectionView;
@property (nonatomic, strong) NSArray<NSString *> *tags;
@property (nonatomic, strong) NSMutableArray<NSString *> *selectedTags;

@end

@implementation HomeworkTagsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.tagsCollectionView.layer.cornerRadius = 12;
    self.tagsCollectionView.layer.masksToBounds = YES;
    
    [self registerCellNibs];
}

- (void)registerCellNibs {
    [self.tagsCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([TagCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:TagCollectionViewCellId];
}

- (void)setupWithTags:(NSArray <NSString *> *)tags
         selectedTags:(NSArray <NSString *> *)selectedTags {
    self.tags = tags;
    self.selectedTags = [NSMutableArray arrayWithArray:selectedTags];
    
    [self.tagsCollectionView reloadData];
}

+ (CGFloat)heightWithTags:(NSArray <NSString *> *)tags{
    if (tags.count == 0) {
        return 50.f;
    }
    
    static HomeworkTagsTableViewCell *tempCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tempCell = [[[NSBundle mainBundle] loadNibNamed:@"HomeworkTagsTableViewCell" owner:nil options:nil] lastObject];
        [tempCell setupWithTags:tags selectedTags:nil];
    });
    
    [tempCell setupWithTags:tags selectedTags:nil];
    
    [tempCell setNeedsLayout];
    [tempCell layoutIfNeeded];
    
    [tempCell setNeedsUpdateConstraints];
    [tempCell updateConstraintsIfNeeded];
    
    CGSize size = [tempCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    
    return size.height;
}

#pragma mark - IBActions

- (IBAction)manageButtonPressed:(id)sender {
    if (self.manageCallback != nil) {
        self.manageCallback();
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
    return 6;
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
    
    if (self.selectCallback != nil) {
        self.selectCallback(tag);
    }
}

@end

