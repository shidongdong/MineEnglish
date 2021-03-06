//
//  HomeworkVideoTableViewCell.h
//  X5Teacher
//
//  Created by yebw on 2018/1/24.
//  Copyright © 2018年 netease. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HomeworkVideoTableViewCellPlayCallback)(NSString *);
typedef void(^HomeworkVideoTableViewCellDeleteCallback)(void);

extern NSString * const HomeworkVideoTableViewCellId;
extern CGFloat const HomeworkVideoTableViewCellHeight;

@interface HomeworkVideoTableViewCell : UITableViewCell

@property (nonatomic, copy) HomeworkVideoTableViewCellPlayCallback playCallback;
@property (nonatomic, copy) HomeworkVideoTableViewCellDeleteCallback deleteCallback;

- (void)setupWithVideoUrl:(NSString *)videoUrl
                 coverUrl:(NSString *)coverUrl;

@end

