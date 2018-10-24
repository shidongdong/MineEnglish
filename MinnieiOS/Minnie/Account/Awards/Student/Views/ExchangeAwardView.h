//
//  ExchangeAwardView.h
//  X5
//
//  Created by yebw on 2017/9/19.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Award;

typedef void(^ExchangeButtonClickCallback)(void);

@interface ExchangeAwardView : UIView
    
+ (void)showExchangeAwardViewInView:(UIView *)superView
                          withAward:(Award *)award
                         starCount:(long long)starCount
                   exchangeCallback:(ExchangeButtonClickCallback)exchangeCallback;

@end

