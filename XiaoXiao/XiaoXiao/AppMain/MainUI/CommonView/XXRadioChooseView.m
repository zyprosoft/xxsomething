//
//  XXRadioChooseView.m
//  XXSegmentControl
//
//  Created by ZYVincent on 13-12-24.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "XXRadioChooseView.h"

@class XXRadioChooseItem;
typedef void (^XXRadioChooseItemSelectBlock) (XXRadioChooseItem *selectItem);

@interface XXRadioChooseItem : UIControl
{
    XXRadioChooseItemSelectBlock _selectBlock;
}
@property (nonatomic,strong)UIImageView *iconImageView;
@property (nonatomic,strong)UILabel     *titleLabel;
@property (nonatomic,strong)NSString *normalBack;
@property (nonatomic,strong)NSString *selectBack;
@property (nonatomic,strong)UIColor *selectColor;
@property (nonatomic,strong)UIColor *normalColor;
- (id)initWithFrame:(CGRect)frame withTitle:(NSString*)title withBackgroundImage:(NSString*)bImage withSelectBackgroundImage:(NSString*)selectImage withSelectTitleColor:(UIColor*)sColor withNormalTitleColor:(UIColor*)nColor;
- (void)setSelectedBlock:(XXRadioChooseItemSelectBlock)selectBlock;
- (void)switchSelectState;
- (void)switchNormalState;
@end
@implementation XXRadioChooseItem
- (id)initWithFrame:(CGRect)frame withTitle:(NSString *)title withBackgroundImage:(NSString *)bImage withSelectBackgroundImage:(NSString *)selectImage withSelectTitleColor:(UIColor *)sColor withNormalTitleColor:(UIColor *)nColor
{
    if (self=[super initWithFrame:frame]) {
#define XXRaidoTitleFontSize 11
#define XXRaidoIconWidth     20
        
        self.normalBack = bImage;
        self.selectBack = selectImage;
        self.selectColor = sColor;
        self.normalColor = nColor;
        
        self.iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,XXRaidoIconWidth,XXRaidoIconWidth)];
        self.iconImageView.image = [UIImage imageNamed:self.normalBack];
        [self addSubview:self.iconImageView];
        
        self.titleLabel = [[UILabel alloc]init];
        self.titleLabel.frame = CGRectMake(XXRaidoIconWidth+8,0,frame.size.width-XXRaidoIconWidth-8,frame.size.height);
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.textColor = self.normalColor;
        self.titleLabel.font = [UIFont systemFontOfSize:XXRaidoTitleFontSize];
        self.titleLabel.text = title;
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:self.titleLabel];
        
        [self addTarget:self action:@selector(tapSelectAction) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}
- (void)switchSelectState
{
    self.iconImageView.image = [UIImage imageNamed:self.selectBack];
    self.titleLabel.textColor = self.selectColor;
}
- (void)switchNormalState
{
    self.iconImageView.image = [UIImage imageNamed:self.normalBack];
    self.titleLabel.textColor=self.normalColor;
}
- (void)setSelectedBlock:(XXRadioChooseItemSelectBlock)selectBlock
{
    _selectBlock = [selectBlock copy];
}
- (void)tapSelectAction
{
    if (_selectBlock) {
        _selectBlock(self);
    }
}
@end

@implementation XXRadioChooseView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame withConfigArray:(NSArray*)configArray withChooseType:(XXRadioChooseType)type withDefaultSelectValue:(NSString *)value
{
    self = [super initWithFrame:frame];
    if (self) {
#define XXChooseRadioItemBaseTag 9970080
        
        
        CGFloat itemWidth = 90.f;
        CGFloat itemMargin = 30.0f;
        CGFloat itemTopMargin = 30.f;
        NSInteger rowCount = 0;
        CGFloat rowHeight = 23.f;
        switch (type) {
            case XXRadioChooseTypeClonumTwo:
            {
                itemMargin = (frame.size.width-2*90)/3;
                rowCount = configArray.count/2+1;
                
            }
                break;
            case XXRadioChooseTypeClonumThree:
            {
                itemWidth = (frame.size.width-2*itemMargin)/3;
                rowCount = configArray.count/3+1;
            }
                break;
            default:
                break;
        }
//        rowHeight = (frame.size.height-rowCount*itemTopMargin)/rowCount;

        
        [configArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
           
            switch (type) {
                case XXRadioChooseTypeClonumTwo:
                {
                    NSInteger cloumIndex = idx%2;
                    NSInteger rowIndex = (int)((idx)/2);
                    CGFloat originX = itemMargin*(cloumIndex+1)+cloumIndex*itemWidth;
                    CGFloat originY = itemTopMargin*(rowIndex+1)+rowIndex*rowHeight;
                    CGRect itemRect = CGRectMake(originX,originY,itemWidth,rowHeight);
                    
                    NSDictionary *item = (NSDictionary*)obj;
                    NSString *normalBack = [item objectForKey:@"normalBack"];
                    NSString *selectBack = [item objectForKey:@"selectBack"];
                    NSString *title = [item objectForKey:@"title"];
                    UIColor *normalColor = [item objectForKey:@"normalColor"];
                    UIColor *selectColor = [item objectForKey:@"selectColor"];
                    
                    XXRadioChooseItem *newItem = [[XXRadioChooseItem alloc]initWithFrame:itemRect withTitle:title withBackgroundImage:normalBack withSelectBackgroundImage:selectBack withSelectTitleColor:selectColor withNormalTitleColor:normalColor];
                    newItem.tag = idx+XXChooseRadioItemBaseTag;
                    [newItem setSelectedBlock:^(XXRadioChooseItem *selectItem) {
                        XXRadioChooseItem *currentSelectItem = (XXRadioChooseItem*)[self viewWithTag:XXChooseRadioItemBaseTag+self.selectIndex];
                        [currentSelectItem switchNormalState];
                        self.selectIndex = selectItem.tag-XXChooseRadioItemBaseTag;
                        [selectItem switchSelectState];
                    }];
                    if ([title isEqualToString:value]) {
                        self.selectIndex = idx;
                        [newItem switchSelectState];
                    }
                    if (idx==0&&(value==nil||[value isEqualToString:@""])) {
                        [newItem switchSelectState];
                        self.selectIndex = 0;
                    }
                    [self addSubview:newItem];
                
                }
                    break;
                case XXRadioChooseTypeClonumThree:
                {
                    NSInteger cloumIndex = idx%3;
                    NSInteger rowIndex = (int)((idx)/3);
                    CGFloat originX = itemMargin*cloumIndex+cloumIndex*itemWidth;
                    CGFloat originY = itemTopMargin*rowIndex+rowIndex*rowHeight;
                    CGRect itemRect = CGRectMake(originX,originY,itemWidth,rowHeight);

                    NSDictionary *item = (NSDictionary*)obj;
                    NSString *normalBack = [item objectForKey:@"normalBack"];
                    NSString *selectBack = [item objectForKey:@"selectBack"];
                    NSString *title = [item objectForKey:@"title"];
                    
                    UIColor *normalColor = [item objectForKey:@"normalColor"];
                    UIColor *selectColor = [item objectForKey:@"selectColor"];
                    
                    XXRadioChooseItem *newItem = [[XXRadioChooseItem alloc]initWithFrame:itemRect withTitle:title withBackgroundImage:normalBack withSelectBackgroundImage:selectBack withSelectTitleColor:selectColor withNormalTitleColor:normalColor];
                    newItem.tag = idx+XXChooseRadioItemBaseTag;
                    [newItem setSelectedBlock:^(XXRadioChooseItem *selectItem) {
                        XXRadioChooseItem *currentSelectItem = (XXRadioChooseItem*)[self viewWithTag:XXChooseRadioItemBaseTag+self.selectIndex];
                        [currentSelectItem switchNormalState];
                        self.selectIndex = selectItem.tag-XXChooseRadioItemBaseTag;
                        [selectItem switchSelectState];
                    }];
                    if ([title isEqualToString:value]) {
                        self.selectIndex = idx;
                        [newItem switchSelectState];
                    }
                    if (idx==0&&(value==nil||[value isEqualToString:@""])) {
                        [newItem switchSelectState];
                        self.selectIndex = 0;
                    }
                    [self addSubview:newItem];
                }
                    break;
                default:
                    break;
            }
            
        }];
        
        
        
    }
    return self;
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
