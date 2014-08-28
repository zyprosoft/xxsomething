//
//  XXCommonUitil.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "XXCommonUitil.h"
#import "XiaoXiaoAppDelegate.h"

@implementation XXCommonUitil
+ (void)keywindowShowProgressHUDHiddenNow
{
    XiaoXiaoAppDelegate *appDelegate = (XiaoXiaoAppDelegate*)[[UIApplication sharedApplication]delegate];
    [appDelegate.appHUD hide:YES];
    
    
}
+ (void)keywindowShowProgressHUDWithProgressValue:(CGFloat)progressValue withTitle:(NSString *)title
{
    XiaoXiaoAppDelegate *appDelegate = (XiaoXiaoAppDelegate*)[[UIApplication sharedApplication]delegate];
    appDelegate.appHUD.mode = MBProgressHUDModeAnnularDeterminate;
    appDelegate.appHUD.progress = progressValue;
    [appDelegate.appHUD showAnimated:YES whileExecutingBlock:^{
        
    }];
}
+ (void)keywindowShowProgressHUDWithTitle:(NSString *)withTitle
{
    XiaoXiaoAppDelegate *appDelegate = (XiaoXiaoAppDelegate*)[[UIApplication sharedApplication]delegate];
    appDelegate.appHUD.mode = MBProgressHUDModeText;
    appDelegate.appHUD.labelText = withTitle;
    [appDelegate.appHUD show:YES];
}

+ (void)setCommonNavigationTitle:(NSString *)title forViewController:(UIViewController *)aViewController
{
    UILabel *customTitleLabel = [[UILabel alloc]init];
    customTitleLabel.frame = CGRectMake(0,4,150,aViewController.navigationController.navigationBar.frame.size.height-8);
    customTitleLabel.font = [UIFont boldSystemFontOfSize:17.5];
    customTitleLabel.backgroundColor = [XXCommonStyle xxThemeDarkBlueColor];
    customTitleLabel.text = aViewController.title;
    customTitleLabel.textAlignment = NSTextAlignmentCenter;
    customTitleLabel.textColor = [UIColor whiteColor];
    aViewController.navigationItem.titleView = customTitleLabel;
    [aViewController.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bar.png"] forBarMetrics:UIBarMetricsDefault];
    if (IS_IOS_7) {
        aViewController.edgesForExtendedLayout = UIRectEdgeNone;
        aViewController.automaticallyAdjustsScrollViewInsets = YES;
    }
}
+ (void)setCommonNavigationReturnItemForViewController:(UIViewController *)aViewController
{
    aViewController.view.backgroundColor = [XXCommonStyle xxThemeBackgroundColor];
    XXResponseButton *returnCustomButton = [XXResponseButton buttonWithType:UIButtonTypeCustom];
    returnCustomButton.frame = CGRectMake(0,0,50,20);
    [returnCustomButton setBackgroundImage:[UIImage imageNamed:@"nav_return_button.png"] forState:UIControlStateNormal];
    [returnCustomButton setBackgroundImage:[UIImage imageNamed:@"nav_return_button_selected.png"] forState:UIControlStateHighlighted];
    [returnCustomButton setButtonSelfTapInside];
    [returnCustomButton setResponseButtonTapped:^{
        [aViewController.navigationController popViewControllerAnimated:YES];
    }];
    UIBarButtonItem *returnNavItem = [[UIBarButtonItem alloc]initWithCustomView:returnCustomButton];
    aViewController.navigationItem.leftBarButtonItem = returnNavItem;
    UILabel *customTitleLabel = [[UILabel alloc]init];
    customTitleLabel.frame = CGRectMake(0,4,150,aViewController.navigationController.navigationBar.frame.size.height-8);
    customTitleLabel.font = [UIFont boldSystemFontOfSize:17.5];
    customTitleLabel.backgroundColor = [XXCommonStyle xxThemeDarkBlueColor];
    customTitleLabel.text = aViewController.title;
    customTitleLabel.textAlignment = NSTextAlignmentCenter;
    customTitleLabel.textColor = [UIColor whiteColor];
    aViewController.navigationItem.titleView = customTitleLabel;
    [aViewController.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bar.png"] forBarMetrics:UIBarMetricsDefault];
    if (IS_IOS_7) {
        aViewController.edgesForExtendedLayout = UIRectEdgeNone;
        aViewController.automaticallyAdjustsScrollViewInsets = YES;
    }
}
+ (void)setCommonNavigationReturnItemForViewController:(UIViewController *)aViewController withBackStepAction:(XXNavigationNextStepItemBlock)stepAction withIconImage:(NSString *)iconName
{
    aViewController.view.backgroundColor = [XXCommonStyle xxThemeBackgroundColor];
    XXResponseButton *returnCustomButton = [XXResponseButton buttonWithType:UIButtonTypeCustom];
    UIImage *iconImage = [UIImage imageNamed:iconName];
    CGSize iconSize = [UIImage imageNamed:iconName].size;
    returnCustomButton.frame = CGRectMake(0,0,iconSize.width,iconSize.height);
    [returnCustomButton setBackgroundImage:iconImage forState:UIControlStateNormal];
    NSRange typeRange = [iconName rangeOfString:@".png"];
    NSString *nameString = [iconName substringWithRange:NSMakeRange(0,typeRange.location)];
    NSString *selectedName = [NSString stringWithFormat:@"%@_selected.png",nameString];
    UIImage *selectImage = [UIImage imageNamed:selectedName];
    [returnCustomButton setBackgroundImage:selectImage forState:UIControlStateHighlighted];
    [returnCustomButton setButtonSelfTapInside];
    [returnCustomButton setResponseButtonTapped:^{
        if (stepAction) {
            stepAction();
        }
    }];
    UIBarButtonItem *returnNavItem = [[UIBarButtonItem alloc]initWithCustomView:returnCustomButton];
    aViewController.navigationItem.leftBarButtonItem = returnNavItem;
    UILabel *customTitleLabel = [[UILabel alloc]init];
    customTitleLabel.frame = CGRectMake(0,4,150,aViewController.navigationController.navigationBar.frame.size.height-8);
    customTitleLabel.font = [UIFont boldSystemFontOfSize:17.5];
    customTitleLabel.backgroundColor = [XXCommonStyle xxThemeDarkBlueColor];
    customTitleLabel.text = aViewController.title;
    customTitleLabel.textAlignment = NSTextAlignmentCenter;
    customTitleLabel.textColor = [UIColor whiteColor];
    aViewController.navigationItem.titleView = customTitleLabel;
    [aViewController.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bar.png"] forBarMetrics:UIBarMetricsDefault];
    if (IS_IOS_7) {
        aViewController.edgesForExtendedLayout = UIRectEdgeNone;
        aViewController.automaticallyAdjustsScrollViewInsets = YES;
    }
}

+ (void)setCommonNavigationNextStepItemForViewController:(UIViewController*)aViewController withIconImage:(NSString*)iconName withNextStepAction:(XXNavigationNextStepItemBlock)nextAction withTitle:(NSString*)title
{
    aViewController.view.backgroundColor = [XXCommonStyle xxThemeBackgroundColor];
    XXResponseButton *returnCustomButton = [XXResponseButton buttonWithType:UIButtonTypeCustom];
    UIImage *iconImage = [UIImage imageNamed:iconName];
    if ([iconName isEqualToString:@"next_step.png"]||[iconName isEqualToString:@"nav_stroll.png"]) {
        iconImage =   [[UIImage imageNamed:iconName]makeStretchForNavigationItem];
        CGSize iconSize = CGSizeMake(60,30);
        returnCustomButton.frame = CGRectMake(0,0,iconSize.width,iconSize.height);
    }else{
        CGSize iconSize = [UIImage imageNamed:iconName].size;
        returnCustomButton.frame = CGRectMake(0,0,iconSize.width,iconSize.height);
    }
    [returnCustomButton setBackgroundImage:iconImage forState:UIControlStateNormal];
    NSRange typeRange = [iconName rangeOfString:@".png"];
    NSString *nameString = [iconName substringWithRange:NSMakeRange(0,typeRange.location)];
    NSString *selectedName = [NSString stringWithFormat:@"%@_selected.png",nameString];
    UIImage *selectImage = [UIImage imageNamed:selectedName];
    if ([iconName isEqualToString:@"next_step.png"]||[iconName isEqualToString:@"nav_stroll.png"]) {
        selectImage =   [[UIImage imageNamed:selectedName]makeStretchForNavigationItem];
    }
    [returnCustomButton setBackgroundImage:selectImage forState:UIControlStateHighlighted];
    [returnCustomButton setTitle:title forState:UIControlStateNormal];
    [returnCustomButton setButtonSelfTapInside];
    [returnCustomButton setResponseButtonTapped:^{
        if (nextAction) {
            nextAction();
        }
    }];
    UIBarButtonItem *returnNavItem = [[UIBarButtonItem alloc]initWithCustomView:returnCustomButton];
    aViewController.navigationItem.rightBarButtonItem = returnNavItem;
    if (IS_IOS_7) {
        aViewController.edgesForExtendedLayout = UIRectEdgeNone;
        aViewController.automaticallyAdjustsScrollViewInsets = YES;
    }

}

+ (void)setCommonNavigationReturnItemForViewController:(UIViewController *)aViewController withBackStepAction:(XXNavigationNextStepItemBlock)stepAction
{
    aViewController.view.backgroundColor = [XXCommonStyle xxThemeBackgroundColor];
    XXResponseButton *returnCustomButton = [XXResponseButton buttonWithType:UIButtonTypeCustom];
    returnCustomButton.frame = CGRectMake(0,0,50,20);
    [returnCustomButton setBackgroundImage:[UIImage imageNamed:@"nav_return_button.png"] forState:UIControlStateNormal];
    [returnCustomButton setBackgroundImage:[UIImage imageNamed:@"nav_return_button_selected.png"] forState:UIControlStateHighlighted];
    [returnCustomButton setButtonSelfTapInside];
    [returnCustomButton setResponseButtonTapped:^{
        if (stepAction) {
            stepAction();
        }
    }];
    UIBarButtonItem *returnNavItem = [[UIBarButtonItem alloc]initWithCustomView:returnCustomButton];
    aViewController.navigationItem.leftBarButtonItem = returnNavItem;
    UILabel *customTitleLabel = [[UILabel alloc]init];
    customTitleLabel.frame = CGRectMake(0,4,150,aViewController.navigationController.navigationBar.frame.size.height-8);
    customTitleLabel.font = [UIFont boldSystemFontOfSize:17.5];
    customTitleLabel.backgroundColor = [XXCommonStyle xxThemeDarkBlueColor];
    customTitleLabel.text = aViewController.title;
    customTitleLabel.textAlignment = NSTextAlignmentCenter;
    customTitleLabel.textColor = [UIColor whiteColor];
    aViewController.navigationItem.titleView = customTitleLabel;
    if (IS_IOS_7) {
        aViewController.edgesForExtendedLayout = UIRectEdgeNone;
        aViewController.automaticallyAdjustsScrollViewInsets = YES;
    }
}
+ (void)setCommonNavigationNextStepItemForViewController:(UIViewController *)aViewController withNextStepAction:(XXNavigationNextStepItemBlock)nextAction
{
    aViewController.view.backgroundColor = [XXCommonStyle xxThemeBackgroundColor];
    XXResponseButton *returnCustomButton = [XXResponseButton buttonWithType:UIButtonTypeCustom];
    returnCustomButton.frame = CGRectMake(0,0,70,35);
    [returnCustomButton setBackgroundImage:[[UIImage imageNamed:@"next_step.png"]makeStretchForNavigationItem] forState:UIControlStateNormal];
    [returnCustomButton setBackgroundImage:[[UIImage imageNamed:@"next_step_selected.png"]makeStretchForNavigationItem] forState:UIControlStateHighlighted];
    [returnCustomButton setButtonSelfTapInside];
    [returnCustomButton.titleLabel setFont:[UIFont systemFontOfSize:17]];
    [returnCustomButton setTitle:@"下一步" forState:UIControlStateNormal];
    returnCustomButton.layer.cornerRadius = 6.f;
    [returnCustomButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [returnCustomButton setResponseButtonTapped:^{
        if (nextAction) {
            nextAction();
        }
    }];
    returnCustomButton.layer.borderWidth = 2.0f;
    UIBarButtonItem *returnNavItem = [[UIBarButtonItem alloc]initWithCustomView:returnCustomButton];
    aViewController.navigationItem.rightBarButtonItem = returnNavItem;
    if (IS_IOS_7) {
        aViewController.edgesForExtendedLayout = UIRectEdgeNone;
        aViewController.automaticallyAdjustsScrollViewInsets = YES;
    }
}
+ (void)setCommonNavigationNextStepItemForViewController:(UIViewController *)aViewController withNextStepAction:(XXNavigationNextStepItemBlock)nextAction withTitle:(NSString *)title
{
    aViewController.view.backgroundColor = [XXCommonStyle xxThemeBackgroundColor];
    XXResponseButton *returnCustomButton = [XXResponseButton buttonWithType:UIButtonTypeCustom];
    returnCustomButton.frame = CGRectMake(0,0,70,35);
    returnCustomButton.layer.borderWidth = 2.0f;
    [returnCustomButton.titleLabel setFont:[UIFont systemFontOfSize:17]];
    [returnCustomButton setBackgroundImage:[[UIImage imageNamed:@"next_step.png"]makeStretchForNavigationItem] forState:UIControlStateNormal];
    [returnCustomButton setBackgroundImage:[[UIImage imageNamed:@"next_step_selected.png"]makeStretchForNavigationItem] forState:UIControlStateHighlighted];
    returnCustomButton.layer.cornerRadius = 6.f;
    [returnCustomButton setButtonSelfTapInside];
    [returnCustomButton setTitle:title forState:UIControlStateNormal];
    [returnCustomButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [returnCustomButton setButtonSelfTapInside];
    [returnCustomButton setResponseButtonTapped:^{
        if (nextAction) {
            nextAction();
        }
    }];
    UIBarButtonItem *returnNavItem = [[UIBarButtonItem alloc]initWithCustomView:returnCustomButton];
    aViewController.navigationItem.rightBarButtonItem = returnNavItem;
    if (IS_IOS_7) {
        aViewController.edgesForExtendedLayout = UIRectEdgeNone;
        aViewController.automaticallyAdjustsScrollViewInsets = YES;
    }
}
+ (void)setCommonNavigationNextStepItemForViewController:(UIViewController *)aViewController withIconImage:(NSString *)iconName withNextStepAction:(XXNavigationNextStepItemBlock)nextAction
{
    aViewController.view.backgroundColor = [XXCommonStyle xxThemeBackgroundColor];
    XXResponseButton *returnCustomButton = [XXResponseButton buttonWithType:UIButtonTypeCustom];
    UIImage *iconImage = [UIImage imageNamed:iconName];
    if ([iconName isEqualToString:@"next_step.png"]||[iconName isEqualToString:@"nav_stroll.png"]) {
        iconImage =   [[UIImage imageNamed:iconName]makeStretchForNavigationItem];
        CGSize iconSize = CGSizeMake(60,30);
        returnCustomButton.frame = CGRectMake(0,0,iconSize.width,iconSize.height);
    }else{
        CGSize iconSize = [UIImage imageNamed:iconName].size;
        returnCustomButton.frame = CGRectMake(0,0,iconSize.width,iconSize.height);
    }
    [returnCustomButton setBackgroundImage:iconImage forState:UIControlStateNormal];
    NSRange typeRange = [iconName rangeOfString:@".png"];
    NSString *nameString = [iconName substringWithRange:NSMakeRange(0,typeRange.location)];
    NSString *selectedName = [NSString stringWithFormat:@"%@_selected.png",nameString];
    UIImage *selectImage = [UIImage imageNamed:selectedName];
    if ([iconName isEqualToString:@"next_step.png"]||[iconName isEqualToString:@"nav_stroll.png"]) {
        selectImage =   [[UIImage imageNamed:selectedName]makeStretchForNavigationItem];
    }
    [returnCustomButton setBackgroundImage:selectImage forState:UIControlStateHighlighted];
    [returnCustomButton setButtonSelfTapInside];
    [returnCustomButton setResponseButtonTapped:^{
        if (nextAction) {
            nextAction();
        }
    }];
    UIBarButtonItem *returnNavItem = [[UIBarButtonItem alloc]initWithCustomView:returnCustomButton];
    aViewController.navigationItem.rightBarButtonItem = returnNavItem;
    if (IS_IOS_7) {
        aViewController.edgesForExtendedLayout = UIRectEdgeNone;
        aViewController.automaticallyAdjustsScrollViewInsets = YES;
    }
}


+ (NSString*)getTimeStrWithDateString:(NSString *)dateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yyyy-M-d HH:mm:ss";
    NSDate *date = [dateFormatter dateFromString:dateString];
    
    return [XXCommonUitil getTimeStrStyle3:date];
}

+ (NSString*)getTimeStr:(long) createdAt
{
    // Calculate distance time string
    //
    NSString *timestamp;
    time_t now;
    time(&now);
    
    int distance = (int)difftime(now, createdAt);
    if (distance < 0) distance = 0;
    
    if (distance < 60) {
        timestamp = [NSString stringWithFormat:@"%d %s", distance, (distance == 1) ? "second ago" : "seconds ago"];
    }
    else if (distance < 60 * 60) {
        distance = distance / 60;
        timestamp = [NSString stringWithFormat:@"%d %s", distance, (distance == 1) ? "minute ago" : "minutes ago"];
    }
    else if (distance < 60 * 60 * 24) {
        distance = distance / 60 / 60;
        timestamp = [NSString stringWithFormat:@"%d %s", distance, (distance == 1) ? "hour ago" : "hours ago"];
    }
    else if (distance < 60 * 60 * 24 * 7) {
        distance = distance / 60 / 60 / 24;
        timestamp = [NSString stringWithFormat:@"%d %s", distance, (distance == 1) ? "day ago" : "days ago"];
    }
    else if (distance < 60 * 60 * 24 * 7 * 4) {
        distance = distance / 60 / 60 / 24 / 7;
        timestamp = [NSString stringWithFormat:@"%d %s", distance, (distance == 1) ? "week ago" : "weeks ago"];
    }
    else {
        static NSDateFormatter *dateFormatter = nil;
        if (dateFormatter == nil) {
            dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateStyle:NSDateFormatterShortStyle];
            [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        }
        
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:createdAt];
        timestamp = [dateFormatter stringFromDate:date];
    }
    return timestamp;
}

+ (NSString*)getFullTimeStr:(long long)time
{
    NSDate * date=[NSDate dateWithTimeIntervalSince1970:time];
    NSCalendar * calendar=[[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger unitFlags = NSMonthCalendarUnit | NSDayCalendarUnit|NSYearCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit;
    NSDateComponents * component=[calendar components:unitFlags fromDate:date];
    NSString * string=[NSString stringWithFormat:@"%04d-%02d-%02d %02d:%02d",[component year],[component month],[component day],[component hour],[component minute]];
    return string;
}

+ (NSString*)getMDStr:(long long)time
{
    
    NSDate * date=[NSDate dateWithTimeIntervalSince1970:time];
    NSCalendar * calendar=[[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger unitFlags = NSMonthCalendarUnit | NSDayCalendarUnit|NSYearCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit;
    NSDateComponents * component=[calendar components:unitFlags fromDate:date];
    NSString * string=[NSString stringWithFormat:@"%d月%d日",[component month],[component day]];
    return string;
}

+(NSDateComponents*) getComponent:(long long)time
{
    NSDate * date=[NSDate dateWithTimeIntervalSince1970:time];
    NSCalendar * calendar=[[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger unitFlags = NSMonthCalendarUnit | NSDayCalendarUnit|NSYearCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit;
    NSDateComponents * component=[calendar components:unitFlags fromDate:date];
    return component;
}


+ (NSString*)getTimeStrStyle3:(NSDate*)date
{
    long long timeNow = [date timeIntervalSince1970];
    NSCalendar * calendar=[[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger unitFlags = NSMonthCalendarUnit | NSDayCalendarUnit|NSYearCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit|NSWeekCalendarUnit|NSWeekdayCalendarUnit;
    NSDateComponents * component=[calendar components:unitFlags fromDate:date];
    
    int year=[component year];
    int month=[component month];
    int day=[component day];
    
    NSDate * today=[NSDate date];
    component=[calendar components:unitFlags fromDate:today];
    
    int t_year=[component year];
    
    NSString*string=nil;
    
    long long now = [today timeIntervalSince1970];
    
    long distance= now - timeNow;
    if(distance<60)
        string=@"刚刚";
    else if(distance<60*60)
        string=[NSString stringWithFormat:@"%ld 分钟前",distance/60];
    else if(distance<60*60*24)
        string=[NSString stringWithFormat:@"%ld 小时前",distance/60/60];
    else if(distance<60*60*24*7)
        string=[NSString stringWithFormat:@"%ld 天前",distance/60/60/24];
    else if(year==t_year)
        string=[NSString stringWithFormat:@"%d月%d日",month,day];
    else
        string=[NSString stringWithFormat:@"%d年%d月%d日",year,month,day];
    
    return string;
}

+(NSString*) getTimeStrStyle1:(long long)time
{
    NSDate * date=[NSDate dateWithTimeIntervalSince1970:time];
    NSCalendar * calendar=[[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger unitFlags = NSMonthCalendarUnit | NSDayCalendarUnit|NSYearCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit|NSWeekCalendarUnit|NSWeekdayCalendarUnit;
    NSDateComponents * component=[calendar components:unitFlags fromDate:date];
    
    int year=[component year];
    int month=[component month];
    int day=[component day];
    
    NSDate * today=[NSDate date];
    component=[calendar components:unitFlags fromDate:today];
    
    int t_year=[component year];
    
    NSString*string=nil;
    
    long long now=[today timeIntervalSince1970];
    
    long distance=now-time;
    if(distance<60)
        string=@"刚刚";
    else if(distance<60*60)
        string=[NSString stringWithFormat:@"%ld 分钟前",distance/60];
    else if(distance<60*60*24)
        string=[NSString stringWithFormat:@"%ld 小时前",distance/60/60];
    else if(distance<60*60*24*7)
        string=[NSString stringWithFormat:@"%ld 天前",distance/60/60/24];
    else if(year==t_year)
        string=[NSString stringWithFormat:@"%d月%d日",month,day];
    else
        string=[NSString stringWithFormat:@"%d年%d月%d日",year,month,day];
    
    return string;
    
}
+(NSString*) getTimeStrStyle2:(long long)time
{
    NSDate * date=[NSDate dateWithTimeIntervalSince1970:time];
    NSCalendar * calendar=[[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger unitFlags = NSMonthCalendarUnit | NSDayCalendarUnit|NSYearCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit|NSWeekCalendarUnit|NSWeekdayCalendarUnit;
    NSDateComponents * component=[calendar components:unitFlags fromDate:date];
    
    int year=[component year];
    int month=[component month];
    int day=[component day];
    int hour=[component hour];
    int minute=[component minute];
    int week=[component week];
    int weekday=[component weekday];
    
    NSDate * today=[NSDate date];
    component=[calendar components:unitFlags fromDate:today];
    
    int t_year=[component year];
    int t_month=[component month];
    int t_day=[component day];
    int t_week=[component week];
    
    NSString*string=nil;
    if(year==t_year&&month==t_month&&day==t_day)
    {
        if(hour<6&&hour>=0)
            string=[NSString stringWithFormat:@"凌晨 %d:%02d",hour,minute];
        else if(hour>=6&&hour<12)
            string=[NSString stringWithFormat:@"上午 %d:%02d",hour,minute];
        else if(hour>=12&&hour<18)
            string=[NSString stringWithFormat:@"下午 %d:%02d",hour-12,minute];
        else
            string=[NSString stringWithFormat:@"晚上 %d:%02d",hour-12,minute];
    }
    else if(year==t_year&&week==t_week)
    {
        NSString * daystr=nil;
        switch (weekday) {
            case 1:
                daystr=@"日";
                break;
            case 2:
                daystr=@"一";
                break;
            case 3:
                daystr=@"二";
                break;
            case 4:
                daystr=@"三";
                break;
            case 5:
                daystr=@"四";
                break;
            case 6:
                daystr=@"五";
                break;
            case 7:
                daystr=@"六";
                break;
            default:
                break;
        }
        string=[NSString stringWithFormat:@"周%@ %d:%02d",daystr,hour,minute];
    }
    else if(year==t_year)
        string=[NSString stringWithFormat:@"%d月%d日",month,day];
    else
        string=[NSString stringWithFormat:@"%d年%d月%d日",year,month,day];
    
    return string;
}

+ (XiaoXiaoAppDelegate*)appDelegate
{
    XiaoXiaoAppDelegate *appDelegate = (XiaoXiaoAppDelegate *)[[UIApplication sharedApplication]delegate];
    return appDelegate;
}
+ (MainTabViewController*)appMainTabController
{
    return [[XXCommonUitil appDelegate]mainTabController];
}

+ (UIImage*)imageForColor:(UIColor *)aColor withSize:(CGSize)imageSize
{
    CGRect rect = CGRectMake(0, 0, imageSize.width, imageSize.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [aColor CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

+(BOOL)validateEmail:(NSString *)candidate
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:candidate];
}

@end
