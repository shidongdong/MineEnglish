//
//  HomeworkVideoCollectionViewCell.m
//  X5Teacher
//
//  Created by yebw on 2018/2/3.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "HomeworkVideoCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

NSString * const HomeworkVideoCollectionViewCellId = @"HomeworkVideoCollectionViewCellId";

@interface HomeworkVideoCollectionViewCell()

@property (nonatomic, weak) IBOutlet UIImageView *homeworkImageView;
@property (nonatomic, weak) IBOutlet UILabel *homeworkLabel;

@end

@implementation HomeworkVideoCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.homeworkImageView.layer.cornerRadius = 12.f;
    self.homeworkImageView.layer.masksToBounds = YES;
}

- (void)setupWithHomeworkItem:(HomeworkItem *)item name:(NSString *)name {
    [self.homeworkImageView sd_setImageWithURL:[item.videoUrl videoCoverUrlWithWidth:90.f height:90.f] placeholderImage:[UIImage imageNamed:@"attachment_placeholder"]];
    self.homeworkLabel.text = name;
}

+ (CGSize)cellSize {
    return CGSizeMake(90, 110);
}

@end
