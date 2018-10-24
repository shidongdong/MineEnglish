//
//  CircleMoreCommentsTableViewCell.m
//  X5
//
//  Created by yebw on 2017/11/5.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "CircleMoreCommentsTableViewCell.h"

NSString * const CircleMoreCommentsTableViewCellId = @"CircleMoreCommentsTableViewCellId";
CGFloat const CircleMoreCommentsTableViewCellHeight = 44;

@interface CircleMoreCommentsTableViewCell()

@property (nonatomic, weak) IBOutlet UIImageView *grayBGImageView;

@end

@implementation CircleMoreCommentsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.grayBGImageView.image = [[UIImage imageNamed:@"gray_bottom_corner_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(2, 6.f, 6.f, 6.f) resizingMode:UIImageResizingModeStretch];
}

- (IBAction)moreButtonPressed:(id)sender {
    if (self.moreButtonClickCallback != nil) {
        self.moreButtonClickCallback();
    }
}

@end
