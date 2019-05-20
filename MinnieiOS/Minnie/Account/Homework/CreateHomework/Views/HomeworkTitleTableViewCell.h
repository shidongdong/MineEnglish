//
//  HomeworkTitleTableViewCell.h
//  X5Teacher
//
//  Created by yebw on 2018/1/24.
//  Copyright © 2018年 netease. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,CreateHomeworkCellType) {
    
    CreateHomeworkCell_Title,// 新建作业-标题
    CreateHomeworkCell_CorrectRemarks// 批改备注
};

extern NSString * const HomeworkTitleTableViewCellId;

typedef void(^CellHeightDidChangeCallback)(NSString *text, BOOL heightChanged);

@interface HomeworkTitleTableViewCell : UITableViewCell

@property (nonatomic, copy) CellHeightDidChangeCallback callback;

@property (nonatomic, assign) CreateHomeworkCellType cellType;

- (void)setupWithText:(NSString *)text title:(NSString *)title placeholder:(NSString *)holde;

+ (CGFloat)cellHeightWithText:(NSString *)text;

- (void)ajustTextView;

@end
