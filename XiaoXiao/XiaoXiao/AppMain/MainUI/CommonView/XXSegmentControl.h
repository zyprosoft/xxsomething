//
//  XXSegmentControl.h
//  XXSegmentControl
//
//  Created by ZYVincent on 13-12-24.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

//ConfigArray   @[@{@"title":@"xxx",@"normalBack":@"xxx",@"selectBack":@"xxx",@"normalColor":@"xxxx",@"selectColor":@"xxx"}]

@interface XXSegmentControl : UIView
@property (nonatomic,assign)NSInteger selectIndex;

- (id)initWithFrame:(CGRect)frame withConfigArray:(NSArray*)configArray;

@end
