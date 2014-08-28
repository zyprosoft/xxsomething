//
//  XXSearchBar.h
//  SearchBar
//
//  Created by ZYVincent on 13-12-23.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^XXSearchBarDidBeginSearchBlock) (void);
typedef void (^XXSearchBarValueChangeBlock) (BOOL canEnableNextStep,NSString *msg);
typedef void (^XXSearchBarFinishSearchBlock) (NSString *searchText);

@interface XXSearchBar : UIView<UITextFieldDelegate>
{
    UIImageView *backgroundImageView;
    UIImageView *rightIconImageView;
    UIButton    *deleteBtn;
    
    XXSearchBarDidBeginSearchBlock _beginBlock;
    XXSearchBarValueChangeBlock _valueChangeBlock;
    XXSearchBarFinishSearchBlock _searchBlock;
}
@property (nonatomic,strong)NSString *searchText;
@property (nonatomic,strong)NSString *placeHoldString;
@property (nonatomic,strong)UITextField *contentTextField;

+ (BOOL)formValidateIsAllSpace:(NSString*)sourceString;

- (void)setBeginSearchBlock:(XXSearchBarDidBeginSearchBlock)beginBlock;
- (void)setValueChangedBlock:(XXSearchBarValueChangeBlock)valueChangeBlock;
- (void)setSearchBlock:(XXSearchBarFinishSearchBlock)searchBlock;

- (void)finishChooseWithNameText:(NSString*)name;

@end
