//
//  XXSharePostTypeConfig.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-18.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "XXSharePostTypeConfig.h"

@implementation XXSharePostTypeConfig

+ (NSString*)sharePostHTMLTemplateForType:(XXSharePostType)sharePostType
{
    NSString *templateFileName = nil;
    switch (sharePostType) {
        case XXSharePostTypeImageAudio0:
            templateFileName = @"xxshare_image_audio_0.html";
            break;
        case XXSharePostTypeImageAudio1:
            templateFileName = @"xxshare_image_audio_1.html";
            break;
        case XXSharePostTypeImageAudio2:
            templateFileName = @"xxshare_image_audio_2.html";
            break;
        case XXSharePostTypeImageAudio3:
            templateFileName = @"xxshare_image_audio_3.html";
            break;
        case XXSharePostTypeImageAudio4:
            templateFileName = @"xxshare_image_audio_4.html";
            break;
        case XXSharePostTypeImageAudio5:
            templateFileName = @"xxshare_image_audio_5.html";
            break;
        case XXSharePostTypeImageAudio6:
            templateFileName = @"xxshare_image_audio_6.html";
            break;
        case XXSharePostTypeImageText0:
            templateFileName = @"xxshare_image_text_0.html";
            break;
        case XXSharePostTypeImageText1:
            templateFileName = @"xxshare_image_text_1.html";
            break;
        case XXSharePostTypeImageText2:
            templateFileName = @"xxshare_image_text_2.html";
            break;
        case XXSharePostTypeImageText3:
            templateFileName = @"xxshare_image_text_3.html";
            break;
        case XXSharePostTypeImageText4:
            templateFileName = @"xxshare_image_text_4.html";
            break;
        case XXSharePostTypeImageText5:
            templateFileName = @"xxshare_image_text_5.html";
            break;
        case XXSharePostTypeImageText6:
            templateFileName = @"xxshare_image_text_6.html";
            break;
        default:
            break;
    }
    
    return [XXFileUitil loadStringFromBundleForName:templateFileName];
}
+ (XXSharePostType)postTypeWithImageCount:(NSInteger)imagesCount withIsAudioContent:(BOOL)isAudio
{
    if (isAudio) {
        
        NSInteger baseTypeTag = 8877990;
        return baseTypeTag+imagesCount;
        
    }else{
        
        NSInteger baseTypeTag = 8877997;
        return baseTypeTag+imagesCount;
    }
}

@end
