//
//  MIAddWordTableViewCell.m
//  MinnieManager
//
//  Created by songzhen on 2019/6/6.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import "MIAddWordTableViewCell.h"
#import "MIEqualSpaceFlowLayout.h"
#import "MIWordTagCollectionViewCell.h"


NSString * const MIAddWordTableViewCellId = @"MIAddWordTableViewCellId";

@interface MIAddWordTableViewCell ()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
MIEqualSpaceFlowLayoutDelegate
>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) NSInteger collecttionViewWidth;

@property (nonatomic, strong) NSMutableArray *dataArray;


@property (nonatomic, assign) NSInteger createType;
@property (nonatomic, assign) BOOL isEditState;

@end

@implementation MIAddWordTableViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
    
    if (@available(iOS 12.0, *)) {
        // Addresses a separate issue and prevent auto layout warnings due to the temporary width constraint in the xib.
        self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSLayoutConstraint *leftConstraint = [self.contentView.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:0];
        NSLayoutConstraint *rightConstraint = [self.contentView.rightAnchor constraintEqualToAnchor:self.rightAnchor constant:0];
        NSLayoutConstraint *topConstraint = [self.contentView.topAnchor constraintEqualToAnchor:self.topAnchor constant:0];
        NSLayoutConstraint *bottomConstraint = [self.contentView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:0];
        
        [NSLayoutConstraint activateConstraints:@[leftConstraint, rightConstraint, topConstraint, bottomConstraint]];
    }
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _collecttionViewWidth = (ScreenWidth - kRootModularWidth) /2.0;
    self.dataArray = [NSMutableArray array];
    [self addContentView];
}


- (void)setupAwordWithDataArray:(NSArray <WordInfo *> *)dataArray{
   
    self.titleLabel.text = @"添加单词";
    self.createType = MIHomeworkCreateContentType_AddWords;
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:dataArray];
    [self.dataArray addObject:@" + 添加单词"];
    self.collectionView.frame = CGRectMake(0, 30, _collecttionViewWidth, [MIAddWordTableViewCell heightWithTags:self.dataArray]);
    [self.collectionView reloadData];
}

- (void)setupParticipateWithClazzArray:(NSArray <Clazz *> *)clazzArray
                          studentArray:(NSArray <User *> *)studentArray{
    
    self.titleLabel.text = @"添加参与对象";
    self.createType = MIHomeworkCreateContentType_ActivityParticipant;
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:clazzArray];
    [self.dataArray addObjectsFromArray:studentArray];
    [self.dataArray addObject:@" + 添加对象"];
    self.collectionView.frame = CGRectMake(0, 40, _collecttionViewWidth, [MIAddWordTableViewCell heightWithTags:self.dataArray]);
    [self.collectionView reloadData];
    
}


+ (CGFloat)heightWithTags:(NSArray*)tags{
    
    if (tags.count == 0) {
        return 50.f;
    }
    CGFloat leftSpace = 10;
    CGFloat topSpace = 10;
    CGFloat rightSpace = 10;
    CGFloat minimumInteritemSpacing = 10;
    CGFloat minimumLineSpacing = 10;
    
    CGFloat xOffset = leftSpace;
    CGFloat yOffset = topSpace;
    CGFloat xNextOffset = leftSpace;
    
    CGFloat height = 0;
    
    CGFloat collecttionViewWidth = (ScreenWidth - kRootModularWidth) /2.0;
    for (NSInteger idx = 0; idx < tags.count; idx++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:idx inSection:0];
        
        NSString *tag;
        if ([tags[indexPath.row] isKindOfClass:[NSString class]]) {
            tag = tags[indexPath.row];
        } else if ([tags[indexPath.row] isKindOfClass:[WordInfo class]]) {
          
            tag = ((WordInfo *)tags[indexPath.row]).english;
        } else if ([tags[indexPath.row] isKindOfClass:[Clazz class]]) {
            tag = ((Clazz *)tags[indexPath.row]).name;
        } else if ([tags[indexPath.row] isKindOfClass:[User class]]) {
            tag = ((User *)tags[indexPath.row]).nickname;
        }
        CGSize itemSize = [MIWordTagCollectionViewCell cellSizeWithTag:tag];
        
        xNextOffset+=(minimumInteritemSpacing + itemSize.width);
        if (xNextOffset >= collecttionViewWidth - 30 - rightSpace) {
            xOffset = leftSpace;
            xNextOffset = (leftSpace + minimumInteritemSpacing + itemSize.width);
            yOffset += (itemSize.height + minimumLineSpacing);
        }
        else
        {
            xOffset = xNextOffset - (minimumInteritemSpacing + itemSize.width);
        }
        height = yOffset + itemSize.height + 10;
    }
    return height;
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    MIWordTagCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MIWordTagCollectionViewCellId
                                                                            forIndexPath:indexPath];
    NSString *tag;
    if ([self.dataArray[indexPath.row] isKindOfClass:[NSString class]]) {
        tag = self.dataArray[indexPath.row];
    } else if ([self.dataArray[indexPath.row] isKindOfClass:[WordInfo class]]) {
        WordInfo *word = self.dataArray[indexPath.row];
        tag = word.english;
    } else if ([self.dataArray[indexPath.row] isKindOfClass:[Clazz class]]) {
        Clazz *clazz = self.dataArray[indexPath.row];
        tag = clazz.name;
    } else if ([self.dataArray[indexPath.row] isKindOfClass:[User class]]) {
        User *student = self.dataArray[indexPath.row];
        tag = student.nickname;
    }
    if (indexPath.row == self.dataArray.count - 1) {
        [cell setupWithText:tag isEditState:self.isEditState isLast:YES];
    } else {
        [cell setupWithText:tag isEditState:self.isEditState isLast:NO];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    
    if (indexPath.row < self.dataArray.count - 1) {
      
        if (self.isEditState) {
            
            NSString *tag = self.dataArray[indexPath.row];
            [self.dataArray removeObject:tag];
            if (self.callback) {
                
                self.callback(NO,self.dataArray);
            }
            [self.collectionView reloadData];
        }
    } else {// 添加单词
        if (self.isEditState) {
            self.isEditState = NO;
            [self.collectionView reloadData];
        }
        if (self.callback) {
            
            self.callback(YES,self.dataArray[indexPath.row]);
        }
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *tag;
    if ([self.dataArray[indexPath.row] isKindOfClass:[NSString class]]) {
        tag = self.dataArray[indexPath.row];
    } else if ([self.dataArray[indexPath.row] isKindOfClass:[WordInfo class]]) {
        WordInfo *word = self.dataArray[indexPath.row];
        tag = word.english;
    } else if ([self.dataArray[indexPath.row] isKindOfClass:[Clazz class]]) {
        Clazz *clazz = self.dataArray[indexPath.row];
        tag = clazz.name;
    } else if ([self.dataArray[indexPath.row] isKindOfClass:[User class]]) {
        User *student = self.dataArray[indexPath.row];
        tag = student.nickname;
    }
    CGSize itemSize = [MIWordTagCollectionViewCell cellSizeWithTag:tag];
    // 标签长度大于屏幕
    if (itemSize.width > _collecttionViewWidth -30) {
        
        itemSize.width = _collecttionViewWidth - 30;
    }
    return itemSize;
}

- (void)addContentView{
    
    MIEqualSpaceFlowLayout *flowLayout = [[MIEqualSpaceFlowLayout alloc] initWithCollectionViewWidth:_collecttionViewWidth];
    flowLayout.delegate = self;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 50, _collecttionViewWidth, 50) collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self addSubview:self.collectionView];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([MIWordTagCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:MIWordTagCollectionViewCellId];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    [self.collectionView addGestureRecognizer:longPress];
}

- (void)longPressAction:(UILongPressGestureRecognizer *)longPress{
    
    if (longPress.state == UIGestureRecognizerStateEnded) {
       
        self.isEditState = !self.isEditState;
        [self.collectionView reloadData];
    }
}
@end
