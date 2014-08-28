//
//  XXSearchBar.m
//  SearchBar
//
//  Created by ZYVincent on 13-12-23.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "XXSearchBar.h"

@implementation XXSearchBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [XXCommonStyle xxThemeDarkBlueColor];
        
        self.placeHoldString = @"请输入学校关键字";
        
        backgroundImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,frame.size.width,frame.size.height)];
        backgroundImageView.image = [[UIImage imageNamed:@"search_bar_back.png"]makeStretchForSearchBar];
        [self addSubview:backgroundImageView];
        
        self.contentTextField = [[UITextField alloc]initWithFrame:CGRectMake(8,5,frame.size.width-8,frame.size.height-10)];
        [self addSubview:self.contentTextField];
        self.contentTextField.placeholder = self.placeHoldString;
        self.contentTextField.delegate = self;
        self.contentTextField.returnKeyType = UIReturnKeySearch;
        self.contentTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.contentTextField.textColor = [UIColor whiteColor];
        
        rightIconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width-16-8-4,12,16,17)];
        rightIconImageView.image = [UIImage imageNamed:@"search_icon.png"];
        [self addSubview:rightIconImageView];
        rightIconImageView.hidden = NO;
        
        //
        deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteBtn.frame = CGRectMake(frame.size.width-23-8,7,23,23);
        [deleteBtn setBackgroundImage:[UIImage imageNamed:@"search_bar_delete.png"] forState:UIControlStateNormal];
        [deleteBtn addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:deleteBtn];
        deleteBtn.hidden = YES;//default
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(searchInputValueChanged:) name:UITextFieldTextDidChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(searchInputBeginEdit:) name:UITextFieldTextDidBeginEditingNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(searchInputEndEdit:) name:UITextFieldTextDidEndEditingNotification object:nil];
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
- (void)setBeginSearchBlock:(XXSearchBarDidBeginSearchBlock)beginBlock
{
    _beginBlock = [beginBlock copy];
}
- (void)setValueChangedBlock:(XXSearchBarValueChangeBlock)valueChangeBlock
{
    _valueChangeBlock = [valueChangeBlock copy];
}
- (void)setSearchBlock:(XXSearchBarFinishSearchBlock)searchBlock
{
    _searchBlock = [searchBlock copy];
}

//不允许全部为空
+ (BOOL)formValidateIsAllSpace:(NSString*)sourceString
{
    BOOL status = YES;
    int postion = 0;
    while (postion<=sourceString.length-1) {
        
        NSString *subChar = [sourceString substringWithRange:NSMakeRange(postion,1)];
        if (![subChar isEqualToString:@" "]) {
            status = NO;
            break;
        }
        postion++;
    }
    return status;
}

- (void)searchInputBeginEdit:(NSNotification*)noti
{
    rightIconImageView.hidden=YES;
    if (self.contentTextField.text.length>0) {
        deleteBtn.hidden = NO;
    }else{
        deleteBtn.hidden = YES;
    }
    if (_beginBlock) {
        _beginBlock();
    }
}
- (void)searchInputEndEdit:(NSNotification*)noti
{
    rightIconImageView.hidden = NO;
    rightIconImageView.frame = CGRectMake(self.frame.size.width-16-8,10,16,17);
}

- (void)searchInputValueChanged:(NSNotification*)noti
{
    if (_valueChangeBlock ) {
        if (self.contentTextField.text.length>0) {
            self.searchText = self.contentTextField.text;
            _valueChangeBlock(YES,self.contentTextField.text);
            deleteBtn.hidden = NO;
            rightIconImageView.hidden = YES;
        }else{
            rightIconImageView.hidden = NO;
            deleteBtn.hidden = YES;
        }
    }
}
#pragma mark - textfield delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (![textField.text isEqualToString:@""]) {
        [textField resignFirstResponder];
        if (_searchBlock) {
            _searchBlock(textField.text);
        }
        return YES;
    }else{
        return NO;
    }
}
- (void)finishChooseWithNameText:(NSString *)name
{
    [self.contentTextField resignFirstResponder];
    self.contentTextField.text = name;
    self.searchText = name;
    rightIconImageView.hidden = NO;
    deleteBtn.hidden = YES;
    rightIconImageView.frame = CGRectMake(self.frame.size.width-23-8,10,23,23);
    rightIconImageView.image = [UIImage imageNamed:@"blue_right_selected.png"];
}
- (void)deleteAction
{
    self.contentTextField.text = @"";
}

@end
