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
NSInteger const XXItemBarIconTopMargin = 5.f;

#define XXItemBarSelectTitleColor [UIColor blueColor]
#define XXItemBarUnselectTitleColor [UIColor whiteColor]
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

- (void)setItemTapSelectBlock:(XXCustomTabBarItemTapSelectBlock)selectBlock;

- (id)initWithFrame:(CGRect)frame withSelectIcon:(NSString*)sIcon withNormalIcon:(NSString*)nIcon withTitle:(NSString*)aTitle;

- (void)switchToSelected;
- (void)switchToNormal;

@end

@implementation XXCustomTabBarItem

- (id)initWithFrame:(CGRect)frame withSelectIcon:(NSString *)sIcon withNormalIcon:(NSString *)nIcon withTitle:(NSString *)aTitle
{
    if (self = [super initWithFrame:frame]) {
        
        self.iconNormal = nIcon;
        self.iconSelected = sIcon;
        
        UIImage *normalIcon = [UIImage imageNamed:self.iconNormal];
        CGSize iconSize = normalIcon.size;
        
        CGFloat leftMargin = (frame.size.width-iconSize.width)/2;
        
        self.backgroundView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,frame.size.width,frame.size.height)];
        [self addSubview:self.backgroundView];
        self.backgroundView.image = [UIImage imageNamed:XXBarItemBackNormal];
        
        self.iconImageView = [[UIImageView alloc]init];
        self.iconImageView.frame = CGRectMake(leftMargin,XXItemBarIconTopMargin,iconSize.width,iconSize.height);
        [self addSubview:self.iconImageView];
        self.iconImageView.image = [UIImage imageNamed:nIcon];
        
        self.titleLabel = [[UILabel alloc]init];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.frame = CGRectMake(0,self.iconImageView.frame.origin.y+self.iconImageView.frame.size.height,self.frame.size.width,self.frame.size.height-self.iconImageView.frame.size.height-2*XXItemBarIconTopMargin);
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.text = aTitle;
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
    self.titleLabel.textColor = XXItemBarUnselectTitleColor;
    self.iconImageView.image = [UIImage imageNamed:self.iconNormal];
    self.backgroundView.image = [UIImage imageNamed:XXBarItemBackNormal];
}
- (void)switchToSelected
{
    self.titleLabel.textColor = XXItemBarSelectTitleColor;
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
                
                XXCustomTabBarItem *barItem = [[XXCustomTabBarItem alloc]initWithFrame:itemRect withSelectIcon:[item objectForKey:XXBarItemSelectIconKey] withNormalIcon:[item objectForKey:XXBarItemNormalIconKey] withTitle:[item objectForKey:XXBarItemTitleKey]];
                barItem.tag = XXItemBarItemBaseTag+i;
                [self addSubview:barItem];
                
                //selectAction
                [barItem setItemTapSelectBlock:^(XXCustomTabBarItem *selectItem) {
                   
                    self.selectedIndex = selectItem.tag-XXItemBarItemBaseTag;
                    if (_selectBlock) {
                        _selectBlock(self.selectedIndex);
                    }
                    
                }];
                
                if (i==0) {
                    [barItem switchToSelected];
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


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
