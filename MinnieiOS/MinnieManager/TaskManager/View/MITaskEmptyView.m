//
//  MITaskEmptyView.m
//  MinnieManager
//
//  Created by songzhen on 2019/5/28.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import "MITaskEmptyView.h"

@interface MITaskEmptyView ()

@property (weak, nonatomic) IBOutlet UILabel *detail;
@property (weak, nonatomic) IBOutlet UIButton *addFolderBtn;

@end



@implementation MITaskEmptyView


-(void)awakeFromNib{
    
    [super awakeFromNib];
    self.addFolderBtn.layer.masksToBounds = YES;
    self.addFolderBtn.layer.cornerRadius = 22;
}

- (IBAction)addFolderAction:(id)sender {
    
    if (self.callBack) {
        
        self.callBack(self.isAddFolder);
    }
}
- (void)setIsAddFolder:(BOOL)isAddFolder{
    
    _isAddFolder = isAddFolder;
    if (_isAddFolder) {
        self.detail.text = @"请先创建子文件夹";
        [self.addFolderBtn setTitle:@"添加子文件夹" forState:UIControlStateNormal];
    } else {
        self.detail.text = @"请先创建任务";
        [self.addFolderBtn setTitle:@"创建任务" forState:UIControlStateNormal];
    }
}
@end
