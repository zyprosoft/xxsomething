//
//  XXShareTemplateBuilder.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "XXShareTemplateBuilder.h"
#import "XXSharePostUserStyle.h"

BOOL const XXLockShareCSSTemplateState = YES;
BOOL const XXLockCommonCSSTemplateState = NO;

@implementation XXShareTemplateBuilder

+ (NSString*)buildCSSTemplateWithBundleFormatteFile:(NSString *)fileName withShareStyle:(XXShareStyle *)aStyle
{
    if (XXLockShareCSSTemplateState) {
        if (![fileName isEqualToString:XXBaseTextTemplateCSS]) {

            DDLogWarn(@"CSS Template has been locked,you can only use css file:%@",XXBaseTextTemplateCSS);
            
            NSString *ccsFormatteString = [XXFileUitil loadStringFromBundleForName:XXBaseTextTemplateCSS];
            
            return [XXShareTemplateBuilder buildCSSTemplateWithFormatte:ccsFormatteString withShareStyle:aStyle];

        }
    }
    NSString *ccsFormatteString = [XXFileUitil loadStringFromBundleForName:fileName];
    
    return [XXShareTemplateBuilder buildCSSTemplateWithBundleFormatteFile:ccsFormatteString withShareStyle:aStyle];
}

+ (NSString*)buildCSSTemplateWithFormatte:(NSString *)cssFormatte withShareStyle:(XXShareStyle *)aStyle
{
    NSString *resultString = [NSString stringWithFormat:cssFormatte,aStyle.contentLineHeight,aStyle.contentFontSize,aStyle.contentTextColor,aStyle.contentTextAlign,aStyle.contentFontWeight,aStyle.contentFontFamily,aStyle.emojiSize,aStyle.emojiSize,aStyle.thumbImageSize,aStyle.thumbImageSize,aStyle.audioImageWidth,aStyle.audioImageHeight];
    
    return resultString;
}

+ (NSString*)buildSharePostContentWithCSSTemplate:(NSString *)cssTemplate withSharePostModel:(XXSharePostModel*)aSharePost
{
    NSString *htmlTemplate = [XXSharePostTypeConfig sharePostHTMLTemplateForType:aSharePost.postType];
    
    //替换CSS
    htmlTemplate = [htmlTemplate stringByReplacingOccurrencesOfString:@"!$css$!" withString:cssTemplate];
    
    //替换content,如果没有，就移除内容标签
    if ([aSharePost.postContent isEqualToString:@""]) {
        htmlTemplate = [htmlTemplate stringByReplacingOccurrencesOfString:@"<p class=\"content\">!$content$!</p>" withString:@""];
    }else{
        aSharePost.postContent = [XXBaseTextView switchEmojiTextWithSourceText:aSharePost.postContent];
        htmlTemplate = [htmlTemplate stringByReplacingOccurrencesOfString:@"!$content$!" withString:aSharePost.postContent];
    }
    
    
    //替换音频
    htmlTemplate = [htmlTemplate stringByReplacingOccurrencesOfString:@"!$audio$!" withString:[XXSharePostStyle sharePostAudioSrcImageName]];
    NSString *audioTagUrl = [NSString stringWithFormat:@"%@%@$%@",XXMIMETypeAudioFormatte,aSharePost.postAudio,aSharePost.postAudioTime];
    htmlTemplate = [htmlTemplate stringByReplacingOccurrencesOfString:@"!$audioUrl$!" withString:audioTagUrl];

    //替换图片
    NSArray *images = [aSharePost.postImages componentsSeparatedByString:[XXSharePostStyle sharePostImagesSeprator]];
    for (int i=0; i<images.count; i++) {
        
        NSString *imageWillReplace = [NSString stringWithFormat:@"!$image%d$!",i];
        htmlTemplate = [htmlTemplate stringByReplacingOccurrencesOfString:imageWillReplace withString:[images objectAtIndex:i]];
        
        //增加大图获取链接拼接
        NSString *imageLinkWillReplace = [NSString stringWithFormat:@"!$image%dLink$!",i];
        NSString *imageLinkUrl = [NSString stringWithFormat:@"%@%@",XXMIMETypeImageFormatte,[images objectAtIndex:i]];
        htmlTemplate = [htmlTemplate stringByReplacingOccurrencesOfString:imageLinkWillReplace withString:imageLinkUrl];
    }
    
    return htmlTemplate;
}

+ (NSString*)buildSharePostHeadHtmlContentWithName:(NSString *)name withGrade:(NSString *)grade withCollege:(NSString *)college withSexTag:(NSString *)sexTag withTimeString:(NSString*)time withStyle:(XXSharePostUserStyle*)aStyle
{
    NSString *htmlTemplate = [XXShareTemplateBuilder buildSharePostUserCSSWithFileName:@"xxshare_post_user.html" withStyle:aStyle];
    
    //替换content
    NSString *sexTagImageName = [NSString stringWithFormat:@"sex_tag_%@@2x.png",sexTag];
    htmlTemplate = [htmlTemplate stringByReplacingOccurrencesOfString:@"!$sextag$!" withString:sexTagImageName];
    htmlTemplate = [htmlTemplate stringByReplacingOccurrencesOfString:@"!$username$!" withString:name];
    htmlTemplate = [htmlTemplate stringByReplacingOccurrencesOfString:@"!$grade$!" withString:grade];
    NSString *combineCollege = [NSString stringWithFormat:@"来自%@",college];
    htmlTemplate = [htmlTemplate stringByReplacingOccurrencesOfString:@"!$college$!" withString:combineCollege];

    return htmlTemplate;
}
+ (NSString*)buildSharePostHeadHtmlContentForMessageListWithName:(NSString *)name withGrade:(NSString *)grade withCollege:(NSString *)college withSexTag:(NSString *)sexTag withTimeString:(NSString*)time withStyle:(XXSharePostUserStyle*)aStyle
{
    NSString *htmlTemplate = [XXShareTemplateBuilder buildSharePostUserCSSWithFileName:@"xxshare_post_user.html" withStyle:aStyle];
    
    //替换content
    NSString *sexTagImageName = [NSString stringWithFormat:@"sex_tag_%@@2x.png",sexTag];
    htmlTemplate = [htmlTemplate stringByReplacingOccurrencesOfString:@"!$sextag$!" withString:sexTagImageName];
    htmlTemplate = [htmlTemplate stringByReplacingOccurrencesOfString:@"!$username$!" withString:name];
//    htmlTemplate = [htmlTemplate stringByReplacingOccurrencesOfString:@"<span class=\"grade\">!$grade$!</span>" withString:@""];
    htmlTemplate = [htmlTemplate stringByReplacingOccurrencesOfString:@"!$grade$!" withString:grade];
    NSString *combineCollege = [NSString stringWithFormat:@"%@",college];
    htmlTemplate = [htmlTemplate stringByReplacingOccurrencesOfString:@"!$college$!" withString:combineCollege];
    
    return htmlTemplate;
}

#pragma mark - 通用表情文字混排
+ (NSString*)buildCommonCSSTemplateWithBundleFormatteFile:(NSString*)fileName withShareStyle:(XXShareStyle*)aStyle
{
    if (XXLockCommonCSSTemplateState) {
        if (![fileName isEqualToString:XXCommonTextTemplateCSS]) {
            
            DDLogWarn(@"CSS Template has been locked,you can only use css file:%@",XXCommonTextTemplateCSS);
            
            NSString *ccsFormatteString = [XXFileUitil loadStringFromBundleForName:XXCommonTextTemplateCSS];
            
            return [XXShareTemplateBuilder buildCSSTemplateWithFormatte:ccsFormatteString withShareStyle:aStyle];
            
        }
    }
    NSString *ccsFormatteString = [XXFileUitil loadStringFromBundleForName:fileName];
    
    return [XXShareTemplateBuilder buildCommonCSSTemplateWithFormatte:ccsFormatteString withShareStyle:aStyle];
}
+ (NSString*)buildCommonCSSTemplateWithBundleFormatteFile:(NSString*)fileName withShareStyle:(XXShareStyle*)aStyle isFromSelf:(BOOL)isFromSelf
{
    if (XXLockCommonCSSTemplateState) {
        if (![fileName isEqualToString:XXCommonTextTemplateCSS]) {
            
            DDLogWarn(@"CSS Template has been locked,you can only use css file:%@",XXCommonTextTemplateCSS);
            
            NSString *ccsFormatteString = [XXFileUitil loadStringFromBundleForName:XXCommonTextTemplateCSS];
            
            return [XXShareTemplateBuilder buildCSSTemplateWithFormatte:ccsFormatteString withShareStyle:aStyle];
            
        }
    }
    NSString *ccsFormatteString = [XXFileUitil loadStringFromBundleForName:fileName];
    
    return [XXShareTemplateBuilder buildCommonCSSTemplateWithFormatte:ccsFormatteString withShareStyle:aStyle];
}


+ (NSString*)buildCommonCSSTemplateWithFormatte:(NSString *)cssFormatte withShareStyle:(XXShareStyle *)aStyle
{
    NSString *resultString = [NSString stringWithFormat:cssFormatte,aStyle.contentLineHeight,aStyle.contentFontSize,aStyle.contentTextColor,aStyle.contentTextAlign,aStyle.contentFontWeight,aStyle.contentFontFamily,aStyle.emojiSize,aStyle.emojiSize];
    
    return resultString;
}

+ (NSString*)buildCommonTextContentWithCSSTemplate:(NSString*)cssTemplate withConentText:(NSString*)contentText
{
    NSString *htmlTemplate = [XXFileUitil loadStringFromBundleForName:XXCommonHtmlTemplate];
    
    //替换CSS
    htmlTemplate = [htmlTemplate stringByReplacingOccurrencesOfString:@"!$css$!" withString:cssTemplate];
    
    //替换content
    contentText = [XXBaseTextView switchEmojiTextWithSourceText:contentText];
    htmlTemplate = [htmlTemplate stringByReplacingOccurrencesOfString:@"!$content$!" withString:contentText];
    
    return htmlTemplate;
}

+ (NSString*)buildHtmlContentWithCSSTemplate:(NSString *)cssTemplate withHtmlTemplateFile:(NSString *)htmlTemplate withConentText:(NSString *)contentText
{
    NSString *htmlTemp= [XXFileUitil loadStringFromBundleForName:htmlTemplate];

    //替换CSS
    htmlTemp = [htmlTemp stringByReplacingOccurrencesOfString:@"!$css$!" withString:cssTemplate];
    
    //替换content
    contentText = [XXBaseTextView switchEmojiTextWithSourceText:contentText];
    htmlTemp = [htmlTemp stringByReplacingOccurrencesOfString:@"!$content$!" withString:contentText];
    
    return htmlTemp;
}

//user info cell
+ (NSString*)buildUserCellCSSTemplateWithBundleFormatteFile:(NSString*)fileName withShareStyle:(XXUserCellStyle*)aStyle
{
    NSString *ccsFormatteString = [XXFileUitil loadStringFromBundleForName:fileName];
    
    return [XXShareTemplateBuilder buildUserCellCSSTemplateWithFormatte:ccsFormatteString withShareStyle:aStyle];
}
+ (NSString*)buildUserCellCSSTemplateWithFormatte:(NSString*)cssFormatte withShareStyle:(XXUserCellStyle*)aStyle
{
    
    NSString *resultCSS = [NSString stringWithFormat:cssFormatte,
                           aStyle.emojiDes.width,aStyle.emojiDes.height,aStyle.sexTagDes.width,aStyle.sexTagDes.height,
                                aStyle.userNameDes.lineHeight,aStyle.userNameDes.fontSize,aStyle.userNameDes.fontColor,aStyle.userNameDes.fontAlign,aStyle.userNameDes.fontWeight,aStyle.userNameDes.fontFamily
                                ,aStyle.collegeDes.lineHeight,aStyle.collegeDes.fontSize,aStyle.collegeDes.fontColor,aStyle.collegeDes.fontAlign,aStyle.collegeDes.fontWeight,aStyle.collegeDes.fontFamily
                                ,aStyle.starscoreDes.lineHeight,aStyle.starscoreDes.fontSize,aStyle.starscoreDes.fontColor,aStyle.starscoreDes.fontAlign,aStyle.starscoreDes.fontWeight,aStyle.starscoreDes.fontFamily
                                ,aStyle.scoreDes.lineHeight,aStyle.scoreDes.fontSize,aStyle.scoreDes.fontColor,aStyle.scoreDes.fontAlign,aStyle.scoreDes.fontWeight,aStyle.scoreDes.fontFamily
                                ,aStyle.profileDes.lineHeight,aStyle.profileDes.fontSize,aStyle.profileDes.fontColor,aStyle.profileDes.fontAlign,aStyle.profileDes.fontWeight,aStyle.profileDes.fontFamily];
    return resultCSS;
    
}
+ (NSString*)buildUserCellContentWithCSSTemplate:(NSString*)cssTemplate withUserModel:(XXUserModel*)userModel
{
    NSString *htmlTemp = nil;
    DDLogVerbose(@"userModel isInSchool:%@",userModel.isInSchool);
    if ([userModel.isInSchool boolValue]) {
        htmlTemp= [XXFileUitil loadStringFromBundleForName:XXUserCellHtmlTemplate1];
    }else{
        htmlTemp= [XXFileUitil loadStringFromBundleForName:XXUserCellHtmlTemplate];
    }
    
    //替换CSS
    htmlTemp = [htmlTemp stringByReplacingOccurrencesOfString:@"!$css$!" withString:cssTemplate];
    
    //替换content
    
    NSString *sexTagImageName = (userModel.sex==nil||[userModel.sex isEqualToString:@""])? @"sex_tag_0@2x.png": [NSString stringWithFormat:@"sex_tag_%@@2x.png",userModel.sex];
    DDLogVerbose(@"sextag image:%@",sexTagImageName);
    htmlTemp = [htmlTemp stringByReplacingOccurrencesOfString:@"!$sextag$!" withString:sexTagImageName];
    htmlTemp = [htmlTemp stringByReplacingOccurrencesOfString:@"!$username$!" withString:userModel.nickName];
    if ([userModel.isInSchool boolValue]) {
        htmlTemp = [htmlTemp stringByReplacingOccurrencesOfString:@"!$college$!" withString:userModel.grade];
    }else{
        htmlTemp = [htmlTemp stringByReplacingOccurrencesOfString:@"!$college$!" withString:userModel.schoolName];
    }
    NSString *constellationDefault = (userModel.constellation==nil||[userModel.constellation isEqualToString:@""])? @"天枰座":userModel.constellation;
    NSString *combineConstellation = [NSString stringWithFormat:@"%@ ",constellationDefault];
    htmlTemp = [htmlTemp stringByReplacingOccurrencesOfString:@"!$starscore$!" withString:combineConstellation];
    htmlTemp = [htmlTemp stringByReplacingOccurrencesOfString:@"!$score$!" withString:userModel.wellknow];
    DDLogVerbose(@"profile:%@",userModel.signature);
    if ([userModel.isInSchool boolValue]) {
        NSString *signature = (userModel.signature==nil||[userModel.signature isEqualToString:@""])? @"未设置签名":userModel.signature;
        htmlTemp = [htmlTemp stringByReplacingOccurrencesOfString:@"!$profile$!" withString:signature];
    }

    return htmlTemp;
    
}

+ (NSString*)buildSharePostUserCSSWithFileName:(NSString *)fileName withStyle:(XXSharePostUserStyle *)aStyle
{
    NSString *cssFormate = [XXFileUitil loadStringFromBundleForName:fileName];
    
    cssFormate = [NSString stringWithFormat:cssFormate,aStyle.nameDes.fontSize,aStyle.nameDes.fontColor,aStyle.nameDes.fontAlign,aStyle.nameDes.fontWeight,aStyle.nameDes.fontFamily,aStyle.gradeDes.fontSize,aStyle.gradeDes.fontColor,aStyle.gradeDes.fontAlign,aStyle.gradeDes.fontWeight,aStyle.gradeDes.fontFamily,aStyle.collegeDes.fontSize,aStyle.collegeDes.fontColor,aStyle.collegeDes.fontAlign,aStyle.collegeDes.fontWeight,aStyle.collegeDes.fontFamily,aStyle.sexTagDes.width,aStyle.sexTagDes.height];
    
    return cssFormate;
}


@end
