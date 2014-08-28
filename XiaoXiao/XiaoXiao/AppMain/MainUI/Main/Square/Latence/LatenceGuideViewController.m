//
//  LatenceGuideViewController.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "LatenceGuideViewController.h"
#import "XXLeftNavItem.h"
#import "XXSchoolSearchViewController.h"
#import "LatenceSameCityViewController.h"
#import "LatenceHistoryViewController.h"

@interface LatenceGuideViewController ()

@end

@implementation LatenceGuideViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = @"潜伏";
    [XXCommonUitil setCommonNavigationReturnItemForViewController:self];
    
    CGFloat totalHeight = XXNavContentHeight-44;
    
    CGFloat originY  = 20.f;
    
    currentSchool = [[XXLeftNavItem alloc]initWithFrame:CGRectMake(10,originY,300,44)];
    [self.view addSubview:currentSchool];
    [currentSchool setIconName:@"nav_location.png"];
    NSString *latenceSchool = [XXUserDataCenter currentLoginUser].strollSchoolName;
    NSString *latenceSchoolString = [NSString stringWithFormat:@"当前校园:%@",latenceSchool];
    [currentSchool setTitle:latenceSchoolString];
    originY = currentSchool.frame.origin.y+currentSchool.frame.size.height+10;
    
    UIImage *normalBack = [[UIImage imageNamed:@"single_round_cell_normal.png"]makeStretchForSingleCornerCell];
    UIImage *selectBack = [[UIImage imageNamed:@"single_round_cell_selected.png"]makeStretchForSingleCornerCell];
    //
    UIButton *bestLatenceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bestLatenceBtn.frame = CGRectMake(10,originY,300,44);
    [bestLatenceBtn setBackgroundImage:normalBack forState:UIControlStateNormal];
    [bestLatenceBtn setBackgroundImage:selectBack forState:UIControlStateHighlighted];
    [self.view addSubview:bestLatenceBtn];
    [bestLatenceBtn addTarget:self action:@selector(bestLatenceAction) forControlEvents:UIControlEventTouchUpInside];
    [bestLatenceBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [bestLatenceBtn setTitle:@"精准潜伏" forState:UIControlStateNormal];
    
    //
    originY = bestLatenceBtn.frame.origin.y+bestLatenceBtn.frame.size.height+5;
    UIButton *sameSchoollBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sameSchoollBtn.frame = CGRectMake(10,originY,300,44);
    [sameSchoollBtn setBackgroundImage:normalBack forState:UIControlStateNormal];
    [sameSchoollBtn setBackgroundImage:selectBack forState:UIControlStateHighlighted];
    [self.view addSubview:sameSchoollBtn];
    [sameSchoollBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sameSchoollBtn addTarget:self action:@selector(sameCityLatenceAction) forControlEvents:UIControlEventTouchUpInside];
    [sameSchoollBtn setTitle:@"同城的校园" forState:UIControlStateNormal];
    
    //
    originY  = sameSchoollBtn.frame.origin.y+sameSchoollBtn.frame.size.height+5;
    UIButton *historySchoollBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    historySchoollBtn.frame = CGRectMake(10,originY,300,44);
    [historySchoollBtn setBackgroundImage:normalBack forState:UIControlStateNormal];
    [historySchoollBtn setBackgroundImage:selectBack forState:UIControlStateHighlighted];
    [self.view addSubview:historySchoollBtn];
    [historySchoollBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [historySchoollBtn addTarget:self action:@selector(historyCityLatenceAction) forControlEvents:UIControlEventTouchUpInside];
    [historySchoollBtn setTitle:@"去过的校园" forState:UIControlStateNormal];
    
    XXUserModel *cUser = [XXUserDataCenter currentLoginUser];
    if (![cUser.schoolId isEqualToString:cUser.strollSchoolId]) {
        
        //return my school
        originY  = historySchoollBtn.frame.origin.y+historySchoollBtn.frame.size.height+5;
        UIButton *returnMySchoolBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        returnMySchoolBtn.frame = CGRectMake(10,originY,300,44);
        [returnMySchoolBtn setBackgroundImage:normalBack forState:UIControlStateNormal];
        [returnMySchoolBtn setBackgroundImage:selectBack forState:UIControlStateHighlighted];
        [self.view addSubview:returnMySchoolBtn];
        [returnMySchoolBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [returnMySchoolBtn addTarget:self action:@selector(returnMySchoollAction) forControlEvents:UIControlEventTouchUpInside];
        [returnMySchoolBtn setTitle:@"返回我的校园" forState:UIControlStateNormal];
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)bestLatenceAction
{
    XXSchoolSearchViewController *schoolChooseVC = [[XXSchoolSearchViewController alloc]init];
    schoolChooseVC.title = @"精准潜伏";
    [schoolChooseVC setFinishChooseSchool:^(XXSchoolModel *chooseSchool) {
        
    }];
    [schoolChooseVC setNextStepAction:^(NSDictionary *resultDict) {
       
        XXSchoolModel *chooseSchool = [resultDict objectForKey:@"result"];
        
        [[XXMainDataCenter shareCenter]requestStrollSchoolWithConditionSchool:chooseSchool withSuccess:^(NSString *successMsg) {
            [SVProgressHUD showSuccessWithStatus:@"潜伏成功"];
            NSString *latenceSchoolString = [NSString stringWithFormat:@"当前校园:%@",chooseSchool.schoolName];
            [currentSchool setTitle:latenceSchoolString];
            XXUserModel *cUser = [XXUserDataCenter currentLoginUser];
            cUser.strollSchoolId = chooseSchool.schoolId;
            cUser.strollSchoolName = chooseSchool.schoolName;
            [XXUserDataCenter loginThisUser:cUser];
            [[XXUserCacheCenter shareCenter]saveStrolledSchool:chooseSchool];//save for history

            //post noti
            [[NSNotificationCenter defaultCenter]postNotificationName:XXUserHasStrollNewSchool object:chooseSchool];
            UIViewController *inSchoolVC = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-3];
            [self.navigationController popToViewController:inSchoolVC animated:YES];
            [SVProgressHUD showErrorWithStatus:@"已经潜伏在此校园了"];
            
        } withFaild:^(NSString *faildMsg) {
            [SVProgressHUD showErrorWithStatus:@"潜伏失败"];
        }];
    } withNextStepTitle:@"潜伏"];
    [self.navigationController pushViewController:schoolChooseVC animated:YES];
    [XXCommonUitil setCommonNavigationReturnItemForViewController:schoolChooseVC];

}
- (void)returnMySchoollAction
{
    XXUserModel *cUser = [XXUserDataCenter currentLoginUser];
    XXSchoolModel *chooseSchool = [[XXSchoolModel alloc]init];
    chooseSchool.schoolId = cUser.schoolId;
    chooseSchool.schoolName = cUser.schoolName;
    
    [[XXMainDataCenter shareCenter]requestStrollSchoolWithConditionSchool:chooseSchool withSuccess:^(NSString *successMsg) {
        [SVProgressHUD showSuccessWithStatus:@"返回成功"];
        NSString *latenceSchoolString = [NSString stringWithFormat:@"当前校园:%@",chooseSchool.schoolName];
        [currentSchool setTitle:latenceSchoolString];
        XXUserModel *cUser = [XXUserDataCenter currentLoginUser];
        cUser.strollSchoolId = chooseSchool.schoolId;
        cUser.strollSchoolName = chooseSchool.schoolName;
        [XXUserDataCenter loginThisUser:cUser];
        [[XXUserCacheCenter shareCenter]saveStrolledSchool:chooseSchool];//save for history
        
        //post noti
        [[NSNotificationCenter defaultCenter]postNotificationName:XXUserHasStrollNewSchool object:chooseSchool];
        UIViewController *inSchoolVC = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
        [self.navigationController popToViewController:inSchoolVC animated:YES];
        [SVProgressHUD showErrorWithStatus:@"已经返回校园了"];
        
    } withFaild:^(NSString *faildMsg) {
        [SVProgressHUD showErrorWithStatus:@"返回失败"];
    }];

}

- (void)sameCityLatenceAction
{
    LatenceSameCityViewController *schoolChooseVC = [[LatenceSameCityViewController alloc]init];
    schoolChooseVC.title = @"同城的校园";
    [schoolChooseVC setFinishChooseSchool:^(XXSchoolModel *chooseSchool) {
        
    }];
    [schoolChooseVC setNextStepAction:^(NSDictionary *resultDict) {
        
        XXSchoolModel *chooseSchool = [resultDict objectForKey:@"result"];
        
        [[XXMainDataCenter shareCenter]requestStrollSchoolWithConditionSchool:chooseSchool withSuccess:^(NSString *successMsg) {
            [SVProgressHUD showSuccessWithStatus:@"潜伏成功"];
            NSString *latenceSchoolString = [NSString stringWithFormat:@"当前校园:%@",chooseSchool.schoolName];
            [currentSchool setTitle:latenceSchoolString];
            XXUserModel *cUser = [XXUserDataCenter currentLoginUser];
            cUser.strollSchoolId = chooseSchool.schoolId;
            cUser.strollSchoolName = chooseSchool.schoolName;
            [XXUserDataCenter loginThisUser:cUser];
            [[XXUserCacheCenter shareCenter]saveStrolledSchool:chooseSchool];//save for history
            
            //post noti
            [[NSNotificationCenter defaultCenter]postNotificationName:XXUserHasStrollNewSchool object:chooseSchool];
            UIViewController *inSchoolVC = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-3];
            [self.navigationController popToViewController:inSchoolVC animated:YES];
            [SVProgressHUD showSuccessWithStatus:@"已经潜伏在此校园了"];
            
        } withFaild:^(NSString *faildMsg) {
            [SVProgressHUD showErrorWithStatus:@"潜伏失败"];
        }];
    } withNextStepTitle:@"潜伏"];
    [self.navigationController pushViewController:schoolChooseVC animated:YES];
    [XXCommonUitil setCommonNavigationReturnItemForViewController:schoolChooseVC];
}
- (void)historyCityLatenceAction
{
    LatenceHistoryViewController *schoolChooseVC = [[LatenceHistoryViewController alloc]init];
    schoolChooseVC.title = @"去过的校园";
    [schoolChooseVC setFinishChooseSchool:^(XXSchoolModel *chooseSchool) {
        
    }];
    [schoolChooseVC setNextStepAction:^(NSDictionary *resultDict) {
        
        XXSchoolModel *chooseSchool = [resultDict objectForKey:@"result"];
        
        [[XXMainDataCenter shareCenter]requestStrollSchoolWithConditionSchool:chooseSchool withSuccess:^(NSString *successMsg) {
            [SVProgressHUD showSuccessWithStatus:@"潜伏成功"];
            NSString *latenceSchoolString = [NSString stringWithFormat:@"当前校园:%@",chooseSchool.schoolName];
            [currentSchool setTitle:latenceSchoolString];
            XXUserModel *cUser = [XXUserDataCenter currentLoginUser];
            cUser.strollSchoolId = chooseSchool.schoolId;
            cUser.strollSchoolName = chooseSchool.schoolName;
            [XXUserDataCenter loginThisUser:cUser];
            
            //post noti
            [[NSNotificationCenter defaultCenter]postNotificationName:XXUserHasStrollNewSchool object:chooseSchool];
            UIViewController *inSchoolVC = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-3];
            [self.navigationController popToViewController:inSchoolVC animated:YES];
            [SVProgressHUD showErrorWithStatus:@"已经潜伏在此校园了"];
            
        } withFaild:^(NSString *faildMsg) {
            [SVProgressHUD showErrorWithStatus:@"潜伏失败"];
        }];
    } withNextStepTitle:@"潜伏"];
    [self.navigationController pushViewController:schoolChooseVC animated:YES];
    [XXCommonUitil setCommonNavigationReturnItemForViewController:schoolChooseVC];

}

@end
