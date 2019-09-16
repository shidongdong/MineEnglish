//
//  AudioPlayerViewController.m
//  Minnie
//
//  Created by 栋栋 施 on 2018/12/6.
//  Copyright © 2018年 minnieedu. All rights reserved.
//

#import "AudioPlayerViewController.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>
@interface AudioPlayerViewController ()

@property(nonatomic,strong)UIImageView * coverImageView;

@end

@implementation AudioPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.coverImageView = [[UIImageView alloc] init];
    self.coverImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.coverImageView.backgroundColor = [UIColor blackColor];
    [self.contentOverlayView addSubview:self.coverImageView];
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentOverlayView);
    }];
    // Do any additional setup after loading the view.
}

- (void)setOverlyViewCoverUrl:(NSString *)cover
{
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:cover]];
}


@end
