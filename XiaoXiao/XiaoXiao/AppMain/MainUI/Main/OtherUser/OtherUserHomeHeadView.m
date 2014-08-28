//
//  OtherUserHomeHeadView.m
//  XiaoXiao
//
//  Created by ZYVincent on 14-1-15.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "OtherUserHomeHeadView.h"

@implementation OtherUserHomeHeadView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _themeBackgroundView = [[XXImageView alloc]initWithFrame:CGRectMake(0,0,frame.size.width,223)];
        _themeBackgroundView.backgroundColor = [XXCommonStyle xxThemeHomeBackColor];
        [self addSubview:_themeBackgroundView];
        
        //
        _infoBackgroundView = [[UIImageView alloc]init];
        _infoBackgroundView.frame = CGRectMake(0,223,frame.size.width,223);
        _infoBackgroundView.userInteractionEnabled = YES;
        _infoBackgroundView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_infoBackgroundView];
        
        //
        _headView = [[XXHeadView alloc]initWithFrame:CGRectMake(96,_themeBackgroundView.frame.size.height-63.5,127,127)];
        _headView.contentImageView.borderColor = [UIColor whiteColor];
        _headView.contentImageView.borderWidth = 4.0f;
        [self addSubview:_headView];
        
        //
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.frame = CGRectMake(50,63.5+6,220,35);
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.font = [UIFont systemFontOfSize:20];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        [_infoBackgroundView addSubview:_nameLabel];
        
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
        
        
        //sex tag
        _sexImageView = [[UIImageView alloc]init];
        _sexImageView.frame = CGRectMake(62,223-22-46-20-22+4,12,12);
        [_infoBackgroundView addSubview:_sexImageView];
        
        //star label
        _starLabel = [[UILabel alloc]init];
        _starLabel.frame = CGRectMake(_sexImageView.frame.origin.x+_sexImageView.frame.size.width+7,223-22-46-20-22,45,20);
        _starLabel.font = [UIFont systemFontOfSize:12.5];
        [_infoBackgroundView addSubview:_starLabel];
        
        CGFloat originX = _starLabel.frame.origin.x + _starLabel.frame.size.width + 1;
        UIImageView  *locationView = [[UIImageView alloc]initWithFrame:CGRectMake(originX,_sexImageView.frame.origin.y,12,12)];
        locationView.image = [UIImage imageNamed:@"location_icon.png"];
        [_infoBackgroundView addSubview:locationView];
        
        UIColor *grayColor = rgb(125,130,136,1);
        originX = locationView.frame.origin.x+locationView.frame.size.width+1;
        _distanceLabel = [[UILabel alloc]init];
        _distanceLabel.frame = CGRectMake(originX,_starLabel.frame.origin.y,45,_starLabel.frame.size.height);
        _distanceLabel.backgroundColor = [UIColor clearColor];
        _distanceLabel.text = @"0.05km";
        _distanceLabel.textColor = grayColor;
        _distanceLabel.font = [UIFont systemFontOfSize:12.5];
        [_infoBackgroundView addSubview:_distanceLabel];
        
        originX = _distanceLabel.frame.origin.x + _distanceLabel.frame.size.width + 8;
        timeView = [[UIImageView alloc]init];
        timeView.frame = CGRectMake(originX,_sexImageView.frame.origin.y,13,13);
        timeView.image = [UIImage imageNamed:@"time_icon.png"];
        [_infoBackgroundView addSubview:timeView];
        
        originX = timeView.frame.origin.x+timeView.frame.size.width+1;
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.frame = CGRectMake(originX,_starLabel.frame.origin.y,50,_starLabel.frame.size.height);
        _timeLabel.text = @"8分钟前";
        _timeLabel.textColor = grayColor;
        _timeLabel.font = [UIFont systemFontOfSize:12.5];
        [_infoBackgroundView addSubview:_timeLabel];
        
        //tease button
        _teaseButton = [XXCustomButton buttonWithType:UIButtonTypeCustom];
        _teaseButton.frame = CGRectMake(62,223-22-46,196, 46);
        [_teaseButton teaseStyle];
        [_teaseButton setNormalIconImage:@"other_add_care_icon.png" withSelectedImage:@"other_add_care_icon.png" withFrame:CGRectMake(63,14,22.5,18)];
        _teaseButton.titleEdgeInsets = UIEdgeInsetsMake(0,30,0,0);
        [_teaseButton setTitle:@"关心" withFrame:CGRectMake(55,5,100,30)];
        _teaseButton.titleLabel.font = [UIFont boldSystemFontOfSize:17.5];
        _teaseButton.layer.cornerRadius = 23.f;
        [_infoBackgroundView addSubview:_teaseButton];
        
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

- (void)updateUserCared:(BOOL)isCared
{
    if (isCared) {
        [_teaseButton setNormalIconImage:@"other_cancel_care_icon.png" withSelectedImage:@"other_cancel_care_icon.png" withFrame:CGRectMake(55,14,22.5,18)];
        _teaseButton.titleEdgeInsets = UIEdgeInsetsMake(0,47,0,0);
        [_teaseButton setTitle:@"取消关心" withFrame:CGRectMake(55,5,100,30)];
    }else{
        [_teaseButton setNormalIconImage:@"other_add_care_icon.png" withSelectedImage:@"other_add_care_icon.png" withFrame:CGRectMake(63,14,22.5,18)];
        _teaseButton.titleEdgeInsets = UIEdgeInsetsMake(0,30,0,0);
        [_teaseButton setTitle:@"关心" withFrame:CGRectMake(55,5,100,30)];
    }
}


- (void)setContentUser:(XXUserModel *)aUser
{
    [_headView setHeadWithUserId:aUser.userId];
    _nameLabel.text = aUser.nickName;
    NSString *starDefatult = (aUser.constellation==Nil||[aUser.constellation isEqualToString:@""])? @"天枰座":aUser.constellation;
    _starLabel.text = starDefatult;
    NSString *sexTag = [aUser.sex boolValue]? @"sex_tag_1.png":@"sex_tag_0.png";
    _sexImageView.image = [UIImage imageNamed:sexTag];
    [_themeBackgroundView setImageUrl:aUser.bgImage];
    NSString *wellKnowReal = (aUser.wellknow==nil||[aUser.wellknow isEqualToString:@""])? @"0％":aUser.wellknow;
    NSString *combineString = [NSString stringWithFormat:@"%@",wellKnowReal];
    _wellknowView.contentLabel.text = combineString;
    
    
    CGSize distanceSize = [aUser.latestDistance sizeWithFont:[UIFont systemFontOfSize:12.5] constrainedToSize:CGSizeMake(280,_timeLabel.frame.size.height)];
    
    CGSize timeSize = [aUser.lastTime sizeWithFont:[UIFont systemFontOfSize:12.5] constrainedToSize:CGSizeMake(280,_distanceLabel.frame.size.height)];
    
    _distanceLabel.frame = CGRectMake(_distanceLabel.frame.origin.x,_distanceLabel.frame.origin.y,distanceSize.width,_distanceLabel.frame.size.height);
    
    timeView.frame = CGRectMake(_distanceLabel.frame.origin.x+_distanceLabel.frame.size.width+5,_sexImageView.frame.origin.y,13,13);
    
    _timeLabel.frame = CGRectMake(timeView.frame.origin.x+timeView.frame.size.width+5,_timeLabel.frame.origin.y,timeSize.width,_timeLabel.frame.size.height);
  
    _timeLabel.text = aUser.lastTime;
    _distanceLabel.text = aUser.latestDistance;
}

- (void)addTagert:(id)target forTeaseAction:(SEL)teaseAction
{
    [_teaseButton addTarget:target action:teaseAction forControlEvents:UIControlEventTouchUpInside];
}
@end
