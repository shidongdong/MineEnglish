//
//  FilterAlertView.m
//  Minnie
//
//  Created by 栋栋 施 on 2018/11/1.
//  Copyright © 2018年 minnieedu. All rights reserved.
//

#import "FilterAlertView.h"

@interface FilterAlertView()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *filterHieghtConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewTopConstraint;
@property (weak, nonatomic) IBOutlet UITableView *mTableView;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property(nonatomic,strong)NSArray * fliterArray;
@property(nonatomic,assign)NSInteger defultIndex;
@property (nonatomic, copy) FliterAlertActionCallback actionCallback;
@end

@implementation FilterAlertView

+ (instancetype)showInView:(UIView *)superView atFliterType:(NSInteger)index forFliterArray:(NSArray *)array withAtionBlock:(FliterAlertActionCallback)block
{
   // self.defultIndex = index;
    
    FilterAlertView *alertView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([FilterAlertView class])
                                                          owner:nil
                                                        options:nil] lastObject];
    
    
    CGFloat offset = isIPhoneX ? 88 : 64;
    alertView.bgViewTopConstraint.constant = offset;
    alertView.filterHieghtConstraint.constant = array.count * 44 + 12;
    alertView.fliterArray = array;
    alertView.defultIndex = index;
    alertView.actionCallback = block;
    [superView addSubview:alertView];
    [FilterAlertView addConstraintsWithAlertView:alertView inSuperView:superView];
    [alertView showWithAnimation];
    return alertView;
}

- (IBAction)dismissClick:(UIButton *)sender {
    [self hideWithAnimation];
}

- (void)showWithAnimation {
    self.hidden = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.hidden = NO;
        
        self.backgroundView.alpha = 0.f;
        [UIView animateWithDuration:0.3 animations:^{
            self.backgroundView.alpha = 1.f;
        } completion:^(BOOL finished) {
            [self.mTableView reloadData];
        }];
    });
}

- (void)hideWithAnimation {
//    dispatch_async(dispatch_get_main_queue(), ^{
//
//        self.backgroundView.alpha = 1.f;
//        self.mTableView.alpha = 1.f;
//        [UIView animateWithDuration:0.3 animations:^{
//            self.backgroundView.alpha = 0.f;
//            self.mTableView.alpha = 0.f;
//        } completion:^(BOOL finished) {
            [self removeFromSuperview];
//        }];
//    });
}

+ (void)addConstraintsWithAlertView:(FilterAlertView *)alertView inSuperView:(UIView *)superView {
    alertView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *leadingConstraint = [NSLayoutConstraint constraintWithItem:alertView
                                                                         attribute:NSLayoutAttributeLeading
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:superView
                                                                         attribute:NSLayoutAttributeLeading
                                                                        multiplier:1
                                                                          constant:0];
    
    NSLayoutConstraint *trailingConstraint = [NSLayoutConstraint constraintWithItem:alertView
                                                                          attribute:NSLayoutAttributeTrailing
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:superView
                                                                          attribute:NSLayoutAttributeTrailing
                                                                         multiplier:1
                                                                           constant:0];
    
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:alertView
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:superView
                                                                     attribute:NSLayoutAttributeTop
                                                                    multiplier:1
                                                                      constant:0];
    
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:alertView
                                                                        attribute:NSLayoutAttributeBottom
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:superView
                                                                        attribute:NSLayoutAttributeBottom
                                                                       multiplier:1
                                                                         constant:0];
    [superView addConstraints:@[leadingConstraint, trailingConstraint, topConstraint, bottomConstraint]];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    //   self.defultIndex = -1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.fliterArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"fliterCellId"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"fliterCellId"];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont systemFontOfSize:12.0];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (self.defultIndex == indexPath.row)
    {
        cell.textLabel.textColor = [UIColor colorWithHex:0x0098FE];
    }
    else
    {
        cell.textLabel.textColor = [UIColor colorWithHex:0x999999];
    }
    cell.textLabel.text = [self.fliterArray objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    self.actionCallback(indexPath.row);
    [self hideWithAnimation];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
