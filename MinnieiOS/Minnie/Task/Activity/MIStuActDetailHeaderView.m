//
//  MIStuActDetailHeaderView.m
//  MinnieStudent
//
//  Created by songzhen on 2019/6/9.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import "MIStuActDetailHeaderView.h"
#import "HomeworkImageCollectionViewCell.h"
#import "HomeworkVideoCollectionViewCell.h"
#import "HomeworkAudioCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface MIStuActDetailHeaderView ()<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UIImageView *headerImagV;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionHeightContraint;

@end

@implementation MIStuActDetailHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.itemSize = CGSizeMake(90, 110);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 12;
    self.collectionView.collectionViewLayout = layout;
    self.contentLabel.preferredMaxLayoutWidth = ScreenWidth - 24;
    [self registerCellNibs];
}

- (void)registerCellNibs {
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"HomeworkImageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:HomeworkImageCollectionViewCellId];
    [self.collectionView registerNib:[UINib nibWithNibName:@"HomeworkVideoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:HomeworkVideoCollectionViewCellId];
    [self.collectionView registerNib:[UINib nibWithNibName:@"HomeworkAudioCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:HomeworkAudioCollectionViewCellId];
}

- (void)setActInfo:(ActivityInfo *)actInfo{
    
    _actInfo = actInfo;
    NSString *text = nil;
    for (HomeworkItem *item in _actInfo.items) {
        if ([item.type isEqualToString:HomeworkItemTypeText]) {
            text = item.text;
            break;
        }
    }
    if (_actInfo.items.count == 1) {
        self.collectionHeightContraint.constant = 0.f;
        self.collectionView.hidden = YES;
    } else {
        self.collectionHeightContraint.constant = 110.f;
        self.collectionView.hidden = NO;
        [self.collectionView reloadData];
        
    }
    NSMutableAttributedString * mAttribute = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineSpacing = 5;
    [mAttribute addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, text.length)];
    [mAttribute addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, text.length)];
    self.contentLabel.attributedText = mAttribute;
    NSString *urlStr = self.actInfo.actPicUrl;
    if (urlStr.length == 0) {
        urlStr = self.actInfo.actCoverUrl;
    }
    [self.headerImagV sd_setImageWithURL:[urlStr imageURLWithWidth:ScreenWidth] placeholderImage:[UIImage imageNamed:@"activity_placeholder"] completed:nil];
}


+ (CGFloat)heightWithActInfo:(ActivityInfo *)actInfo {
   
    if (actInfo.cellHeight > 0) {
        return actInfo.cellHeight;
    }
    
    static MIStuActDetailHeaderView *headerView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        headerView = [[[NSBundle mainBundle] loadNibNamed:@"MIStuActDetailHeaderView" owner:nil options:nil] lastObject];
    });
    
    NSString *text = nil;
    for (HomeworkItem *item in actInfo.items) {
        if ([item.type isEqualToString:HomeworkItemTypeText]) {
            text = item.text;
            break;
        }
    }
    NSMutableAttributedString * mAttribute = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineSpacing = 5;
    [mAttribute addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, text.length)];
    [mAttribute addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, text.length)];
    headerView.contentLabel.attributedText = mAttribute;
    CGSize size = [headerView.contentLabel systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    if (actInfo.items.count > 1) {
        size.height += 110;
    }
    size.height = size.height + 150 + 50;
    return size.height;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger number = 0;
    
    for (HomeworkItem *item in self.actInfo.items) {
        if (![item.type isEqualToString:HomeworkItemTypeText]) {
            number++;
        }
    }
    return number;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = nil;
    
    HomeworkItem *item = self.actInfo.items[indexPath.row+1];
    if ([item.type isEqualToString:HomeworkItemTypeImage]) {
        HomeworkImageCollectionViewCell *imageCell = [collectionView dequeueReusableCellWithReuseIdentifier:HomeworkImageCollectionViewCellId forIndexPath:indexPath];
        
        [imageCell setupWithHomeworkItem:item name:[NSString stringWithFormat:@"材料%zd", indexPath.row+1]];
        
        cell = imageCell;
    } else if ([item.type isEqualToString:HomeworkItemTypeVideo]) {
        HomeworkVideoCollectionViewCell *videoCell = [collectionView dequeueReusableCellWithReuseIdentifier:HomeworkVideoCollectionViewCellId forIndexPath:indexPath];
        
        [videoCell setupWithHomeworkItem:item name:[NSString stringWithFormat:@"材料%zd", indexPath.row+1]];
        
        cell = videoCell;
    } else if ([item.type isEqualToString:HomeworkItemTypeAudio]) {
        HomeworkAudioCollectionViewCell *audioCell = [collectionView dequeueReusableCellWithReuseIdentifier:HomeworkAudioCollectionViewCellId forIndexPath:indexPath];
        
        [audioCell setupWithHomeworkItem:item name:[NSString stringWithFormat:@"材料%zd", indexPath.row+1]];
        
        cell = audioCell;
    } else { // 异常保护
        HomeworkImageCollectionViewCell *imageCell = [collectionView dequeueReusableCellWithReuseIdentifier:HomeworkImageCollectionViewCellId forIndexPath:indexPath];
        cell = imageCell;
    }
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    
    HomeworkItem *item = self.actInfo.items[indexPath.row+1];
    if ([item.type isEqualToString:HomeworkItemTypeImage]) {
        
        HomeworkImageCollectionViewCell *cell = (HomeworkImageCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        
        if (self.imageCallback != nil) {
            self.imageCallback(item.imageUrl, cell.homeworkImageView, indexPath.item);
        }
    } else if ([item.type isEqualToString:HomeworkItemTypeVideo]) {
        if (self.videoCallback != nil) {
            self.videoCallback(item.videoUrl);
        }
    } else if ([item.type isEqualToString:HomeworkItemTypeAudio]) {
        if (self.audioCallback != nil) {
            self.audioCallback(item.audioUrl,item.audioCoverUrl);
        }
    }
}


@end


