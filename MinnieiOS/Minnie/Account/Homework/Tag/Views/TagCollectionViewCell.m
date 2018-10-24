//
//  TagCollectionViewCell.m
//  X5Teacher
//
//  Created by yebw on 2017/12/20.
//  Copyright © 2017年 netease. All rights reserved.
//

#import "TagCollectionViewCell.h"
#import "UIColor+HEX.h"

NSString * const TagCollectionViewCellId = @"TagCollectionViewCellId";

@interface TagCollectionViewCell()

@property (nonatomic, weak) IBOutlet UIImageView *bgImageView;
@property (nonatomic, weak) IBOutlet UILabel *tagLabel;

@end

@implementation TagCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.bgImageView.layer.cornerRadius = 14.f;
    self.bgImageView.layer.masksToBounds = YES;
}

- (void)setupWithTag:(NSString *)tag {
    self.tagLabel.text = tag;
}

- (void)setChoice:(BOOL)choice {
    _choice = choice;
    
    if (choice) {
        self.tagLabel.textColor = [UIColor whiteColor];
        self.bgImageView.backgroundColor = [UIColor colorWithHex:0x00ce00];
    } else {
        self.tagLabel.textColor = [UIColor colorWithHex:0x666666];
        self.bgImageView.backgroundColor = [UIColor whiteColor];
    }
}

+ (CGSize)cellSizeWithTag:(NSString *)tag {
    static TagCollectionViewCell *tempCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tempCell = [[[NSBundle mainBundle] loadNibNamed:@"TagCollectionViewCell" owner:nil options:nil] lastObject];
    });
    
    [tempCell setupWithTag:tag];

    return [tempCell systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
}

@end
