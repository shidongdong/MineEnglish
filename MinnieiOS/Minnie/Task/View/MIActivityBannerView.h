//
//  MIActivityBannerView.h
//  Minnie
//
//  Created by songzhen on 2019/6/8.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityInfo.h"

@protocol MIActivityBannerViewDelegate;
NS_ASSUME_NONNULL_BEGIN

@interface MIActivityBannerView : UIView

@property (nonatomic, weak) id <MIActivityBannerViewDelegate> delegate;
// 是否自动滚动,默认Yes
@property (nonatomic, assign) BOOL autoScroll;
// 是否显示分页控件,默认Yes
@property (nonatomic, assign) BOOL showPageControl;
// 是否无限循环,默认Yes
@property (nonatomic, assign) BOOL infiniteLoop;
// 网络图片 url string 数组
@property (nonatomic, strong) NSArray<ActivityInfo*> * imagesGroup;

@end

NS_ASSUME_NONNULL_END

@protocol MIActivityBannerViewDelegate <NSObject>

@optional
- (void)bannerView:(MIActivityBannerView *_Nullable)bannerView didSelectItemAtIndex:(NSInteger)index;

@end

@interface MIActivityBannerViewCell : UICollectionViewCell

@property (nonatomic, strong) UIView * _Nullable cellBgView;
@property (nonatomic, strong) UIImageView * _Nullable imageView;

@end
