//
//  HomeworkDiffTableViewCell.h
//  Minnie
//
//  Created by 栋栋 施 on 2018/10/25.
//  Copyright © 2018年 minnieedu. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const HomeworkDiffTableViewCellId;
extern CGFloat const HomeworkDiffcultTableViewCellHeight;

typedef void(^HomeworkDiffTableViewCellSelectCallback)(NSInteger);

@interface HomeworkDiffTableViewCell : UITableViewCell

@property (nonatomic, copy)HomeworkDiffTableViewCellSelectCallback selectCallback;

- (void)updateHomeworkLevel:(NSInteger)level;

@end
