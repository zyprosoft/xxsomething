//
//  XXRadioChooseViewController.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXRadioChooseView.h"

/*
 *通用多选择Radio视图
 */
typedef void (^XXRadioChooseViewControllerFinishBlock) (NSString *resultString);

@interface XXRadioChooseViewController : UIViewController
{
    XXRadioChooseView *_chooseView;
    NSMutableArray    *_titleArray;
    XXRadioChooseViewControllerFinishBlock _finishBlock;
    XXRadioChooseType _chooseType;
    NSString          *_defaultValue;
}
- (id)initWithConfigArray:(NSArray*)configArray withRadioChooseType:(XXRadioChooseType)chooseType withFinishBlock:(XXRadioChooseViewControllerFinishBlock)finishBlock withDefaultValue:(NSString*)value;
- (NSString*)finialChooseString;

@end
