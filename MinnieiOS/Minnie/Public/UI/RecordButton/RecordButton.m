//
//  RecordButton.m
//  AVFileDemo
//
//  Created by yebw on 2018/3/31.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "RecordButton.h"
#import <Masonry/Masonry.h>

@interface RecordButton()

@property (nonatomic, strong) IBOutlet UILabel *label;
@property (nonatomic, assign) RecordButtonState state;

@end

@implementation RecordButton

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self != nil) {
        [self customInit];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self != nil) {
        [self customInit];
    }
    
    return self;
}

- (void)customInit {
    _label = [[UILabel alloc] init];
    _label.text = @"按住 说话";
    _label.font = [UIFont systemFontOfSize:15.f];
    _label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_label];
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.stateChangeBlock != nil) {
        self.state = RecordButtonStateTouchDown;
        self.stateChangeBlock(self.state);
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint location = [[touches anyObject] locationInView:self];
    if (CGRectContainsPoint(self.bounds, location)) {
        if (self.stateChangeBlock != nil && self.state!=RecordButtonStateMoveInside) {
            self.state = RecordButtonStateMoveInside;
            self.stateChangeBlock(self.state);
        }
    } else {
        if (self.stateChangeBlock != nil && self.state!=RecordButtonStateMoveOutside) {
            self.state = RecordButtonStateMoveOutside;
            self.stateChangeBlock(self.state);
        }
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint location = [[touches anyObject] locationInView:self];
    if (CGRectContainsPoint(self.bounds, location)) {
        if (self.stateChangeBlock != nil && self.state!=RecordButtonStateTouchUpInside) {
            self.state = RecordButtonStateTouchUpInside;
            self.stateChangeBlock(self.state);
        }
    } else {
        if (self.stateChangeBlock != nil && self.state!=RecordButtonStateTouchUpOutside) {
            self.state = RecordButtonStateTouchUpOutside;
            self.stateChangeBlock(self.state);
        }
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.stateChangeBlock != nil && self.state!=RecordButtonStateTouchCancelled) {
        self.state = RecordButtonStateTouchCancelled;
        self.stateChangeBlock(self.state);
    }
}

@end


