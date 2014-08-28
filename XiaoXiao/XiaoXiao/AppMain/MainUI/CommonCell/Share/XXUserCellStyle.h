//
//  XXUserCellStyle.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-19.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "XXShareStyle.h"
#import "XXFontStyleDescription.h"
#import "XXImageDescription.h"

@interface XXUserCellStyle : XXShareStyle
@property (nonatomic,strong)XXImageDescription *emojiDes;
@property (nonatomic,strong)XXImageDescription *sexTagDes;
@property (nonatomic,strong)XXFontStyleDescription *userNameDes;
@property (nonatomic,strong)XXFontStyleDescription *collegeDes;
@property (nonatomic,strong)XXFontStyleDescription *starscoreDes;
@property (nonatomic,strong)XXFontStyleDescription *scoreDes;
@property (nonatomic,strong)XXFontStyleDescription *profileDes;

+ (XXUserCellStyle*)userCellStyle;

@end
