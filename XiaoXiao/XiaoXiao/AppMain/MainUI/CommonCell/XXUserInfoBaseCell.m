//
//  XXUserInfoBaseCell.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "XXUserInfoBaseCell.h"

@implementation XXUserInfoBaseCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.contentView.backgroundColor = rgb(250,250,250,1);
        
        headView = [[XXHeadView alloc]initWithFrame:CGRectMake(12,11,78,78)];
        headView.contentImageView.image = [UIImage imageNamed:@"xxx.jpg"];
        headView.contentImageView.borderWidth = 3.0f;
        [headView addTarget:self action:@selector(tapOnHeadViewAction) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:headView];
        
        //remind
        remindNewImgView = [[XXBadgeView alloc]initWithFrame:CGRectMake(7,5,30,15)];
        remindNewImgView.titleLabel.text = @"新故事";
        remindNewImgView.hidden = YES;
        [self.contentView addSubview:remindNewImgView];
        
        contentTextView = [[XXBaseTextView alloc]init];
        contentTextView.frame = CGRectMake(106,14,[XXUserInfoCellStyle contentWidth],78);
        contentTextView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:contentTextView];
        
        //visit time label
        self.visitTimeLabel = [[UILabel alloc]init];
        self.visitTimeLabel.frame = CGRectMake(self.frame.size.width-_leftMargin-60,_topMargin*2,60,15);
        self.visitTimeLabel.font = [UIFont systemFontOfSize:10];
        self.visitTimeLabel.backgroundColor = [UIColor clearColor];
        self.visitTimeLabel.textAlignment = NSTextAlignmentRight;
        self.visitTimeLabel.textColor = [XXCommonStyle xxThemeButtonGrayTitleColor];
        [self.contentView addSubview:self.visitTimeLabel];
        self.visitTimeLabel.hidden = YES;
        
        UIView *normalBack = [[UIView alloc]initWithFrame:CGRectMake(0,0,self.frame.size.width,self.frame.size.height)];
        normalBack.backgroundColor = rgb(233,233,234,1);
        self.selectedBackgroundView = normalBack;

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSAttributedString*)buildAttributedStringWithUserModel:(XXUserModel *)userModel
{
    userModel.signature = [XXBaseTextView switchEmojiTextWithSourceText:userModel.signature];
    NSString *css = [XXShareTemplateBuilder buildUserCellCSSTemplateWithBundleFormatteFile:XXUserCellTemplateCSS withShareStyle:[XXUserCellStyle userCellStyle]];
    NSString *htmlString = [XXShareTemplateBuilder buildUserCellContentWithCSSTemplate:css withUserModel:userModel];
    
    NSAttributedString *attributedString = [[NSAttributedString alloc]initWithHTMLData:[htmlString dataUsingEncoding:NSUTF8StringEncoding] documentAttributes:nil];
    
    return attributedString;
}

- (void)setContentModel:(XXUserModel *)userModel
{
    [contentTextView setAttributedString:userModel.attributedContent];
    CGFloat contentHeight = [XXUserInfoBaseCell heightWithContentModel:userModel];
    [contentTextView setFrame:CGRectMake(contentTextView.frame.origin.x,contentTextView.frame.origin.y,contentTextView.frame.size.width,73)];
    [headView setRoundHeadWithUserId:userModel.userId];
    
    if (userModel.visitTime!=nil&&![userModel.visitTime isEqualToString:@""]) {
        self.visitTimeLabel.hidden = NO;
        self.visitTimeLabel.text = userModel.visitTime;
    }
    _cellLineImageView.frame = CGRectMake(0,contentHeight-1,self.frame.size.width,1);//重设分割线
    
    if ([userModel.isInMyCareList boolValue]&&[userModel.hasNewPosts boolValue]) {
        remindNewImgView.hidden = NO;
    }else{
        remindNewImgView.hidden = YES;
    }
}

+ (CGFloat)heightWithContentModel:(XXUserModel *)userModel
{
    return 100;
}

#pragma mark - tap on headview
- (void)tapOnHeadViewAction
{
    if ([self.delegate respondsToSelector:@selector(userInfoBaseCellDidTapOnHeadView:)]) {
        [self.delegate userInfoBaseCellDidTapOnHeadView:self];
    }
}


@end
