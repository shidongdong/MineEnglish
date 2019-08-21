//
//  CircleVideoTableViewCell.m
//  X5
//
//  Created by yebw on 2017/10/8.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "CircleVideoTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MaskImageView.h"
#import "Application.h"

NSString * const CircleVideoTableViewCellId = @"CircleVideoTableViewCellId";

static CGFloat const CircleVideoThumbnailRatio = 140/222.f;

@interface CircleVideoTableViewCell()

@property (nonatomic, weak) IBOutlet MaskImageView *videoThumbnailView;

@end

@implementation CircleVideoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.avatarImageView.layer.cornerRadius = 22.f;
    self.avatarImageView.layer.masksToBounds = YES;
    
    self.classlevelLabel.layer.cornerRadius = 7.0f;
    self.classlevelLabel.layer.masksToBounds = YES;
//    self.classlevelLabel.layer.borderWidth = 0.5;
//    self.classlevelLabel.layer.borderColor = [UIColor colorWithHex:0x999999].CGColor;
    
    
    self.bgImageView.image = [[UIImage imageNamed:@"white_top_corner_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(14, 14, 10, 14) resizingMode:UIImageResizingModeStretch];
}

- (IBAction)videoButtonPressed:(id)sender {
    if (self.videoClickCallback != nil) {
        self.videoClickCallback();
    }
}
- (IBAction)headerAvatarPress:(id)sender {
    
    if (self.avatarClickCallback != nil) {
        self.avatarClickCallback();
    }
    
}

- (IBAction)deleteButtonPressed:(id)sender {
    if (self.deleteClickCallback != nil) {
        self.deleteClickCallback();
    }
}

- (IBAction)likeButtonPressed:(id)sender {
    if (self.likeClickCallback != nil) {
        self.likeClickCallback();
    }
}

- (IBAction)commentButtonPressed:(id)sender {
    if (self.commentClickCallback != nil) {
        self.commentClickCallback();
    }
}

- (void)setupWithHomework:(CircleHomework *)homework {
    self.nicknameLabel.text = homework.student.nickname;
    [self.avatarImageView sd_setImageWithURL:[homework.student.avatarUrl imageURLWithWidth:44.f]];
    [self.videoThumbnailView sd_setImageWithURL:[homework.videoUrl videoCoverUrlWithWidth:260.f height:164.f]];
    self.timeLabel.text = [Utils formatedDateString:homework.commitTime];
    self.classlevelLabel.text = [NSString stringWithFormat:@"%ld",homework.classLevel];
    self.deleteButton.hidden = APP.currentUser.userId != homework.student.userId;
    
    NSString *imageName = nil;
    if (homework.liked) {
        imageName = @"icon_like_selected";
    } else {
        imageName = @"icon_like_disabled";
    }
    [self.likeButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width - 24 - 70 - 60.f;
    
    UIImage *maskImage = [[UIImage imageNamed:@"三圆角_遮罩"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 15, 15, 15) resizingMode:UIImageResizingModeStretch];
    [self.videoThumbnailView fitShapeWithMaskImage:maskImage
                                       topCapInset:15
                                      leftCapInset:15
                                              size:CGSizeMake(width, width*CircleVideoThumbnailRatio)];
}

+ (CGFloat)cellHeight {
    CGFloat width = [UIScreen mainScreen].bounds.size.width - 24 - 70 - 60.f;
    
    return ceil(12.f + 34.f + width * CircleVideoThumbnailRatio + 44.f);
}

@end


