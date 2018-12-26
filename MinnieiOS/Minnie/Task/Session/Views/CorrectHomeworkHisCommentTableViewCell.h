//
//  CorrectHomeworkHisCommentTableViewCell.h
//  Minnie
//
//  Created by 栋栋 施 on 2018/12/24.
//  Copyright © 2018年 minnieedu. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const CorrectHomeworkHisCommentTableViewCellId;

typedef void(^CorrectHomeworkHisCommentTableViewCellAddCommentCallback)(void);
typedef void(^CorrectHomeworkHisCommentTableViewCellClickCommentCallback)(NSString *);


@interface CorrectHomeworkHisCommentTableViewCell : UITableViewCell

@property (nonatomic, copy) CorrectHomeworkHisCommentTableViewCellAddCommentCallback addCommentCallback;
@property (nonatomic, copy) CorrectHomeworkHisCommentTableViewCellClickCommentCallback clickCommentCallback;

- (void)setupWithTags:(NSArray <NSString *> *)tags;

+ (CGFloat)heightWithTags:(NSArray <NSString *> *)tags;

@end

