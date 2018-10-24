//
//  CircleCommentTableViewCell.h
//  X5
//
//  Created by yebw on 2017/10/8.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YYText/YYText.h>
#import "Comment.h"
#import "User.h"

typedef void(^CircleCommentReplyClickCallback)(void);

extern NSString * const CircleCommentTableViewCellId;

@interface CircleCommentTableViewCell : UITableViewCell

@property (nonatomic, copy) CircleCommentReplyClickCallback commentReplyClickCallback;

+ (CGFloat)heightOfComment:(Comment *)comment
                isFirstOne:(BOOL)isFirstOne
                 isLastOne:(BOOL)isLastOne;

- (void)setupWithComment:(Comment *)comment
              isFirstOne:(BOOL)isFirstOne
               isLastOne:(BOOL)isLastOne
                 hasMore:(BOOL)hasMore;

@end

