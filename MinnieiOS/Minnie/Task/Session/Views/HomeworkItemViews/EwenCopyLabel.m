//
//  EwenCopyLabel.m
//  SuoMusicStudent
//
//  Created by apple on 2016/10/20.
//  Copyright © 2016年 suomusic. All rights reserved.
//

#import "EwenCopyLabel.h"
#define UIColorRGB(x,y,z,a) [UIColor colorWithRed:x/255.0 green:y/255.0 blue:z/255.0 alpha:a]

@implementation EwenCopyLabel

-(BOOL)canBecomeFirstResponder {
    return YES;
}

// 可以响应的方法
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    return (action == @selector(newCopy:));
}

//针对于响应方法的实现
-(void)newCopy:(id)sender {
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = self.text;
}

//UILabel默认是不接收事件的，我们需要自己添加touch事件
-(void)attachTapHandler {
    self.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *touch = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    touch.minimumPressDuration = 1.0;
    [self addGestureRecognizer:touch];
}

//绑定事件
//- (id)initWithFrame:(CGRect)frame {
//    self = [super initWithFrame:frame];
//    if (self) {
//        [self attachTapHandler];
//        [[NSNotificationCenter defaultCenter] addObserverForName:UIMenuControllerWillHideMenuNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
//            self.backgroundColor = [UIColor clearColor];
//        }];
//    }
//    return self;
//}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self attachTapHandler];
        self.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}

-(void)awakeFromNib {
    [super awakeFromNib];
    [self attachTapHandler];
}

-(void)handleTap:(UIGestureRecognizer*) recognizer {
    if (recognizer.state != UIGestureRecognizerStateBegan || ![self becomeFirstResponder])
    {
        return;
    }
    
    SEL action = @selector(newCopy:);
    NSMutableArray *menuItems = [[NSMutableArray alloc] init];
    if (action) {
        UIMenuItem *item = [[UIMenuItem alloc] initWithTitle:@"复制" action:action];
        if (item) {
            [menuItems addObject:item];
        }
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleMenuWillShowNotification:)
                                                     name:UIMenuControllerWillShowMenuNotification
                                                   object:nil];
        [[UIMenuController sharedMenuController] setTargetRect:self.frame inView:self.superview];
        [UIMenuController sharedMenuController].menuItems = menuItems;
        [UIMenuController sharedMenuController].menuVisible = YES;
    }
    
}

- (void)handleMenuWillHideNotification:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIMenuControllerWillHideMenuNotification
                                                  object:nil];
}

- (void)handleMenuWillShowNotification:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIMenuControllerWillShowMenuNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleMenuWillHideNotification:)
                                                 name:UIMenuControllerWillHideMenuNotification
                                               object:nil];
}

//-(void)newFunc{
//    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
//    pboard.string = self.text;
//}




@end

