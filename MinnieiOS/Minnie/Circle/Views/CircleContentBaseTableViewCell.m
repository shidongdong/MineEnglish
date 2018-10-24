//
//  CircleContentBaseTableViewCell.m
//  X5
//
//  Created by yebw on 2017/11/15.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "CircleContentBaseTableViewCell.h"

@implementation CircleContentBaseTableViewCell

- (void)setupWithHomework:(CircleHomework *)homework {
    // 子类实现
}

- (void)updateLikeState:(BOOL)liked {
    NSString *imageName = nil;
    if (liked) {
        imageName = @"icon_like_selected";
    } else {
        imageName = @"icon_like_disabled";
    }

    [self.likeButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

@end
