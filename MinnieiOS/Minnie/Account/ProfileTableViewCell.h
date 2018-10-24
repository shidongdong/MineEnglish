//
//  ProfileTableViewCell.h
//  X5
//
//  Created by yebw on 2017/9/4.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^EditAvatarCallback)(void);
typedef void(^EditNicknameCallback)(void);
typedef void(^ClassButtonClickCallback)(void);

extern CGFloat const ProfileTableViewCellHeight;
extern NSString * const ProfileTableViewCellId;

@interface ProfileTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *avatarImageView;
@property (nonatomic, weak) IBOutlet UILabel *nicknameLabel;
@property (nonatomic, weak) IBOutlet UIButton *classButton;

@property (nonatomic, copy) EditAvatarCallback editAvatarCallback;
@property (nonatomic, copy) EditNicknameCallback editNicknameCallback;
@property (nonatomic, copy) ClassButtonClickCallback classButtonClickCallback;

@end
