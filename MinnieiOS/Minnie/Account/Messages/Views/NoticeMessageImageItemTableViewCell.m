//
//  NoticeMessageImageItemTableViewCell.m
//  X5
//
//  Created by yebw on 2017/9/19.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "NoticeMessageImageItemTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

NSString * const NoticeMessageImageItemTableViewCellId = @"NoticeMessageImageItemTableViewCellId";

@interface NoticeMessageImageItemTableViewCell()

@property (nonatomic, weak) IBOutlet UIImageView *itemImageView;

@end

@implementation NoticeMessageImageItemTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

+ (CGFloat)heightWithMessageItem:(NoticeMessageItem *)item {
    CGFloat height = 0.f;
    
    CGFloat width = ScreenWidth - 24.f;
    if (item.imageWidth==0 || item.imageHeight==0) {
        height = width;
    } else {
        height = width * item.imageHeight / item.imageWidth;
    }

    height += 12.f;

    return height;
}

- (void)setupWithMessageItem:(NoticeMessageItem *)item {
    [self.itemImageView sd_setImageWithURL:[NSURL URLWithString:item.imageUrl]];
}
@end
