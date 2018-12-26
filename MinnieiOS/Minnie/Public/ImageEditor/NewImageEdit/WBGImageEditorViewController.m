//
//  WBGImageEditorViewController.m
//  CLImageEditorDemo
//
//  Created by Jason on 2017/2/27.
//  Copyright © 2017年 CALACULU. All rights reserved.
//

#import "WBGImageEditorViewController.h"
#import "WBGImageToolBase.h"
#import "WBGDrawTool.h"
#import "UIView+YYAdd.h"
#import "YYCategories.h"
#import <SDWebImage/UIImageView+WebCache.h>
NSString * const kColorPanNotificaiton = @"kColorPanNotificaiton";
NSString * const kColorPanRemoveNotificaiton = @"kColorPanRemoveNotificaiton";

#pragma mark - WBGImageEditorViewController

@interface WBGImageEditorViewController () <UINavigationBarDelegate, UIScrollViewDelegate> {
    
    __weak IBOutlet NSLayoutConstraint *topBarTop;
    __weak IBOutlet NSLayoutConstraint *bottomBarBottom;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topbarConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomBarConstraint;

@property (nonatomic, strong, nullable) WBGImageToolBase *currentTool;
@property (weak, nonatomic) IBOutlet UIView *topBar;

@property (strong, nonatomic) UIView *topBannerView;
@property (strong, nonatomic) UIView *bottomBannerView;
@property (strong, nonatomic) UIView *leftBannerView;
@property (strong, nonatomic) UIView *rightBannerView;
@property (weak,   nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) UIImageView *drawingView;
@property (weak,   nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet WBGColorPan *colorPan;
@property (nonatomic, strong) WBGDrawTool *drawTool;
@property (nonatomic, copy  ) UIImage   *originImage;
@property (nonatomic, assign) CGFloat clipInitScale;
@property (nonatomic, assign) BOOL barsHiddenStatus;
@property (nonatomic, assign) EditorMode currentMode;
@end

@implementation WBGImageEditorViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (id)init
{
    self = [self initWithNibName:@"WBGImageEditorViewController" bundle:[NSBundle bundleForClass:self.class]];
    if (self){
        
    }
    return self;
}


//- (id)initWithImage:(UIImage*)image delegate:(id<WBGImageEditorDelegate>)delegate dataSource:(id<WBGImageEditorDataSource>)dataSource;
//{
//    self = [self init];
//    if (self){
//        _originImage = image;
//        self.delegate = delegate;
//        self.dataSource = dataSource;
//    }
//    return self;
//}

//- (id)initWithDelegate:(id<WBGImageEditorDelegate>)delegate
//{
//    self = [self init];
//    if (self){
//
//        self.delegate = delegate;
//    }
//    return self;
//}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addNotication];
    // Do any additional setup after loading the view from its nib.
    
    BOOL iPHONEX = ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO);
    
    CGFloat bottomHeight;
    if (iPHONEX)
    {
        bottomHeight = 70.0f;
        self.topbarConstraint.constant = 88.0f;
        
    }
    else
    {
        bottomHeight = 50.0f;
        self.topbarConstraint.constant = 64.0f;
    }
    self.bottomBarConstraint.constant = bottomHeight;
    self.colorPan.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - bottomHeight, [UIScreen mainScreen].bounds.size.width, 50);
    [self.view addSubview:self.colorPan];
    if (self.originalImageUrl.length > 0) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.originalImageUrl]
                          placeholderImage:self.thumbnailImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                              if (error == nil) {
                                  [self adjustInit];
                                 // [self adjustCanvasSize];
                              }
                          }];
    } else {
        self.imageView.image = self.thumbnailImage;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self adjustInit];
           // [self adjustCanvasSize];
        });
    }

}

- (void)addNotication
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(undo) name:kColorPanRemoveNotificaiton object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(undo) name:kColorPanNotificaiton object:nil];
    
}


- (void)adjustInit
{
    [self initImageScrollView];
    
    @weakify(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @strongify(self)
        [self startPanDrawMode];
    });
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //ShowBusyIndicatorForView(self.view);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      //  HideBusyIndicatorForView(self.view);
        [self refreshImageView];
    });
    
    //获取自定制组件 - fecth custom config
  //  [self configCustomComponent];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (!self.drawingView) {
        self.drawingView = [[UIImageView alloc] init];
        self.drawingView.contentMode = UIViewContentModeCenter;
        self.drawingView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin;
        [self.imageView.superview addSubview:self.drawingView];
        self.drawingView.userInteractionEnabled = YES;
    } else {
        //self.drawingView.frame = self.imageView.superview.frame;
    }
    self.drawingView.frame = self.imageView.frame;
    
//    self.topBannerView.frame = CGRectMake(0, 0, self.imageView.width, CGRectGetMinY(self.imageView.frame));
//    self.bottomBannerView.frame = CGRectMake(0, CGRectGetMaxY(self.imageView.frame), self.imageView.width, self.drawingView.height - CGRectGetMaxY(self.imageView.frame));
//    self.leftBannerView.frame = CGRectMake(0, 0, CGRectGetMinX(self.imageView.frame), self.drawingView.height);
//    self.rightBannerView.frame= CGRectMake(CGRectGetMaxX(self.imageView.frame), 0, self.drawingView.width - CGRectGetMaxX(self.imageView.frame), self.drawingView.height);
}

- (UIView *)topBannerView {
    if (!_topBannerView) {
        _topBannerView = ({
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = self.scrollView.backgroundColor;
            [self.imageView.superview addSubview:view];
            view;
        });
    }
    
    return _topBannerView;
}

- (UIView *)bottomBannerView {
    if (!_bottomBannerView) {
        _bottomBannerView = ({
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = self.scrollView.backgroundColor;
            [self.imageView.superview addSubview:view];
            view;
        });
    }
    return _bottomBannerView;
}

- (UIView *)leftBannerView {
    if (!_leftBannerView) {
        _leftBannerView = ({
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = self.scrollView.backgroundColor;
            [self.imageView.superview addSubview:view];
            view;
        });
    }
    
    return _leftBannerView;
}

- (UIView *)rightBannerView {
    if (!_rightBannerView) {
        _rightBannerView = ({
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = self.scrollView.backgroundColor;
            [self.imageView.superview addSubview:view];
            view;
        });
    }
    
    return _rightBannerView;
}

#pragma mark - 初始化 &getter
- (WBGDrawTool *)drawTool {
    if (_drawTool == nil) {
        _drawTool = [[WBGDrawTool alloc] initWithImageEditor:self];
        
//  __weak typeof(self)weakSelf = self;
        _drawTool.drawToolStatus = ^(BOOL canPrev) {
//            if (canPrev) {
//                weakSelf.undoButton.hidden = NO;
//            } else {
//                weakSelf.undoButton.hidden = YES;
//            }
        };
        _drawTool.drawingCallback = ^(BOOL isDrawing) {
         //   [weakSelf hiddenTopAndBottomBar:isDrawing animation:YES];
        };
        _drawTool.drawingDidTap = ^(void) {
         //   [weakSelf hiddenTopAndBottomBar:!weakSelf.barsHiddenStatus animation:YES];
        };
        _drawTool.pathWidth = 4.0f;
    }
    
    return _drawTool;
}

- (void)initImageScrollView {
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.delegate = self;
    self.scrollView.clipsToBounds = NO;
    self.scrollView.backgroundColor = [UIColor blackColor];

}

- (void)refreshImageView {
    if (self.imageView.image == nil) {
        self.imageView.image = self.originImage;
    }
    
    [self resetImageViewFrame];
    [self resetZoomScaleWithAnimated:NO];
    [self viewDidLayoutSubviews];
}

- (void)resetImageViewFrame {
    CGSize size = (_imageView.image) ? _imageView.image.size : _imageView.frame.size;
    if(size.width > 0 && size.height > 0 ) {
        CGFloat ratio = MIN(_scrollView.frame.size.width / size.width, _scrollView.frame.size.height / size.height);
        CGFloat W = ratio * size.width * _scrollView.zoomScale;
        CGFloat H = ratio * size.height * _scrollView.zoomScale;
        
        _imageView.frame = CGRectMake(MAX(0, (_scrollView.width-W)/2), MAX(0, (_scrollView.height-H)/2), W, H);
    }
}

- (void)resetZoomScaleWithAnimated:(BOOL)animated
{
    CGFloat Rw = _scrollView.frame.size.width / _imageView.frame.size.width;
    CGFloat Rh = _scrollView.frame.size.height / _imageView.frame.size.height;
    
    //CGFloat scale = [[UIScreen mainScreen] scale];
    CGFloat scale = 1;
    Rw = MAX(Rw, _imageView.image.size.width / (scale * _scrollView.frame.size.width));
    Rh = MAX(Rh, _imageView.image.size.height / (scale * _scrollView.frame.size.height));
    
    _scrollView.contentSize = _imageView.frame.size;
    _scrollView.minimumZoomScale = 1;
    _scrollView.maximumZoomScale = MAX(MAX(Rw, Rh), 3);
    
    [_scrollView setZoomScale:_scrollView.minimumZoomScale animated:animated];
    [self scrollViewDidZoom:_scrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (BOOL)prefersStatusBarHidden {
//    return YES;
//}

#pragma mark- ScrollView delegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageView.superview;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{ }

#pragma mark - Property
- (void)setCurrentTool:(WBGImageToolBase *)currentTool {
    if(_currentTool != currentTool) {
        [_currentTool cleanup];
        _currentTool = currentTool;
        [_currentTool setup];
        
    }
    
//    [self swapToolBarWithEditting];
}

#pragma mark- ImageTool setting
+ (NSString*)defaultIconImagePath {
    return nil;
}

+ (CGFloat)defaultDockedNumber {
    return 0;
}

+ (NSString *)defaultTitle {
    return @"";
}

+ (BOOL)isAvailable {
    return YES;
}

+ (NSArray *)subtools {
    return [NSArray new];
}

+ (NSDictionary*)optionalInfo {
    return nil;
}


#pragma mark - Actions
///发送
- (IBAction)sendAction:(UIButton *)sender {

    if (self.onlyForSend) {
        [self send];
        
        return;
    }
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil
                                                                     message:nil
                                                              preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *sendAction = [UIAlertAction actionWithTitle:@"发送"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                           [self send];
                                                       }];
    
    UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"保存"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                           [self save];
                                                       }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消"
                                                     style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction * _Nonnull action) {
                                                   }];
    
    [alertVC addAction:sendAction];
    [alertVC addAction:saveAction];
    [alertVC addAction:cancel];
    
    [self presentViewController:alertVC
                       animated:YES
                     completion:nil];
}
    
    

- (void)save
{
    [self buildClipImageShowHud:YES clipedCallback:^(UIImage *clipedImage) {
        UIImageWriteToSavedPhotosAlbum(clipedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }];
}

- (void)send {
    
    [self buildClipImageShowHud:YES clipedCallback:^(UIImage *clipedImage) {
        [self dismissViewControllerAnimated:YES
                                 completion:^{
                                     if (self.sendCallback != nil) {
                                         self.sendCallback(clipedImage);
                                     }
                                 }];
    }];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error == nil) {
        NSLog(@"%@", @"保存成功啦");
        [HUD showWithMessage:@"保存成功"];
    }
}

///涂鸦模式
- (void)startPanDrawMode {
    if (_currentMode == EditorDrawMode) {
        return;
    }
    //先设置状态，然后在干别的
    self.currentMode = EditorDrawMode;
    self.currentTool = self.drawTool;
}


- (IBAction)backAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)undo{
    if (self.currentMode == EditorDrawMode) {
        WBGDrawTool *tool = (WBGDrawTool *)self.currentTool;
        [tool backToLastDraw];
    }
}


#pragma mark -


//- (void)hiddenColorPan:(BOOL)yesOrNot animation:(BOOL)animation {
//    [UIView animateWithDuration:animation ? .25f : 0.f delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:yesOrNot ? UIViewAnimationOptionCurveEaseOut : UIViewAnimationOptionCurveEaseIn animations:^{
//        self.colorPan.hidden = yesOrNot;
//    } completion:^(BOOL finished) {
//
//    }];
//}

+ (UIImage *)createViewImage:(UIView *)shareView {
    UIGraphicsBeginImageContextWithOptions(shareView.bounds.size, NO, [UIScreen mainScreen].scale);
    [shareView.layer renderInContext:UIGraphicsGetCurrentContext()];
    shareView.layer.affineTransform = shareView.transform;
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)buildClipImageShowHud:(BOOL)showHud clipedCallback:(void(^)(UIImage *clipedImage))clipedCallback {
    if (showHud) {
        //ShowBusyTextIndicatorForView(self.view, @"生成图片中...", nil);
    }
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CGFloat WS = self.imageView.width/ self.drawingView.width;
        CGFloat HS = self.imageView.height/ self.drawingView.height;
    
  //  dispatch_async(dispatch_get_main_queue(), ^{
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.imageView.image.size.width, self.imageView.image.size.height),
                                               NO,
                                               self.imageView.image.scale);
   // });
    
        [self.imageView.image drawAtPoint:CGPointZero];
        CGFloat viewToimgW = self.imageView.width/self.imageView.image.size.width;
        CGFloat viewToimgH = self.imageView.height/self.imageView.image.size.height;
        __unused CGFloat drawX = self.imageView.left/viewToimgW;
//        CGFloat drawY = self.imageView.top/viewToimgH;
        [_drawingView.image drawInRect:CGRectMake(0, 0, self.imageView.image.size.width/WS, self.imageView.image.size.height/HS)];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        for (UIView *subV in _drawingView.subviews) {
//            if ([subV isKindOfClass:[WBGTextToolView class]]) {
//                WBGTextToolView *textLabel = (WBGTextToolView *)subV;
//                //进入正常状态
//                [WBGTextToolView setInactiveTextView:textLabel];
//
//                //生成图片
//                __unused UIView *tes = textLabel.archerBGView;
//                UIImage *textImg = [self.class screenshot:textLabel.archerBGView orientation:UIDeviceOrientationPortrait usePresentationLayer:YES];
//                CGFloat rotation = textLabel.archerBGView.layer.transformRotationZ;
//                textImg = [textImg imageRotatedByRadians:rotation];
//
//                CGFloat selfRw = self.imageView.bounds.size.width / self.imageView.image.size.width;
//                CGFloat selfRh = self.imageView.bounds.size.height / self.imageView.image.size.height;
//
//                CGFloat sw = textImg.size.width / selfRw;
//                CGFloat sh = textImg.size.height / selfRh;
//
//                [textImg drawInRect:CGRectMake(textLabel.left/selfRw, (textLabel.top/selfRh) - drawY, sw, sh)];
//            }
//        }
//    });
    
//        UIImage *textImg = [self.class screenshot:self.imageView orientation:UIDeviceOrientationPortrait usePresentationLayer:YES];
    
        UIImage *tmp = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
      //  dispatch_async(dispatch_get_main_queue(), ^{
            //HideBusyIndicatorForView(self.view);
            UIImage *image = [UIImage imageWithCGImage:tmp.CGImage scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
            clipedCallback(image);
            
      //  });
//    });
}

+ (UIImage *)screenshot:(UIView *)view orientation:(UIDeviceOrientation)orientation usePresentationLayer:(BOOL)usePresentationLayer
{
    __block CGSize targetSize = CGSizeZero;
    dispatch_async(dispatch_get_main_queue(), ^{
        CGSize size = view.bounds.size;
        targetSize = CGSizeMake(size.width * view.layer.transformScaleX, size.height *  view.layer.transformScaleY);
    });
    
    UIGraphicsBeginImageContextWithOptions(targetSize, NO, [UIScreen mainScreen].scale);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    dispatch_async(dispatch_get_main_queue(), ^{
        [view drawViewHierarchyInRect:CGRectMake(0, 0, targetSize.width, targetSize.height) afterScreenUpdates:NO];
    });
    CGContextRestoreGState(ctx);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end

#pragma mark - Class WBGWColorPan
@interface WBGColorPan ()
@property (nonatomic, strong) UIColor *currentColor;
@property (nonatomic, strong) NSArray * colors;

@property (nonatomic, weak) IBOutlet UIImageView *redImageView;
@property (nonatomic, weak) IBOutlet UIImageView *redSelectedImageView;
@property (nonatomic, weak) IBOutlet UIImageView *whiteImageView;
@property (nonatomic, weak) IBOutlet UIImageView *whiteSelectedImageView;
@property (nonatomic, weak) IBOutlet UIImageView *blackImageView;
@property (nonatomic, weak) IBOutlet UIImageView *blackSelectedImageView;
@property (nonatomic, weak) IBOutlet UIImageView *blueImageView;
@property (nonatomic, weak) IBOutlet UIImageView *blueSelectedImageView;


@end

@implementation WBGColorPan

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.currentColor = [UIColor colorWithHex:0xFF4858];
        @weakify(self);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            @strongify(self)
            [self configUI];
        });
    }
    return self;
}


- (IBAction)clearAction:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kColorPanRemoveNotificaiton object:nil];
}

- (void)configUI
{
    self.colors = @[[UIColor colorWithHex:0xFF4858], [UIColor whiteColor], [UIColor colorWithHex:0x333333],[UIColor colorWithHex:0x0098FE]];
    
    self.redImageView.layer.cornerRadius = 13.f;
    self.redImageView.layer.masksToBounds = YES;
    self.redSelectedImageView.layer.cornerRadius = 18.f;
    self.redSelectedImageView.layer.masksToBounds = YES;
    self.redSelectedImageView.layer.borderColor = [UIColor colorWithHex:0xCCCCCC].CGColor;
    self.redSelectedImageView.layer.borderWidth = 2;
    
    self.whiteImageView.layer.cornerRadius = 13.f;
    self.whiteImageView.layer.masksToBounds = YES;
    self.whiteImageView.layer.borderColor = [UIColor colorWithHex:0x999999].CGColor;
    self.whiteImageView.layer.borderWidth = 0.5;
    self.whiteSelectedImageView.layer.cornerRadius = 18.f;
    self.whiteSelectedImageView.layer.masksToBounds = YES;
    self.whiteSelectedImageView.layer.borderColor = [UIColor colorWithHex:0xCCCCCC].CGColor;
    self.whiteSelectedImageView.layer.borderWidth = 2;
    
    self.blackImageView.layer.cornerRadius = 13.f;
    self.blackImageView.layer.masksToBounds = YES;
    self.blackSelectedImageView.layer.cornerRadius = 18.f;
    self.blackSelectedImageView.layer.masksToBounds = YES;
    self.blackSelectedImageView.layer.borderColor = [UIColor colorWithHex:0xCCCCCC].CGColor;
    self.blackSelectedImageView.layer.borderWidth = 2;
    
    
    self.blueImageView.layer.cornerRadius = 13.f;
    self.blueImageView.layer.masksToBounds = YES;
    self.blueSelectedImageView.layer.cornerRadius = 18.f;
    self.blueSelectedImageView.layer.masksToBounds = YES;
    self.blueSelectedImageView.layer.borderColor = [UIColor colorWithHex:0xCCCCCC].CGColor;
    self.blueSelectedImageView.layer.borderWidth = 2;
    
}

- (IBAction)colorBtnAction:(UIButton *)sender {
    NSInteger tag = sender.tag - 100;
    
    self.redSelectedImageView.hidden = tag!=0;
    self.whiteSelectedImageView.hidden = tag!=1;
    self.blackSelectedImageView.hidden = tag!=2;
    self.blueSelectedImageView.hidden = tag!=3;
    self.currentColor = [self.colors objectAtIndex:tag];
}

@end

