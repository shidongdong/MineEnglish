//
//  CircleAndStarTableViewCell.h
//  X5
//
//  Created by yebw on 2017/9/4.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CircleClickCallback)(void);
typedef void(^StarClickCallback)(void);

extern CGFloat const CircleAndStarTableViewCellHeight;
extern NSString * const CircleAndStarTableViewCellId;

@interface CircleAndStarTableViewCell : UITableViewCell

@property (nonatomic, copy) CircleClickCallback circleClickCallback;
@property (nonatomic, copy) StarClickCallback starClickCallback;

- (void)update;

- (void)updateTitle:(NSString *)title image:(NSString *)image;

@end
