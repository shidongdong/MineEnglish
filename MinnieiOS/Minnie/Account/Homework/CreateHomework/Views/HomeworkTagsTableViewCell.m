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
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@end

@implementation HomeworkTagsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
  
    if (@available(iOS 12.0, *)) {
        // Addresses a separate issue and prevent auto layout warnings due to the temporary width constraint in the xib.
        self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
        
        // Code below is needed to make the self-sizing cell work when building for iOS 12 from Xcode 10.0:
        
        NSLayoutConstraint *leftConstraint = [self.contentView.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:0];
        NSLayoutConstraint *rightConstraint = [self.contentView.rightAnchor constraintEqualToAnchor:self.rightAnchor constant:0];
        NSLayoutConstraint *topConstraint = [self.contentView.topAnchor constraintEqualToAnchor:self.topAnchor constant:0];
        NSLayoutConstraint *bottomConstraint = [self.contentView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:0];
        
        [NSLayoutConstraint activateConstraints:@[leftConstraint, rightConstraint, topConstraint, bottomConstraint]];
    }
    
    self.tagsCollectionView.layer.cornerRadius = 12;
    self.tagsCollectionView.layer.masksToBounds = YES;
    
    [self registerCellNibs];
}

- (void)registerCellNibs {
    [self.tagsCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([TagCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:TagCollectionViewCellId];
}

- (void)setupWithTags:(NSArray <NSString *> *)tags
         selectedTags:(NSArray <NSString *> *)selectedTags
            typeTitle:(NSString *)title {
    self.typeLabel.text = title;
    self.tags = tags;
    self.selectedTags = [NSMutableArray arrayWithArray:selectedTags];
    
    [self.tagsCollectionView reloadData];
}

+ (CGFloat)heightWithTags:(NSArray <NSString *> *)tags typeTitle:(NSString *)title{
    if (tags.count == 0) {
        return 50.f;
    }
    
    static HomeworkTagsTableViewCell *tempCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tempCell = [[[NSBundle mainBundle] loadNibNamed:@"HomeworkTagsTableViewCell" owner:nil options:nil] lastObject];
        [tempCell setupWithTags:tags selectedTags:nil typeTitle:title];
    });
    
    [tempCell setupWithTags:tags selectedTags:nil typeTitle:title];
    
    CGRect  rect = tempCell.frame;
    tempCell.frame = CGRectMake(rect.origin.x, rect.origin.y, ScreenWidth - 24, rect.size.height);
    
    [tempCell.contentView setNeedsLayout];
    [tempCell.contentView layoutIfNeeded];
    
    [tempCell.contentView setNeedsUpdateConstraints];
    [tempCell.contentView updateConstraintsIfNeeded];
    
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
    
    
    NSLog(@"~~~~~~~~~%f  %f",collectionView.frame.size.width, collectionView.frame.size.height);
    
    NSString *tag = self.tags[indexPath.item];
    TagCollectionViewCell *cell = (TagCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    if ([self.selectedTags containsObject:tag]) {
        [self.selectedTags removeObject:tag];
        [cell setChoice:NO];
    } else {
        if (self.bSingleSelect)
        {
            if (self.selectedTags.count == 1)
            {
                NSString * lastTag = [self.selectedTags objectAtIndex:0];
                NSInteger lastIndex = [self.tags indexOfObject:lastTag];
                TagCollectionViewCell *lastCell = (TagCollectionViewCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:lastIndex inSection:0]];
                [lastCell setChoice:NO];
                [self.selectedTags removeAllObjects];
            }
        }
        [self.selectedTags addObject:tag];
        [cell setChoice:YES];
    }
    
    if (self.selectCallback != nil) {
        self.selectCallback(tag);
    }
}

@end

