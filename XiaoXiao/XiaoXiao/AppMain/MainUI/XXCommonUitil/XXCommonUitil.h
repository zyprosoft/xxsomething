//
//  XXCommonUitil.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XiaoXiaoAppDelegate.h"

#define WeakObj(x)  __block __weak typeof(x) 
#define rgb(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define XXThemeColor [UIColor colorWithRed:10/255.0 green:216/255.0 blue:204/255.0 alpha:1]
#define IS_IOS_7  [[[UIDevice currentDevice]systemVersion]floatValue]>=7.0
#define IS_PHONE_5 [UIScreen mainScreen].bounds.size.height==568.f 
#define CGRectX(x,y,w,h) CGRectMake(x,(y+(IS_IOS_7?20:0)),w,h)
#define StringInt(x) [NSString stringWithFormat:@"%d",x]
#define StringFloat(x) [NSString stringWithFormat:@"%f",x]
#define StringLong(x) [NSString stringWithFormat:@"%ld",x]

#define XXNavContentHeight [UIScreen mainScreen].bounds.size.height-20

#define XXContentHeight [UIScreen mainScreen].bounds.size.height-20

typedef enum {
    XXSchoolTypeHighSchool = 0,
    XXSchoolTypeCollege,
}XXSchoolType;


typedef void (^XXNavigationNextStepItemBlock) (void);
typedef void (^XXCommonNavigationNextStepBlock) (NSDictionary *resultDict);

//Noti
#define XXUserInfoHasUpdatedNoti @"XXUserInfoHasUpdatedNoti"
#define XXUserHasStrollNewSchool @"XXUserHasStrollNewSchool"
#define XXUserHasMoveHomeSchoolNoti  @"XXUserHasMoveHomeSchoolNoti"
#define XXUserHasUpdateProfileNoti @"XXUserHasUpdateProfileNoti"
#define XXUserHasRecievedNewMsgNoti @"XXUserHasRecievedNewMsgNoti"
#define XXUserHasGetRemindCountNoti @"XXUserHasGetRemindCountNoti"

@interface XXCommonUitil : NSObject
+ (void)setCommonNavigationReturnItemForViewController:(UIViewController*)aViewController;
+ (void)setCommonNavigationReturnItemForViewController:(UIViewController*)aViewController withBackStepAction:(XXNavigationNextStepItemBlock)stepAction;

+ (void)setCommonNavigationReturnItemForViewController:(UIViewController*)aViewController withBackStepAction:(XXNavigationNextStepItemBlock)stepAction withIconImage:(NSString*)iconName;

+ (void)setCommonNavigationNextStepItemForViewController:(UIViewController*)aViewController withNextStepAction:(XXNavigationNextStepItemBlock)nextAction;

+ (void)setCommonNavigationNextStepItemForViewController:(UIViewController*)aViewController withNextStepAction:(XXNavigationNextStepItemBlock)nextAction withTitle:(NSString*)title;

+ (void)setCommonNavigationTitle:(NSString*)title forViewController:(UIViewController*)aViewController;

+ (void)setCommonNavigationNextStepItemForViewController:(UIViewController*)aViewController withIconImage:(NSString*)iconName withNextStepAction:(XXNavigationNextStepItemBlock)nextAction;

+ (void)setCommonNavigationNextStepItemForViewController:(UIViewController*)aViewController withIconImage:(NSString*)iconName withNextStepAction:(XXNavigationNextStepItemBlock)nextAction withTitle:(NSString*)title;

+ (void)keywindowShowProgressHUDWithProgressValue:(CGFloat)progressValue withTitle:(NSString*)title;
+ (void)keywindowShowProgressHUDWithTitle:(NSString*)withTitle;
+ (void)keywindowShowProgressHUDHiddenNow;

+ (NSString*)getTimeStrWithDateString:(NSString*)dateString;
+ (NSString*)getTimeStr:(long) createdAt;
+ (NSString*)getFullTimeStr:(long long)time;
+ (NSString*)getMDStr:(long long)time;
+(NSDateComponents*) getComponent:(long long)time;
+(NSString*) getTimeStrStyle1:(long long)time;
+(NSString*) getTimeStrStyle2:(long long)time;
+ (NSString*)getTimeStrStyle3:(NSDate*)date;

+ (BOOL)validateEmail:(NSString *)candidate;

+ (XiaoXiaoAppDelegate*)appDelegate;
+ (MainTabViewController*)appMainTabController;

+ (UIImage*)imageForColor:(UIColor*)aColor withSize:(CGSize)imageSize;


@end
