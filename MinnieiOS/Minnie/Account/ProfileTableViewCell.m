//
//  ProfileTableViewCell.m
//  X5
//
//  Created by yebw on 2017/9/4.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "ProfileTableViewCell.h"

CGFloat const ProfileTableViewCellHeight = 102.f;
NSString * const ProfileTableViewCellId = @"ProfileTableViewCellId";

@interface ProfileTableViewCell()

@property (nonatomic, weak) IBOutlet UIView *containerView;

@end

@implementation ProfileTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.avatarImageView.layer.cornerRadius = 32.f;
    self.avatarImageView.layer.masksToBounds = YES;
    
    self.containerView.layer.cornerRadius = 12.f;
    self.containerView.layer.shadowOpacity = 0.4;// 阴影透明度
    self.containerView.layer.shadowColor = [UIColor colorWithHex:0xEEEEEE].CGColor;
    self.containerView.layer.shadowRadius = 3;
    self.containerView.layer.shadowOffset = CGSizeMake(2, 4);
    
#if TEACHERSIDE
    self.classButton.hidden = YES;
#else
    self.classButton.layer.cornerRadius = 12.f;
    self.classButton.layer.masksToBounds = YES;
    [self.classButton setBackgroundImage:[Utils imageWithColor:[UIColor colorWithRed:0 green:0xCE/255.f blue:0 alpha:1.f]] forState:UIControlStateNormal];
    [self.classButton setBackgroundImage:[Utils imageWithColor:[UIColor colorWithRed:0 green:0xCE/255.f blue:0 alpha:.8f]] forState:UIControlStateHighlighted];
    [self.classButton setBackgroundImage:[Utils imageWithColor:[UIColor colorWithRed:0xDD/255.f green:0xDD/255.f blue:0xDD/255.f alpha:1.f]] forState:UIControlStateDisabled];
#endif
}

- (IBAction)editAvatarButtonPressed:(id)sender {
    if (self.editAvatarCallback != nil) {
        self.editAvatarCallback();
    }
}

- (IBAction)editNicknameButtonPressed:(id)sender {
    if (self.editNicknameCallback != nil) {
        self.editNicknameCallback();
    }
}

- (IBAction)classButtonPressed:(id)sender {
    if (self.classButtonClickCallback != nil) {
        self.classButtonClickCallback();
    }
}

@end

