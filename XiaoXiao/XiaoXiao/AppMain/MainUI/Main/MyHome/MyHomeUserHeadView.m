//
//  MyHomeUserHeadView.m
//  XiaoXiao
//
//  Created by ZYVincent on 14-1-14.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "MyHomeUserHeadView.h"

@implementation MyHomeUserHeadView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _themeBackgroundView = [[XXImageView alloc]initWithFrame:CGRectMake(0,0,frame.size.width,223)];
        _themeBackgroundView.userInteractionEnabled = YES;
        [self addSubview:_themeBackgroundView];
        UITapGestureRecognizer *themeTapR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapOnThemeBack:)];
        _themeBackgroundView.backgroundColor = [XXCommonStyle xxThemeHomeBackColor];
        [_themeBackgroundView addGestureRecognizer:themeTapR];
        
        //
        _infoBackgroundView = [[UIImageView alloc]init];
        _infoBackgroundView.frame = CGRectMake(0,223,frame.size.width,83);
        _infoBackgroundView.backgroundColor = [UIColor whiteColor];
        _infoBackgroundView.userInteractionEnabled = YES;
        [self addSubview:_infoBackgroundView];
        
        //
        _headView = [[XXHeadView alloc]initWithFrame:CGRectMake(15,223-58.5,117,117)];
        _headView.contentImageView.borderColor = [UIColor whiteColor];
        _headView.contentImageView.borderWidth = 3.0f;
        [self addSubview:_headView];
        //tap gesture
        UITapGestureRecognizer *headTapR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOnEditHeadViewAction)];
        [_headView addGestureRecognizer:headTapR];
        
        DDLogVerbose(@"_headView target:%@",_headView);
        
        //
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.frame = CGRectMake(137,5,180,35);
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.font = [UIFont systemFontOfSize:20];
        [_infoBackgroundView addSubview:_nameLabel];
        
        //
        _signuareView = [[UILabel alloc]initWithFrame:CGRectMake(137,frame.size.height*3/4+25,180,35)];
        _signuareView.backgroundColor = [UIColor clearColor];
        _signuareView.font = [UIFont systemFontOfSize:12.5];
        _signuareView.userInteractionEnabled = YES;
        _signuareView.textColor = rgb(199,199,204,1);
        _signuareView.numberOfLines = 0;
        [self addSubview:_signuareView];
        
        //
        _wellknowView = [[XXOpacityView alloc]initWithFrame:CGRectMake(-6,14,80,52)];
        _wellknowView.contentLabel.textColor = [UIColor whiteColor];
        _wellknowView.contentLabel.font = [UIFont boldSystemFontOfSize:20];
        _wellknowView.contentLabel.frame = CGRectMake(8,0,68,35);
        _wellknowView.detailLabel.frame = CGRectMake(8,30,68,17);
        _wellknowView.detailLabel.backgroundColor = [UIColor clearColor];
        _wellknowView.detailLabel.textColor = [UIColor whiteColor];
        _wellknowView.detailLabel.font = [UIFont boldSystemFontOfSize:12];
        _wellknowView.detailLabel.text = @"校内知名度";
        _wellknowView.contentLabel.textAlignment = NSTextAlignmentCenter;
        _wellknowView.detailLabel.textAlignment = NSTextAlignmentCenter;
        _wellknowView.contentLabel.shadowColor = [UIColor blackColor];
        _wellknowView.detailLabel.shadowColor = [UIColor blackColor];
        _wellknowView.contentLabel.shadowOffset = CGSizeMake(0.2,0.2);
        _wellknowView.detailLabel.shadowOffset = CGSizeMake(0.1,0.1);
        _wellknowView.userInteractionEnabled = NO;
        [self addSubview:_wellknowView];
        
        //settingView
        _settingView = [[XXOpacityView alloc]initWithFrame:CGRectMake(251,152,54,54)];
        _settingView.iconImageView.frame = CGRectMake(15.25,15.5,23.5,23);
        _settingView.iconImageView.image = [UIImage imageNamed:@"setting.png"];
        [self addSubview:_settingView];
        
        
        //remind set theme image
        NSString *title = @"设置个性壁纸";
        CGSize titleSize = [title sizeWithFont:[UIFont boldSystemFontOfSize:15] constrainedToSize:CGSizeMake(999,30)];
        CGFloat originX = (self.frame.size.width - titleSize.width)/2;
        CGFloat originY = (_themeBackgroundView.frame.size.height-30)/2;
        _remindSetThemeImageView = [[XXOpacityView alloc]initWithFrame:CGRectMake(originX,originY,titleSize.width+8,30)];
        _remindSetThemeImageView.contentLabel.textColor = [UIColor whiteColor];
        _remindSetThemeImageView.contentLabel.text = title;
        _remindSetThemeImageView.contentLabel.textAlignment = NSTextAlignmentCenter;
        _remindSetThemeImageView.contentLabel.font = [UIFont boldSystemFontOfSize:15];
        [_remindSetThemeImageView addTarget:self action:@selector(didTapOnThemeBack:) forControlEvents:UIControlEventTouchUpInside];
        [_themeBackgroundView addSubview:_remindSetThemeImageView];
        _remindSetThemeImageView.hidden = YES;
        
        [self setContentUser:[XXUserDataCenter currentLoginUser]];
        //observe noti
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(observeUpdateUserProfile:) name:XXUserHasUpdateProfileNoti object:nil];
        
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
- (void)setContentUser:(XXUserModel *)aUser
{
    [_headView setHeadWithUserId:aUser.userId];
    _nameLabel.text = aUser.nickName;
    NSString *signature = (aUser.signature==nil||[aUser.signature isEqualToString:@""])? @"编辑个性签名":aUser.signature;
    _signuareView.text = signature;
    
    NSString *combineString = (aUser.wellknow==nil||[aUser.wellknow isEqualToString:@""])? @"0％":aUser.wellknow;
    _wellknowView.contentLabel.text = combineString;
    
    DDLogVerbose(@"aUser for content:%@",aUser.bgImage);
    [_themeBackgroundView setImageUrl:aUser.bgImage];
    
    //need remind
    if ((aUser.bgImage==nil||[aUser.bgImage isEqualToString:@""])&&_remindSetThemeImageView) {
        _remindSetThemeImageView.hidden = NO;
    }
    
}
- (void)setDidTapThemeBackBlock:(MyHomeUserHeadViewDidTapThemeBackBlock)tapBlock
{
    _tapBackBlock = [tapBlock copy];
}

- (void)didTapOnThemeBack:(UITapGestureRecognizer*)tapR
{
    if (_tapBackBlock) {
        _tapBackBlock();
    }
}

- (void)updateThemeBack:(NSString *)newBackUrl
{
    [_themeBackgroundView setImageUrl:newBackUrl];
    [_remindSetThemeImageView removeFromSuperview];
}
- (void)updateThemeImage:(UIImage *)newImage
{
    UIImage *resizeImage = [newImage resizedImage:CGSizeMake(_themeBackgroundView.frame.size.width,_themeBackgroundView.frame.size.height) interpolationQuality:kCGInterpolationDefault];
    [_themeBackgroundView setContentImage:resizeImage];
}
- (void)tapOnSettingAddTarget:(id)target withSelector:(SEL)selector
{
    [_settingView addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
}
- (void)tapOnEditProfileAddTarget:(id)target withSelector:(SEL)selector
{
    UITapGestureRecognizer *tapR = [[UITapGestureRecognizer alloc]initWithTarget:target action:selector];
    [_signuareView addGestureRecognizer:tapR];
}
- (void)tapOnEditHeadViewAction
{
    DDLogVerbose(@"tap on headview responsed!!!+++___++++");
    if ([self.delegate respondsToSelector:@selector(homeUserHeadViewDidTapOnHeadAction:)]) {
        [self.delegate homeUserHeadViewDidTapOnHeadAction:self];
    }
}
- (void)observeUpdateUserProfile:(NSNotification*)noti
{
    _signuareView.text = [XXUserDataCenter currentLoginUser].signature;
    _nameLabel.text = [XXUserDataCenter currentLoginUser].nickName;
}

@end
