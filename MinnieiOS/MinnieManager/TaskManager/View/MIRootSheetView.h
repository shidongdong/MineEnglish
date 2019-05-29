//
//  RootSheetView.h
//  
//
//  Created by songzhen on 2019/5/27.
//  根模块视图

#import <UIKit/UIKit.h>

#define kRootModularWidth           90.f

NS_ASSUME_NONNULL_BEGIN

@protocol RootSheetViewDelete <NSObject>

- (void)rootSheetViewClickedIndex:(NSInteger)index;

@end

@interface MIRootSheetView : UIView

@property (nonatomic, weak) id<RootSheetViewDelete> delegate;

@property (nonatomic,assign) NSInteger selectIndex;

@end

NS_ASSUME_NONNULL_END
