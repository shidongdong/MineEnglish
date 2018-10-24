//
//  Comment.h
//  X5
//
//  Created by yebw on 2017/10/8.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import <Mantle/Mantle.h>
#import <UIKit/UIKit.h>
#import "User.h"

// 朋友圈作业的评论
@interface Comment : MTLModel<MTLJSONSerializing>

@property (nonatomic, assign) NSInteger homeworkSessionId;
@property (nonatomic, assign) NSUInteger commentId;

@property (nonatomic, strong) User *user;
@property (nonatomic, strong) Comment *originalComment;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) long long time;
@property (nonatomic, assign) BOOL deleted;

@property (nonatomic, copy) NSString *videoUrl;

// 朋友圈里面的
@property (nonatomic, assign) CGFloat cellHeightInCircle;
@property (nonatomic, assign) BOOL isLastCommentInCircle;

// 作业详情里面的
@property (nonatomic, assign) CGFloat cellHeightInDetail;

@end

