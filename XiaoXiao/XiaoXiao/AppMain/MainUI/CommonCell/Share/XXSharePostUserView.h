//
//  XXSharePostUserView.h
//  XiaoXiao
//
//  Created by ZYVincent on 14-1-9.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "DTAttributedTextContentView.h"
#import "XXSharePostModel.h"
#import "XXTeaseModel.h"
#import "XXCommentModel.h"
#import "XXSharePostUserStyle.h"
#import "ZYXMPPMessage.h"

@interface XXSharePostUserView : DTAttributedTextContentView
- (void)setContentModel:(XXSharePostModel*)contentModel;
- (void)setTeaseModel:(XXTeaseModel*)teaseModel;
- (void)setCommentModel:(XXCommentModel*)commentModel;
- (void)setXMPPMessage:(ZYXMPPMessage*)aMessage;

+ (NSAttributedString*)useHeadAttributedStringWithModel:(XXSharePostModel*)contentModel;
+ (NSAttributedString*)useHeadAttributedStringWithTeaseModel:(XXTeaseModel*)contentModel;
+ (NSAttributedString*)useHeadAttributedStringWithCommnetModel:(XXCommentModel*)commentModel;

+ (NSAttributedString*)useHeadAttributedStringWithModel:(XXSharePostModel*)contentModel withShareUserPostStyle:(XXSharePostUserStyle*)aStyle;

+ (NSAttributedString*)useHeadAttributedStringWithTeaseModel:(XXTeaseModel*)contentModel withShareUserPostStyle:(XXSharePostUserStyle*)aStyle;

+ (NSAttributedString*)useHeadAttributedStringWithCommnetModel:(XXCommentModel*)commentModel withShareUserPostStyle:(XXSharePostUserStyle*)aStyle;

+ (NSAttributedString*)useHeadAttributedStringWithCommnetModelForMessageList:(XXCommentModel*)commentModel withShareUserPostStyle:(XXSharePostUserStyle*)aStyle;


@end
