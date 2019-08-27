//
//  MILookImagesViewController.m
//  MinnieManager
//
//  Created by songzhen on 2019/8/26.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import "MILookImagesViewController.h"

@interface MILookImagesViewController ()
@property (strong, nonatomic) UIImageView *imageV;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet UIView *titleBgView;

@end

@implementation MILookImagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    self.titleBgView.hidden = YES;
    self.view.backgroundColor = [UIColor emptyBgColor];
    self.scrollview.bounces = NO;
    self.imageV = [[UIImageView alloc] init];
    [self.scrollview addSubview:self.imageV];
    
    
}

- (void)updateContentImage{
    
    if (_imageUrl.length == 0) {
        return;
    }
    //@"http://api.minniedu.com:8888/main.png"
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:_imageUrl] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
        if (image.size.width > 0) {
            
            CGFloat imageWidth = (ScreenWidth - kRootModularWidth)/2.0;
            CGFloat imageHeight = imageWidth * image.size.height / image.size.width;
            self.imageV.frame =  CGRectMake(0, 0 , imageWidth, imageHeight);
            self.scrollview.contentSize = CGSizeMake(imageWidth, imageHeight);
        }
    }];
}

- (void)setImageUrl:(NSString *)imageUrl{
    
    _imageUrl = imageUrl;
    [self updateContentImage];
    if (_imageUrl.length ==0) {
        self.titleBgView.hidden = YES;
    } else {
        self.titleBgView.hidden = NO;
    }
}

@end
