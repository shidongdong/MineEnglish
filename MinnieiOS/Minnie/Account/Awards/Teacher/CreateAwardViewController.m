//
//  CreateAwardViewController.m
//  X5Teacher
//
//  Created by yebw on 2017/12/26.
//  Copyright © 2017年 netease. All rights reserved.
//

#import "CreateAwardViewController.h"
#import "TeacherAwardService.h"
#import "FileUploader.h"
#import "TIP.h"
#import "Constants.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface CreateAwardViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, weak) IBOutlet UITextField *nameTextField;
@property (nonatomic, weak) IBOutlet UITextField *countTextField;
@property (nonatomic, weak) IBOutlet UITextField *priceTextField;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *scrollViewBottomConstraint;

@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *imageViewHeightConstraint;
@property (nonatomic, weak) IBOutlet UIView *addImageView;

@property (nonatomic, assign) BOOL imageChanged;

@end

@implementation CreateAwardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.award != nil) {
        self.customTitleLabel.text = @"编辑礼品";
        self.nameTextField.text = self.award.name;
        self.countTextField.text = [NSString stringWithFormat:@"%@", @(self.award.count)];
        self.priceTextField.text = [NSString stringWithFormat:@"%@", @(self.award.price)];

        self.imageViewHeightConstraint.constant = ScreenWidth;
        [self.imageView sd_setImageWithURL:[self.award.imageUrl imageURLWithWidth:ScreenWidth]];
    } else {
        self.customTitleLabel.text = @"新建礼品";
        self.imageViewHeightConstraint.constant = 0.f;
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    NSLog(@"%s", __func__);
}

#pragma mark - IBAction

- (IBAction)addImageButtonPressed:(id)sender {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self.navigationController presentViewController:imagePickerController animated:YES completion:nil];
}

- (IBAction)saveButtonPressed:(id)sender {
    NSString *name = [self.nameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (name.length == 0) {
        [TIP showText:@"请输入礼物名称" inView:self.navigationController.view];
        return;
    }
    
    NSString *count = [self.countTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (count.length == 0) {
        [TIP showText:@"请输入礼物数量" inView:self.navigationController.view];
        return;
    }
    
    NSString *price = [self.priceTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (price.length == 0) {
        [TIP showText:@"请输入礼物价格" inView:self.navigationController.view];
        return;
    }
    
    UIImage *image = self.imageView.image;
    if (image == nil && self.award == nil) {
        [TIP showText:@"请添加礼物图片" inView:self.navigationController.view];
        return;
    }

    if (self.award==nil || self.imageChanged) {
        [HUD showProgressWithMessage:@"正在上传图片..."];

        NSData *imageData = UIImageJPEGRepresentation(image, .8f);
        [FileUploader uploadData:imageData
                            type:UploadFileTypeImage
                   progressBlock:^(NSInteger number) {
                       [HUD showProgressWithMessage:[NSString stringWithFormat:@"正在上传图片%@%%...", @(number)]];
                   }
                 completionBlock:^(NSString * _Nullable imageUrl, NSError * _Nullable error) {
                     if (imageUrl.length == 0) {
                         [HUD showErrorWithMessage:@"图片上传失败"];
                         return;
                     }
                     
                     NSMutableDictionary *info = [NSMutableDictionary dictionary];
                     if (self.award != nil) {
                         info[@"id"] = @(self.award.awardId);
                     }
                     info[@"imageUrl"] = imageUrl;
                     info[@"name"] = name;
                     info[@"count"] = @([count integerValue]);
                     info[@"price"] = @([price integerValue]);

                     [self addAwardWithInfo:info];
                 }];
    } else {
        NSMutableDictionary *info = [NSMutableDictionary dictionary];
        if (self.award != nil) {
            info[@"id"] = @(self.award.awardId);
        }
        info[@"name"] = name;
        info[@"count"] = @([count integerValue]);
        info[@"price"] = @([price integerValue]);
        
        [self addAwardWithInfo:info];
    }
}

- (void)addAwardWithInfo:(NSDictionary *)info {
    [HUD showProgressWithMessage:@"正在新建礼物..."];
    
    [TeacherAwardService addAward:info
                         callback:^(Result *result, NSError *error) {
                             if (error != nil) {
                                 [HUD showErrorWithMessage:@"创建礼物失败"];
                             } else {
                                 [HUD showWithMessage:@"礼物创建成功"];
                                 
                                 [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationKeyOfAddAward object:nil];
                                 
                                 [self backButtonPressed:nil];
                             }
                         }];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    self.imageChanged = YES;
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    self.imageView.image = image;
    
    CGFloat height = ScreenWidth * image.size.height / image.size.width;
    self.imageViewHeightConstraint.constant = height;
    
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end


