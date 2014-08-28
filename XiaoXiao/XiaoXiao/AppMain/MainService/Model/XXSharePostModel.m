//
//  XXSharePostModel.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-18.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "XXSharePostModel.h"

@implementation XXSharePostModel
@synthesize postAudio,postContent,postImages,postType,attributedContent;

- (id)initWithContentDict:(NSDictionary *)contentDict
{
    if (self = [super init]) {
        
        //给个默认值
        self.postId = @"";
        self.type = @"";
        self.tag = @"";
        self.commentCount = @"";
        self.forwordCount = @"";
        self.praiseCount = @"";
        self.userId = @"";
        self.addTime = @"";
        self.schoolId = @"";
        self.content = @"";
        
        self.nickName = @"vincent";
        self.grade = @"二年级";
        self.schoolName = @"清华大学";
        self.sex = @"1";

        self.postId = [contentDict objectForKey:@"id"];
        self.type = [contentDict objectForKey:@"type"];
        self.tag = [contentDict objectForKey:@"tag"];
        self.commentCount = [contentDict objectForKey:@"comment_count"];
        self.forwordCount = [contentDict objectForKey:@"forword_count"];
        self.praiseCount = [contentDict objectForKey:@"praise_count"];
        self.userId = [contentDict objectForKey:@"user_id"];
        self.addTime = [contentDict objectForKey:@"add_time"];
        self.friendAddTime = [XXCommonUitil getTimeStrWithDateString:self.addTime];
        self.schoolId = [contentDict objectForKey:@"xuexiao_id"];
        
        //user
        NSDictionary *userDict = [contentDict objectForKey:@"user"];
        self.nickName = [userDict objectForKey:@"nickname"];
        self.sex = [userDict objectForKey:@"sex"];
        self.schoolName = [userDict objectForKey:@"school_name"];
        self.grade = [userDict objectForKey:@"grade"];
        self.userId = [userDict objectForKey:@"id"];
        
        //如果内容完全不符合自定义结构体，考虑平台数据失误出错的可能
        
        //自定义内容字段解析
        self.content= [contentDict objectForKey:@"content"];
        NSError *decodeContentJSonError = nil;
        NSDictionary *customContentDict = [NSJSONSerialization JSONObjectWithData:[self.content dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&decodeContentJSonError];
        if (decodeContentJSonError) {
            DDLogVerbose(@"decode content json error -->%@",decodeContentJSonError.description);
        }
        self.postContent = [customContentDict objectForKey:XXSharePostJSONContentKey];
        self.postAudio = [customContentDict objectForKey:XXSharePostJSONAudioKey];
        
        //补全图片链接地址
        NSString *images = [customContentDict objectForKey:XXSharePostJSONImageKey];
        NSArray *imageArray = [images componentsSeparatedByString:@"|"];
        NSMutableString *imageNewString = [NSMutableString string];
        [imageArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            //缩略图，根据图片个数确定图片的大小和宽度
            CGFloat imageWidth = 0.f;
            switch (imageArray.count) {
                case 1:
                    imageWidth = 274.f;
                    break;
                case 2:
                    imageWidth = 135.f;
                    break;
                case 3:
                    imageWidth = 90.f;
                    break;
                case 4:
                    imageWidth = 90.f;
                    break;
                case 5:
                    imageWidth = 90.f;
                    break;
                case 6:
                    imageWidth = 90.f;
                    break;
                    
                default:
                    break;
            }
            DDLogVerbose(@"link obj:%@",obj);
            NSString *preViewImageLink = [NSString stringWithFormat:@"%@/%d/%d%@",XX_Image_Resize_Url,(int)imageWidth,(int)imageWidth,obj];
            NSString *url = [NSString stringWithFormat:@"%@%@",XXBase_Host_Url,preViewImageLink];
            
            if (idx!=imageArray.count-1) {
                [imageNewString appendFormat:@"%@|",url];
            }else{
                [imageNewString appendString:url];
            }
        }];
        self.postImages = imageNewString;
        
        self.postType = [[customContentDict objectForKey:XXSharePostJSONTypeKey]intValue];
        self.postAudioTime = [customContentDict objectForKey:XXSharePostJSONAudioTime];
        //确保每个属性都有，即使为空字符串
        if (!self.postContent) {
            self.postContent = @"";
        }
        if (!self.postAudio) {
            self.postAudio=@"";
        }
        if (!self.postImages) {
            self.postImages=@"";
        }
        self.attributedContent = [XXShareBaseCell buildAttributedStringWithSharePost:self forContentWidth:[XXSharePostStyle sharePostContentWidth]];
        self.content = nil;
        self.postContent = nil;
        self.userHeadContent = [XXSharePostUserView useHeadAttributedStringWithModel:self];
                
    }
    return self;
}

- (id)initWithCoder:(NSCoder*)aDecoder
{
    if (self = [super init]) {
        
        self.postAudio = [aDecoder decodeObjectForKey:@"postAudio"];
        self.postType = [aDecoder decodeIntegerForKey:@"postType"];
        self.postImages = [aDecoder decodeObjectForKey:@"postImages"];
        self.postContent = [aDecoder decodeObjectForKey:@"postContent"];
        self.attributedContent = [aDecoder decodeObjectForKey:@"attributedContent"];
        self.userHeadContent = [aDecoder decodeObjectForKey:@"userHeadContent"];
        
        self.nickName = [aDecoder decodeObjectForKey:@"nickName"];
        self.grade = [aDecoder decodeObjectForKey:@"grade"];
        self.schoolName = [aDecoder decodeObjectForKey:@"schoolName"];
        self.sex = [aDecoder decodeObjectForKey:@"sex"];
        self.friendAddTime = [aDecoder decodeObjectForKey:@"friendAddTime"];

    }
    return self;
}
- (void)encodeWithCoder:(NSCoder*)aCoder
{
    [aCoder encodeObject:self.postAudio forKey:@"postAudio"];
    [aCoder encodeInteger:self.postType forKey:@"postType"];
    [aCoder encodeObject:self.postContent forKey:@"postContent"];
    [aCoder encodeObject:self.postImages forKey:@"postImages"];
    [aCoder encodeObject:self.attributedContent forKey:@"attributedContent"];
    [aCoder encodeObject:self.userHeadContent forKey:@"userHeadContent"];
    
    [aCoder encodeObject:self.nickName forKey:@"nickName"];
    [aCoder encodeObject:self.grade forKey:@"grade"];
    [aCoder encodeObject:self.schoolName forKey:@"schoolName"];
    [aCoder encodeObject:self.sex forKey:@"sex"];
    [aCoder encodeObject:self.friendAddTime forKey:@"friendAddTime"];

}

@end
