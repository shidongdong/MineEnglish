//
//  CircleHomework.h
//  X5
//
//  Created by yebw on 2017/10/8.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "HomeworkSession.h"
#import "Comment.h"

// 朋友圈的作业
@interface CircleHomework : HomeworkSession

// 点赞的用户
@property (nonatomic, strong) NSArray<User *> *likeUsers;

// 评论
@property (nonatomic, assign) NSUInteger commentCount;
@property (nonatomic, strong) NSArray<Comment *> *comments;

// 当前用户是否已经赞
@property (nonatomic, assign) BOOL liked;

// 创建的时间
@property (nonatomic, assign) long long commitTime;

// 班级等级
@property (nonatomic, assign) NSInteger classLevel;

@end


