//
//  XXActionSheetView.m
//  XiaoXiao
//
//  Created by ZYVincent on 14-1-6.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "XXActionSheetView.h"

@implementation XXActionSheetView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        UIImageView *backgroundView = [[UIImageView alloc]init];
        backgroundView.backgroundColor = [UIColor blackColor];
        backgroundView.alpha = 0.5;
        backgroundView.frame = CGRectMake(0,0,frame.size.width,frame.size.height);
        [self addSubview:backgroundView];
        
        UIButton *checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
        checkButton.frame = CGRectMake(40,30,frame.size.width-80,40);
        [self addSubview:checkButton];
        checkButton.layer.cornerRadius = 6.0f;
        checkButton.tag = 77660;
        checkButton.backgroundColor = [XXCommonStyle xxThemeBlueColor];
        [checkButton setTitle:@"确定" forState:UIControlStateNormal];
        [checkButton addTarget:self action:@selector(chooseAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:checkButton];
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = CGRectMake(40,95,frame.size.width-80,40);
        cancelButton.layer.cornerRadius = 6.0f;
        cancelButton.tag = 77661;
        cancelButton.backgroundColor = [XXCommonStyle xxThemeRedColor];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(chooseAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelButton];
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame withTitle:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        UIImageView *backgroundView = [[UIImageView alloc]init];
        backgroundView.backgroundColor = [UIColor blackColor];
        backgroundView.alpha = 0.5;
        backgroundView.frame = CGRectMake(0,0,frame.size.width,frame.size.height);
        [self addSubview:backgroundView];
        
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.frame = CGRectMake(0,0,frame.size.height,30);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.text = title;
        [self addSubview:titleLabel];
        
        UIButton *checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
        checkButton.frame = CGRectMake(40,30,frame.size.width-80,40);
        [checkButton blueStyle];
        [self addSubview:checkButton];
        checkButton.layer.cornerRadius = 6.0f;
        checkButton.tag = 77660;
        [checkButton setTitle:@"确定" forState:UIControlStateNormal];
        [checkButton addTarget:self action:@selector(chooseAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:checkButton];
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = CGRectMake(40,95,frame.size.width-80,40);
        [cancelButton redStyle];
        cancelButton.layer.cornerRadius = 6.0f;
        cancelButton.tag = 77661;
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(chooseAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelButton];
        
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
- (void)chooseAction:(UIButton*)sender
{
    if (sender.tag==77660) {
        if (_chooseBlock) {
            _chooseBlock(YES);
        }
    }
    if (sender.tag==77661) {
        if (_chooseBlock) {
            _chooseBlock(NO);
        }
    }
}

- (void)setFinishChooseIndexBlock:(XXActionSheetViewDidChooseIndexBlock)chooseBlock
{
    _chooseBlock = [chooseBlock copy];
}

@end
