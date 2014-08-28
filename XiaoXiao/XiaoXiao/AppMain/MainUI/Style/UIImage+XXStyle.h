//
//  UIImage+XXStyle.h
//  NavigationTest
//
//  Created by ZYVincent on 14-1-17.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage (XXStyle)

- (UIImage*)makeStretchForBubbleLeft;
- (UIImage*)makeStretchForBubbleRight;
- (UIImage*)makeStretchForBubbleLeftVertical;
- (UIImage*)makeStretchForBubbleRightVertical;

- (UIImage*)makeStretchForSingleRoundCell;
- (UIImage*)makeStretchForSingleCornerCell;
- (UIImage*)makeStretchForCellTop;
- (UIImage*)makeStretchForCellMiddle;
- (UIImage*)makeStretchForCellBottom;
- (UIImage*)makeStretchForSharePostList;
- (UIImage*)makeStretchForSharePostDetail;
- (UIImage*)makeStretchForSharePostDetailMiddle;
- (UIImage*)makeStretchForSharePostDetailBottom;

- (UIImage*)makeStretchForSegmentLeft;
- (UIImage*)makeStretchForSegmentMiddle;
- (UIImage*)makeStretchForSegmentRight;

- (UIImage*)makeStretchForNavigationBar;
- (UIImage*)makeStretchForNavigationItem;
- (UIImage*)makeStretchForSearchBar;

- (UIImage*)t:(CGFloat)top l:(CGFloat)left b:(CGFloat)bottom r:(CGFloat)right;

@end
