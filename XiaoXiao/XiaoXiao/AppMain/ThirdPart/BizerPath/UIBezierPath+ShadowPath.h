//
//  UIBezierPath+ShadowPath.h
//  ShadowDemo
//
//  Created by navy on 12-12-24.
//  Copyright (c) 2012年 navy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBezierPath (ShadowPath)

+ (UIBezierPath*)bezierPathWithCurvedShadowForRect:(CGRect)rect;
+ (UIBezierPath*)bezierPathForTopCellRect:(CGRect)rect;
+ (UIBezierPath*)bezierPathForMiddleCellRect:(CGRect)rect;
+ (UIBezierPath*)bezierPathForBottomCellRect:(CGRect)rect;
+ (UIBezierPath*)bezierPathForSingleCellRect:(CGRect)rect;

@end
