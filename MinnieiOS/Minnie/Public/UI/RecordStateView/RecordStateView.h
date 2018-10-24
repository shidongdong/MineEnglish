//
//  RecordStateView.h
//  AudioRecorder
//
//  Created by yebw on 2018/3/30.
//  Copyright © 2018年 netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordStateView : UIView

+ (RecordStateView *)showInView:(UIView *)superView;

- (void)updateWithCancelState:(BOOL)isCancelState;

- (void)hide;

@end
