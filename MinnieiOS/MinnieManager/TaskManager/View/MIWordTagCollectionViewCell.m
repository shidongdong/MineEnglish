//
//  MIWordTagCollectionViewCell.m
//  MinnieManager
//
//  Created by songzhen on 2019/6/6.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import "MIWordTagCollectionViewCell.h"

NSString * const MIWordTagCollectionViewCellId = @"MIWordTagCollectionViewCellId";

@interface MIWordTagCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@property (weak, nonatomic) IBOutlet UIImageView *cancelImageV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftImgContraint;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation MIWordTagCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    //ios 12 上特有的Bug
    if (@available(iOS 12.0, *)) {
        // Addresses a separate issue and prevent auto layout warnings due to the temporary width constraint in the xib.
        self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
        
        // Code below is needed to make the self-sizing cell work when building for iOS 12 from Xcode 10.0:
        
        NSLayoutConstraint *leftConstraint = [self.contentView.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:0];
        NSLayoutConstraint *rightConstraint = [self.contentView.rightAnchor constraintEqualToAnchor:self.rightAnchor constant:0];
        NSLayoutConstraint *topConstraint = [self.contentView.topAnchor constraintEqualToAnchor:self.topAnchor constant:0];
        NSLayoutConstraint *bottomConstraint = [self.contentView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:0];
        
        [NSLayoutConstraint activateConstraints:@[leftConstraint, rightConstraint, topConstraint, bottomConstraint]];
    }
    
    self.bgView.layer.cornerRadius = 12.f;
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.borderWidth = 1.0;
    self.bgView.layer.borderColor = [UIColor colorWithHex:0xDDDDDD].CGColor;
}

- (void)setupWithTag:(NSString *)tag {
    self.textLabel.text = tag;
}
- (void)setupWithText:(NSString *)text isEditState:(BOOL)isEditState isLast:(BOOL)isLast{
    
    [self setupWithTag:text];
    self.textLabel.textColor = [UIColor detailColor];
    if (isEditState) {
        self.cancelImageV.hidden = NO;
    } else {
        self.cancelImageV.hidden = YES;
    }
    if (isLast) {
        self.textLabel.textColor = [UIColor mainColor];
        self.cancelImageV.hidden = YES;
    }
    CGSize sizeItem = [MIWordTagCollectionViewCell cellSizeWithTag:text];
    self.leftImgContraint.constant = sizeItem.width - 15;
}

+ (CGSize)cellSizeWithTag:(NSString *)tag {
  
    static MIWordTagCollectionViewCell *tempCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tempCell = [[[NSBundle mainBundle] loadNibNamed:@"MIWordTagCollectionViewCell" owner:nil options:nil] lastObject];
    });
    [tempCell setupWithTag:tag];
    
    return [tempCell systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
}


@end
