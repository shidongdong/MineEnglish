//
//  StudentCollectionViewCell.m
//  X5
//
//  Created by yebw on 2017/9/4.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "StudentCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

NSString * const StudentCollectionViewCellId = @"StudentCollectionViewCellId";

@interface StudentCollectionViewCell()

@property (nonatomic, weak) IBOutlet UIView *deleteView;
@property (nonatomic, weak) IBOutlet UIImageView *deleteModeImageView;
@property (nonatomic, weak) IBOutlet UIImageView *avatarImageView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;

@property (nonatomic, weak) User *currentUser;

@end

@implementation StudentCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.avatarImageView.layer.cornerRadius = 32.f;
    self.avatarImageView.layer.masksToBounds = YES;
    
    self.deleteView.hidden = YES;
}

+ (CGSize)size {
    return CGSizeMake(64, 84);
}

- (IBAction)deleteButtonPressed:(id)sender {
    // 当前是否是选择的状态
    BOOL selected = !self.deleteModeImageView.hidden;
    
    self.deleteModeImageView.hidden = selected;
    
    if (self.deleteCallback != nil) {
        self.deleteCallback(self.currentUser.userId, selected);
    }
}

- (void)setupWithUser:(User *)user {
    self.currentUser = user;
    
    if (user.avatarUrl.length > 0) {
        [self.avatarImageView sd_setImageWithURL:[user.avatarUrl imageURLWithWidth:64.f]];
    } else {
        [self.avatarImageView setImage:[UIImage imageNamed:@""]];
    }
    
    [self.nameLabel setText:user.nickname];
}

- (void)updateWithDeleteMode:(BOOL)deleteMode selected:(BOOL)selected {
    self.deleteView.hidden = !deleteMode;
    self.deleteModeImageView.hidden = !selected;
}

@end

