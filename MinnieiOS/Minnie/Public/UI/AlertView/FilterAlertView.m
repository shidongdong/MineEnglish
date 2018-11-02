//
//  FilterAlertView.m
//  Minnie
//
//  Created by 栋栋 施 on 2018/11/1.
//  Copyright © 2018年 minnieedu. All rights reserved.
//

#import "FilterAlertView.h"

@interface FilterAlertView()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewTopConstraint;
@property (weak, nonatomic) IBOutlet UITableView *mTableView;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property(nonatomic,strong)NSArray * fliterArray;
@property(nonatomic,assign)NSInteger defultIndex;
@property (nonatomic, copy) FliterAlertActionCallback actionCallback;
@end

@implementation FilterAlertView

+ (instancetype)showInView:(UIView *)superView atFliterType:(NSInteger)index forBgViewOffset:(CGFloat)offset withAtionBlock:(FliterAlertActionCallback)block
{
   // self.defultIndex = index;
    
    FilterAlertView *alertView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([FilterAlertView class])
                                                          owner:nil
                                                        options:nil] lastObject];
    
    alertView.defultIndex = index;
    alertView.actionCallback = block;
    [superView addSubview:alertView];
    
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
        }];
    });
}

- (void)hideWithAnimation {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.backgroundView.alpha = 1.f;
        [UIView animateWithDuration:0.3 animations:^{
            self.backgroundView.alpha = 0.f;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    });
}


- (void)awakeFromNib {
    [super awakeFromNib];
    //   self.defultIndex = -1;
    self.fliterArray = @[@"按时间",@"按任务",@"按人"];
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
