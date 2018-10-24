//
//  HomeworkAudioTableViewCell.h
//  X5Teacher
//
//  Created by yebw on 2018/1/24.
//  Copyright © 2018年 netease. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HomeworkAudioTableViewCellPlayCallback)(NSString *);
typedef void(^HomeworkAudioTableViewCellDeleteCallback)(void);

extern NSString * const HomeworkAudioTableViewCellId;
extern CGFloat const HomeworkAudioTableViewCellHeight;

@interface HomeworkAudioTableViewCell : UITableViewCell

@property (nonatomic, copy) HomeworkAudioTableViewCellPlayCallback playCallback;
@property (nonatomic, copy) HomeworkAudioTableViewCellDeleteCallback deleteCallback;

- (void)setupWithAudioUrl:(NSString *)AudioUrl duration:(NSTimeInterval)duration;

@end


