//
//  XXSegmentControl.m
//  XXSegmentControl
//
//  Created by ZYVincent on 13-12-24.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "XXSegmentControl.h"

@class XXSegmentControlItem;
typedef void (^XXSegmentControlItemSelectBlock) (XXSegmentControlItem *selectItem);

@interface XXSegmentControlItem : UIControl
{
    XXSegmentControlItemSelectBlock _selectBlock;
}
@property (nonatomic,strong)UIImageView *backImageView;
@property (nonatomic,strong)UILabel     *titleLabel;
@property (nonatomic,strong)NSString *normalBack;
@property (nonatomic,strong)NSString *selectBack;
@property (nonatomic,strong)UIColor *selectColor;
@property (nonatomic,strong)UIColor *normalColor;
- (id)initWithFrame:(CGRect)frame withTitle:(NSString*)title withBackgroundImage:(NSString*)bImage withSelectBackgroundImage:(NSString*)selectImage withSelectTitleColor:(UIColor*)sColor withNormalTitleColor:(UIColor*)nColor;
- (void)setSelectedBlock:(XXSegmentControlItemSelectBlock)selectBlock;
- (void)switchSelectState;
- (void)switchNormalState;
@end

@implementation XXSegmentControlItem
- (id)initWithFrame:(CGRect)frame withTitle:(NSString *)title withBackgroundImage:(NSString *)bImage withSelectBackgroundImage:(NSString *)selectImage withSelectTitleColor:(UIColor *)sColor withNormalTitleColor:(UIColor *)nColor
{
    if (self=[super initWithFrame:frame]) {
        
        self.normalBack = bImage;
        self.selectBack = selectImage;
        self.selectColor = sColor;
        self.normalColor = nColor;
        
        self.backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,frame.size.width,frame.size.height)];
        self.backImageView.image = [UIImage imageNamed:self.normalBack];
        [self addSubview:self.backImageView];
        
        self.titleLabel = [[UILabel alloc]init];
        self.titleLabel.frame = CGRectMake(0,0,frame.size.width,frame.size.height);
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.textColor = self.normalColor;
        self.titleLabel.text = title;
        self.titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.titleLabel];
        
        [self addTarget:self action:@selector(tapSelectAction) forControlEvents:UIControlEventTouchUpInside];

    }
    return self;
}
- (void)switchSelectState
{
    self.backImageView.image = [UIImage imageNamed:self.selectBack];
    self.titleLabel.textColor = self.selectColor;
}
- (void)switchNormalState
{
    self.backImageView.image = [UIImage imageNamed:self.normalBack];
    self.titleLabel.textColor=self.normalColor;
}
- (void)setSelectedBlock:(XXSegmentControlItemSelectBlock)selectBlock
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

@implementation XXSegmentControl

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
#define XXSegmentBaseItemTag 88990070
        
        CGFloat itemWidth = frame.size.width/configArray.count;
        for (int i=0; i<configArray.count; i++) {
            
            CGRect itemRect = CGRectMake(itemWidth*i,0,itemWidth,frame.size.height);
            NSDictionary *item = [configArray objectAtIndex:i];
            NSString *normalBack = [item objectForKey:@"normalBack"];
            NSString *selectBack = [item objectForKey:@"selectBack"];
            NSString *title = [item objectForKey:@"title"];
            UIColor *normalColor = [item objectForKey:@"normalColor"];
            UIColor *selectColor = [item objectForKey:@"selectColor"];
            
            XXSegmentControlItem *segItem = [[XXSegmentControlItem alloc]initWithFrame:itemRect withTitle:title withBackgroundImage:normalBack withSelectBackgroundImage:selectBack withSelectTitleColor:selectColor withNormalTitleColor:normalColor];
            segItem.tag = XXSegmentBaseItemTag+i;
            [self addSubview:segItem];
            
            //tap
            [segItem setSelectedBlock:^(XXSegmentControlItem *selectItem) {
                XXSegmentControlItem *lastSelect = (XXSegmentControlItem*)[self viewWithTag:XXSegmentBaseItemTag+self.selectIndex];
                [lastSelect switchNormalState];
                self.selectIndex = selectItem.tag-XXSegmentBaseItemTag;
                [selectItem switchSelectState];
            }];
            
            if (i==0) {
                [segItem switchSelectState];
                self.selectIndex = 0;
            }
            
            
        }
        
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
