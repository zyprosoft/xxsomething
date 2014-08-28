//
//  SettingMyProfileGuideViewController.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "SettingMyProfileGuideViewController.h"
#import "XXBaseTagLabelCell.h"

@interface SettingMyProfileGuideViewController ()

@end

@implementation SettingMyProfileGuideViewController

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
    self.title = @"资料设置";
    [XXCommonUitil setCommonNavigationTitle:self.title forViewController:self];
    
    _titleArray = [[NSMutableArray alloc]init];
    XXUserModel *cUser = [XXUserDataCenter currentLoginUser];
    NSString *nameValue = ([cUser.nickName isEqualToString:@""]||cUser.nickName==nil)? @"":cUser.nickName;
    NSString *sexValue = nil;
    if (cUser.sex==nil||[cUser.sex isEqualToString:@""]) {
        sexValue = @"";
    }else{
        sexValue = [cUser.sex boolValue]? @"女":@"男";
    }
    NSString *starValue = ([cUser.constellation isEqualToString:@""]||cUser.constellation==nil)? @"":cUser.constellation;

    NSDictionary *item0 = @{@"title":@"名字",@"placeholder":@"请输入",@"value":nameValue};
    NSDictionary *item1 = @{@"title":@"性别",@"placeholder":@"请选择",@"value":sexValue};
    NSDictionary *item2 = @{@"title":@"星座",@"placeholder":@"请选择",@"value":starValue};
    NSDictionary *item3 = nil;
    
    //中学生与大学生区别
    NSString *strollSchoolId = [XXUserDataCenter currentLoginUser].schoolId;
    NSString *schoolType = [[XXCacheCenter shareCenter]returnUserSchoolTypeBySchoolId:strollSchoolId];
    
    if ([schoolType intValue]!=0) {
        NSString *schoolRollValue = ([cUser.schoolRoll isEqualToString:@""]||cUser.schoolRoll==nil)? @"":cUser.schoolRoll;
        item3 =  @{@"title":@"学级",@"placeholder":@"请选择",@"value":schoolRollValue};
    }else{
        NSString *collegeValue = ([cUser.college isEqualToString:@""]||cUser.college==nil)? @"":cUser.college;
        item3 = @{@"title":@"院系",@"placeholder":@"请输入",@"value":collegeValue};
    }
    NSString *gradeValue = ([cUser.grade isEqualToString:@""]||cUser.grade==nil)? @"":cUser.grade;
    NSDictionary *item4 = @{@"title":@"年级",@"placeholder":@"请选择",@"value":gradeValue};

    [_titleArray addObject:item0];
    [_titleArray addObject:item1];
    [_titleArray addObject:item2];
    [_titleArray addObject:item3];
    [_titleArray addObject:item4];
    
    CGFloat totalHeight = self.view.frame.size.height-44;
    CGFloat totalWidth =  self.view.frame.size.width;
    
    _tableView = [[UITableView alloc]init];
    _tableView.frame = CGRectMake(0,0,totalWidth,totalHeight);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [XXCommonStyle xxThemeBackgroundColor];
    [self.view addSubview:_tableView];
    
    _updateModel = [[XXUserModel alloc]init];
    _updateModel.nickName = cUser.nickName;
    _updateModel.sex = cUser.sex;
    _updateModel.grade = cUser.grade;
    _updateModel.schoolRoll = cUser.schoolRoll;
    _updateModel.college = cUser.college;
    _updateModel.constellation = cUser.constellation;
    
    //更新操作
    [XXCommonUitil setCommonNavigationNextStepItemForViewController:self withNextStepAction:^{
        
        XXUserModel *currentUser = [XXUserDataCenter currentLoginUser];
        currentUser.nickName = _updateModel.nickName;
        currentUser.grade = _updateModel.grade;
        currentUser.constellation = _updateModel.constellation;
        currentUser.sex = _updateModel.sex;
        
        //中学生与大学生区别
        NSString *strollSchoolId = [XXUserDataCenter currentLoginUser].schoolId;
        NSString *schoolType = [[XXCacheCenter shareCenter]returnUserSchoolTypeBySchoolId:strollSchoolId];
        if ([schoolType intValue]!=0) {
            currentUser.schoolRoll = _updateModel.schoolRoll;
            if ([currentUser.schoolRoll isEqualToString:@"初中"]) {
                currentUser.type = @"0";
            }
            if ([currentUser.schoolRoll isEqualToString:@"高中"]) {
                currentUser.type = @"1";
            }
            if (currentUser.schoolRoll==nil) {
                [SVProgressHUD showErrorWithStatus:@"请将资料填写完善"];
                return;
            }
        }else{
            currentUser.college = _updateModel.college;
            if (currentUser.college==nil) {
                [SVProgressHUD showErrorWithStatus:@"请将资料填写完善"];
                return;
            }
            currentUser.type = @"2";
        }
        if (!currentUser.nickName || !currentUser.grade || !currentUser.constellation || !currentUser.sex) {
            [SVProgressHUD showErrorWithStatus:@"请将资料填写完善"];
            return;
        }
    
        [SVProgressHUD show];
        [[XXMainDataCenter shareCenter]requestUpdateUserInfoWithConditionUser:currentUser withSuccess:^(NSString *successMsg) {
            [SVProgressHUD showSuccessWithStatus:successMsg];
            if (_finishBlock) {
                _finishBlock(YES);
            }
            //update currentUser
            if ([XXUserDataCenter checkLoginUserInfoIsWellDone]) {
                [[NSNotificationCenter defaultCenter]postNotificationName:XXUserHasUpdateProfileNoti object:nil];
            }
            [XXUserDataCenter loginThisUser:currentUser];
            
            
            [self.navigationController popViewControllerAnimated:YES];
        } withFaild:^(NSString *faildMsg) {
            [SVProgressHUD showErrorWithStatus:faildMsg];
            if (_finishBlock) {
                _finishBlock(NO);
            }
        }];
        
    } withTitle:@"更新"];
    
}
- (void)setFinishBlock:(SettingMyProfileGuideViewControllerFinishBlock)finishBlock
{
    _finishBlock = [finishBlock copy];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArray.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    XXBaseTagLabelCell *cell = (XXBaseTagLabelCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[XXBaseTagLabelCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.customAccessoryView.hidden = NO;
    }
    if(indexPath.row==0){
        [cell setCellType:XXBaseCellTypeTop withBottomMargin:0.f withCellHeight:46.f];
    }else if(indexPath.row== _titleArray.count-1){
        [cell setCellType:XXBaseCellTypeBottom withBottomMargin:0.f withCellHeight:46.5f];
    }else{
        [cell setCellType:XXBaseCellTypeMiddel withBottomMargin:0.f withCellHeight:45.5f];
    }
    
    NSDictionary *item = [_titleArray objectAtIndex:indexPath.row];
    [cell setTagName:[item objectForKey:@"title"]];
    cell.inputTextField.placeholder = [item objectForKey:@"placeholder"];
    cell.inputTextField.text = [item objectForKey:@"value"];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.f;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0,0,tableView.frame.size.width-20,44)];
    headView.backgroundColor = [UIColor clearColor];
    return headView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [[_titleArray objectAtIndex:indexPath.section]count]-1) {
        return 46.5;
    }else if(indexPath.row == 0){
        return 46;
    }else{
        return 45.5f;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XXBaseTagLabelCell *selectCell = (XXBaseTagLabelCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    NSDictionary *itemDict = [_titleArray objectAtIndex:indexPath.row];
    NSString *defaultValue = [itemDict objectForKey:@"value"];
    NSDictionary *baseRadioConfigDict = @{@"normalBack":@"radio_choose_normal.png",@"selectBack":@"blue_right_selected.png",@"normalColor":[UIColor blackColor],@"selectColor":[XXCommonStyle xxThemeBlueColor]};
    switch (indexPath.row) {
        case 0:
        {
            XXEditInputViewController *nameEditVC = [[XXEditInputViewController alloc]initWithFinishAction:^(NSString *resultText) {
                _updateModel.nickName = resultText;
                [selectCell setContentText:resultText];
                [self.navigationController popViewControllerAnimated:YES];
            }];
            nameEditVC.title = @"填写昵称";
            [self.navigationController pushViewController:nameEditVC animated:YES];
            nameEditVC.inputTextView.text = defaultValue;
            [XXCommonUitil setCommonNavigationReturnItemForViewController:nameEditVC withBackStepAction:^{
                _updateModel.nickName = [nameEditVC resultText];
                [self.navigationController popViewControllerAnimated:YES];
            }];
            
        }
            break;
        case 1:
        {
            NSMutableDictionary *sexBoy = [NSMutableDictionary dictionaryWithDictionary:baseRadioConfigDict];
            [sexBoy setObject:@"男" forKey:@"title"];
            [sexBoy setObject:@"0" forKey:@"value"];
            NSMutableDictionary *sexGirl= [NSMutableDictionary dictionaryWithDictionary:baseRadioConfigDict];
            [sexGirl setObject:@"女" forKey:@"title"];
            [sexGirl setObject:@"1" forKey:@"value"];
            NSArray *configArray = @[sexBoy,sexGirl];
            XXRadioChooseViewController *sexChooseVC = [[XXRadioChooseViewController alloc]initWithConfigArray:configArray withRadioChooseType:XXRadioChooseTypeClonumTwo withFinishBlock:^(NSString *resultString) {
                _updateModel.sex = resultString;
                NSString *sexString = [_updateModel.sex boolValue]? @"女":@"男";
                [selectCell setContentText:sexString];
                [self.navigationController popViewControllerAnimated:YES];
            } withDefaultValue:defaultValue];
            sexChooseVC.title = @"性别选择";
            [self.navigationController pushViewController:sexChooseVC animated:YES];
            [XXCommonUitil setCommonNavigationReturnItemForViewController:sexChooseVC withBackStepAction:^{
                _updateModel.sex = [sexChooseVC finialChooseString];
                NSString *sexString = [_updateModel.sex boolValue]? @"女":@"男";
                [selectCell setContentText:sexString];
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
            break;
        case 2:
        {
            NSArray *starsArray = @[@"白羊座",@"金牛座",@"双子座",@"巨蟹座",@"狮子座",@"处女座",@"天秤座",@"天蝎座",@"射手座",@"摩羯座",@"水瓶座",@"双鱼座"];
            NSMutableArray *configArray = [NSMutableArray array];
            [starsArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSMutableDictionary *item = [NSMutableDictionary dictionaryWithDictionary:baseRadioConfigDict];
                [item setObject:obj forKey:@"title"];
                [item setObject:obj forKey:@"value"];
                [configArray addObject:item];
            }];
            XXRadioChooseViewController *starChooseVC = [[XXRadioChooseViewController alloc]initWithConfigArray:configArray withRadioChooseType:XXRadioChooseTypeClonumTwo withFinishBlock:^(NSString *resultString) {
                _updateModel.constellation = resultString;
                [selectCell setContentText:_updateModel.constellation];
                [self.navigationController popViewControllerAnimated:YES];
            } withDefaultValue:defaultValue];
            starChooseVC.title = @"星座选择";
            [self.navigationController pushViewController:starChooseVC animated:YES];
            [XXCommonUitil setCommonNavigationReturnItemForViewController:starChooseVC withBackStepAction:^{
                _updateModel.constellation = [starChooseVC finialChooseString];
                [selectCell setContentText:_updateModel.constellation];
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
            break;
        case 3:
        {
            //中学生与大学生区别
            NSString *strollSchoolId = [XXUserDataCenter currentLoginUser].schoolId;
            NSString *schoolType = [[XXCacheCenter shareCenter]returnUserSchoolTypeBySchoolId:strollSchoolId];
            
            if ([schoolType intValue]!=0) {
                
                NSArray *gradesArray = @[@"高中",@"初中"];
                NSMutableArray *configArray = [NSMutableArray array];
                [gradesArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    NSMutableDictionary *item = [NSMutableDictionary dictionaryWithDictionary:baseRadioConfigDict];
                    [item setObject:obj forKey:@"title"];
                    [item setObject:obj forKey:@"value"];
                    [configArray addObject:item];
                }];
                
                XXRadioChooseViewController *gradeChooseVC = [[XXRadioChooseViewController alloc]initWithConfigArray:configArray withRadioChooseType:XXRadioChooseTypeClonumTwo withFinishBlock:^(NSString *resultString) {
                    _updateModel.schoolRoll = resultString;
                    [selectCell setContentText:_updateModel.schoolRoll];
                    [self.navigationController popViewControllerAnimated:YES];
                } withDefaultValue:defaultValue];
                gradeChooseVC.title = @"选择学级";
                [self.navigationController pushViewController:gradeChooseVC animated:YES];
                [XXCommonUitil setCommonNavigationReturnItemForViewController:gradeChooseVC withBackStepAction:^{
                    _updateModel.schoolRoll = [gradeChooseVC finialChooseString];
                    [selectCell setContentText:_updateModel.schoolRoll];
                    [self.navigationController popViewControllerAnimated:YES];
                }];
                
            }else{
                XXEditInputViewController *CollegeEditVC = [[XXEditInputViewController alloc]initWithFinishAction:^(NSString *resultText) {
                    _updateModel.college = resultText;
                    [selectCell setContentText:resultText];
                    [self.navigationController popViewControllerAnimated:YES];
                }];
                CollegeEditVC.title = @"填写院系";
                [self.navigationController pushViewController:CollegeEditVC animated:YES];
                CollegeEditVC.inputTextView.text = defaultValue;
                [XXCommonUitil setCommonNavigationReturnItemForViewController:CollegeEditVC withBackStepAction:^{
                    _updateModel.college = [CollegeEditVC resultText];
                    [selectCell setContentText:_updateModel.college];
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }
        }
            break;
        case 4:
        {
            //中学生与大学生区别
            NSArray *gradesArray=nil;
            NSString *strollSchoolId = [XXUserDataCenter currentLoginUser].schoolId;
            NSString *schoolType = [[XXCacheCenter shareCenter]returnUserSchoolTypeBySchoolId:strollSchoolId];
            
            if ([schoolType intValue]!=0) {
                gradesArray = @[@"一年级",@"二年级",@"三年级"];
            }else{
                gradesArray = @[@"一年级",@"二年级",@"三年级",@"四年级"];
            }
            NSMutableArray *configArray = [NSMutableArray array];
            [gradesArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSMutableDictionary *item = [NSMutableDictionary dictionaryWithDictionary:baseRadioConfigDict];
                [item setObject:obj forKey:@"title"];
                [item setObject:obj forKey:@"value"];
                [configArray addObject:item];
            }];
            XXRadioChooseViewController *gradeChooseVC = [[XXRadioChooseViewController alloc]initWithConfigArray:configArray withRadioChooseType:XXRadioChooseTypeClonumTwo withFinishBlock:^(NSString *resultString) {
                _updateModel.grade = resultString;
                [selectCell setContentText:_updateModel.grade];
                [self.navigationController popViewControllerAnimated:YES];
            } withDefaultValue:defaultValue];
            gradeChooseVC.title = @"年级选择";
            [self.navigationController pushViewController:gradeChooseVC animated:YES];
            [XXCommonUitil setCommonNavigationReturnItemForViewController:gradeChooseVC withBackStepAction:^{
                _updateModel.grade = [gradeChooseVC finialChooseString];
                [selectCell setContentText:_updateModel.grade];
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
            break;
        default:
            break;
    }
}


@end
