//
//  XXActionSheetView.h
//  XiaoXiao
//
//  Created by ZYVincent on 14-1-6.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^XXActionSheetViewDidChooseIndexBlock) (BOOL checkState);

@interface XXActionSheetView : UIView
{
    XXActionSheetViewDidChooseIndexBlock _chooseBlock;
}

- (id)initWithFrame:(CGRect)frame withTitle:(NSString*)title;

- (void)setFinishChooseIndexBlock:(XXActionSheetViewDidChooseIndexBlock)chooseBlock;
@end
