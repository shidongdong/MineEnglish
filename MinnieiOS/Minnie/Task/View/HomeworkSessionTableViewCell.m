//
//  HomeworkSessionTableViewCell.m
//  X5
//
//  Created by yebw on 2017/8/30.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "HomeworkSessionTableViewCell.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import <Masonry/Masonry.h>
#import "IMManager.h"

NSString * const UnfinishedHomeworkSessionTableViewCellId = @"UnfinishedHomeworkSessionTableViewCellId";
NSString * const FinishedHomeworkSessionTableViewCellId = @"FinishedHomeworkSessionTableViewCellId";

@interface HomeworkSessionTableViewCell()

@property (nonatomic, weak) IBOutlet UIView *containerView;

@property (nonatomic, weak) IBOutlet UIImageView *avatarImageView;
@property (nonatomic, weak) IBOutlet UIImageView *unreadIconImageView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;

@property (nonatomic, weak) IBOutlet UILabel *homeworkTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *lastSessionLabel;

@property (nonatomic, weak) IBOutlet UILabel *timeLabel;

@property (nonatomic, weak) IBOutlet UIView *scoreView;

@end

@implementation HomeworkSessionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.containerView.layer.cornerRadius = 12.f;
    self.containerView.layer.shadowOpacity = 0.4;// 阴影透明度
    self.containerView.layer.shadowColor = [UIColor colorWithHex:0xEEEEEE].CGColor;
    self.containerView.layer.shadowRadius = 3;
    self.containerView.layer.shadowOffset = CGSizeMake(2, 4);
    
    self.avatarImageView.layer.cornerRadius = 22.f;
    self.avatarImageView.layer.masksToBounds = YES;
    
    self.unreadIconImageView.layer.cornerRadius = 5.f;
    self.unreadIconImageView.layer.masksToBounds = YES;
    
    self.homeworkTitleLabel.preferredMaxLayoutWidth = ScreenWidth - 4 * 12.f - 56.f;
    self.lastSessionLabel.preferredMaxLayoutWidth = ScreenWidth - 4 * 12.f - 56.f;
}

- (void)setupWithHomeworkSession:(HomeworkSession *)homeworkSession {
#if TEACHERSIDE
    self.nameLabel.text = homeworkSession.student.nickname;
    [self.avatarImageView sd_setImageWithURL:[homeworkSession.student.avatarUrl imageURLWithWidth:44.f]];
#else
    self.nameLabel.text = homeworkSession.correctTeacher.nickname;
    [self.avatarImageView sd_setImageWithURL:[homeworkSession.correctTeacher.avatarUrl imageURLWithWidth:44.f]];
#endif

    HomeworkItem *item = homeworkSession.homework.items[0];
    self.homeworkTitleLabel.text = item.text?:@"[无文字内容]";
    
    self.lastSessionLabel.text = homeworkSession.lastSessionContent;
    
#if TEACHERSIDE
    if (homeworkSession.shouldColorLastSessionContent) {
        self.lastSessionLabel.textColor = [UIColor colorWithHex:0x0098FE];
    } else {
        self.lastSessionLabel.textColor = [UIColor colorWithHex:0xFFA500];
    }
#else
    
    if (homeworkSession.shouldColorLastSessionContent) {
        self.lastSessionLabel.textColor = [UIColor redColor];
    } else {
        self.lastSessionLabel.textColor = [UIColor colorWithHex:0x999999];
    }
    
    
#endif
    if (homeworkSession.sortTime > 0)
    {
        self.timeLabel.text = [Utils formatedDateString:homeworkSession.sortTime];
    }
    else
    {
        self.timeLabel.text = [Utils formatedDateString:homeworkSession.sendTime];
    }
    
    self.unreadIconImageView.hidden = homeworkSession.unreadMessageCount==0;

    if (self.scoreView != nil) {
        for (UIView *v in self.scoreView.subviews) {
            [v removeFromSuperview];
        }
        
        NSString *desc = nil;
        NSUInteger starCount = 0;
        UIColor *color = nil;
        if (homeworkSession.score == 0) {
            starCount = 0;
            color = [UIColor lightGrayColor];
        } else if (homeworkSession.score == 1) {
            desc = @"Pass!";
            starCount = 1;
            color = [UIColor colorWithHex:0x28C4B7];
        } else if (homeworkSession.score == 2) {
            desc = @"Good job!";
            starCount = 2;
            color = [UIColor colorWithHex:0x00CE00];
        } else if (homeworkSession.score == 3) {
            desc = @"Very nice!";
            starCount = 3;
            color = [UIColor colorWithHex:0x0098FE];
        } else if (homeworkSession.score == 4) {
            desc = @"Great!";
            starCount = 4;
            color = [UIColor colorWithHex:0xFFC600];
        } else if (homeworkSession.score == 5) {
            desc = @"Perfect!";
            starCount = 5;
            color = [UIColor colorWithHex:0xFF4858];
        }
//        else if (homeworkSession.score == 6) {
//            desc = @"Very hard working!";
//            starCount = 5; // 没有写错，就是5颗
//            color = [UIColor colorWithHex:0xB248FF];
//        }
        
        self.scoreView.backgroundColor = color;
        
        CGFloat trailing = 0;
        for (NSInteger index=0; index<starCount; index++) {
            trailing = 8+index*12;
            
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_stars"]];
            [imageView setContentMode:UIViewContentModeScaleAspectFill];
            [self.scoreView addSubview:imageView];
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.trailing.equalTo(self.scoreView).with.offset(-trailing);
                make.centerY.equalTo(self.scoreView);
                make.size.mas_equalTo(CGSizeMake(12, 12));
            }];
        }
        
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentLeft;
        label.text = homeworkSession.reviewText;
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor whiteColor];
        
        [self.scoreView addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.scoreView).with.offset(10);
            make.trailing.equalTo(self.scoreView).with.offset(-trailing-12-8);
            make.centerY.equalTo(self.scoreView);
        }];
    }
}

+ (CGFloat)cellHeightWithHomeworkSession:(HomeworkSession *)homeworkSession finished:(BOOL)finished {
    if (homeworkSession.cellHeightWithMessage>0 && homeworkSession.lastSessionContent.length>0) {
        return homeworkSession.cellHeightWithMessage;
    }
    
    if (homeworkSession.cellHeightWithoutMessage>0 && homeworkSession.lastSessionContent.length==0) {
        return homeworkSession.cellHeightWithoutMessage;
    }
    
    CGFloat height = 0.f;
    
    if (!finished) {
        static HomeworkSessionTableViewCell *unfinishedCell = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            unfinishedCell = [[[NSBundle mainBundle] loadNibNamed:@"UnfinishedHomeworkSessionTableViewCell"
                                                            owner:nil
                                                          options:nil] lastObject];
            
            
        });
        
        
        HomeworkItem *item = homeworkSession.homework.items[0];
        
        unfinishedCell.homeworkTitleLabel.text = item.text?:@"[无文字内容]";
        unfinishedCell.lastSessionLabel.text = homeworkSession.lastSessionContent;
        
        CGSize size = [unfinishedCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        height = size.height;
        
//        if (homeworkSession.lastSessionContent.length == 0) {
//            height -= 8.f;
//        }
    } else {
        static HomeworkSessionTableViewCell *finishedCell = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            finishedCell = [[[NSBundle mainBundle] loadNibNamed:@"FinishedHomeworkSessionTableViewCell"
                                                          owner:nil
                                                        options:nil] lastObject];
            
            
        });
        
        HomeworkItem *item = homeworkSession.homework.items[0];
        
        finishedCell.homeworkTitleLabel.text = item.text?:@"[无文字内容]";
        finishedCell.lastSessionLabel.text = homeworkSession.lastSessionContent;
        
        CGSize size = [finishedCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        height = size.height;
    }
    
    if (homeworkSession.lastSessionContent.length > 0) {
        homeworkSession.cellHeightWithMessage = height;
    } else {
        homeworkSession.cellHeightWithoutMessage = height;
    }
    
    return height;
}

@end

