//
//  HomeworkTagsTableViewCell.h
//  X5Teacher
//
//  Created by yebw on 2018/1/24.
//  Copyright © 2018年 netease. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HomeworkTagsTableViewCellSelectCallback)(NSString *);
typedef void(^HomeworkTagsTableViewCellManageCallback)(void);

typedef NS_ENUM(NSInteger, HomeworkTagsTableViewCellSelectType) {
    HomeworkTagsTableViewCellSelectSigleType = 0, // 单选
    HomeworkTagsTableViewCellSelectMutiType = 1, // 消息相关
    HomeworkTagsTableViewCellSelectNoneType = 2, // 无选择状态
};

extern NSString * const HomeworkTagsTableViewCellId;

@interface HomeworkTagsTableViewCell : UITableViewCell

@property (nonatomic, copy) HomeworkTagsTableViewCellSelectCallback selectCallback;
@property (nonatomic, copy) HomeworkTagsTableViewCellManageCallback manageCallback;

@property (nonatomic, assign) HomeworkTagsTableViewCellSelectType type; //选择状态

- (void)setupWithTags:(NSArray <NSString *> *)tags
         selectedTags:(NSArray <NSString *> *)selectedTags
            typeTitle:(NSString *)title
      collectionWidth:(CGFloat)collectionWidth;

+ (CGFloat)heightWithTags:(NSArray <NSString *> *)tags typeTitle:(NSString *)title collectionWidth:(CGFloat)collectionWidth;
@end
