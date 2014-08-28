//
//  XXCustomTabBar.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-17.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "XXCustomTabBar.h"

NSString *const XXBarItemBackNormal = @"";
NSString *const XXBarItemBackSelected = @"";
NSInteger const XXItemBarIconTopMargin = 0.f;

#define XXItemBarSelectTitleColor [UIColor blackColor]
#define XXItemBarUnselectTitleColor [UIColor lightGrayColor]
#define XXItemBarItemBaseTag 2222330

@class XXCustomTabBarItem;
typedef void (^XXCustomTabBarItemTapSelectBlock) (XXCustomTabBarItem *selectItem);

@interface XXCustomTabBarItem : UIControl
{
    XXCustomTabBarItemTapSelectBlock _selectBlock;
}
@property (nonatomic,strong)UIImageView *iconImageView;
@property (nonatomic,strong)UIImageView *backgroundView;
@property (nonatomic,strong)UIImageView *remindPotView;
@property (nonatomic,strong)UILabel     *titleLabel;
@property (nonatomic,strong)NSString *iconNormal;
@property (nonatomic,strong)NSString *iconSelected;
@property (nonatomic,assign)BOOL hasNewState;
@property (nonatomic,strong)UIColor *titleNormalColor;
@property (nonatomic,strong)UIColor *titleSelectColor;

- (void)setItemTapSelectBlock:(XXCustomTabBarItemTapSelectBlock)selectBlock;

- (id)initWithFrame:(CGRect)frame withSelectIcon:(NSString*)sIcon withNormalIcon:(NSString*)nIcon withTitle:(NSString*)aTitle withNormalTitleColor:(UIColor *)normalColor withSelectTitleColor:(UIColor*)selectColor;

- (void)switchToSelected;
- (void)switchToNormal;

@end

@implementation XXCustomTabBarItem

- (id)initWithFrame:(CGRect)frame withSelectIcon:(NSString *)sIcon withNormalIcon:(NSString *)nIcon withTitle:(NSString *)aTitle withNormalTitleColor:(UIColor *)normalColor withSelectTitleColor:(UIColor *)selectColor
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.iconNormal = nIcon;
        self.iconSelected = sIcon;
        self.titleNormalColor = normalColor;
        self.titleSelectColor = selectColor;
        
        
        CGFloat leftMargin = 0.f;
        
        self.backgroundView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,frame.size.width,frame.size.height)];
        [self addSubview:self.backgroundView];
        self.backgroundView.image = [UIImage imageNamed:XXBarItemBackNormal];
        
        self.iconImageView = [[UIImageView alloc]init];
        self.iconImageView.frame = CGRectMake(leftMargin,XXItemBarIconTopMargin,frame.size.width,frame.size.height);
        [self addSubview:self.iconImageView];
        UIImage *normalIcon = [UIImage imageNamed:self.iconNormal];
        self.iconImageView.image = normalIcon;
        
        self.titleLabel = [[UILabel alloc]init];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.frame = CGRectMake(0,0,self.frame.size.width,self.frame.size.height);
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.text = aTitle;
        self.titleLabel.textColor = [UIColor blackColor];
        [self addSubview:self.titleLabel];
        
        [self addTarget:self action:@selector(didTapOnItem) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)setItemTapSelectBlock:(XXCustomTabBarItemTapSelectBlock)selectBlock
{
    _selectBlock = [selectBlock copy];
}

#pragma mark -tap item
- (void)didTapOnItem
{
    if (_selectBlock) {
        _selectBlock(self);
    }
}

- (void)switchToNormal
{
    self.titleLabel.textColor = self.titleNormalColor;
    self.iconImageView.image = [UIImage imageNamed:self.iconNormal];
    self.backgroundView.image = [UIImage imageNamed:XXBarItemBackNormal];
}
- (void)switchToSelected
{
    self.titleLabel.textColor = self.titleSelectColor;
    self.iconImageView.image = [UIImage imageNamed:self.iconSelected];
    self.backgroundView.image = [UIImage imageNamed:XXBarItemBackSelected];
}

@end

@implementation XXCustomTabBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame withConfigArray:(NSArray *)configArray
{
    if (self = [super initWithFrame:frame]) {
        
        if (configArray.count>0) {
            
            CGFloat itemWidth = frame.size.width/configArray.count;
            
            for (int i=0; i<configArray.count;i++) {
                
                NSDictionary *item = [configArray objectAtIndex:i];
                
                CGRect itemRect = CGRectMake(itemWidth*i,0,itemWidth,frame.size.height);
                
                UIColor *titleNormaColor = [UIColor lightGrayColor];
                UIColor *titleSelectColor = [UIColor blackColor];
                if ([item objectForKey:XXBarItemTitleNormalColorKey]) {
                    titleNormaColor = [item objectForKey:XXBarItemTitleNormalColorKey];
                }
                if ([item objectForKey:XXBarItemTitleSelectColorKey]) {
                    titleSelectColor = [item objectForKey:XXBarItemTitleSelectColorKey];
                }
                
                XXCustomTabBarItem *barItem = [[XXCustomTabBarItem alloc]initWithFrame:itemRect withSelectIcon:[item objectForKey:XXBarItemSelectIconKey] withNormalIcon:[item objectForKey:XXBarItemNormalIconKey] withTitle:[item objectForKey:XXBarItemTitleKey] withNormalTitleColor:titleNormaColor withSelectTitleColor:titleSelectColor];
                barItem.tag = XXItemBarItemBaseTag+i;
                [self addSubview:barItem];
                
                //selectAction
                [barItem setItemTapSelectBlock:^(XXCustomTabBarItem *selectItem) {
                   
                    XXCustomTabBarItem *unSelectedItem = (XXCustomTabBarItem*)[self viewWithTag:XXItemBarItemBaseTag+self.selectedIndex];
                    [unSelectedItem switchToNormal];
                    
                    self.selectedIndex = selectItem.tag-XXItemBarItemBaseTag;
                    [selectItem switchToSelected];
                    if (_selectBlock) {
                        _selectBlock(self.selectedIndex);
                    }
                    
                }];
                
                if (i==0) {
                    [barItem switchToSelected];
                }else{
                    [barItem switchToNormal];
                }
                
            }
        }
        
        
    }
    return self;
}

- (void)setTabBarDidSelectAtIndexBlock:(XXCustomTabBarDidSelectIndexBlock)selectBlock
{
    _selectBlock = [selectBlock copy];
}

- (void)setSelectAtIndex:(NSInteger)index
{
    XXCustomTabBarItem *unSelectedItem = (XXCustomTabBarItem*)[self viewWithTag:XXItemBarItemBaseTag+self.selectedIndex];
    [unSelectedItem switchToNormal];
    
    XXCustomTabBarItem *selectItem = (XXCustomTabBarItem*)[self viewWithTag:XXItemBarItemBaseTag+index];
    self.selectedIndex = index;
    [selectItem switchToSelected];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
