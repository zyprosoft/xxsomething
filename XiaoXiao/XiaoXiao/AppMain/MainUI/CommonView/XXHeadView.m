//
//  XXHeadView.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "XXHeadView.h"

@implementation XXHeadView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.contentImageView = [[AGMedallionView alloc] initWithFrame:CGRectMake(0,0,frame.size.width,frame.size.height)];
        self.contentImageView.borderColor = [UIColor whiteColor];
        self.contentImageView.borderWidth = 2.0f;
        [self addSubview:self.contentImageView];
        
        self.roundImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,frame.size.width,frame.size.height)];
        [self addSubview:self.roundImageView];
        self.roundImageView.layer.cornerRadius = 12;
        self.roundImageView.layer.masksToBounds = YES;
        self.roundImageView.hidden = YES;
        
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
- (void)setHeadWithUserId:(NSString*)userId;
{
    self.roundImageView.hidden = YES;
    self.contentImageView.hidden = NO;
    
    if (!userId) {
        return;
    }
    _userId = userId;

    NSString *imageSizeNeedUrl = [NSString stringWithFormat:@"%@%@/%d/%d/%@",XXBase_Host_Url,XX_Head_Url_Base_Url,(int)self.frame.size.width*2,(int)self.frame.size.height*2,userId];
    NSURL *combineUrl = [NSURL URLWithString:imageSizeNeedUrl];
    
    WeakObj(self.contentImageView) weakContentImageView = self.contentImageView;
    [self.roundImageView setImageWithURL:combineUrl completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        weakContentImageView.image = image;
    }];
}
- (void)setRoundHeadWithUserId:(NSString *)userId
{
    self.contentImageView.hidden = YES;
    self.roundImageView.hidden = NO;
    
    if (!userId) {
        return;
    }
    _userId = userId;
    
    NSString *imageSizeNeedUrl = [NSString stringWithFormat:@"%@%@/%d/%d/%@",XXBase_Host_Url,XX_Head_Url_Base_Url,(int)self.frame.size.width*2,(int)self.frame.size.height*2,userId];
    NSURL *combineUrl = [NSURL URLWithString:imageSizeNeedUrl];
    [self.roundImageView setImageWithURL:combineUrl];
    
}
@end
