//
//  XXShareTemplateBuilder.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XXShareStyle.h"
#import "XXSharePostModel.h"
#import "XXUserModel.h"
#import "XXUserCellStyle.h"
#import "XXSharePostUserStyle.h"

#define XXTextAlignLeft @"left"
#define XXTextAlignRight @"right"
#define XXTextAlignCenter @"center"
#define XXFontWeightNormal @"normal"
#define XXFontWeightBold   @"bold"


extern BOOL const XXLockShareCSSTemplateState;

@interface XXShareTemplateBuilder : NSObject

+ (NSString*)buildCSSTemplateWithBundleFormatteFile:(NSString*)fileName withShareStyle:(XXShareStyle*)aStyle;

+ (NSString *)buildCSSTemplateWithFormatte:(NSString*)cssFormatte withShareStyle:(XXShareStyle*)aStyle;

+ (NSString*)buildSharePostContentWithCSSTemplate:(NSString*)cssTemplate withSharePostModel:(XXSharePostModel*)aSharePost;

+ (NSString*)buildSharePostHeadHtmlContentWithName:(NSString*)name withGrade:(NSString*)grade withCollege:(NSString*)college withSexTag:(NSString*)sexTag withTimeString:(NSString*)time  withStyle:(XXSharePostUserStyle*)aStyle;

+ (NSString*)buildSharePostHeadHtmlContentForMessageListWithName:(NSString *)name withGrade:(NSString *)grade withCollege:(NSString *)college withSexTag:(NSString *)sexTag withTimeString:(NSString*)time withStyle:(XXSharePostUserStyle*)aStyle;

+ (NSString*)buildCommonCSSTemplateWithBundleFormatteFile:(NSString*)fileName withShareStyle:(XXShareStyle*)aStyle;
+ (NSString*)buildCommonCSSTemplateWithBundleFormatteFile:(NSString*)fileName withShareStyle:(XXShareStyle*)aStyle isFromSelf:(BOOL)isFromSelf;

+ (NSString*)buildCommonCSSTemplateWithFormatte:(NSString*)cssFormatte withShareStyle:(XXShareStyle*)aStyle;

+ (NSString*)buildCommonTextContentWithCSSTemplate:(NSString*)cssTemplate withConentText:(NSString*)contentText;

+ (NSString*)buildHtmlContentWithCSSTemplate:(NSString*)cssTemplate withHtmlTemplateFile:(NSString*)htmlTemplate withConentText:(NSString*)contentText;


+ (NSString*)buildUserCellCSSTemplateWithBundleFormatteFile:(NSString*)fileName withShareStyle:(XXUserCellStyle*)aStyle;
+ (NSString*)buildUserCellCSSTemplateWithFormatte:(NSString*)cssFormatte withShareStyle:(XXUserCellStyle*)aStyle;

+ (NSString*)buildUserCellContentWithCSSTemplate:(NSString*)cssTemplate withUserModel:(XXUserModel*)userModel;

+ (NSString*)buildSharePostUserCSSWithFileName:(NSString*)fileName withStyle:(XXSharePostUserStyle*)aStyle;

@end
