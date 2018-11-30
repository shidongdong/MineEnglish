//
//  StudentDetailHeaderCell.m
//  Minnie
//
//  Created by 栋栋 施 on 2018/11/8.
//  Copyright © 2018年 minnieedu. All rights reserved.
//

#import "StudentDetailHeaderCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

NSString * const StudentDetailHeaderCellId = @"StudentDetailHeaderCellId";

@interface StudentDetailHeaderCell()
{
    UIView * background;

}
@property (nonatomic, strong) NSString * mAvatarURL;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

@end

@implementation StudentDetailHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.avatarImageView.layer.cornerRadius = 40.f;
    self.avatarImageView.layer.masksToBounds = YES;
    
    // Initialization code
}

- (IBAction)headerAvatarClick:(UIButton *)sender {
    
    //创建一个黑色背景
    //初始化一个用来当做背景的View。我这里为了省时间计算，宽高直接用的5s的尺寸
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    background = bgView;
    [bgView setBackgroundColor:[UIColor blackColor]];
    [[[UIApplication sharedApplication] keyWindow] addSubview:bgView];
    
    //创建显示图像的视图
    //初始化要显示的图片内容的imageView（这里位置继续偷懒...没有计算）
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (ScreenHeight - ScreenWidth) / 2, ScreenWidth, ScreenWidth)];
    //要显示的图片，即要放大的图片
    [imgView sd_setImageWithURL:[self.mAvatarURL imageURLWithWidth:ScreenWidth]];
    [bgView addSubview:imgView];
    imgView.userInteractionEnabled = YES;
    //添加点击手势（即点击图片后退出全屏）
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeView)];
    [background addGestureRecognizer:tapGesture];
    [self shakeToShow:bgView];//放大过程中的动画
}

-(void)closeView{
    [background removeFromSuperview];
}

//放大过程中出现的缓慢动画
- (void) shakeToShow:(UIView*)aView{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.2;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [aView.layer addAnimation:animation forKey:nil];
}

- (void)setHeaderURL:(NSString *)avatarUrl
{
    if (avatarUrl != nil) {
        self.mAvatarURL = avatarUrl;
        [self.avatarImageView sd_setImageWithURL:[avatarUrl imageURLWithWidth:80.f]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
