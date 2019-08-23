//
//  CorrectHomeworkScoreTableViewCell.h
//  Minnie
//
//  Created by 栋栋 施 on 2018/12/24.
//  Copyright © 2018年 minnieedu. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const CorrectHomeworkScoreTableViewCellId;
extern CGFloat const CorrectHomeworkScoreTableViewCellHeight;

typedef void(^CorrectHomeworkScoreTableViewCellClickScoreCallback)(NSInteger);
typedef void(^CorrectHomeworkScoreTableViewCellClickShareCallback)(BOOL share,BOOL shareType);

@interface CorrectHomeworkScoreTableViewCell : UITableViewCell

@property (nonatomic, copy) CorrectHomeworkScoreTableViewCellClickScoreCallback scoreCallback;
@property (nonatomic, copy) CorrectHomeworkScoreTableViewCellClickShareCallback shareCallback;

- (void)updateRecommendScoreHomeworkLevel:(NSInteger)level score:(NSInteger)score;


@end

