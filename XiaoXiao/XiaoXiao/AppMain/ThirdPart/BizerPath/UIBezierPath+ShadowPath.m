//
//  UIBezierPath+ShadowPath.m
//  ShadowDemo
//
//  Created by navy on 12-12-24.
//  Copyright (c) 2012年 navy. All rights reserved.
//

#import "UIBezierPath+ShadowPath.h"

static const CGFloat offset = 10.0;
static const CGFloat xOffset = 3.0;
static const CGFloat curve = 5.0;

@implementation UIBezierPath (ShadowPath)

+ (UIBezierPath*)bezierPathWithCurvedShadowForRect:(CGRect)rect {
    
	UIBezierPath *path = [UIBezierPath bezierPath];
	
	CGPoint topLeft		 = rect.origin;
	CGPoint bottomLeft	 = CGPointMake(0.0, CGRectGetHeight(rect)+offset);
	CGPoint bottomMiddle = CGPointMake(CGRectGetWidth(rect)/2, CGRectGetHeight(rect)-curve);
	CGPoint bottomRight	 = CGPointMake(CGRectGetWidth(rect), CGRectGetHeight(rect)+offset);
	CGPoint topRight	 = CGPointMake(CGRectGetWidth(rect), 0.0);
	
	[path moveToPoint:topLeft];
	[path addLineToPoint:bottomLeft];
	[path addQuadCurveToPoint:bottomRight
				 controlPoint:bottomMiddle];
	[path addLineToPoint:topRight];
	[path addLineToPoint:topLeft];
	[path closePath];
	
	return path;
}

+ (UIBezierPath*)bezierPathForTopCellRect:(CGRect)rect
{
    
}
+ (UIBezierPath*)bezierPathForMiddleCellRect:(CGRect)rect
{
    
}
+ (UIBezierPath*)bezierPathForBottomCellRect:(CGRect)rect
{
    
}

+ (UIBezierPath*)bezierPathForSingleCellRect:(CGRect)rect
{
    UIBezierPath *path = [UIBezierPath bezierPath];
	
	CGPoint topLeft		 = CGPointMake(rect.origin.x-xOffset,rect.origin.y-xOffset);
	CGPoint bottomLeft	 = CGPointMake(0.0, CGRectGetHeight(rect)+xOffset);
	CGPoint bottomRight	 = CGPointMake(CGRectGetWidth(rect)-offset, CGRectGetHeight(rect)+xOffset);
	CGPoint topRight	 = CGPointMake(CGRectGetWidth(rect)+offset, xOffset);
	
	[path moveToPoint:topLeft];
	[path addLineToPoint:bottomLeft];
	[path addLineToPoint:bottomRight];
	[path addLineToPoint:topRight];
	[path addLineToPoint:topLeft];
	[path closePath];
    
    return path;

}


@end
