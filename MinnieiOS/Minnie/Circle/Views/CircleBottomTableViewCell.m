//
//  CircleBottomTableViewCell.m
//  X5
//
//  Created by yebw on 2017/11/5.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "CircleBottomTableViewCell.h"

NSString * const CircleBottomTableViewCellId = @"CircleBottomTableViewCellId";
CGFloat const CircleBottomTableViewCellHeight = 14;

@interface CircleBottomTableViewCell()

@property (nonatomic, weak) IBOutlet UIImageView *whiteBGImageView;

@end

@implementation CircleBottomTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.whiteBGImageView.image = [[UIImage imageNamed:@"white_bottom_corner_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(2, 14.f, 14.f, 14.f) resizingMode:UIImageResizingModeStretch];
}

@end
