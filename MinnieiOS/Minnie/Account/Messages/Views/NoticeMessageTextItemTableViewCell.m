//
//  NoticeMessageTextItemTableViewCell.m
//  X5
//
//  Created by yebw on 2017/9/19.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "NoticeMessageTextItemTableViewCell.h"

NSString * const NoticeMessageTextItemTableViewCellId = @"NoticeMessageTextItemTableViewCellId";

@interface NoticeMessageTextItemTableViewCell()

@property (nonatomic, weak) IBOutlet UILabel *itemTextLabel;

@end

@implementation NoticeMessageTextItemTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.itemTextLabel.preferredMaxLayoutWidth = ScreenWidth - 2 + 24.f;
}

+ (CGFloat)heightWithMessageItem:(NoticeMessageItem *)item {
    if (item.cellHeight > 0) {
        return item.cellHeight;
    }
    
    static NoticeMessageTextItemTableViewCell *cellForCaculatingHeight = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cellForCaculatingHeight = [[[NSBundle mainBundle] loadNibNamed:@"NoticeMessageTextItemTableViewCell" owner:nil options:nil] lastObject];
    });
    
    [cellForCaculatingHeight setupWithMessageItem:item];
    
    CGSize size = [cellForCaculatingHeight.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    item.cellHeight = size.height;
    
    return size.height;
}

- (void)setupWithMessageItem:(NoticeMessageItem *)item {
    self.itemTextLabel.text = item.text;
}

@end

