//
//  XXRadioChooseView.h
//  XXSegmentControl
//
//  Created by ZYVincent on 13-12-24.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    XXRadioChooseTypeClonumTwo=0,
    XXRadioChooseTypeClonumThree,
}XXRadioChooseType;

//ConfigArray   @[@{@"title":@"xxx",@"value":@"",@"normalBack":@"xxx",@"selectBack":@"xxx",@"normalColor":@"xxxx",@"selectColor":@"xxx"}]

@interface XXRadioChooseView : UIView
@property (nonatomic,assign)NSInteger selectIndex;

- (id)initWithFrame:(CGRect)frame withConfigArray:(NSArray*)configArray withChooseType:(XXRadioChooseType)type withDefaultSelectValue:(NSString*)value;

@end
