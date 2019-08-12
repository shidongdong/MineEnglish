//
//  MIReadingWordsView.h
//  Minnie
//
//  Created by songzhen on 2019/6/10.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeworkItem.h"

typedef void(^MIReadingWordsFinish)(void);

typedef void(^MIReadingWordsSeek)(CGFloat rate);

NS_ASSUME_NONNULL_BEGIN

@interface MIReadingWordsView : UIView

@property (nonatomic,strong) HomeworkItem *wordsItem;
@property (nonatomic,copy) MIReadingWordsFinish readingWordsCallBack;
@property (nonatomic,copy) MIReadingWordsSeek readingWordsSeekCallBack;

- (void)startPlayWords;
- (void)stopPlayWords;

- (void)invalidateTimer;

@end

NS_ASSUME_NONNULL_END
