//
//  HeaderTableViewCell.m
//  Manager
//
//  Created by songzhen on 2019/5/27.
//  Copyright © 2019 songzhen. All rights reserved.
//

#import "MIEidtFileView.h"
#import "MIHeaderTableViewCell.h"


NSString * const MIHeaderTableViewCellId = @"MIHeaderTableViewCellId";
CGFloat const MIHeaderTableViewCellHeight = 60.f;

@interface MIHeaderTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIButton *addBtn;


@property (nonatomic , strong) NSIndexPath *indexPath;

@property (nonatomic , strong) FileInfo *fileInfo;

@property (nonatomic , assign) NSInteger isParentFile;


@end

@implementation MIHeaderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self addGestureRecognizer:tap];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    [self addGestureRecognizer:longPress];
}

- (void)tapAction:(UITapGestureRecognizer *)tap
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(headerViewDidCellClicked:isParentFile:)]) {
        [self.delegate headerViewDidCellClicked:self.indexPath isParentFile:self.isParentFile];
    }
}

- (void)longPressAction:(UILongPressGestureRecognizer *)pressGest
{
    if (pressGest.state == UIGestureRecognizerStateBegan) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(headerViewEditFileClicked:isParentFile:)]) {
            [self.delegate headerViewEditFileClicked:self.indexPath isParentFile:self.isParentFile];
        }
    }
}

- (IBAction)addBtnClicked:(id)sender {
  
    if (self.isParentFile) {
       
        if (self.delegate && [self.delegate respondsToSelector:@selector(headerViewAddClicked:)]) {
            [self.delegate headerViewAddClicked:self.indexPath.section];
        }
    }
}

- (void)setupFilesWithFileInfo:(FileInfo *)fileInfo indexPath:(NSIndexPath *)indexPath isParentFile:(NSInteger)isParentFile selected:(BOOL)selected{
    
    self.fileInfo = fileInfo;
    self.indexPath = indexPath;
    self.isParentFile = isParentFile;
    if (isParentFile) {
       
        if (self.fileInfo.isOpen) {
            self.titleLabel.textColor = [UIColor mainColor];
            [self.addBtn setImage:[UIImage imageNamed:@"ic_add_blue"] forState:UIControlStateNormal];
        } else {
            self.titleLabel.textColor = [UIColor normalColor];
            [self.addBtn setImage:[UIImage imageNamed:@"ic_add_black"] forState:UIControlStateNormal];
        }
        if (self.fileInfo.subFileList.count == 0) {
            self.addBtn.hidden = YES;
        } else {
            self.addBtn.hidden = NO;
        }
        self.titleLabel.text = self.fileInfo.fileName;
        self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    } else {
        
        self.addBtn.hidden = YES;
        if (selected) {
            self.titleLabel.textColor = [UIColor mainColor];
        } else {
            self.titleLabel.textColor = [UIColor normalColor];
        }
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.titleLabel.text = [NSString stringWithFormat:@"   %@",self.fileInfo.fileName];
    }
}
@end
