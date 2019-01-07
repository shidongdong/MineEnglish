//
//  HomeworkSessionViewController.m
// X5
//
//  Created by yebw on 2017/8/24.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "HomeworkSessionViewController.h"
#import "FileUploader.h"
#import "IMManager.h"
#import "User.h"
#import "PushManager.h"
#import "NEPhotoBrowser.h"
#import "TextMessageTableViewCell.h"
#import "ImageMessageTableViewCell.h"
#import "MessageTimeTableViewCell.h"
#import "EmojiMessageTableViewCell.h"
#import "VideoMessageTableViewCell.h"
#import "AudioMessageTableViewCell.h"
#import <AVOSCloudIM/AVOSCloudIM.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVKit/AVKit.h>
#import <Bugly/Bugly.h>
#import "UIView+Load.h"
#import "HomeworkSessionService.h"
#import "NSDate+X5.h"
#import "IMManager.h"
#import "SessionHomeworkTableViewCell.h"
#import "EmojiInputView.h"
#import "RecordStateView.h"
#import "RecordButton.h"
#import "WBGImageEditorViewController.h"
#import "AlertView.h"
#import "StudentDetailViewController.h"
#import "AudioPlayer.h"
#import "VIResourceLoaderManager.h"
#import "AudioPlayerViewController.h"
#import "CorrectHomeworkViewController.h"
#import "TZImagePickerController.h"
static NSString * const kKeyOfCreateTimestamp = @"createTimestamp";
static NSString * const kKeyOfAudioDuration = @"audioDuration";
static NSString * const kKeyOfVideoDuration = @"videoDuration";

@interface HomeworkSessionViewController()<UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate, EmojiInputViewDelegate, NEPhotoBrowserDataSource, NEPhotoBrowserDelegate,UINavigationControllerDelegate>

@property (nonatomic, weak) IBOutlet UITableView *messagesTableView;
@property (nonatomic, weak) IBOutlet UIButton *audioButton;
@property (nonatomic, weak) IBOutlet UIButton *emojiButton;
@property (nonatomic, weak) IBOutlet UITextView *inputTextView;
@property (nonatomic, weak) IBOutlet UIView *inputTextBgView;
@property (nonatomic, weak) IBOutlet RecordButton *recordButton;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *inputTextViewHeightConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *inputViewBottomConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *operationsViewBottomConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *emojiViewBottomLayoutConstraint;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *answerViewWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *warnViewWidthConstraint;

@property (nonatomic, weak) IBOutlet UIView *loadingContainerView;
@property (nonatomic, weak) IBOutlet UIButton *correctButton;

@property (nonatomic, strong) NSMutableArray<AVIMTypedMessage *> *messages;
@property (nonatomic, strong) NSMutableDictionary *sortedMessages;
@property (nonatomic, strong) NSArray *sortedKeys;

@property (nonatomic, readonly) AVIMClient *client;
@property (nonatomic, readonly) AVIMConversation *conversation;

@property (nonatomic, strong) AVAudioRecorder *audioRecorder;
@property (nonatomic, strong) NSDate *startTime;

@property (nonatomic, copy) NSString *tempText;

@property (nonatomic, weak) RecordStateView *recordStateView;

@property (nonatomic, weak) IBOutlet UIView *resultView;
@property (nonatomic, weak) IBOutlet UIView *resultContentView;
@property (nonatomic, weak) IBOutlet UIView *resultPaddingView;
@property (nonatomic, weak) IBOutlet UILabel *scoreLabel;
@property (nonatomic, weak) IBOutlet UIImageView *start1ImageView;
@property (nonatomic, weak) IBOutlet UIImageView *start2ImageView;
@property (nonatomic, weak) IBOutlet UIImageView *start3ImageView;
@property (nonatomic, weak) IBOutlet UIImageView *start4ImageView;
@property (nonatomic, weak) IBOutlet UIImageView *start5ImageView;
@property (nonatomic, weak) IBOutlet UIButton *retryButton;

@property (nonatomic, strong) NEPhotoBrowser *photoBrowser;
@property (nonatomic, strong) NSArray<UIImageView *> * currentImageViews;
@property (nonatomic, strong)NSMutableArray * homeworkImages;    //作业详情所

@property (nonatomic, assign) BOOL isCommitingHomework;

@property (nonatomic, assign) BOOL dontScrollWhenAppeard;
@property (nonatomic, assign) BOOL isViewAppeard;
@property (nonatomic, assign) BOOL bFailReSendFlag;
@property (nonatomic, strong) VIResourceLoaderManager *resourceLoaderManager;
@end

@implementation HomeworkSessionViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
#if TEACHERSIDE
    self.customTitleLabel.text = self.homeworkSession.student.nickname;
    self.correctButton.hidden = self.homeworkSession.score>0;
    self.answerViewWidthConstraint.constant = ScreenWidth/4;
    self.warnViewWidthConstraint.constant = ScreenWidth/4;
#else
    self.customTitleLabel.text = self.homeworkSession.correctTeacher.nickname;
    self.correctButton.hidden = YES;
    self.answerViewWidthConstraint.constant = 0;
    self.warnViewWidthConstraint.constant = 0;
#endif
    
    self.messages = [NSMutableArray array];
    self.sortedMessages = [NSMutableDictionary dictionary];
    self.currentImageViews = [NSMutableArray array];
    //从作业中提取
    self.homeworkImages = [NSMutableArray array];
    for (int i = 0; i < self.homeworkSession.homework.items.count; i++)
    {
        HomeworkItem * items = [self.homeworkSession.homework.items objectAtIndex:i];
        if ([items.type isEqualToString:HomeworkItemTypeImage])
        {
            [self.homeworkImages addObject:items.imageUrl];
        }
    }
    
    
    self.recordButton.hidden = YES;
    self.recordButton.layer.borderWidth = 0.5f;
    self.recordButton.layer.borderColor = [UIColor colorWithHex:0x333333].CGColor;
    self.recordButton.layer.cornerRadius = 12.f;
    self.recordButton.layer.masksToBounds = YES;
    WeakifySelf;
    self.recordButton.stateChangeBlock = ^(RecordButtonState state) {
        if (state == RecordButtonStateTouchCancelled ||
            state == RecordButtonStateTouchUpInside ||
            state == RecordButtonStateTouchUpOutside) {
            weakSelf.recordButton.backgroundColor = [UIColor whiteColor];
        } else {
            weakSelf.recordButton.backgroundColor = [UIColor colorWithHex:0xCCCCCC];
        }
        
        if (state == RecordButtonStateTouchDown) {
            [weakSelf startRecord];
            
            weakSelf.recordStateView = [RecordStateView showInView:weakSelf.view];
        } else if (state == RecordButtonStateMoveInside) {
            [weakSelf.recordStateView updateWithCancelState:NO];
        } else if (state == RecordButtonStateMoveOutside) {
            [weakSelf.recordStateView updateWithCancelState:YES];
        } else if (state == RecordButtonStateTouchUpInside) {
            [weakSelf.recordStateView hide];
            [weakSelf stopRecord:YES];
        } else if (state == RecordButtonStateTouchUpOutside ||
                   state == RecordButtonStateTouchCancelled) {
            [weakSelf.recordStateView hide];
            [weakSelf stopRecord:NO];
        }
    };
    
    self.inputTextBgView.layer.cornerRadius = 12.f;
    self.inputTextBgView.layer.masksToBounds = YES;
    self.inputTextView.textContainerInset = UIEdgeInsetsZero;
    self.inputTextViewHeightConstraint.constant = self.inputTextView.font.lineHeight;
    
    self.messagesTableView.estimatedRowHeight = 0.f;
    self.messagesTableView.estimatedSectionFooterHeight = 0.f;
    self.messagesTableView.estimatedSectionHeaderHeight = 0.f;
    
    UIView *footerView = [[UIView alloc] init];
    [footerView setBackgroundColor:[UIColor colorWithHex:0xF5F5F5]];
    [footerView setFrame:CGRectMake(0, 0, ScreenWidth, 20)];
    self.messagesTableView.tableFooterView = footerView;
    
    self.emojiViewBottomLayoutConstraint.constant = -216.f - (isIPhoneX?39:0);
    self.operationsViewBottomConstraint.constant = -80.f - (isIPhoneX?39:0);
    
    if (self.messages == nil) {
        self.messages = [NSMutableArray array];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardFrameWillChange:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardFrameDidChange:)
                                                 name:UIKeyboardDidChangeFrameNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(messageDidReceive:)
                                                 name:kIMManagerContentMessageDidReceiveNotification
                                               object:nil];
    
    // 老师批改作业
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(homeworkDidFinishCorrect:)
                                                 name:kNotificationKeyOfCorrectHomework
                                               object:nil];
    
    [self setupConversation];
    
    if (self.homeworkSession.score >= 0) {
        [self setupResultView];
        
        self.resultView.hidden = NO;
        self.inputView.hidden = YES;
    } else {
        self.resultView.hidden = YES;
        self.inputView.hidden = NO;
    }
    
    APP.currentIMHomeworkSessionId = self.homeworkSession.homeworkSessionId;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.isViewAppeard = YES;
    
    if (!self.dontScrollWhenAppeard && self.sortedMessages.count>0) {
        [self scrollMessagesTableViewToBottom:NO];
        self.dontScrollWhenAppeard = NO;
    }
    
    for (UIGestureRecognizer *gr in self.view.window.gestureRecognizers) {
        if (gr.delaysTouchesBegan) {
            gr.delaysTouchesBegan = NO;
        }
    }
    
    //
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[AudioPlayer sharedPlayer] stop];
}

- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc {
    APP.currentIMHomeworkSessionId = 0;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    NSLog(@"%s", __func__);
}

#pragma mark - Notification

- (void)keyboardFrameWillChange:(NSNotification *)notification {
    NSValue *endValue = notification.userInfo[UIKeyboardFrameEndUserInfoKey];
    CGRect kbFrame = [endValue CGRectValue];
    kbFrame = [self.view convertRect:kbFrame fromView:nil];
    
    if (kbFrame.origin.y >= self.view.bounds.size.height) { // 键盘隐藏
        if (self.emojiViewBottomLayoutConstraint.constant == 0) {
            self.inputViewBottomConstraint.constant = 216.f;
        } else if (self.operationsViewBottomConstraint.constant == 0) {
            self.inputViewBottomConstraint.constant = 80.f;
        } else {
            self.inputViewBottomConstraint.constant = 0.f;
        }
    } else { // 键盘显示
        self.inputViewBottomConstraint.constant = kbFrame.size.height - (isIPhoneX?39:0);
    }
    
    [UIView animateWithDuration:0.3f
                     animations:^{
                         [self.view layoutIfNeeded];
                     } completion:^(BOOL finished) {
                     }];
}

- (void)keyboardFrameDidChange:(NSNotification *)notification {
    NSValue *endValue = notification.userInfo[UIKeyboardFrameEndUserInfoKey];
    CGRect kbFrame = [endValue CGRectValue];
    kbFrame = [self.view convertRect:kbFrame fromView:nil];
    
    if (kbFrame.origin.y >= self.view.bounds.size.height) { // 键盘隐藏
    } else { // 键盘显示
        [self scrollMessagesTableViewToBottom:YES];
    }
}

- (void)messageDidReceive:(NSNotification *)notification {
    AVIMTypedMessage *message = notification.userInfo[@"message"];
    if (![self.conversation.conversationId isEqualToString:message.conversationId]) {
        return;
    }
    
    if (self.conversation != nil) {
        [self.conversation readInBackground];
    }
    
    NSDictionary *attributes = message.attributes;
    if (attributes[@"score"] != nil && [attributes[@"score"] integerValue]>=0) {
        self.homeworkSession.score = [attributes[@"score"] integerValue];
        self.homeworkSession.reviewText = attributes[@"reviewText"];
        self.homeworkSession.isRedo = [attributes[@"isRedo"] integerValue];
#if TEACHERSIDE
#else
        NSInteger star = MIN(5, self.homeworkSession.score);
        APP.currentUser.starCount += star;
#endif
        
        if ([self.inputView isFirstResponder] && [self isViewLoaded]) {
            [self.inputTextView resignFirstResponder];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self setupResultView];
                
                self.resultView.hidden = NO;
                self.inputView.hidden = YES;
                
                self.emojiViewBottomLayoutConstraint.constant = -216.f - (isIPhoneX?39:0);
                self.operationsViewBottomConstraint.constant = -80.f - (isIPhoneX?39:0);
                self.inputViewBottomConstraint.constant = 0.f;
            });
        } else {
            [self setupResultView];
            
            self.resultView.hidden = NO;
            self.inputView.hidden = YES;
            
            self.emojiViewBottomLayoutConstraint.constant = -216.f - (isIPhoneX?39:0);
            self.operationsViewBottomConstraint.constant = -80.f - (isIPhoneX?39:0);
            self.inputViewBottomConstraint.constant = 0.f;
        }
    }
    
    [self.messages addObject:message];
    [self sortMessages];
    
    [self reloadDataAndScrollToBottom];
}

- (void)homeworkDidFinishCorrect:(NSNotification *)notification {
#if TEACHERSIDE
#else
    return ;
#endif
    
    NSString *text = nil;
    if (self.homeworkSession.score == 0){
        text = [@"0星 " stringByAppendingString:self.homeworkSession.reviewText];
    }else if (self.homeworkSession.score == 1) {
        text = [@"1星 " stringByAppendingString:self.homeworkSession.reviewText];
    } else if (self.homeworkSession.score == 2) {
        text = [@"2星 " stringByAppendingString:self.homeworkSession.reviewText];
    } else if (self.homeworkSession.score == 3) {
        text = [@"3星 " stringByAppendingString:self.homeworkSession.reviewText];
    } else if (self.homeworkSession.score == 4) {
        text = [@"4星 " stringByAppendingString:self.homeworkSession.reviewText];
    } else if (self.homeworkSession.score == 5) {
        text = [@"5星 " stringByAppendingString:self.homeworkSession.reviewText];
    } else if (self.homeworkSession.score == 6) {
        text = [@"5星 " stringByAppendingString:self.homeworkSession.reviewText];
    }
    
    [self sendTextMessage:text attributes:@{@"score":@(self.homeworkSession.score), @"reviewText":self.homeworkSession.reviewText,@"isRedo":@(self.homeworkSession.isRedo)}];
    [self.conversation setObject:@(YES) forKey:@"taskfinished"];
    [self.conversation updateWithCallback:^(BOOL succeeded, NSError * _Nullable error) {
        if (!succeeded) {
            [self.conversation updateWithCallback:^(BOOL succeeded, NSError * _Nullable error) {
            }];
        }
    }];
    
    [PushManager pushText:@"你有作业已通过" toUsers:@[@(self.homeworkSession.student.userId)]];
}

#pragma mark - IBActions

- (IBAction)audioButtonPressed:(id)sender {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (authStatus == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio
                                 completionHandler:^(BOOL granted) {
                                     dispatch_async(dispatch_get_main_queue(), ^{
                                         if (granted) {
                                             [self audioButtonPressed:nil];
                                         } else {
                                             [HUD showErrorWithMessage:@"麦克风使用权限未授权"];
                                         }
                                     });
                                 }];
        
        return ;
    } else if (authStatus != AVAuthorizationStatusAuthorized) {
        [HUD showErrorWithMessage:@"麦克风使用权限未授权"];
        
        return ;
    }
    
    // 表情相关重置
    self.emojiViewBottomLayoutConstraint.constant = -216.f - (isIPhoneX?39:0);
    [self.emojiButton setImage:[UIImage imageNamed:@"icon_Emoji"] forState:UIControlStateNormal];
    
    // 操作按钮相关的重置
    self.operationsViewBottomConstraint.constant = -80.f - (isIPhoneX?39:0);
    
    // 根据录音按钮判断是否需要显示录音按钮
    if (self.recordButton.hidden) { // 需要显示 按住录音 文字
        self.tempText = self.inputTextView.text;
        self.inputTextView.text = @"minnie";
        [self resizeInputTextView];
        
        self.recordButton.hidden = NO;
        [self.audioButton setImage:[UIImage imageNamed:@"btn_keyboard"] forState:UIControlStateNormal];
        
        if (!self.inputTextView.isFirstResponder) {
            self.inputViewBottomConstraint.constant = 0;
            
            [UIView animateWithDuration:0.3f
                             animations:^{
                                 [self.view layoutIfNeeded];
                             }];
        } else {
            [self.inputTextView resignFirstResponder];
        }
    } else { // 显示键盘
        self.inputTextView.text = self.tempText;
        [self resizeInputTextView];
        
        self.recordButton.hidden = YES;
        [self.audioButton setImage:[UIImage imageNamed:@"icon_Voice"] forState:UIControlStateNormal];
        
        [self.inputTextView becomeFirstResponder];
    }
    
    [self disableControlsForAWhile];
}

- (IBAction)emojiButtonPressed:(id)sender {
    // 录音相关重置
    if (!self.recordButton.hidden) {
        self.inputTextView.text = self.tempText;
        [self resizeInputTextView];
    }
    
    self.recordButton.hidden = YES;
    [self.audioButton setImage:[UIImage imageNamed:@"icon_Voice"] forState:UIControlStateNormal];
    
    // 操作按钮相关的重置
    self.operationsViewBottomConstraint.constant = -80.f - (isIPhoneX?39:0);
    
    [self.view layoutIfNeeded];
    
    // 显示emoji键盘
    if (self.emojiViewBottomLayoutConstraint.constant < 0) { // 隐藏状态，需要显示emoji
        self.emojiViewBottomLayoutConstraint.constant = 0;
        [self.emojiButton setImage:[UIImage imageNamed:@"btn_keyboard"] forState:UIControlStateNormal];
        
        if ([self.inputTextView isFirstResponder]) {
            [self.inputTextView resignFirstResponder];
        } else {
            self.inputViewBottomConstraint.constant = 216.f;
            [UIView animateWithDuration:0.3
                             animations:^{
                                 [self.view layoutIfNeeded];
                             } completion:^(BOOL finished) {
                                 [self scrollMessagesTableViewToBottom:YES];
                             }];
        }
    } else { // 显示键盘
        self.emojiViewBottomLayoutConstraint.constant = -216.f - (isIPhoneX?39:0);
        [self.emojiButton setImage:[UIImage imageNamed:@"icon_Emoji"] forState:UIControlStateNormal];
        
        [self.inputTextView becomeFirstResponder];
    }
    
    [self disableControlsForAWhile];
}

- (IBAction)addButtonPressed:(id)sender {
    if (!self.recordButton.hidden) {
        self.inputTextView.text = self.tempText;
        [self resizeInputTextView];
    }
    
    self.recordButton.hidden = YES;
    [self.audioButton setImage:[UIImage imageNamed:@"icon_Voice"] forState:UIControlStateNormal];
    
    self.emojiViewBottomLayoutConstraint.constant = -216.f - (isIPhoneX?39:0);
    [self.emojiButton setImage:[UIImage imageNamed:@"icon_Emoji"] forState:UIControlStateNormal];
    
    if (self.operationsViewBottomConstraint.constant < 0) { // 显示操作栏
        self.operationsViewBottomConstraint.constant = 0.f;
        
        if (self.inputTextView.isFirstResponder) {
            [self.inputTextView resignFirstResponder];
        } else {
            self.inputViewBottomConstraint.constant = 80.f;
            [UIView animateWithDuration:0.3
                             animations:^{
                                 [self.view layoutIfNeeded];
                             }
                             completion:^(BOOL finished) {
                                 [self scrollMessagesTableViewToBottom:YES];
                             }];
        }
    } else {
        self.operationsViewBottomConstraint.constant = -80.f - (isIPhoneX?39:0);
        
        [self.inputTextView becomeFirstResponder];
    }
    
    [self disableControlsForAWhile];
}

- (IBAction)photoButtonPressed:(id)sender {
#if TEACHERSIDE
    self.isCommitingHomework = NO;
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:4 delegate:nil pushPhotoPickerVc:YES];
#else
    self.isCommitingHomework = YES;
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 columnNumber:4 delegate:nil pushPhotoPickerVc:YES];
#endif
    
    
#pragma mark - 五类个性化设置，这些参数都可以不传，此时会走默认设置
    imagePickerVc.naviBgColor = [UIColor whiteColor];
    imagePickerVc.barItemTextColor = [UIColor colorWithHex:0x333333];
    imagePickerVc.naviTitleColor = [UIColor colorWithHex:0x333333];
    imagePickerVc.isSelectOriginalPhoto = YES;
    imagePickerVc.allowTakePicture = NO; // 在内部显示拍照按钮
    imagePickerVc.allowTakeVideo = NO;   // 在内部显示拍视频按
    [imagePickerVc setUiImagePickerControllerSettingBlock:^(UIImagePickerController *imagePickerController) {
        imagePickerController.videoQuality = UIImagePickerControllerQualityTypeHigh;
    }];
    
    imagePickerVc.iconThemeColor = [UIColor colorWithRed:31 / 255.0 green:185 / 255.0 blue:34 / 255.0 alpha:1.0];
    imagePickerVc.showPhotoCannotSelectLayer = YES;
    imagePickerVc.cannotSelectLayerColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    [imagePickerVc setPhotoPickerPageUIConfigBlock:^(UICollectionView *collectionView, UIView *bottomToolBar, UIButton *previewButton, UIButton *originalPhotoButton, UILabel *originalPhotoLabel, UIButton *doneButton, UIImageView *numberImageView, UILabel *numberLabel, UIView *divideLine) {
        [doneButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }];

    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    imagePickerVc.allowPickingGif = NO;
    imagePickerVc.allowPickingMultipleVideo = NO; // 是否可以多选视频
    
  
    imagePickerVc.showSelectBtn = NO;
    imagePickerVc.allowCrop = NO;
    imagePickerVc.needCircleCrop = NO;
    // 设置竖屏下的裁剪尺寸
   
    imagePickerVc.statusBarStyle = UIStatusBarStyleDefault;
    
    // 设置是否显示图片序号
    imagePickerVc.showSelectedIndex = NO;
    
    WeakifySelf;
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        StrongifySelf;
#if TEACHERSIDE
        WBGImageEditorViewController *editVC = [[WBGImageEditorViewController alloc] init];
        [editVC setOnlyForSend:YES];
        [editVC setThumbnailImages:photos];
        [editVC setSendCallback:^(UIImage *image) {
            [strongSelf sendImageMessageWithImage:image];
        }];
        [strongSelf.navigationController presentViewController:editVC animated:YES completion:nil];
#else
        [strongSelf sendImageMessageWithImages:photos withSendIndex:0];
#endif
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
    
}

- (IBAction)videoButtonPressed:(id)sender {
#if TEACHERSIDE
    self.isCommitingHomework = NO;
#else
    self.isCommitingHomework = YES;
#endif
    UIImagePickerController *videoPicker = [[UIImagePickerController alloc] init];
    videoPicker.allowsEditing = YES;
    videoPicker.videoMaximumDuration = 300;
    videoPicker.delegate = self;
    videoPicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    videoPicker.mediaTypes =  @[(NSString *)kUTTypeMovie];
    
    [self.navigationController presentViewController:videoPicker animated:YES completion:nil];
}

- (IBAction)sendAnswerButtonPressed:(id)sender {
    if (self.homeworkSession.homework.answerItems.count == 0) {
        [HUD showWithMessage:@"当前作业没有设置答案"];

        return;
    }
    
    for (HomeworkAnswerItem *item in self.homeworkSession.homework.answerItems) {
        if ([item.type isEqualToString:HomeworkAnswerItemTypeImage]) {
            [self sendImageMessageWithURL:[NSURL URLWithString:item.imageUrl]];
        } else if ([item.type isEqualToString:HomeworkAnswerItemTypeVideo]) {
            [self sendVideoMessage:[NSURL URLWithString:item.videoUrl] duration:1.0];
        }
    }
}

- (IBAction)sendWarningButtonPressed:(id)sender {
    
    [self sendImageMessageWithImage:[UIImage imageNamed:@"警告图片"]];
}


- (IBAction)correctButtonPressed:(id)sender {
    CorrectHomeworkViewController *vc = [[CorrectHomeworkViewController alloc] initWithNibName:@"CorrectHomeworkViewController" bundle:nil];
    vc.homeworkSession = self.homeworkSession;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)retryButtonPressed:(id)sender {
    [AlertView showInView:self.navigationController.view
                withImage:[UIImage imageNamed:@"pop_img_return"]
                    title:@"重做这个作业？"
                  message:@"少年，很有个性哦！你确认要这么做？"
                  action1:@"放弃"
          action1Callback:^{
          }
                  action2:@"确定"
          action2Callback:^{
              [HomeworkSessionService redoHomeworkSessionWithId:self.homeworkSession.homeworkSessionId
                                                       callback:^(Result *result, NSError *error) {
                                                           if (error != nil) {
                                                               [HUD showErrorWithMessage:@"请求失败"];
                                                               return;
                                                           }
                                                           
#if TEACHERSIDE
#else
                                                           NSInteger star = MIN(5, self.homeworkSession.score);
                                                           if (APP.currentUser.starCount > star) {
                                                               APP.currentUser.starCount -= star;
                                                           } else {
                                                               APP.currentUser.starCount = 0;
                                                           }
                                                           
                                                           [PushManager pushText:@"你有重做的作业"
                                                                         toUsers:@[@(self.homeworkSession.correctTeacher.userId)]];
#endif
                                                           
                                                           self.homeworkSession.score = 0;
                                                           self.homeworkSession.reviewText = nil;
                                                           
                                                           self.resultView.hidden = YES;
                                                           self.inputView.hidden = NO;
                                                           
                                                           [self sendTextMessage:@"为了更多的星星而奋斗"];
                                                           
                                                           [self.conversation setObject:@(NO) forKey:@"taskfinished"];
                                                           [self.conversation updateWithCallback:^(BOOL succeeded, NSError * _Nullable error) {
                                                               if (!succeeded) {
                                                                   [self.conversation updateWithCallback:^(BOOL succeeded, NSError * _Nullable error) {
                                                                   }];
                                                               }
                                                           }];
                                                           
                                                           [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationKeyOfRedoHomework object:nil];
                                                       }];
          }];
}

- (IBAction)studentButtonPressed:(id)sender {
#if TEACHERSIDE
    StudentDetailViewController *vc = [[StudentDetailViewController alloc] initWithNibName:@"StudentDetailViewController" bundle:nil];
    vc.userId = self.homeworkSession.student.userId;
    [self.navigationController pushViewController:vc animated:YES];
#endif
}

#pragma mark - Private

- (AVIMClient *)client {
    return [IMManager sharedManager].client;
}

- (AVIMConversation *)conversation {
    return self.homeworkSession.conversation;
}

- (void)updateHomeworkSessionModifiedTime {
    WeakifySelf;
    [HomeworkSessionService updateHomeworkSessionModifiedTimeWithId:self.homeworkSession.homeworkSessionId
                                                           callback:^(Result *result, NSError *error) {
                                                               if (error == nil) {
                                                                 //  [weakSelf reUpdateModeifyTime];
                                                                   weakSelf.bFailReSendFlag = NO;
                                                               }
                                                               else
                                                               {
                                                                   weakSelf.bFailReSendFlag = YES;
                                                               }
                                                           }];
}

//- (void)reUpdateModeifyTime
//{
//    _failReSendCount--;
//    if (_failReSendCount > 0)
//    {
//        WeakifySelf;
//        [HomeworkSessionService updateHomeworkSessionModifiedTimeWithId:self.homeworkSession.homeworkSessionId
//                                                               callback:^(Result *result, NSError *error) {
//                                                                   if (error) {
//                                                                       [weakSelf reUpdateModeifyTime];
//
//                                                                   }
//                                                               }];
//    }
//}


- (void)setupResultView {
    UIColor *bgColor = nil;
    NSString *text = nil;
    
    self.start1ImageView.hidden = self.homeworkSession.score<1;
    self.start2ImageView.hidden = self.homeworkSession.score<2;
    self.start3ImageView.hidden = self.homeworkSession.score<3;
    self.start4ImageView.hidden = self.homeworkSession.score<4;
    self.start5ImageView.hidden = self.homeworkSession.score<5;
    
    if (self.homeworkSession.score == 0) {
       // text = @"Pass!";
        bgColor = [UIColor lightGrayColor];
    }else if (self.homeworkSession.score == 1) {
        text = @"Pass!";
        bgColor = [UIColor colorWithHex:0x28C4B7];
    } else if (self.homeworkSession.score == 2) {
        text = @"Good job!";
        bgColor = [UIColor colorWithHex:0x00CE00];
    } else if (self.homeworkSession.score == 3) {
        text = @"Very nice!";
        bgColor = [UIColor colorWithHex:0x0098FE];
    } else if (self.homeworkSession.score == 4) {
        text = @"Great!";
        bgColor = [UIColor colorWithHex:0xFFC600];
    } else if (self.homeworkSession.score == 5) {
        text = @"Perfect!";
        bgColor = [UIColor colorWithHex:0xFF4858];
    } else if (self.homeworkSession.score == 6) {
        text = @"Very hardworking!";
        bgColor = [UIColor colorWithHex:0xB248FF];
    }
    
    self.scoreLabel.text = self.homeworkSession.reviewText;
    
    self.resultContentView.backgroundColor = bgColor;
    self.resultPaddingView.backgroundColor = bgColor;
    
#if TEACHERSIDE
    self.retryButton.hidden = YES;
#else
    
    if (self.homeworkSession.isRedo)
    {
        self.retryButton.backgroundColor = bgColor;
        self.retryButton.layer.cornerRadius = 12.f;
        self.retryButton.layer.masksToBounds = YES;
        self.retryButton.layer.borderColor = [UIColor whiteColor].CGColor;
        self.retryButton.layer.borderWidth = 1;
        self.retryButton.hidden = NO;
    }
    
#endif
}

- (void)setupConversation {
    NSString *teacherId = [NSString stringWithFormat:@"%@", @(self.homeworkSession.correctTeacher.userId)];
    NSString *studentId = [NSString stringWithFormat:@"%@", @(self.homeworkSession.student.userId)];
    
    [self.loadingContainerView showLoadingView];
    
    NSString *name = [NSString stringWithFormat:@"%@", @(self.homeworkSession.homeworkSessionId)];
    if (self.conversation == nil) {
        AVIMConversationQuery *query = [self.client conversationQuery];
        [query whereKey:@"name" equalTo:name];
        [query findConversationsWithCallback:^(NSArray * _Nullable conversations, NSError * _Nullable error) {
            if (error == nil)
            {
                if (conversations.count > 0) {
                    self.homeworkSession.conversation = conversations[0];
                    
                    [self loadMessagesHistory];
                } else {
                    [self.client createConversationWithName:name
                                                  clientIds:@[teacherId, studentId]
                                                 attributes:nil
                                                    options:AVIMConversationOptionNone
                                                   callback:^(AVIMConversation * conversation, NSError * error) {
                                                       if (error == nil) {
                                                           self.homeworkSession.conversation = conversation;
                                                           
                                                           [self loadMessagesHistory];
                                                       } else {
                                                           BLYLogError(@"会话页面加载失败(创建IM会话失败): %@", error);
                                                           
                                                           [self.loadingContainerView showFailureViewWithRetryCallback:^{
                                                               [self setupConversation];
                                                           }];
                                                       }
                                                   }];
                }
            }
            else
            {
                BLYLogError(@"会话页面加载失败(创建IM会话失败): %@", error);
                
                [self.loadingContainerView showFailureViewWithRetryCallback:^{
                    [self setupConversation];
                }];
            }
        }];
    } else {
        [self loadMessagesHistory];
    }
}

- (void)sendTextMessage:(NSString *)text {
    [self sendTextMessage:text attributes:nil];
}

- (void)sendTextMessage:(NSString *)text attributes:(NSDictionary *)attributes {
    self.inputTextView.text = nil;
    [self resizeInputTextView];
    
    int64_t timestamp = (int64_t)([[NSDate date] timeIntervalSince1970] * 1000);
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (attributes.count > 0) {
        [dict addEntriesFromDictionary:attributes];
    }
    dict[kKeyOfCreateTimestamp] = @(timestamp);

    [NSMutableDictionary dictionaryWithDictionary:attributes];
    AVIMTextMessage *message = [AVIMTextMessage messageWithText:text attributes:dict];
    [self sendMessage:message];
}

- (void)sendEmojiMessage:(NSString *)text {
    int64_t timestamp = (int64_t)([[NSDate date] timeIntervalSince1970] * 1000);
    AVIMTextMessage *message = [AVIMTextMessage messageWithText:text attributes:@{@"isEmoji":@(1), kKeyOfCreateTimestamp:@(timestamp)}];
    
    [self sendMessage:message];
}

- (UIImage *)editedImageWithImage:(UIImage *)originalImage {
    // 先看确定尺寸
    CGFloat width = originalImage.size.width;
    CGFloat height = originalImage.size.height;
    if (originalImage.size.width>=720.f || originalImage.size.height>=2160.f) {
        CGFloat ratio = originalImage.size.width / originalImage.size.height;
        if (ratio >= 1/3.f) {
            width = MIN(originalImage.size.width, 720.f);
            height = width / ratio;
        }
        else {
            width = MIN(originalImage.size.width, 480.f);
            height = width / ratio;
        }
    }
    
    UIImage *image = originalImage;
    if (ABS(width-originalImage.size.width) > 1.f) {
        CGSize imageSize = CGSizeMake(width, height);
        UIGraphicsBeginImageContextWithOptions(imageSize, NO, 1.f);
        [originalImage drawInRect:CGRectMake(0.f, 0.f, width, height)];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    return image;
}

- (void)sendImageMessageWithImages:(NSArray *)images withSendIndex:(NSInteger)index
{
    if (index == images.count)
    {
        return;
    }
    NSInteger nextIndex = index+1;
    [HUD showProgressWithMessage:@"正在压缩图片..."];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *editedImage = [self editedImageWithImage:[images objectAtIndex:index]];
        NSData *data = UIImageJPEGRepresentation(editedImage, 0.7f);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [HUD showProgressWithMessage:@"正在上传图片..."];
            WeakifySelf;
            [[FileUploader shareInstance] uploadData:data
                                                type:UploadFileTypeImage
                                       progressBlock:^(NSInteger number) {
                                           [HUD showProgressWithMessage:[NSString stringWithFormat:@"正在上传图片%@%%...", @(number)]];
                                       }
                                     completionBlock:^(NSString * _Nullable imageUrl, NSError * _Nullable error) {
                                         
                                         StrongifySelf;
                                         if (imageUrl.length > 0) {
                                             [HUD hideAnimated:YES];
                                             
                                             [self sendImageMessageWithURL:[NSURL URLWithString:imageUrl]];
                                         } else {
                                             [HUD showErrorWithMessage:@"图片上传失败"];
                                         }
                            
                                         [strongSelf sendImageMessageWithImages:images withSendIndex:nextIndex];
                                         
                                     }];
        });
    });
    
    
}


- (void)sendImageMessageWithImage:(UIImage *)image {
    [HUD showProgressWithMessage:@"正在压缩图片..."];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *editedImage = [self editedImageWithImage:image];
        NSData *data = UIImageJPEGRepresentation(editedImage, 0.7f);

        dispatch_async(dispatch_get_main_queue(), ^{
            [HUD showProgressWithMessage:@"正在上传图片..."];
            
            [[FileUploader shareInstance] uploadData:data
                                type:UploadFileTypeImage
                       progressBlock:^(NSInteger number) {
                           [HUD showProgressWithMessage:[NSString stringWithFormat:@"正在上传图片%@%%...", @(number)]];
                       }
                     completionBlock:^(NSString * _Nullable imageUrl, NSError * _Nullable error) {
                         if (imageUrl.length > 0) {
                             [HUD hideAnimated:YES];
                             
                             [self sendImageMessageWithURL:[NSURL URLWithString:imageUrl]];
                         } else {
                             [HUD showErrorWithMessage:@"图片上传失败"];
                         }
                     }];
        });
    });
}

- (void)sendImageMessageWithURL:(NSURL *)imageURL {
    if (self.isCommitingHomework) {
        [HUD showProgressWithMessage:@"正在提交作业..."];
        
        [HomeworkSessionService commitHomeworkWithId:self.homeworkSession.homeworkSessionId
                                            imageUrl:imageURL.absoluteString
                                            videoUrl:nil
                                            callback:^(Result *result, NSError *error) {
                                                
                                                
                                                if (error == nil) {
                                                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationKeyOfCommitHomework object:nil];
                                                    
                                                    [HUD showWithMessage:@"作业提交成功"];
                                                    
                                                    [PushManager pushText:@"[图片]"
                                                                  toUsers:@[@(self.homeworkSession.correctTeacher.userId)] withPushType:PushManagerMessage];
                                                    
                                                    int64_t timestamp = (int64_t)([[NSDate date] timeIntervalSince1970] * 1000);
                                                    AVFile *file = [AVFile fileWithRemoteURL:imageURL];
                                                    AVIMImageMessage *message = [AVIMImageMessage messageWithText:@"image" file:file attributes:@{kKeyOfCreateTimestamp:@(timestamp)}];
                                                    
                                                    [self sendMessage:message];
                                                    
                                                    
                                                } else {
                                                    [HUD showErrorWithMessage:@"作业提交失败"];
                                                }
                                                self.isCommitingHomework = NO;
                                            }];
    } else {
        int64_t timestamp = (int64_t)([[NSDate date] timeIntervalSince1970] * 1000);
        AVFile *file = [AVFile fileWithRemoteURL:imageURL];
        AVIMImageMessage *message = [AVIMImageMessage messageWithText:@"image" file:file attributes:@{kKeyOfCreateTimestamp:@(timestamp)}];
        
        [self sendMessage:message];
    }
}

- (void)sendAudioMessage:(NSURL *)audioURL duration:(CGFloat)duration {
    int64_t timestamp = (int64_t)([[NSDate date] timeIntervalSince1970] * 1000);
    AVFile *file = [AVFile fileWithRemoteURL:audioURL];
    NSInteger d = (NSInteger)duration;
    AVIMAudioMessage *message = [AVIMAudioMessage messageWithText:@"audio"
                                                             file:file
                                                       attributes:@{kKeyOfCreateTimestamp:@(timestamp),
                                                                    kKeyOfAudioDuration:@(d)}];
    [self sendMessage:message];
}

- (void)sendVideoMessageForPath:(NSString *)path
{
    AVIMClientStatus status = [IMManager sharedManager].client.status;
    if (status == AVIMClientStatusNone ||
        status == AVIMClientStatusClosed ||
        status == AVIMClientStatusPaused) {
        NSString *userId = [NSString stringWithFormat:@"%@", @(APP.currentUser.userId)];
        [[IMManager sharedManager] setupWithClientId:userId callback:^(BOOL success, NSError * _Nullable error)
         {
             if (!success)
             {
                 return;
             }
         }];
    }
    
    if (status != AVIMClientStatusOpened) {
        [HUD showErrorWithMessage:@"IM服务暂不可用，请稍后再试"];
        return;
    }
   
    
    AVFile *file = [AVFile fileWithLocalPath:path error:nil];
    int64_t timestamp = (int64_t)([[NSDate date] timeIntervalSince1970] * 1000);
    AVIMVideoMessage *message = [AVIMVideoMessage messageWithText:@"video"
                                                             file:file
                                                       attributes:@{kKeyOfCreateTimestamp:@(timestamp)}];
     BOOL isResend = message.status == AVIMMessageStatusFailed;
    [self.conversation sendMessage:message progressBlock:^(NSInteger progress) {
        [HUD showProgressWithMessage:[NSString stringWithFormat:@"正在上传视频%@%%...", @(progress)] cancelCallback:^{
            [file cancelUploading];
        }];
    } callback:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded)
        {
          //  [HUD hideAnimated:YES];
            
            if (file.url.length == 0)
            {
                [HUD showErrorWithMessage:@"视频上传失败"];
                return;
            }
            
#if TEACHERSIDE
#else
            if (self.messages.count==0)
            {
                [self updateHomeworkSessionModifiedTime];
            }
            
            if (self.bFailReSendFlag)
            {
                [self updateHomeworkSessionModifiedTime];
            }
#endif
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kIMManagerContentMessageDidSendNotification object:nil userInfo:@{@"message": message}];
            
            if (!isResend) {
                [self.messages addObject:(AVIMTypedMessage *)message];
            }
            
            [self sortMessages];
            [self reloadDataAndScrollToBottom];
            
            
            if (self.isCommitingHomework)
            {
                [HUD showProgressWithMessage:@"正在提交作业..."];
                
                [HomeworkSessionService commitHomeworkWithId:self.homeworkSession.homeworkSessionId
                                                    imageUrl:nil
                                                    videoUrl:file.url
                                                    callback:^(Result *result, NSError *error) {
                                                        self.isCommitingHomework = NO;
                                                        
                                                        if (error == nil) {
                                                            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationKeyOfCommitHomework object:nil];
                                                            
                                                            [HUD showWithMessage:@"作业提交成功"];
                                                            [PushManager pushText:@"[视频]"
                                                                          toUsers:@[@(self.homeworkSession.correctTeacher.userId)] withPushType:PushManagerMessage];
                                                            
                                                    
                                                        } else {
                                                            [HUD showErrorWithMessage:@"作业提交失败"];
                                                        }
                                                    }];
                
            }
            
            
        }
        else
        {
            [HUD showErrorWithMessage:@"视频上传失败"];
        }
    }];
    
}

- (void)sendVideoMessage:(NSURL *)videoURL duration:(CGFloat)duration{
    if (self.isCommitingHomework) {
        [HUD showProgressWithMessage:@"正在提交作业..."];
        
        [HomeworkSessionService commitHomeworkWithId:self.homeworkSession.homeworkSessionId
                                            imageUrl:nil
                                            videoUrl:videoURL.absoluteString
                                            callback:^(Result *result, NSError *error) {
                                                
                                                
                                                if (error == nil) {
                                                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationKeyOfCommitHomework object:nil];
                                                    
                                                    [HUD showWithMessage:@"作业提交成功"];
                                                    [PushManager pushText:@"[视频]"
                                                                  toUsers:@[@(self.homeworkSession.correctTeacher.userId)] withPushType:PushManagerMessage];
                                                    
                                                    int64_t timestamp = (int64_t)([[NSDate date] timeIntervalSince1970] * 1000);
                                                    NSInteger d = (NSInteger)duration;
                                                    AVFile *file = [AVFile fileWithRemoteURL:videoURL];
                                                    AVIMVideoMessage *message = [AVIMVideoMessage messageWithText:@"video"
                                                                                                             file:file
                                                                                                       attributes:@{kKeyOfCreateTimestamp:@(timestamp),kKeyOfVideoDuration:@(d)}];
                                                    
                                                    [self sendMessage:message];
                                                } else {
                                                    [HUD showErrorWithMessage:@"作业提交失败"];
                                                }
                                                self.isCommitingHomework = NO;
                                            }];
    } else {
        int64_t timestamp = (int64_t)([[NSDate date] timeIntervalSince1970] * 1000);
        AVFile *file = [AVFile fileWithRemoteURL:videoURL];
        AVIMVideoMessage *message = [AVIMVideoMessage messageWithText:@"video"
                                                                 file:file
                                                           attributes:@{kKeyOfCreateTimestamp:@(timestamp)}];
        
        [self sendMessage:message];
    }
}

- (void)sendMessage:(AVIMMessage *)message {
    //发送消息之前进行IM服务判断
    AVIMClientStatus status = [IMManager sharedManager].client.status;
    if (status == AVIMClientStatusNone ||
        status == AVIMClientStatusClosed ||
        status == AVIMClientStatusPaused) {
        NSString *userId = [NSString stringWithFormat:@"%@", @(APP.currentUser.userId)];
        [[IMManager sharedManager] setupWithClientId:userId callback:^(BOOL success, NSError * _Nullable error)
         {
             if (!success)
             {
                 return;
             }
         }];
    }
    
    if (status != AVIMClientStatusOpened) {
        [HUD showErrorWithMessage:@"IM服务暂不可用，请稍后再试"];
        return;
    }
    BOOL isResend = message.status == AVIMMessageStatusFailed;
    
    //发送消息，区分学生端和客户端
#if TEACHERSIDE
    NSArray * users = @[@(self.homeworkSession.student.userId)];
#else
    NSArray * users = @[@(self.homeworkSession.correctTeacher.userId)];
#endif
    
    if (message.mediaType == kAVIMMessageMediaTypeText)
    {
        AVIMTextMessage * textMessage = (AVIMTextMessage *)message;
        [PushManager pushText:textMessage.text
                      toUsers:users withPushType:PushManagerMessage];
    }
    else if (message.mediaType == kAVIMMessageMediaTypeImage)
    {
        if (!self.isCommitingHomework)
        {
            [PushManager pushText:@"[图片]"
                          toUsers:users withPushType:PushManagerMessage];
        }
    }
    else if (message.mediaType == kAVIMMessageMediaTypeAudio)
    {
        [PushManager pushText:@"[语音]"
                          toUsers:users withPushType:PushManagerMessage];
        
    }
    else if (message.mediaType == kAVIMMessageMediaTypeVideo)
    {
        if (!self.isCommitingHomework)
        {
            [PushManager pushText:@"[视频]"
                          toUsers:users withPushType:PushManagerMessage];
        }
    }
    
    [self.conversation sendMessage:message
                          callback:^(BOOL succeeded, NSError * _Nullable error) {
#if TEACHERSIDE
#else
                              if (succeeded && self.messages.count==0)
                              {
                                  [self updateHomeworkSessionModifiedTime];
                              }
                              
                              if (self.bFailReSendFlag)
                              {
                                  [self updateHomeworkSessionModifiedTime];
                              }
#endif

                              [[NSNotificationCenter defaultCenter] postNotificationName:kIMManagerContentMessageDidSendNotification object:nil userInfo:@{@"message": message}];
                              
                              if (!isResend) {
                                  [self.messages addObject:(AVIMTypedMessage *)message];
                              }
                              
                              [self sortMessages];
                              [self reloadDataAndScrollToBottom];
                          }];
}

//- (void)handlePhotoPickerResult:(UIImagePickerController *)picker
//  didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
//    [picker dismissViewControllerAnimated:YES completion:^{
//        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
//        if (image.size.width==0 || image.size.height==0) {
//            [HUD showErrorWithMessage:@"图片选择失败"];
//            return;
//        }
//
//#if TEACHERSIDE
//        WBGImageEditorViewController *editVC = [[WBGImageEditorViewController alloc] init];
//        [editVC setOnlyForSend:YES];
//        [editVC setThumbnailImage:image];
//        [editVC setSendCallback:^(UIImage *image) {
//            [self sendImageMessageWithImage:image];
//        }];
//        [self.navigationController presentViewController:editVC animated:YES completion:nil];
//#else
//        [self sendImageMessageWithImage:image];
//#endif
//    }];
//}

- (void)handleVideoPickerResult:(UIImagePickerController *)picker
  didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:^{
        NSURL *videoUrl = [info objectForKey:UIImagePickerControllerMediaURL];
        AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoUrl options:nil];
        
        NSTimeInterval durationInSeconds = 0.0;
        if (asset != nil) {
            durationInSeconds = CMTimeGetSeconds(asset.duration);
        }
        
#if TEACHERSIDE
#else
        if (durationInSeconds > 5*60) {
            [HUD showErrorWithMessage:@"视频时长不能超过5分钟"];
            
            return;
        }
#endif
        
        NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%ld_compressedVideo.mp4",time(NULL)]];

        AVURLAsset *avAsset = [[AVURLAsset alloc] initWithURL:videoUrl options:nil];
        NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
        if ([compatiblePresets containsObject:AVAssetExportPresetHighestQuality]) {
            AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPreset960x540];
            exportSession.outputURL = [NSURL fileURLWithPath:path];
            exportSession.shouldOptimizeForNetworkUse = true;
            exportSession.outputFileType = AVFileTypeMPEG4;
            
            [HUD showProgressWithMessage:@"正在压缩视频..."];
            
            [exportSession exportAsynchronouslyWithCompletionHandler:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    
                    if ([exportSession status] == AVAssetExportSessionStatusCompleted) {
                      [[FileUploader shareInstance] uploadDataWithLocalFilePath:path
                                                    progressBlock:^(NSInteger number) {
                                                        [HUD showProgressWithMessage:[NSString stringWithFormat:@"正在上传视频%@%%...", @(number)] cancelCallback:^{
                                                            [[FileUploader shareInstance] cancleUploading];
                                                        }];
                                                    }
                                                  completionBlock:^(NSString * _Nullable videoUrl, NSError * _Nullable error) {
                                                      if (videoUrl.length > 0) {
                                                          [HUD hideAnimated:YES];

                                                          [self sendVideoMessage:[NSURL URLWithString:videoUrl] duration:durationInSeconds];

                                                          [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
                                                      } else {
                                                          [HUD showErrorWithMessage:@"视频上传失败"];
                                                      }
                                                  }];

                        [HUD showProgressWithMessage:@"正在上传视频..." cancelCallback:^{
                            [[FileUploader shareInstance] cancleUploading];
                        }];
                        
//                        [self sendVideoMessageForPath:path];
                        
                    } else{
                        NSLog(@"当前压缩进度:%f",exportSession.progress);
                    }
                    
                    NSLog(@"%@",exportSession.error);
                });
            }];
        }
    }];
}

- (void)playerVideoWithURL:(NSString *)url {
    [self.inputTextView resignFirstResponder];
    
    [[AudioPlayer sharedPlayer] stop];
    
    AVPlayerViewController *playerViewController = [[AVPlayerViewController alloc]init];
    VIResourceLoaderManager *resourceLoaderManager = [VIResourceLoaderManager new];
    self.resourceLoaderManager = resourceLoaderManager;
    AVPlayerItem *playerItem = [resourceLoaderManager playerItemWithURL:[NSURL URLWithString:url]];
    AVPlayer *player = [AVPlayer playerWithPlayerItem:playerItem];
    playerViewController.player = player;
    [self presentViewController:playerViewController animated:YES completion:nil];
    playerViewController.view.frame = self.view.frame;
    [playerViewController.player play];
}

- (void)playAudioWithURL:(NSString *)url withCoverURL:(NSString *)coverUrl
{
    [self.inputTextView resignFirstResponder];
    
    [[AudioPlayer sharedPlayer] stop];
    
    AudioPlayerViewController *playerViewController = [[AudioPlayerViewController alloc]init];
    VIResourceLoaderManager *resourceLoaderManager = [VIResourceLoaderManager new];
    self.resourceLoaderManager = resourceLoaderManager;
    AVPlayerItem *playerItem = [resourceLoaderManager playerItemWithURL:[NSURL URLWithString:url]];
    AVPlayer *player = [AVPlayer playerWithPlayerItem:playerItem];
    playerViewController.player = player;
    [self presentViewController:playerViewController animated:YES completion:nil];
    playerViewController.view.frame = self.view.frame;
    [playerViewController.player play];
    [playerViewController setOverlyViewCoverUrl:coverUrl];
}

- (void)resizeInputTextView {
    NSInteger lines = [self.inputTextView sizeThatFits:self.inputTextView.frame.size].height / self.inputTextView.font.lineHeight;
    CGFloat height = lines * self.inputTextView.font.lineHeight;
    self.inputTextViewHeightConstraint.constant = MIN(height, self.inputTextView.font.lineHeight * 4);
    
    [self.inputView layoutIfNeeded];
}

- (void)loadMessagesHistory {
    [self.conversation queryMessagesFromServerWithLimit:1000 callback:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (error != nil) {
            BLYLogError(@"会话页面加载失败(加载历史小时失败): %@", error);
            
            [self.loadingContainerView showFailureViewWithRetryCallback:^{
                [self setupConversation];
            }];
            
            return;
        }
        
        if (self.conversation != nil) {
            [self.conversation readInBackground];
        }
        
        self.loadingContainerView.hidden = YES;
        
        if (objects.count > 0) {
            self.messagesTableView.hidden = YES;
            
            [self.messages addObjectsFromArray:objects];
            
            [self sortMessages];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.messagesTableView reloadData];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self scrollMessagesTableViewToBottom:NO];
                    self.messagesTableView.hidden = NO;
                });
            });
        }
    }];
}

- (void)sortMessages {
    self.sortedKeys = nil;
    [self.sortedMessages removeAllObjects];
    
    NSArray *orderedMessages = [self.messages sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        AVIMTypedMessage *message1 = (AVIMTypedMessage *)obj1;
        AVIMTypedMessage *message2 = (AVIMTypedMessage *)obj2;
        
        int64_t time1 = message1.sendTimestamp>0?message1.sendTimestamp:[message1.attributes[kKeyOfCreateTimestamp] longLongValue];
        int64_t time2 = message2.sendTimestamp>0?message2.sendTimestamp:[message2.attributes[kKeyOfCreateTimestamp] longLongValue];
        
        if (time1 < time2) {
            return NSOrderedAscending;
        } else if (time1 > time2) {
            return NSOrderedDescending;
        } else {
            return NSOrderedSame;
        }
    }];
    
    NSTimeInterval timeKey = 0;
    NSMutableArray *groupMessages = nil;
    for (NSInteger index=0; index<orderedMessages.count; index++) {
        AVIMMessage *message = orderedMessages[index];
        if ([message isKindOfClass:[AVIMTextMessage class]] &&
            ((AVIMTextMessage *)message).text.length == 0) {
            continue;
        }
        
        if (timeKey == 0) {
            timeKey = message.sendTimestamp;
            groupMessages = [NSMutableArray array];
        }
        
        if (message.sendTimestamp - timeKey > 2 * 50 * 1000) { // 5分钟内是连续的
            NSString *key = [NSString stringWithFormat:@"%.f", timeKey];
            self.sortedMessages[key] = groupMessages;
            
            timeKey = message.sendTimestamp;
            groupMessages = [NSMutableArray array];
        }
        
        BOOL exists = NO;
        for (AVIMMessage *m in groupMessages) {
            if ([m.messageId isEqualToString:message.messageId]) {
                exists = YES;
                break;
            }
        }

        if (!exists) {
            [groupMessages addObject:message];
        }
        
        if (index == orderedMessages.count-1) {
            NSString *key = [NSString stringWithFormat:@"%.f", timeKey];
            self.sortedMessages[key] = groupMessages;
        }
    }
    
    self.sortedKeys = [self.sortedMessages.allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return
        [(NSString *)obj1 compare:(NSString *)obj2];
    }];
}

- (void)scrollMessagesTableViewToBottom:(BOOL)animated {
    CGFloat height = self.messagesTableView.contentSize.height - self.messagesTableView.frame.size.height;
    if (height > 0) {
        [self.messagesTableView setContentOffset:CGPointMake(0, height) animated:animated];
    }
}

- (void)disableControlsForAWhile {
    self.view.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.view.userInteractionEnabled = YES;
    });
}

- (void)reloadDataAndScrollToBottom {
    AVIMMessage *message = self.conversation.lastMessage;
    if ([message isKindOfClass:[AVIMTextMessage class]]) {
        self.homeworkSession.lastSessionContent = ((AVIMTextMessage *)message).text;
    } else if ([message isKindOfClass:[AVIMAudioMessage class]]) {
        self.homeworkSession.lastSessionContent = @"[音频]";
    } else if ([message isKindOfClass:[AVIMVideoMessage class]]) {
        self.homeworkSession.lastSessionContent = @"[视频]";
    } else if ([message isKindOfClass:[AVIMImageMessage class]]) {
        self.homeworkSession.lastSessionContent = @"[图片]";
    }
    
    if (message.ioType == AVIMMessageIOTypeOut) {
        //        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationKeyOfLastIMMessageDidChange
        //                                                            object:nil
        //                                                          userInfo:@{@"message":message}];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.messagesTableView reloadData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self scrollMessagesTableViewToBottom:YES];
        });
    });
}

- (void)startRecord {
    [[AudioPlayer sharedPlayer] stop];

    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(
                                                            NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    NSString *soundFilePath = [docsDir
                               stringByAppendingPathComponent:@"sample.aac"];
    [[NSFileManager defaultManager] removeItemAtPath:soundFilePath
                                               error:nil];
    
    NSURL *url = [NSURL fileURLWithPath:soundFilePath];
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];

    NSError *error = nil;
    self.audioRecorder = [[AVAudioRecorder alloc] initWithURL:url settings:[self audioRecordingSettings] error:&error];
    self.audioRecorder.meteringEnabled = YES;
    if ([self.audioRecorder prepareToRecord]){
        self.audioRecorder.meteringEnabled = YES;
        [self.audioRecorder record];

        self.startTime = [NSDate date];
    }
}

- (void)stopRecord:(BOOL)shouldSend {
    [self.audioRecorder stop];
    self.audioRecorder = nil;
    
    [[AVAudioSession sharedInstance] setActive:NO error:nil];

    NSTimeInterval duration = [[NSDate date] timeIntervalSinceDate:self.startTime];
    if (duration < 1.f) { // 小于1s直接忽略
        return ;
    }
    
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    NSString *soundFilePath = [docsDir stringByAppendingPathComponent:@"sample.aac"];
    
    if (!shouldSend) {
        [[NSFileManager defaultManager] removeItemAtPath:soundFilePath
                                                   error:nil];
        
        return;
    }
    
    NSData *data = [NSData dataWithContentsOfFile:soundFilePath];
    if (data.length == 0) {
        [HUD showErrorWithMessage:@"语音录制失败"];
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [HUD showProgressWithMessage:@"正在上传语音..."];
        
        [[FileUploader shareInstance] uploadData:data
                            type:UploadFileTypeAudio
                   progressBlock:^(NSInteger number) {
                       [HUD showProgressWithMessage:[NSString stringWithFormat:@"正在上传语音%@%%...", @(number)]];
                   }
                 completionBlock:^(NSString * _Nullable audioUrl, NSError * _Nullable error) {
                     if (audioUrl.length > 0) {
                         [[NSFileManager defaultManager] removeItemAtPath:soundFilePath
                                                                    error:nil];
                         
                         [HUD hideAnimated:YES];
                         [self sendAudioMessage:[NSURL URLWithString:audioUrl] duration:duration];
                     } else {
                         [HUD showErrorWithMessage:@"音频上传失败"];
                     }
                 }];
    });
}

- (NSDictionary *)audioRecordingSettings{
    NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:kAudioFormatMPEG4AAC], AVFormatIDKey,
                              [NSNumber numberWithFloat:16000], AVSampleRateKey,
                              [NSNumber numberWithInt:2], AVNumberOfChannelsKey,
                              [NSNumber numberWithInt:AVAudioQualityMedium], AVSampleRateConverterAudioQualityKey,
                              [NSNumber numberWithInt:64000], AVEncoderBitRateKey,
                              [NSNumber numberWithInt:8], AVEncoderBitDepthHintKey,
                              nil];
    
    return settings;
}

- (void)showCurrentSelectedImage:(NSInteger)index {
    self.photoBrowser = [[NEPhotoBrowser alloc] init];
    self.photoBrowser.delegate = self;
    self.photoBrowser.dataSource = self;
    self.photoBrowser.clickedImageIndex = index;
    
    [self.photoBrowser showInContext:self.navigationController];
    
    self.dontScrollWhenAppeard = YES;
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    [self resizeInputTextView];
    
    if (textView.text.length > 0) {
        [textView scrollRangeToVisible:NSMakeRange(textView.text.length - 1, 1)];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [self sendTextMessage:textView.text];
        return NO;
    }
    
    return YES;
}



#pragma mark - UIImagePickerControllerDelegate
//- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    if ([UIDevice currentDevice].systemVersion.floatValue < 11) {
//        return;
//    }
//    if ([viewController isKindOfClass:NSClassFromString(@"PUPhotoPickerHostViewController")]) {
//        [viewController.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            if (obj.frame.size.width < 42) {
//                [viewController.view sendSubviewToBack:obj];
//                *stop = YES;
//            }
//        }];
//    }
//}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    NSString* mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:@"public.movie"]) {
        [self handleVideoPickerResult:picker didFinishPickingMediaWithInfo:info];
    } else {
       // [self handlePhotoPickerResult:picker didFinishPickingMediaWithInfo:info];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    self.isCommitingHomework = NO;
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sortedKeys.count + 1; // 第一个是作业信息
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    
    NSString *key = self.sortedKeys[section-1];
    NSArray *messages = self.sortedMessages[key];
    
    return messages.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        NSString *nibName =  @"SessionHomeworkTableViewCell";;
        
        SessionHomeworkTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil] lastObject];
        
        [cell setupWithHomeworkSession:self.homeworkSession];
        
        WeakifySelf;
        [cell setVideoCallback:^(NSString *videoUrl) {
            [weakSelf playerVideoWithURL:videoUrl];
        }];
        
        [cell setImageCallback:^(NSString * imageUrl, NSArray<UIImageView *> * imageViews, NSInteger index) {
            weakSelf.currentImageViews = imageViews;
            NSInteger selectIndex = [weakSelf.homeworkImages indexOfObject:imageUrl];
            [weakSelf showCurrentSelectedImage:selectIndex];
        }];
        
        [cell setAudioCallback:^(NSString * audioUrl, NSString * audioCoverUrl) {
            [weakSelf playAudioWithURL:audioUrl withCoverURL:audioCoverUrl];
        }];
        
        return cell;
    }
    
    if (indexPath.row == 0) {
        MessageTimeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MessageTimeTableViewCellId];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"MessageTimeTableViewCell" owner:nil options:nil] lastObject];
        }
        
        NSTimeInterval time = [self.sortedKeys[indexPath.section-1] floatValue]/1000;
        NSString *timeString = [[NSDate dateWithTimeIntervalSince1970:time] timeDescription];
        
        cell.timeLabel.text = timeString;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    
    NSString *key = self.sortedKeys[indexPath.section-1];
    NSArray *messages = self.sortedMessages[key];
    AVIMTypedMessage *message = messages[indexPath.row-1];
    UITableViewCell *cell = nil;
    
    User *currentUser = APP.currentUser;
    User *user = nil;
    BOOL isPeerMessage = message.ioType==AVIMMessageIOTypeIn;
    if ([message.clientId integerValue] == APP.currentUser.userId) {
        user = currentUser;
    } else {
#if TEACHERSIDE
        user = self.homeworkSession.student;
#else
        user = self.homeworkSession.correctTeacher;
#endif
    }
    
    if (message.mediaType == kAVIMMessageMediaTypeText) { // 文本信息
        NSDictionary *attributes = ((AVIMTextMessage *)(message)).attributes;
        NSString *identifier = nil;
        
        if (attributes[@"isEmoji"] != nil && [UIImage imageNamed:((AVIMTextMessage *)(message)).text]!=nil) {
            if (isPeerMessage) {
                identifier = LeftEmojiMessageTableViewCellId;
            } else {
                identifier = RightEmojiMessageTableViewCellId;
            }
            
            EmojiMessageTableViewCell *emojiCell = (EmojiMessageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
            if (emojiCell == nil) {
                NSString *nibName = isPeerMessage?@"LeftEmojiMessageTableViewCell":@"RightEmojiMessageTableViewCell";
                emojiCell = [[[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil] lastObject];
            }
            [emojiCell setupWithUser:user message:message];
            
            WeakifySelf;
            [emojiCell setResendCallback:^{
                [weakSelf sendMessage:message];
            }];
            
            cell = emojiCell;
        } else {
            if (isPeerMessage) {
                identifier = LeftTextMessageTableViewCellId;
            } else {
                identifier = RightTextMessageTableViewCellId;
            }
            
            TextMessageTableViewCell *textCell = (TextMessageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
            if (textCell == nil) {
                NSString *nibName = isPeerMessage?@"LeftTextMessageTableViewCell":@"RightTextMessageTableViewCell";
                textCell = [[[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil] lastObject];
            }
            [textCell setupWithUser:user message:message];
            
            WeakifySelf;
            [textCell setResendCallback:^{
                [weakSelf sendMessage:message];
            }];
            
            cell = textCell;
        }
    } else if (message.mediaType == kAVIMMessageMediaTypeImage) { // 图片信息
        NSString *identifier = nil;
        if (isPeerMessage) {
            identifier = LeftImageMessageTableViewCellId;
        } else {
            identifier = RightImageMessageTableViewCellId;
        }
        
        ImageMessageTableViewCell *imageCell = (ImageMessageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (imageCell == nil) {
            NSString *nibName = isPeerMessage?@"LeftImageMessageTableViewCell":@"RightImageMessageTableViewCell";
            imageCell = [[[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil] lastObject];
        }
        [imageCell setupWithUser:user message:message];
        
        WeakifySelf;
        [imageCell setResendCallback:^{
            [weakSelf sendMessage:message];
        }];
        
        __weak ImageMessageTableViewCell *weakCell = imageCell;
        [imageCell setImagePreviewCallback:^{
            UIImage *image = weakCell.messageImageView.image;
            if (image == nil) {
                return;
            }
            NSMutableArray * imageurls = [[NSMutableArray alloc] init];
            
            for (int i = 0; i < self.messages.count; i++)
            {
                AVIMTypedMessage * tmpMessage = self.messages[i];
                if (tmpMessage.mediaType == kAVIMMessageMediaTypeImage)
                {
                    [imageurls addObject:tmpMessage.file.url];
                }
                
            }
            
            
            WBGImageEditorViewController *editVC = [[WBGImageEditorViewController alloc] init];
            [editVC setOriginalImageUrls:imageurls];
            editVC.selectIndex = [imageurls indexOfObject:message.file.url];
//            [editVC setThumbnailImage:image];
            [editVC setSendCallback:^(UIImage *image) {
                if (weakSelf.homeworkSession.score > 0) {
                    [HUD showErrorWithMessage:@"作业已完成，不能发送"];
                } else {
                    [weakSelf sendImageMessageWithImage:image];
                }
            }];
            [weakSelf.navigationController presentViewController:editVC animated:YES completion:nil];
        }];
        
        cell = imageCell;
    } else if (message.mediaType == kAVIMMessageMediaTypeVideo) { // 文本信息
        NSString *identifier = nil;
        if (isPeerMessage) {
            identifier = LeftVideoMessageTableViewCellId;
        } else {
            identifier = RightVideoMessageTableViewCellId;
        }
        
        VideoMessageTableViewCell *videoCell = (VideoMessageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (videoCell == nil) {
            NSString *nibName = isPeerMessage?@"LeftVideoMessageTableViewCell":@"RightVideoMessageTableViewCell";
            videoCell = [[[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil] lastObject];
        }
        [videoCell setupWithUser:user message:message];
        
        WeakifySelf;
        [videoCell setVideoPlayCallback:^{
            [weakSelf playerVideoWithURL:message.file.url];
        }];
        
        [videoCell setResendCallback:^{
            [weakSelf sendMessage:message];
        }];
        
        cell = videoCell;
    } else if (message.mediaType == kAVIMMessageMediaTypeAudio) { // 文本信息
        NSString *identifier = nil;
        if (isPeerMessage) {
            identifier = LeftAudioMessageTableViewCellId;
        } else {
            identifier = RightAudioMessageTableViewCellId;
        }
        
        AudioMessageTableViewCell *audioCell = (AudioMessageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (audioCell == nil) {
            NSString *nibName = isPeerMessage?@"LeftAudioMessageTableViewCell":@"RightAudioMessageTableViewCell";
            audioCell = [[[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil] lastObject];
        }
        [audioCell setupWithUser:user message:message];
        
        WeakifySelf;
        [audioCell setResendCallback:^{
            [weakSelf sendMessage:message];
        }];
        
        cell = audioCell;
    }
    else
    {
        cell = [[UITableView alloc] init];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [SessionHomeworkTableViewCell heightWithHomeworkSession:self.homeworkSession];
    }
    
    if (indexPath.row == 0) {
        return MessageTimeTableViewCellHeight;
    }
    
    NSString *key = self.sortedKeys[indexPath.section-1];
    NSArray *messages = self.sortedMessages[key];
    
    AVIMMessage *message = messages[indexPath.row-1];
    if (message.mediaType == kAVIMMessageMediaTypeText) { // 文本信息或者emoji
        NSDictionary *attributes = ((AVIMTextMessage *)(message)).attributes;
        if (attributes[@"isEmoji"] != nil && [UIImage imageNamed:((AVIMTextMessage *)(message)).text]!=nil) {
            return EmojiMessageTableViewCellHeight;
        }
        
        return [TextMessageTableViewCell heightOfMessage:(AVIMTypedMessage *)message];
    } else if (message.mediaType == kAVIMMessageMediaTypeImage) {
        return ImageMessageTableViewCellHeight;
    } else if (message.mediaType == kAVIMMessageMediaTypeVideo) {
        return VideoMessageTableViewCellHeight;
    } else if (message.mediaType == kAVIMMessageMediaTypeAudio) {
        return AudioMessageTableViewCellHeight;
    }
    
    return 0.f;
}

#pragma mark - EmojiInputViewDelegate

- (void)emojiDidSelect:(NSString *)emojiText {
    
    NSString * text = [self.inputTextView.text stringByAppendingString:emojiText];
    
    self.inputTextView.text = text;
   // [self sendEmojiMessage:emojiText];
}

- (void)emojiDidSend
{
    [self sendTextMessage:self.inputTextView.text];
}

#pragma mark - NEPhotoBrowserDataSource

- (NSInteger)numberOfPhotosInPhotoBrowser:(NEPhotoBrowser *)browser {
    return self.homeworkImages.count;
}
- (NSURL* __nonnull)photoBrowser:(NEPhotoBrowser * __nonnull)browser imageURLForIndex:(NSInteger)index {
    return [NSURL URLWithString:[self.homeworkImages objectAtIndex:index]];
}

- (UIImage * __nullable)photoBrowser:(NEPhotoBrowser * __nonnull)browser placeholderImageForIndex:(NSInteger)index {
    return [self.currentImageViews objectAtIndex:index].image;
}

#pragma mark - NEPhotoBrowserDelegate

- (void)photoBrowser:(NEPhotoBrowser * __nonnull)browser willSavePhotoWithView:(NEPhotoBrowserView *)view {
    [HUD showProgressWithMessage:@"正在保存图片"];
}

- (void)photoBrowser:(NEPhotoBrowser * __nonnull)browser didSavePhotoSuccessWithImage:(UIImage *)image {
    [HUD showWithMessage:@"保存图片成功"];
}

- (void)photoBrowser:(NEPhotoBrowser * __nonnull)browser savePhotoErrorWithError:(NSError *)error {
    [HUD showErrorWithMessage:@"保存图片失败"];
}

@end


