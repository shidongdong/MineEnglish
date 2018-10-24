//
//  HomeworkDetailCommentTableViewCell.h
//  X5
//
//  Created by yebw on 2017/11/15.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "Comment.h"

typedef void(^HomeworkDetailCommentReplyClickCallback)(void);

extern NSString * const HomeworkDetailCommentTableViewCellId;

@interface HomeworkDetailCommentTableViewCell : UITableViewCell

@property (nonatomic, copy) HomeworkDetailCommentReplyClickCallback commentReplyClickCallback;

+ (CGFloat)heightOfComment:(Comment *)comment
                isFirstOne:(BOOL)isFirstOne
                 isLastOne:(BOOL)isLastOne;

- (void)setupWithComment:(Comment *)comment
              isFirstOne:(BOOL)isFirstOne
               isLastOne:(BOOL)isLastOne;

@end
