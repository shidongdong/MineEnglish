//
//  CorrectHomeworkHisCommentTableViewCell.m
//  Minnie
//
//  Created by 栋栋 施 on 2018/12/24.
//  Copyright © 2018年 minnieedu. All rights reserved.
//

#import "CorrectHomeworkHisCommentTableViewCell.h"
#import "TagCollectionViewCell.h"
NSString * const CorrectHomeworkHisCommentTableViewCellId = @"CorrectHomeworkHisCommentTableViewCellId";

@interface CorrectHomeworkHisCommentTableViewCell()<UICollectionViewDataSource,UICollectionViewDelegate>

@property(nonatomic,strong)NSArray * tags;
@property (weak, nonatomic) IBOutlet UICollectionView *tagsCollectionView;

@end

@implementation CorrectHomeworkHisCommentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.tagsCollectionView.backgroundColor = [UIColor whiteColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)registerCellNibs {
    [self.tagsCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([TagCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:TagCollectionViewCellId];
}

- (void)setupWithTags:(NSArray <NSString *> *)tags{
    self.tags = tags;
    [self.tagsCollectionView reloadData];
}

+ (CGFloat)heightWithTags:(NSArray <NSString *> *)tags{
    if (tags.count == 0) {
        return 50.f;
    }
    
    static CorrectHomeworkHisCommentTableViewCell *tempCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tempCell = [[[NSBundle mainBundle] loadNibNamed:@"CorrectHomeworkHisCommentTableViewCell" owner:nil options:nil] lastObject];
        [tempCell setupWithTags:tags];
    });
    
    [tempCell setupWithTags:tags];
    
    [tempCell setNeedsLayout];
    [tempCell layoutIfNeeded];
    
    [tempCell setNeedsUpdateConstraints];
    [tempCell updateConstraintsIfNeeded];
    
    CGSize size = [tempCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height + 50.f;
}


- (IBAction)addCommentPressed:(id)sender {
    
    if (self.addCommentCallback)
    {
        self.addCommentCallback();
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
    
    if (self.clickCommentCallback)
    {
        self.clickCommentCallback(tag);
    }
    
}

@end
