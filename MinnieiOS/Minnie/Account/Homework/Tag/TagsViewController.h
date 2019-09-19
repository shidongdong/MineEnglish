//
//  TagsViewController.h
//  X5Teacher
//
//  Created by yebw on 2017/12/20.
//  Copyright © 2017年 netease. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger, TagsType) {
    TagsHomeworkTipsType = 0,   // 作业创建通用标签
    TagsHomeworkFormType = 1,   // 作业创建形式标签
    TagsCommentType = 2,        // 评语标签
    TagsCampusType,             // 校区标签
};

@interface TagsViewController : BaseViewController

@property (nonatomic, assign)TagsType type;

@end
