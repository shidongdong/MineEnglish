//
//  HomeworkImageTableViewCell.h
//  X5Teacher
//
//  Created by yebw on 2018/1/24.
//  Copyright © 2018年 netease. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HomeworkImageTableViewCellDeleteCallback)(void);

extern NSString * const HomeworkImageTableViewCellId;
extern CGFloat const HomeworkImageTableViewCellHeight;

@interface HomeworkImageTableViewCell : UITableViewCell

@property (nonatomic, copy) HomeworkImageTableViewCellDeleteCallback deleteCallback;

- (void)setupWithImageUrl:(NSString *)ImageUrl;

@end


