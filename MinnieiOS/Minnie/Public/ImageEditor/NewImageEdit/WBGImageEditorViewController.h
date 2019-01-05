//
//  WBGImageEditorViewController.h
//  CLImageEditorDemo
//
//  Created by Jason on 2017/2/27.
//  Copyright © 2017年 CALACULU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBGImageEditorCollectionViewCell.h"
typedef void(^ImageEditViewControllerSendCallback)(UIImage *);

typedef NS_ENUM(NSUInteger, EditorMode) {
    EditorNonMode,
    EditorDrawMode,
    EditorTextMode,
    EditorClipMode,
    EditorPaperMode,
};

extern NSString * const kColorPanNotificaiton;
extern NSString * const kColorPanRemoveNotificaiton;


@interface WBGColorPan : UIView
@property (nonatomic, strong, readonly) UIColor *currentColor;
//@property (nonatomic, weak) id<WBGImageEditorDataSource> dataSource;
@end

@interface WBGImageEditorViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UICollectionView *mCollectionView;

@property (nonatomic, strong) WBGImageEditorCollectionViewCell * editorContent;
@property (strong, nonatomic, readonly) UIImageView *drawingView;
@property (strong, nonatomic, readonly) IBOutlet WBGColorPan *colorPan;


//对外开放
@property (nonatomic, assign) BOOL onlyForSend;
@property (nonatomic, strong) NSArray<UIImage *> *thumbnailImages;
@property (nonatomic, strong) NSArray<NSString *> *originalImageUrls;
@property (nonatomic, assign) NSInteger selectIndex;      //初始化选择位置


@property (nonatomic, copy) ImageEditViewControllerSendCallback sendCallback;


@end
