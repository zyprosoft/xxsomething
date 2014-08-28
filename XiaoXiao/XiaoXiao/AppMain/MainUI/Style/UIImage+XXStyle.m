//
//  UIImage+XXStyle.m
//  NavigationTest
//
//  Created by ZYVincent on 14-1-17.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "UIImage+XXStyle.h"

@implementation UIImage (XXStyle)

- (UIImage*)makeStretchWithEdegeInsets:(UIEdgeInsets)edgeInsets
{
    return [self resizableImageWithCapInsets:edgeInsets resizingMode:UIImageResizingModeStretch];
}
- (UIImage*)makeStretchForBubbleLeft
{
    UIEdgeInsets bLeft = UIEdgeInsetsMake(33.f,23.f,10.f,10.f);
    return [self makeStretchWithEdegeInsets:bLeft];
}
- (UIImage*)makeStretchForBubbleRight
{
    UIEdgeInsets bRight = UIEdgeInsetsMake(33.f,10.f,10.f,23.f);
    return [self makeStretchWithEdegeInsets:bRight];
}
- (UIImage*)makeStretchForBubbleLeftVertical
{
    UIEdgeInsets bLeft = UIEdgeInsetsMake(0.f,15.f,0.f,5.f);
    return [self makeStretchWithEdegeInsets:bLeft];
}
- (UIImage*)makeStretchForBubbleRightVertical
{
    UIEdgeInsets bRight = UIEdgeInsetsMake(0.f,5.f,0.f,15.f);
    return [self makeStretchWithEdegeInsets:bRight];
}
- (UIImage*)makeStretchForSingleRoundCell
{
    UIEdgeInsets sCell = UIEdgeInsetsMake(0.f,30.f,0.f,30.f);
    return [self makeStretchWithEdegeInsets:sCell];
}
- (UIImage*)makeStretchForSingleCornerCell
{
    UIEdgeInsets sCCell = UIEdgeInsetsMake(0.f,30.f,0.f,30.f);
    return [self makeStretchWithEdegeInsets:sCCell];
}
- (UIImage*)makeStretchForCellTop
{
    UIEdgeInsets cellTop = UIEdgeInsetsMake(3.f,5.f,3.f,5.f);
    return [self makeStretchWithEdegeInsets:cellTop];
}
- (UIImage*)makeStretchForCellMiddle
{
    UIEdgeInsets cellMiddle = UIEdgeInsetsMake(5.f,5.f,5.f,5.f);
    return [self makeStretchWithEdegeInsets:cellMiddle];
}
- (UIImage*)makeStretchForCellBottom
{
    UIEdgeInsets cellBottom = UIEdgeInsetsMake(3.f,5.f,3.f,5.f);
    return [self makeStretchWithEdegeInsets:cellBottom];
}
- (UIImage*)makeStretchForSharePostList
{
    UIEdgeInsets shareList = UIEdgeInsetsMake(5.f,5.f,5.f,5.f);
    return [self makeStretchWithEdegeInsets:shareList];
}

- (UIImage*)makeStretchForSharePostDetail
{
    UIEdgeInsets shareListDetail = UIEdgeInsetsMake(5.f,5.f,3.f,5.f);
    return [self makeStretchWithEdegeInsets:shareListDetail];
}
- (UIImage*)makeStretchForSharePostDetailMiddle
{
    UIEdgeInsets shareListDetailMiddle = UIEdgeInsetsMake(3.f,3.f,3.f,3.f);
    return [self makeStretchWithEdegeInsets:shareListDetailMiddle];
}
- (UIImage*)makeStretchForSharePostDetailBottom
{
    UIEdgeInsets shareListDetailBottom = UIEdgeInsetsMake(3.f,3.f,5.f,3.f);
    return [self makeStretchWithEdegeInsets:shareListDetailBottom];
}

- (UIImage*)makeStretchForSegmentLeft
{
    UIEdgeInsets shareListDetailBottom = UIEdgeInsetsMake(3.f,6.f,3.f,3.f);
    return [self makeStretchWithEdegeInsets:shareListDetailBottom];

}
- (UIImage*)makeStretchForSegmentMiddle
{
    UIEdgeInsets shareListDetailBottom = UIEdgeInsetsMake(3.f,3.f,3.f,3.f);
    return [self makeStretchWithEdegeInsets:shareListDetailBottom];

}
- (UIImage*)makeStretchForSegmentRight
{
    UIEdgeInsets shareListDetailBottom = UIEdgeInsetsMake(3.f,3.f,3.f,6.f);
    return [self makeStretchWithEdegeInsets:shareListDetailBottom];

}

- (UIImage*)makeStretchForNavigationBar
{
    UIEdgeInsets navBar = UIEdgeInsetsMake(0,1,0,0);
    
    return [self makeStretchWithEdegeInsets:navBar];
}
- (UIImage*)makeStretchForNavigationItem
{
    UIEdgeInsets navBar = UIEdgeInsetsMake(3,3,3,3);
    
    return [self makeStretchWithEdegeInsets:navBar];
}
- (UIImage*)makeStretchForSearchBar
{
    UIEdgeInsets navBar = UIEdgeInsetsMake(0,20,0,20);
    
    return [self makeStretchWithEdegeInsets:navBar];
}
- (UIImage*)t:(CGFloat)top l:(CGFloat)left b:(CGFloat)bottom r:(CGFloat)right
{
    UIEdgeInsets navBar = UIEdgeInsetsMake(top,left,bottom,right);
    
    return [self makeStretchWithEdegeInsets:navBar];
}

@end
