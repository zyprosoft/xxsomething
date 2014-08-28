//
//  OtherTeaseCell.h
//  NavigationTest
//
//  Created by ZYVincent on 14-1-16.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OtherTeaseCell;
typedef void (^OtherTeaseCellDidSelectBlock) (OtherTeaseCell *tapCell,NSInteger selectIndex);

@interface OtherTeaseCell : UITableViewCell
{
    UIImageView *_teaseLeftImgView;
    UIImageView *_teaseMiddelImgView;
    UIImageView *_teaseRightImgView;
    OtherTeaseCellDidSelectBlock _selectBlock;
}

- (void)setTeaseImages:(NSArray*)teaseImages;
- (void)setTeaseSelectBlock:(OtherTeaseCellDidSelectBlock)selectBlock;

@end
