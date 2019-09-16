//
//  MIMoveHomeworkTaskView.m
//  MinnieManager
//
//  Created by songzhen on 2019/5/31.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import "Result.h"
#import "ManagerServce.h"
#import "MIExpandPickerView.h"
#import "MIMoveHomeworkTaskView.h"

@interface MIMoveHomeworkTaskView ()

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UILabel *homeworkTitle;
@property (weak, nonatomic) IBOutlet UILabel *locationTextLabel;

@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@property (weak, nonatomic) IBOutlet UIView *oneSelectBgView;
@property (weak, nonatomic) IBOutlet UIView *twoSelectBgView;
@property (weak, nonatomic) IBOutlet UILabel *parentLabel;

@property (weak, nonatomic) IBOutlet UILabel *subLabel;


@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moveConstraint;


@property (strong, nonatomic) NSArray<ParentFileInfo*> *currentFileList;

@property (strong, nonatomic) FileInfo *subFileInfo;
@property (strong, nonatomic) FileInfo *parentFileInfo;

@end

@implementation MIMoveHomeworkTaskView

-(void)awakeFromNib{
    
    [super awakeFromNib];
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];

    self.sureBtn.layer.masksToBounds = YES;
    self.sureBtn.layer.cornerRadius = 20.0;
    self.sureBtn.layer.borderWidth = 0.5;
    self.sureBtn.layer.borderColor = [UIColor mainColor].CGColor;
    
    self.cancelBtn.layer.masksToBounds = YES;
    self.cancelBtn.layer.cornerRadius = 20.0;
    self.cancelBtn.layer.borderWidth = 0.5;
    self.cancelBtn.layer.borderColor = [UIColor mainColor].CGColor;
    
    self.oneSelectBgView.layer.masksToBounds = YES;
    self.oneSelectBgView.layer.cornerRadius = 20.0;
    self.oneSelectBgView.layer.borderWidth = 0.5;
    self.oneSelectBgView.layer.borderColor = [UIColor separatorLineColor].CGColor;
    
    self.twoSelectBgView.layer.masksToBounds = YES;
    self.twoSelectBgView.layer.cornerRadius = 20.0;
    self.twoSelectBgView.layer.borderWidth = 0.5;
    self.twoSelectBgView.layer.borderColor = [UIColor separatorLineColor].CGColor;
    
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.cornerRadius = 20.0;
    self.contentView.layer.borderWidth = 0.5;
    self.contentView.layer.borderColor = [UIColor separatorLineColor].CGColor;
}

- (void)setIsMultiple:(BOOL)isMultiple{
    
    _isMultiple = isMultiple;
    if (isMultiple) {
        
        self.homeworkTitle.hidden = YES;
        self.locationLabel.hidden = YES;
        self.locationTextLabel.hidden = YES;
        self.moveConstraint.constant = 30;
    } else {
        
        self.homeworkTitle.hidden = NO;
        self.locationLabel.hidden = NO;
        self.locationTextLabel.hidden = NO;
        self.moveConstraint.constant = 104;
    }
}
- (IBAction)cancelAction:(id)sender {
    if (self.superview) {
        
        [self removeFromSuperview];
    }
    if (self.cancelCallback) {
        self.cancelCallback();
    }
}
- (IBAction)sureAction:(id)sender {
   
    [self requestMoveFiles];
}

- (IBAction)oneSelectViewAction:(id)sender {
    
    MIExpandPickerView * chooseDataPicker = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MIExpandPickerView class]) owner:nil options:nil] lastObject];
    [chooseDataPicker setDefultParentFileInfo:self.parentFileInfo fileArray:self.currentFileList];
    WeakifySelf;
    chooseDataPicker.localCallback = ^(id _Nonnull result) {
        
        // 选则父文件夹，默认选择对应文件夹下面的子文件夹
        if ([result isKindOfClass:[ParentFileInfo class]]) {
            
            ParentFileInfo *parentResult = result;
            if (weakSelf.subFileInfo.parentId !=parentResult.fileInfo.fileId) {
                FileInfo *subInfo = parentResult.subFileList.firstObject;
                weakSelf.subFileInfo = subInfo;
            }
            weakSelf.parentFileInfo = parentResult.fileInfo;
            [weakSelf setParentInfo:parentResult.fileInfo subInfo:weakSelf.subFileInfo];
        }
    };
    [chooseDataPicker show];
}

- (IBAction)twoSelectViewAction:(id)sender {
    
    if (self.subFileInfo.fileId == 0) {
        
        [HUD showWithMessage:@"请先创建子文件夹"];
        return;
    }
    WeakifySelf;
    MIExpandPickerView * chooseDataPicker = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MIExpandPickerView class]) owner:nil options:nil] lastObject];
    chooseDataPicker.localCallback = ^(id _Nonnull result) {
        if ([result isKindOfClass:[FileInfo class]]) {
            
            FileInfo *subResult = result;
            weakSelf.subFileInfo = subResult;
            [weakSelf setParentInfo:weakSelf.parentFileInfo subInfo:weakSelf.subFileInfo];
        }
    };
    [chooseDataPicker setDefultFileInfo:
     self.subFileInfo fileArray:self.currentFileList];
    [chooseDataPicker show];
}

- (void)setParentInfo:(FileInfo *)parentInfo subInfo:(FileInfo*)subInfo{
    
    self.subFileInfo = subInfo;
    self.parentFileInfo = parentInfo;
    self.subLabel.text = subInfo.fileName;
    self.parentLabel.text = parentInfo.fileName;
    self.locationLabel.text = self.currentFileInfo.fileName;
}

#pragma mark - 获取文件列表
- (void)requestGetFiles{
    
    WeakifySelf;
    [ManagerServce requestGetFilesWithFileId:0 callback:^(Result *result, NSError *error) {
        StrongifySelf;
        if (error) return ;
        NSDictionary *dict = (NSDictionary *)(result.userInfo);
        weakSelf.currentFileList = (NSArray *)(dict[@"list"]);
        [strongSelf setFileInfo:strongSelf.currentFileList];
        [weakSelf setParentInfo:weakSelf.parentFileInfo subInfo:weakSelf.subFileInfo];
    }];
}
- (void)setFileInfo:(NSArray *)currentFileList{
    
    for (ParentFileInfo *parentInfo in currentFileList) {
        
        for (FileInfo *subInfo in parentInfo.subFileList) {
            
            if (subInfo.fileId == self.currentFileInfo.fileId) {
                
                self.subFileInfo = subInfo;
                self.parentFileInfo = parentInfo.fileInfo;
            }
        }
    }
}

#pragma mark - 移动文件夹
- (void)requestMoveFiles{
    
    WeakifySelf;
    if (self.subFileInfo.fileId == 0) {
        
        [HUD showWithMessage:@"请先创建子文件夹"];
        return;
    }
    
    [ManagerServce requestMoveFilesWithFileId:self.subFileInfo.fileId parentId:self.parentFileInfo.fileId homeworkIds:self.homeworkIds callback:^(Result *result, NSError *error) {
        
        if (!error) {
            
            if (weakSelf.callback) {
                weakSelf.callback();
            }
            [HUD showWithMessage:@"移动成功"];
        } else {
            [HUD showErrorWithMessage:@"移动失败"];
            if (self.cancelCallback) {
                self.cancelCallback();
            }
        };
        if (self.superview) {
            
            [self removeFromSuperview];
        }
    }];
}

- (void)setCurrentFileInfo:(FileInfo *)currentFileInfo{
    
    _currentFileInfo = currentFileInfo;
    if (self.currentFileList.count == 0) {
        [self requestGetFiles];
    } else {
        [self setFileInfo:(NSArray *)self.currentFileList];
    }
}

- (FileInfo *)parentFileInfo{
    
    if (!_parentFileInfo) {
        _parentFileInfo = [[FileInfo alloc] init];
    }
    return _parentFileInfo;
}

- (FileInfo *)subFileInfo{
    
    if (!_subFileInfo) {
        _subFileInfo = [[FileInfo alloc] init];
    }
    return _subFileInfo;
}

@end
