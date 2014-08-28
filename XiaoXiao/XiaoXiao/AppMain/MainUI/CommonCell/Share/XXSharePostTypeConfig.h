//
//  XXSharePostTypeConfig.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-18.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

//分享模板类型
typedef enum {
    
    XXSharePostTypeImageAudio0 = 8877990,
    XXSharePostTypeImageAudio1,
    XXSharePostTypeImageAudio2,
    XXSharePostTypeImageAudio3,
    XXSharePostTypeImageAudio4,
    XXSharePostTypeImageAudio5,
    XXSharePostTypeImageAudio6,
    XXSharePostTypeImageText0,
    XXSharePostTypeImageText1,
    XXSharePostTypeImageText2,
    XXSharePostTypeImageText3,
    XXSharePostTypeImageText4,
    XXSharePostTypeImageText5,
    XXSharePostTypeImageText6,
    
}XXSharePostType;


@interface XXSharePostTypeConfig : NSObject

+ (NSString *)sharePostHTMLTemplateForType:(XXSharePostType)sharePostType;
+ (XXSharePostType)postTypeWithImageCount:(NSInteger)imagesCount withIsAudioContent:(BOOL)isAudio;
@end
