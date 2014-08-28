//
//  XXFontStyleDescription.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-20.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface XXFontStyleDescription : NSObject
@property (nonatomic,assign)CGFloat lineHeight;
@property (nonatomic,strong)NSString *fontFamily;
@property (nonatomic,strong)NSString *fontColor;
@property (nonatomic,strong)NSString *fontWeight;
@property (nonatomic,strong)NSString *fontAlign;
@property (nonatomic,assign)NSInteger fontSize;

@end
