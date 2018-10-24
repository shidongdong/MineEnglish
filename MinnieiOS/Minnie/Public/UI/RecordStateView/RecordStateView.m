//
//  RecordStateView.m
//  AudioRecorder
//
//  Created by yebw on 2018/3/30.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "RecordStateView.h"
#import <Masonry/Masonry.h>

@interface RecordStateView()

@property (nonatomic, weak) IBOutlet UILabel *tipLabel;
@property (nonatomic, weak) IBOutlet UIView *bgView;

@end

@implementation RecordStateView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if (view == self) {
        return nil;
    }

    return view;
}

+ (RecordStateView *)showInView:(UIView *)superView {
    RecordStateView *v = [[[NSBundle mainBundle] loadNibNamed:@"RecordStateView" owner:nil options:nil] lastObject];

    [v updateWithCancelState:NO];
    [superView addSubview:v];
    [v mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(superView);
    }];
    
    return v;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.bgView.layer.cornerRadius = 12.f;
    self.bgView.layer.masksToBounds = YES;
}

- (void)updateWithCancelState:(BOOL)isCancelState {
    if (!isCancelState) {
        [self.tipLabel setText:@"手指上滑，取消发送"];
    } else {
        [self.tipLabel setText:@"松开手指，取消发送"];
    }
}

- (void)hide {
    [self removeFromSuperview];
}

@end
