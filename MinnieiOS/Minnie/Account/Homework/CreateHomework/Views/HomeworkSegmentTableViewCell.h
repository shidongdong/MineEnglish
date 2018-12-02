//
//  HomeworkSegmentTableViewCell.h
//  Minnie
//
//  Created by 栋栋 施 on 2018/10/25.
//  Copyright © 2018年 minnieedu. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const HomeworkSegmentTableViewCellId;
extern CGFloat const HomeworkTypeTableViewCellHeight;

typedef void(^HomeworkSegmentTableViewCellSelectCallback)(NSInteger);

@interface HomeworkSegmentTableViewCell : UITableViewCell

@property (nonatomic, copy)HomeworkSegmentTableViewCellSelectCallback selectCallback;

//- (void)setContentData:(NSArray *)datas atDefultIndex:(NSInteger)index;

- (void)updateHomeworkCategoryType:(NSInteger)category withStyleType:(NSInteger)style;

@end
