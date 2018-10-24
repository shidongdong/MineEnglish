//
//  HomeAddTableViewCell.h
//  X5Teacher
//
//  Created by yebw on 2018/1/26.
//  Copyright © 2018年 netease. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HomeworkAddTableViewCellAddCallback)(void);

extern NSString * const HomeworkAddTableViewCellId;
extern CGFloat const HomeworkAddTableViewCellHeight;

@interface HomeworkAddTableViewCell : UITableViewCell

@property (nonatomic, copy) HomeworkAddTableViewCellAddCallback addCallback;

@end
