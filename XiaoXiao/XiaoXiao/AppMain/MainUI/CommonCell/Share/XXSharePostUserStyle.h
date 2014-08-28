//
//  XXSharePostUserStyle.h
//  XiaoXiao
//
//  Created by ZYVincent on 14-3-2.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XXFontStyleDescription.h"
#import "XXImageDescription.h"

@interface XXSharePostUserStyle : NSObject
@property (nonatomic,strong)XXFontStyleDescription *nameDes;
@property (nonatomic,strong)XXFontStyleDescription *gradeDes;
@property (nonatomic,strong)XXFontStyleDescription *collegeDes;
@property (nonatomic,strong)XXImageDescription *sexTagDes;
@end
