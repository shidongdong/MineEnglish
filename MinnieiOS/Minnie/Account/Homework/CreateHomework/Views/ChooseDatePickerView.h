//
//  ChooseDatePickerView.h
//  MotherPlanet
//
//  Created by Coder on 2018/6/4.
//  Copyright © 2018年 Geek Zoo Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChooseDatePickerViewDelegate <NSObject>

- (void)finishSelectDate:(NSInteger)seconds;

@end

@interface ChooseDatePickerView : UIView

@property (nonatomic, weak) id <ChooseDatePickerViewDelegate>delegate;

- (void)show;

- (void)hide;

- (void)setDefultSeconds:(NSInteger)secs;

@end
