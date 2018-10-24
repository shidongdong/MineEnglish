//
//  CircleMoreCommentsTableViewCell.h
//  X5
//
//  Created by yebw on 2017/11/5.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CircleMoreButtonClickCallback)(void);

extern NSString * const CircleMoreCommentsTableViewCellId;
extern CGFloat const CircleMoreCommentsTableViewCellHeight;

@interface CircleMoreCommentsTableViewCell : UITableViewCell

@property (nonatomic, copy) CircleMoreButtonClickCallback moreButtonClickCallback;

@end
