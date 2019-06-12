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

NS_ASSUME_NONNULL_BEGIN

@interface MIReadingWordsView : UIView

@property (nonatomic,strong) HomeworkItem *wordsItem;
@property (nonatomic,copy) MIReadingWordsFinish readingWordsCallBack;


- (void)startPlayWords;
- (void)stopPlayWords;

@end

NS_ASSUME_NONNULL_END
