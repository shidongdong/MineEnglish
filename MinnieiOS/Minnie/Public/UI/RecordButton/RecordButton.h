//
//  RecordButton.h
//  AVFileDemo
//
//  Created by yebw on 2018/3/31.
//  Copyright © 2018年 netease. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, RecordButtonState) {
    RecordButtonStateTouchDown = 1,
    RecordButtonStateMoveInside = 2,
    RecordButtonStateMoveOutside = 3,
    RecordButtonStateTouchUpInside = 4,
    RecordButtonStateTouchUpOutside = 5,
    RecordButtonStateTouchCancelled = 6,
};

typedef void (^RecordButtonStateChangeBlock) (RecordButtonState);

@interface RecordButton : UIView

@property (nonatomic, copy) RecordButtonStateChangeBlock stateChangeBlock;

@end


