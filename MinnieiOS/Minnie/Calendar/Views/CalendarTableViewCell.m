//
//  CalendarTableViewCell.m
//  X5
//
//  Created by yebw on 2017/9/17.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "CalendarTableViewCell.h"
#import "DateButton.h"
#import "UIColor+HEX.h"

@implementation DayItem
@end

@implementation MonthItem
@end

NSString * const CalendarTableViewCellId = @"CalendarTableViewCellId";

@interface CalendarTableViewCell()

@property (nonatomic, strong) MonthItem *monthItem;

@property (nonatomic, weak) IBOutlet UIView *containerView;
@property (nonatomic, weak) IBOutlet UILabel *monthLabel;
@property (nonatomic, weak) IBOutletCollection(DateButton) NSArray *dateButtons;

@end

@implementation CalendarTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.containerView.layer.cornerRadius = 12.f;
    self.containerView.layer.masksToBounds = YES;
}

- (void)updateWithMonthItem:(MonthItem *)monthItem editMode:(BOOL)isEditMode {
    self.monthItem = monthItem;
    
    NSString *monthString = [NSString stringWithFormat:@"%zd %zd月", monthItem.year, monthItem.month];
    self.monthLabel.text = monthString;
    
    NSInteger index = 0;
    for (DayItem *item in monthItem.dayItems) {
        NSInteger tag = index + 10;
        
        DateButton *button = (DateButton *)[self viewWithTag:tag];
        [button setTitle:[NSString stringWithFormat:@"%zd", item.day] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(dateButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        if (item.isOtherMonth) {
            [button setEnabled:NO];
            
            [button setCircleBGColor:nil];
            [button setTitleColor:[UIColor colorWithHex:0xCCCCCC] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithHex:0xCCCCCC] forState:UIControlStateDisabled];
            [button setTitleColor:[UIColor colorWithHex:0xCCCCCC] forState:UIControlStateHighlighted];
        } else {
            [button setEnabled:YES];
            [button setToday:item.isToday];
            
            if (item.isClassDay) {
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
                
                [button setCircleBGColor:[UIColor colorWithHex:0x00CE00]];
            } else {
                [button setTitleColor:[UIColor colorWithHex:0x333333] forState:UIControlStateNormal];
                [button setTitleColor:[UIColor colorWithHex:0x333333] forState:UIControlStateHighlighted];
                
                [button setCircleBGColor:nil];
            }
        }
        
        if (!isEditMode) {
            [button setEnabled:NO];
        }
        
        index++;
    }
}

- (void)dateButtonPressed:(id)sender {
    DateButton *button = (DateButton *)sender;
    NSInteger index = button.tag - 10;
    
    if (index >= self.monthItem.dayItems.count) {
        return;
    }
    
    DayItem *item = self.monthItem.dayItems[index];
    item.isClassDay = !item.isClassDay;
    
    [button setToday:item.isToday];
    
    if (item.isClassDay) {
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        
        [button setCircleBGColor:[UIColor colorWithHex:0x00CE00]];
    } else {
        [button setTitleColor:[UIColor colorWithHex:0x333333] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHex:0x333333] forState:UIControlStateHighlighted];
        
        [button setCircleBGColor:nil];
    }
    
    if (self.callback != nil) {
        self.callback(index);
    }
}

@end

