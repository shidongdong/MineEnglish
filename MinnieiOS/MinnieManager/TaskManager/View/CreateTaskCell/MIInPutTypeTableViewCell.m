//
//  MIInPutTypeTableViewCell.m
//  MinnieManager
//
//  Created by songzhen on 2019/5/29.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import "UIColor+HEX.h"
#import "MIInPutTypeTableViewCell.h"

NSString * const MIInPutTypeTableViewCellId = @"MIInPutTypeTableViewCellId";

@interface MIInPutTypeTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleName;

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UITextView *homeworkTextView;
@property (weak, nonatomic) IBOutlet UILabel *placeholder;

@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, assign) MIHomeworkCreateContentType createType;
@end

@implementation MIInPutTypeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.homeworkTextView.showsVerticalScrollIndicator = NO;
    self.bgImageView.layer.borderWidth = 0.5f;
    self.bgImageView.layer.borderColor = [UIColor colorWithHex:0x0098FE].CGColor;
    self.bgImageView.layer.cornerRadius = 6.f;
    self.bgImageView.layer.masksToBounds = YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    
    if ([self.homeworkTextView.text isEqualToString:@""]){
        self.placeholder.hidden = NO;
    }else{
        self.placeholder.hidden = YES;
    }
    // 批改备注 长度限制28
    if (self.createType == MIHomeworkCreateContentType_MarkingRemarks) {
        NSString *text = textView.text;
        if (text.length > 28) {
            self.homeworkTextView.text = [text substringToIndex:28];
        }
    }
    UITextRange *selectedRange = [textView markedTextRange];
    UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
    if (position) {
        return;
    }
    
    CGFloat screenWidth = ([UIScreen mainScreen].bounds.size.width  - 148 * 2)/2.0;
    CGSize size = [textView sizeThatFits:CGSizeMake(screenWidth - 36.f, MAXFLOAT)];
    CGFloat cellHeight = size.height + 51.f;
    
    if (self.cellHeight != cellHeight) {
        self.cellHeight = cellHeight;
        
        if (self.callback != nil) {
            self.callback(textView.text, YES);
        }
    } else {
        if (self.callback != nil) {
            self.callback(textView.text, NO);
        }
    }
}

- (void)setupWithText:(NSString *)text
                title:(NSString *)title
           createType:(MIHomeworkCreateContentType)createType
          placeholder:(NSString *)holder{
    self.createType = createType;
    self.homeworkTextView.text = text;
    self.titleName.text = title;
    self.placeholder.text = holder;
    if ([self.homeworkTextView.text isEqualToString:@""]){
        self.placeholder.hidden = NO;
    }else{
        self.placeholder.hidden = YES;
    }
}

- (void)ajustTextView {
    
    [self.homeworkTextView scrollRangeToVisible:NSMakeRange(0, 1)];
}


+ (CGFloat)cellHeightWithText:(NSString *)text cellWidth:(CGFloat)cellWidth{
   
    static UITextView *textView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        textView = [[UITextView alloc] init];
        textView.font = [UIFont systemFontOfSize:14.f];
    });
    
    textView.text = text;
    CGFloat screenWidth = cellWidth;
    CGSize size = [textView sizeThatFits:CGSizeMake(screenWidth-36.f, MAXFLOAT)];
    
    return size.height + 50.f;;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.homeworkTextView resignFirstResponder];
}
@end
