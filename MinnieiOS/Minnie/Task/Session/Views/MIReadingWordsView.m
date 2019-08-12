//
//  MIReadingWordsView.m
//  Minnie
//
//  Created by songzhen on 2019/6/10.
//  Copyright © 2019 minnieedu. All rights reserved.
//
#import "MIReadingWordsView.h"
#import <AVFoundation/AVFoundation.h>

@interface WordSlider : UISlider

@end

@implementation WordSlider


- (CGRect)trackRectForBounds:(CGRect)bounds{
    
    CGRect newBounds = bounds;
    newBounds.origin.y = 5;
    newBounds.size.height = 15;
    return newBounds;
}

@end


@interface MIReadingWordsView (){
    
    
    BOOL _isSliding;
}

@property (weak, nonatomic) IBOutlet UIView *wordsView;
@property (weak, nonatomic) IBOutlet UILabel *englishLabel;

@property (strong,nonatomic) NSTimer *wordsTimer;

@property (assign,nonatomic) NSInteger currentWordIndex;
@property (weak, nonatomic) IBOutlet UIView *bgProgressView;

@property (strong, nonatomic) WordSlider *sliderView;

@property (strong,nonatomic) NSMutableArray *progressViews;


@end


@implementation MIReadingWordsView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.progressViews = [NSMutableArray array];
    
    self.sliderView = [[WordSlider alloc] init];
    [self.bgProgressView addSubview:self.sliderView];
    self.sliderView.value = 0.0;
    self.sliderView.layer.cornerRadius = 0.0;
    self.sliderView.layer.masksToBounds = YES;
    
    [self.sliderView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.equalTo(self.bgProgressView);
    }];
    
    [self.sliderView setMinimumTrackTintColor:[UIColor mainColor]];
    [self.sliderView setMaximumTrackTintColor:[UIColor unSelectedColor]];
    
    [self.sliderView addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.sliderView addTarget:self action:@selector(sliderValueFinished:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.sliderView setThumbImage:[UIImage imageNamed:@"thum"] forState:UIControlStateNormal];
    [self.sliderView setThumbImage:[UIImage imageNamed:@"thum"] forState:UIControlStateHighlighted];
    
    WordInfo *tempWord = _wordsItem.words.firstObject;
    self.englishLabel.text = tempWord.english;
}

- (void)setWordsItem:(HomeworkItem *)wordsItem{
    
    _wordsItem = wordsItem;
    WordInfo *tempWord = _wordsItem.words.firstObject;
    self.englishLabel.text = tempWord.english;
}

- (void)sliderValueChanged:(id)sender {
    
    _isSliding = YES;
    NSLog(@"sliderValueChanged  %lu,%f",_currentWordIndex,self.sliderView.value);
}

- (void)sliderValueFinished:(id)sender {
   
    NSInteger tempIndex = roundf(self.sliderView.value * self.wordsItem.words.count) - 1;
    _currentWordIndex = tempIndex;
    
    if (self.readingWordsSeekCallBack) {
        self.readingWordsSeekCallBack(self.sliderView.value);
    }
    [self startPlayWords];
    
    _isSliding = NO;
    [self playWords];
    
}

- (void)startPlayWords{
  
    if (_currentWordIndex >= self.wordsItem.words.count) {
        _currentWordIndex = 0;
        WordInfo *tempWord = _wordsItem.words.firstObject;
        self.englishLabel.text = tempWord.english;
        self.sliderView.value = 0.0;
    }
    [self stopPlayWords];
    [self.wordsTimer fireDate];
}

- (void)stopPlayWords{
    
    [self.wordsTimer invalidate];
    self.wordsTimer = nil;
}

-(NSTimer *)wordsTimer{
    
    if (!_wordsTimer) {
        NSInteger playTime = self.wordsItem.playtime/1000;
        if (playTime == 0) {
            playTime = 2.0;
        }
        _wordsTimer = [NSTimer scheduledTimerWithTimeInterval:playTime target:self selector:@selector(playWords) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_wordsTimer forMode:NSDefaultRunLoopMode];
    }
    return _wordsTimer;
}


- (void)invalidateTimer{
    _currentWordIndex = 0;
    [self.wordsTimer invalidate];
    self.wordsTimer = nil;
}

- (void)playWords{
    
    if (_isSliding) {
        
        return;
    }
    if (_currentWordIndex < self.wordsItem.words.count) {
        
        WordInfo *tempWord = self.wordsItem.words[_currentWordIndex];
        self.englishLabel.text = tempWord.english;
    }
    
    self.sliderView.value = (CGFloat)_currentWordIndex/self.wordsItem.words.count;
    NSLog(@"playWords  %lu,%f %@",_currentWordIndex,self.sliderView.value,self.englishLabel.text);
    
    _currentWordIndex ++;
    
    if (_currentWordIndex > self.wordsItem.words.count) {
        
        if (self.readingWordsCallBack) {
            self.readingWordsCallBack();
        }
        [self stopPlayWords];
    }
}

@end
