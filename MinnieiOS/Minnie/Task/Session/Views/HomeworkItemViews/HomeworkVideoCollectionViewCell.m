//
//  HomeworkVideoCollectionViewCell.m
//  X5Teacher
//
//  Created by yebw on 2018/2/3.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "HomeworkVideoCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Masonry.h"
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
    
    UIView * bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor colorWithRed:0/255.f green:0/255.f blue:0/255.f alpha:0.2];
    [self.homeworkImageView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.homeworkImageView);
    }];
    
}

- (void)setupWithHomeworkItem:(HomeworkItem *)item name:(NSString *)name {
    [self.homeworkImageView sd_setImageWithURL:[item.videoUrl videoCoverUrlWithWidth:90.f height:90.f] placeholderImage:[UIImage imageNamed:@"attachment_placeholder"]];
    self.homeworkLabel.text = name;
}

+ (CGSize)cellSize {
    return CGSizeMake(90, 110);
}

@end
