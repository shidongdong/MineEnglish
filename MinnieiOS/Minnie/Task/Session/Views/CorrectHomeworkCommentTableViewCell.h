//
//  CorrectHomeworkCommentTableViewCell.h
//  Minnie
//
//  Created by 栋栋 施 on 2018/12/24.
//  Copyright © 2018年 minnieedu. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const CorrectHomeworkCommentTableViewCellId;
extern CGFloat const CorrectHomeworkCommentTableViewCellHeight;

typedef void(^CorrectHomeworkCommentTableViewCellCommentCallback)(NSString *);

@interface CorrectHomeworkCommentTableViewCell : UITableViewCell

@property (nonatomic, copy) CorrectHomeworkCommentTableViewCellCommentCallback commentCallback;

- (void)setupCommentInfo:(NSString *)info;

@end

