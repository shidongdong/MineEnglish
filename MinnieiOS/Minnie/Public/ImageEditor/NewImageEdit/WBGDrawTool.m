//
//  WBGDrawTool.m
//  CLImageEditorDemo
//
//  Created by Jason on 2017/2/28.
//  Copyright © 2017年 CALACULU. All rights reserved.
//

#import "WBGDrawTool.h"
#import "WBGImageEditorGestureManager.h"

@interface WBGDrawTool ()<DrawImageViewDelegate>

// 双手缩放，单手捏合
@property (nonatomic,assign) BOOL isDouble;

@end

@implementation WBGDrawTool {
    __weak DrawImageView        *_drawingView;
    CGSize                     _originalImageSize;
}

- (instancetype)initWithImageEditor:(WBGImageEditorViewController *)editor {
    self = [super init];
    if(self) {
        self.editor   = editor;
        _allLineMutableArray = [NSMutableArray new];
    }
    return self;
}

- (void)backToLastDraw
{
    [_allLineMutableArray removeLastObject];
    [self drawLine];
    if (self.drawToolStatus) {
        self.drawToolStatus(_allLineMutableArray.count > 0 ? : NO);
    }
}

- (void)backToInital{
   
    [_allLineMutableArray removeAllObjects];
    [self drawLine];
    if (self.drawToolStatus) {
        self.drawToolStatus(_allLineMutableArray.count > 0 ? : NO);
    }
}

#pragma mark - 收集单手绘图的点，进行绘制
#pragma mark - DrawImageViewDelegate
- (void)drawImageViewTouchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if (event.allTouches.count == 2) {
        self.isDouble = YES;
    }
    UITouch *aTouch = [touches anyObject];
    CGPoint currentPoint = [aTouch locationInView:_drawingView];
    
    if (!self.isDouble) {
       
        // 初始化一个UIBezierPath对象, 把起始点存储到UIBezierPath对象中, 用来存储所有的轨迹点
        WBGPath *path = [WBGPath pathToPoint:currentPoint pathWidth:MAX(1, self.pathWidth)];
        path.pathColor         = self.editor.colorPan.currentColor;
        path.shape.strokeColor = self.editor.colorPan.currentColor.CGColor;
        [_allLineMutableArray addObject:path];
    }
}

- (void)drawImageViewTouchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
   
    if (event.allTouches.count == 2) {// 双手缩放
        self.isDouble = YES;
    }
    UITouch *aTouch = [touches anyObject];
    CGPoint currentPoint = [aTouch locationInView:_drawingView];

    if (!self.isDouble) { // 单手涂鸦
        
        // 获得数组中的最后一个UIBezierPath对象(因为我们每次都把UIBezierPath存入到数组最后一个,因此获取时也取最后一个)
        WBGPath *path = [_allLineMutableArray lastObject];
        [path pathLineToPoint:currentPoint];//添加点
        [self drawLine];
    }
}

- (void)drawImageViewTouchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if (event.allTouches.count == 2) {
        self.isDouble = YES;
    }
    UITouch *aTouch = [touches anyObject];
    CGPoint currentPoint = [aTouch locationInView:_drawingView];
    if (!self.isDouble) {
        
        // 获得数组中的最后一个UIBezierPath对象(因为我们每次都把UIBezierPath存入到数组最后一个,因此获取时也取最后一个)
        WBGPath *path = [_allLineMutableArray lastObject];
        [path pathLineToPoint:currentPoint];//添加点
        [self drawLine];
    }
    self.isDouble = NO;
}

#pragma mark 划线
- (void)drawLine {
    
    CGSize size = _drawingView.frame.size;
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //去掉锯齿
    CGContextSetAllowsAntialiasing(context, true);
    CGContextSetShouldAntialias(context, true);
    
    for (WBGPath *path in _allLineMutableArray) {
        [path drawPath];
    }
    _drawingView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

- (UIImage *)buildImage {
   
    UIGraphicsBeginImageContextWithOptions(_originalImageSize, NO, self.editor.editorContent.imageView.image.scale);
    [self.editor.editorContent.imageView.image drawAtPoint:CGPointZero];
    [_drawingView.image drawInRect:CGRectMake(0, 0, _originalImageSize.width, _originalImageSize.height)];
    UIImage *tmp = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return tmp;
}

#pragma mark - implementation 重写父方法
- (void)setup {
    //初始化一些东西
    _originalImageSize   = self.editor.editorContent.imageView.image.size;
    _drawingView         = self.editor.drawingView;
    _drawingView.delegate = self;
    _drawingView.userInteractionEnabled = YES;
    _drawingView.layer.shouldRasterize = YES;
    _drawingView.layer.minificationFilter = kCAFilterTrilinear;
    
    self.editor.editorContent.imageView.userInteractionEnabled = YES;
    self.editor.editorContent.scrollView.panGestureRecognizer.minimumNumberOfTouches = 2;
    self.editor.editorContent.scrollView.panGestureRecognizer.delaysTouchesBegan = NO;
    self.editor.editorContent.scrollView.pinchGestureRecognizer.delaysTouchesBegan = NO;
}

- (void)cleanup {
    self.editor.editorContent.imageView.userInteractionEnabled = NO;
    self.editor.editorContent.scrollView.panGestureRecognizer.minimumNumberOfTouches = 1;
    _drawingView.delegate = nil;
    //TODO: todo?
}

- (void)executeWithCompletionBlock:(void (^)(UIImage *, NSError *, NSDictionary *))completionBlock
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = [self buildImage];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(image, nil, nil);
        });
    });
}

@end


#pragma mark - WBGPath
@interface WBGPath()

@property (nonatomic, strong) UIBezierPath *bezierPath;
@property (nonatomic, assign) CGPoint beginPoint;
@property (nonatomic, assign) CGFloat pathWidth;

@end

@implementation WBGPath


+ (instancetype)pathToPoint:(CGPoint)beginPoint pathWidth:(CGFloat)pathWidth {
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    bezierPath.lineWidth     = pathWidth;
    bezierPath.lineCapStyle  = kCGLineCapRound;
    bezierPath.lineJoinStyle = kCGLineJoinRound;
    [bezierPath moveToPoint:beginPoint];
    
    
    CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.lineJoin = kCALineJoinRound;
    shapeLayer.lineWidth = pathWidth;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.path = bezierPath.CGPath;
    
    WBGPath *path   = [[WBGPath alloc] init];
    path.beginPoint = beginPoint;
    path.pathWidth  = pathWidth;
    path.bezierPath = bezierPath;
    path.shape      = shapeLayer;
    
    return path;
}

//曲线
- (void)pathLineToPoint:(CGPoint)movePoint;
{
    //判断绘图类型
    [self.bezierPath addLineToPoint:movePoint];
    self.shape.path = self.bezierPath.CGPath;
}

- (void)drawPath {
    [self.pathColor set];
    [self.bezierPath stroke];
}

@end
