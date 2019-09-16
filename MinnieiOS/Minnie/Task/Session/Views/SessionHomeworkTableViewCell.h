//
//  SessionHomeworkTableViewCell.h
//  X5Teacher
//
//  Created by yebw on 2018/3/25.
//  Copyright © 2018年 netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeworkSession.h"

typedef void(^SessionHomeworkTableViewCellClickImageCallback)(NSString *, UIImageView *, NSInteger);
typedef void(^SessionHomeworkTableViewCellClickVideoCallback)(NSString *);
typedef void(^SessionHomeworkTableViewCellClickAudioCallback)(NSString *, NSString *);

// 跟读，单词记忆
typedef void(^SessionHomeworkTableViewCellClickStartTaskCallback)(void);

extern NSString * const SessionHomeworkTableViewCellId;

@interface SessionHomeworkTableViewCell : UITableViewCell

@property (nonatomic, copy) SessionHomeworkTableViewCellClickImageCallback imageCallback;
@property (nonatomic, copy) SessionHomeworkTableViewCellClickVideoCallback videoCallback;
@property (nonatomic, copy) SessionHomeworkTableViewCellClickAudioCallback audioCallback;
@property (nonatomic, copy) SessionHomeworkTableViewCellClickStartTaskCallback startTaskCallback;

- (void)setupWithHomeworkSession:(HomeworkSession *)homeworkSession;

+ (CGFloat)heightWithHomeworkSession:(HomeworkSession *)homeworkSession;

@end
