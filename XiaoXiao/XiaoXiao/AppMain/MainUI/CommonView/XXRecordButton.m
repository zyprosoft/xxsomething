//
//  XXRecordButton.m
//  XiaoXiao
//
//  Created by ZYVincent on 14-1-19.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "XXRecordButton.h"

@implementation XXRecordButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _backgroundImageView = [[UIImageView alloc]init];
        _backgroundImageView.frame = CGRectMake(0,0,frame.size.width,frame.size.height);
        [self addSubview:_backgroundImageView];
        
        _playStateImageView = [[UIImageView alloc]init];
        _playStateImageView.frame = CGRectMake((frame.size.width-12)/2,(frame.size.height-12)/2,12,12);
        _playStateImageView.image = [UIImage imageNamed:@"audio_play_stop.png"];
        [self addSubview:_playStateImageView];
        
        _indicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _indicatorView.frame = CGRectMake((frame.size.width-12)/2,(frame.size.height-12)/2,12,12);
        [self addSubview:_indicatorView];
        _indicatorView.hidden = YES;
        
        _recordTimeLabel = [[UILabel alloc]init];
        _recordTimeLabel.frame = CGRectMake(frame.size.width - 30,(frame.size.height-15)/2,30,15);
        _recordTimeLabel.textColor = [XXCommonStyle xxThemeButtonGrayTitleColor];
        _recordTimeLabel.backgroundColor = [UIColor clearColor];
        _recordTimeLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:_recordTimeLabel];
        
        
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)mainThreadUIUpdatePlay
{
    self.selected = YES;
    _indicatorView.hidden = YES;
    [_indicatorView stopAnimating];
    _playStateImageView.hidden = NO;

    _playStateImageView.image = [UIImage animatedImageWithAnimatedGIFData:[XXFileUitil loadDataFromBundleForName:@"audio_playing.gif"]];
}
- (void)mainThreadUIUpdateEnd
{
    self.selected = NO;
    _indicatorView.hidden = YES;
    [_indicatorView stopAnimating];
    _playStateImageView.hidden = NO;
    
    _playStateImageView.image = [UIImage imageNamed:@"audio_play_stop.png"];
}
- (void)mainThreadStartLoading
{
    _playStateImageView.hidden = YES;
    _indicatorView.hidden = NO;
    [_indicatorView startAnimating];

}
- (void)mainThreadStopLoading
{
    _indicatorView.hidden = YES;
    [_indicatorView stopAnimating];
    _playStateImageView.hidden = NO;

}

- (void)startPlay
{
    [self performSelectorOnMainThread:@selector(mainThreadUIUpdatePlay) withObject:nil waitUntilDone:NO];
}
- (void)endPlay
{
    [self performSelectorOnMainThread:@selector(mainThreadUIUpdateEnd) withObject:nil waitUntilDone:NO];
}
- (void)startLoading
{
    [self performSelectorOnMainThread:@selector(mainThreadStartLoading) withObject:nil waitUntilDone:NO];

}
- (void)endLoading
{
    [self performSelectorOnMainThread:@selector(mainThreadStopLoading) withObject:nil waitUntilDone:NO];

}

@end
