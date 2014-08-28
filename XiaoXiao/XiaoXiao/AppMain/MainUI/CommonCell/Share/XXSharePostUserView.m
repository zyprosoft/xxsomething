//
//  XXSharePostUserView.m
//  XiaoXiao
//
//  Created by ZYVincent on 14-1-9.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "XXSharePostUserView.h"

#define XXSharePostUserDefaultHtml @"xxshare_post_user.html"

@implementation XXSharePostUserView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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

- (void)setContentModel:(XXSharePostModel *)contentModel
{
    [self setAttributedString:contentModel.userHeadContent];
}
- (void)setTeaseModel:(XXTeaseModel *)teaseModel
{
    [self setAttributedString:teaseModel.userHeadContent];
}
- (void)setCommentModel:(XXCommentModel *)commentModel
{
    [self setAttributedString:commentModel.userHeadContent];
}
- (void)setXMPPMessage:(ZYXMPPMessage *)aMessage
{
    [self setAttributedString:aMessage.userHeadAttributedString];
}

+ (NSAttributedString*)useHeadAttributedStringWithModel:(XXSharePostModel*)contentModel
{
    XXSharePostUserStyle *aStyle = [[XXSharePostUserStyle alloc]init];
    aStyle.nameDes.fontFamily = @"Helvetica";
    aStyle.nameDes.fontSize = 13;
    aStyle.nameDes.fontAlign = XXTextAlignLeft;
    aStyle.nameDes.fontWeight = XXFontWeightNormal;
    aStyle.nameDes.fontColor = @"#463a45";
    
    aStyle.gradeDes.fontFamily = @"Helvetica";
    aStyle.gradeDes.fontSize = 13;
    aStyle.gradeDes.fontAlign = XXTextAlignLeft;
    aStyle.gradeDes.fontWeight = XXFontWeightNormal;
    aStyle.gradeDes.fontColor = @"#463a45";
    
    aStyle.collegeDes.fontFamily = @"Helvetica";
    aStyle.collegeDes.fontSize = 13;
    aStyle.collegeDes.fontAlign = XXTextAlignLeft;
    aStyle.collegeDes.fontWeight = XXFontWeightNormal;
    aStyle.collegeDes.fontColor = @"#463a45";
    
    aStyle.sexTagDes.width = 12;
    aStyle.sexTagDes.height = 12;
    
   return  [XXSharePostUserView useHeadAttributedStringWithModel:contentModel withShareUserPostStyle:aStyle];
    
}
+ (NSAttributedString*)useHeadAttributedStringWithTeaseModel:(XXTeaseModel*)contentModel
{
    XXSharePostUserStyle *aStyle = [[XXSharePostUserStyle alloc]init];
    aStyle.nameDes.fontFamily = @"Helvetica";
    aStyle.nameDes.fontSize = 13;
    aStyle.nameDes.fontAlign = XXTextAlignLeft;
    aStyle.nameDes.fontWeight = XXFontWeightNormal;
    aStyle.nameDes.fontColor = @"#463a45";
    
    aStyle.gradeDes.fontFamily = @"Helvetica";
    aStyle.gradeDes.fontSize = 13;
    aStyle.gradeDes.fontAlign = XXTextAlignLeft;
    aStyle.gradeDes.fontWeight = XXFontWeightNormal;
    aStyle.gradeDes.fontColor = @"#463a45";
    
    aStyle.collegeDes.fontFamily = @"Helvetica";
    aStyle.collegeDes.fontSize = 10;
    aStyle.collegeDes.fontAlign = XXTextAlignLeft;
    aStyle.collegeDes.fontWeight = XXFontWeightNormal;
    aStyle.collegeDes.fontColor = @"#463a45";
    
    aStyle.sexTagDes.width = 12;
    aStyle.sexTagDes.height = 12;
    
    return  [XXSharePostUserView useHeadAttributedStringWithTeaseModel:contentModel withShareUserPostStyle:aStyle];
}
+ (NSAttributedString*)useHeadAttributedStringWithCommnetModel:(XXCommentModel*)commentModel
{
    XXSharePostUserStyle *aStyle = [[XXSharePostUserStyle alloc]init];
    aStyle.nameDes.fontFamily = @"Helvetica";
    aStyle.nameDes.fontSize = 13;
    aStyle.nameDes.fontAlign = XXTextAlignLeft;
    aStyle.nameDes.fontWeight = XXFontWeightNormal;
    aStyle.nameDes.fontColor = @"#463a45";
    
    aStyle.gradeDes.fontFamily = @"Helvetica";
    aStyle.gradeDes.fontSize = 13;
    aStyle.gradeDes.fontAlign = XXTextAlignLeft;
    aStyle.gradeDes.fontWeight = XXFontWeightNormal;
    aStyle.gradeDes.fontColor = @"#463a45";
    
    aStyle.collegeDes.fontFamily = @"Helvetica";
    aStyle.collegeDes.fontSize = 13;
    aStyle.collegeDes.fontAlign = XXTextAlignLeft;
    aStyle.collegeDes.fontWeight = XXFontWeightNormal;
    aStyle.collegeDes.fontColor = @"#463a45";
    
    aStyle.sexTagDes.width = 12;
    aStyle.sexTagDes.height = 12;
    
    return  [XXSharePostUserView useHeadAttributedStringWithCommnetModel:commentModel withShareUserPostStyle:aStyle];
}

+ (NSAttributedString*)useHeadAttributedStringWithModel:(XXSharePostModel *)contentModel withShareUserPostStyle:(XXSharePostUserStyle *)aStyle
{
    NSString *htmlContent = [XXShareTemplateBuilder buildSharePostHeadHtmlContentWithName:contentModel.nickName withGrade:contentModel.grade withCollege:contentModel.schoolName withSexTag:contentModel.sex withTimeString:contentModel.friendAddTime withStyle:aStyle];
    NSData *htmlData = [htmlContent dataUsingEncoding:NSUTF8StringEncoding];
    
    return [[NSAttributedString alloc]initWithHTMLData:htmlData documentAttributes:nil];
}
+ (NSAttributedString*)useHeadAttributedStringWithTeaseModel:(XXTeaseModel *)contentModel withShareUserPostStyle:(XXSharePostUserStyle *)aStyle
{
    NSString *htmlContent = [XXShareTemplateBuilder buildSharePostHeadHtmlContentWithName:contentModel.nickName withGrade:contentModel.grade withCollege:contentModel.schoolName withSexTag:contentModel.sex withTimeString:contentModel.friendTeaseTime withStyle:aStyle];
    NSData *htmlData = [htmlContent dataUsingEncoding:NSUTF8StringEncoding];
    
    return [[NSAttributedString alloc]initWithHTMLData:htmlData documentAttributes:nil];
    
}
+ (NSAttributedString*)useHeadAttributedStringWithCommnetModel:(XXCommentModel *)commentModel withShareUserPostStyle:(XXSharePostUserStyle *)aStyle
{
    NSString *htmlContent = [XXShareTemplateBuilder buildSharePostHeadHtmlContentWithName:commentModel.userName withGrade:commentModel.grade withCollege:commentModel.schoolName withSexTag:commentModel.sex withTimeString:commentModel.friendAddTime withStyle:aStyle];
    NSData *htmlData = [htmlContent dataUsingEncoding:NSUTF8StringEncoding];
    
    return [[NSAttributedString alloc]initWithHTMLData:htmlData documentAttributes:nil];
}

+ (NSAttributedString*)useHeadAttributedStringWithCommnetModelForMessageList:(XXCommentModel *)commentModel withShareUserPostStyle:(XXSharePostUserStyle *)aStyle
{
    NSString *htmlContent = [XXShareTemplateBuilder buildSharePostHeadHtmlContentForMessageListWithName:commentModel.userName withGrade:commentModel.grade withCollege:commentModel.schoolName withSexTag:commentModel.sex withTimeString:commentModel.friendAddTime withStyle:aStyle];
    NSData *htmlData = [htmlContent dataUsingEncoding:NSUTF8StringEncoding];
    
    return [[NSAttributedString alloc]initWithHTMLData:htmlData documentAttributes:nil];
}

@end
