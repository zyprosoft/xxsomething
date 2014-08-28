//
//  XXCustomTabBar.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-17.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

#define XXBarItemNormalIconKey @"XXBarItemNormalIconKey"
#define XXBarItemSelectIconKey @"XXBarItemSelectIconKey"
#define XXBarItemTitleKey @"XXBarItemTitleKey"
#define XXBarItemTitleNormalColorKey @"XXBarItemTitleNormalColorKey"
#define XXBarItemTitleSelectColorKey @"XXBarItemTitleSelectColorKey"

//configArray  @{XXBarItemNormalIconKey:xxx.png,XXBarItemSelectIconKey:xxx.png,XXBarItemTitleKey:xxx,XXBarItemTitleNormalColorKey:@"",XXBarItemTitleSelectColorKey:@""}

typedef void (^XXCustomTabBarDidSelectIndexBlock) (NSInteger index);

@interface XXCustomTabBar : UIView
{
    XXCustomTabBarDidSelectIndexBlock _selectBlock;
}
@property (nonatomic,assign)NSInteger selectedIndex;

- (id)initWithFrame:(CGRect)frame withConfigArray:(NSArray*)configArray;

- (void)setTabBarDidSelectAtIndexBlock:(XXCustomTabBarDidSelectIndexBlock)selectBlock;

- (void)setSelectAtIndex:(NSInteger)index;

@end
