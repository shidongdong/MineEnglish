//
//  MISelectImageCollectionViewCell.m
//  MinnieManager
//
//  Created by songzhen on 2019/8/26.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import "MISelectImageCollectionViewCell.h"

NSString * _Nullable const MISelectImageCollectionViewCellId = @"MISelectImageCollectionViewCellId";

@interface MISelectImageCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (assign, nonatomic) NSInteger currentIndex;
@end

@implementation MISelectImageCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.deleteBtn.layer.cornerRadius = 5;
    self.deleteBtn.layer.masksToBounds = YES;
    self.deleteBtn.layer.borderWidth = 1.0;
    self.deleteBtn.layer.borderColor = [UIColor separatorLineColor].CGColor;
}

- (void)setupImage:(NSString *)image index:(NSInteger)index{
   
    self.currentIndex = index;
    self.titleLabel.text = [NSString stringWithFormat:@"图片%lu",index];
    [self.imageView sd_setImageWithURL:[image imageURLWithWidth:kColumnThreeWidth/2]];
}
- (IBAction)deleteAction:(id)sender {
    
    if (self.deleteCallBack) {
        self.deleteCallBack(self.currentIndex);
    }
}
- (IBAction)imageAction:(id)sender {
  
    if (self.imageCallBack) {
        self.imageCallBack(self.currentIndex);
    }
}

@end
