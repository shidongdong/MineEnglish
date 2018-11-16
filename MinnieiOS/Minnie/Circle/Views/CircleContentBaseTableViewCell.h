//
//  CircleContentBaseTableViewCell.h
//  X5
//
//  Created by yebw on 2017/11/15.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircleHomework.h"
#import "User.h"

typedef void(^CircleDeleteClickCallback)(void);
typedef void(^CircleLikeClickCallback)(void);
typedef void(^CircleCommentClickCallback)(void);
typedef void(^CircleAvatarClickCallback)(void);
@interface CircleContentBaseTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *bgImageView;
@property (nonatomic, weak) IBOutlet UIImageView *avatarImageView;
@property (nonatomic, weak) IBOutlet UILabel *nicknameLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UIButton *deleteButton;
@property (nonatomic, weak) IBOutlet UIButton *likeButton;

@property (nonatomic, copy) CircleDeleteClickCallback deleteClickCallback;
@property (nonatomic, copy) CircleLikeClickCallback likeClickCallback;
@property (nonatomic, copy) CircleCommentClickCallback commentClickCallback;
@property (nonatomic, copy) CircleAvatarClickCallback avatarClickCallback;
- (void)setupWithHomework:(CircleHomework *)homework;

- (void)updateLikeState:(BOOL)liked;

@end

