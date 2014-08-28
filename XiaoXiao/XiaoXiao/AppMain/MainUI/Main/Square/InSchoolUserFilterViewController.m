//
//  InSchoolUserFilterViewController.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "InSchoolUserFilterViewController.h"
#import "XXSegmentControl.h"
#import "XXUserFilterCell.h"
@interface InSchoolUserFilterViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_cellArray;
}

@end

@implementation InSchoolUserFilterViewController

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
    _cellArray = [[NSMutableArray alloc]init];
    //中学生与大学生区别
    NSDictionary *item0 = @{@"title":@"不限",@"value":@""};
    NSDictionary *item1 = @{@"title":@"一年级",@"value":@""};
    NSDictionary *item2 = @{@"title":@"二年级",@"value":@""};
    NSDictionary *item3 = @{@"title":@"三年级",@"value":@""};
    NSDictionary *item4 = @{@"title":@"四年级",@"value":@""};

    [_cellArray addObject:item0];
    [_cellArray addObject:item1];
    [_cellArray addObject:item2];
    [_cellArray addObject:item3];
    //中学生与大学生区别
    NSString *strollSchoolId = [XXUserDataCenter currentLoginUser].strollSchoolId;
    NSString *schoolType = [[XXCacheCenter shareCenter]returnUserSchoolTypeBySchoolId:strollSchoolId];
    if ([schoolType intValue]==0){
        [_cellArray addObject:item4];
    }
    
    [self loadViewAbout];
    
    //
    [XXCommonUitil setCommonNavigationNextStepItemForViewController:self withNextStepAction:^{
        if ([self.delegate respondsToSelector:@selector(inSchoolUserFilterViewControllerDidFinishChooseCondition:)]) {
            XXConditionModel *condition = [[XXConditionModel alloc]init];
            
            if (segBoyGire.selectIndex==1) {
                condition.sex = @"0";
            }else if(segBoyGire.selectIndex==2){
                condition.sex = @"1";
            }else{
                condition.sex=@"";
            }
            
//            if (AboutKnow.selectIndex==0) {
//                condition.userWellKnowRank = @"1";
//            }else if(AboutKnow.selectIndex==1){
//                condition.userScoreRank = @"1";
//            }
            
            if (schoolRoll) {
                
                if (schoolRoll.selectIndex==0) {
                    condition.schoolRoll = @"高中";
                }else{
                    condition.schoolRoll = @"初中";
                }
                
            }
            
            NSString *grade = nil;
            switch (selectPath.row) {
                case 1:
                    grade = @"一年级";
                    break;
                case 2:
                    grade = @"二年级";
                    break;
                case 3:
                    grade = @"三年级";
                    break;
                case 4:
                    grade = @"四年级";
                    break;
                    
                default:
                    break;
            }
            condition.grade = grade;
            
            [self.delegate inSchoolUserFilterViewControllerDidFinishChooseCondition:condition];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } withTitle:@"完成"];
    
}
- (void)loadViewAbout
{
    CGFloat totalHeight = XXNavContentHeight -44 -49;
    
    //
    
    //back scroll
    _backScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width,totalHeight)];
    [self.view addSubview:_backScrollView];
    
    //男女选择
    NSDictionary *leftIten = @{@"title":@"不限",@"normalBack":@"segment_small_left.png",@"selectBack":@"segment_small_left_selected.png",@"normalColor":[UIColor blackColor],@"selectColor":[UIColor whiteColor]};
    
    NSDictionary *midIten = @{@"title":@"男",@"normalBack":@"segment_small_middle.png",@"selectBack":@"segment_small_middle_selected.png",@"normalColor":[UIColor blackColor],@"selectColor":[UIColor whiteColor]};
    NSDictionary *rightiten = @{@"title":@"女",@"normalBack":@"segment_small_right",@"selectBack":@"segment_small_right_selected.png",@"normalColor":[UIColor blackColor],@"selectColor":[UIColor whiteColor]};
    
    segBoyGire =[[XXSegmentControl alloc]initWithFrame:CGRectMake(10, 15, 300, 47) withConfigArray:@[leftIten,midIten,rightiten]];
    segBoyGire.backgroundColor = [UIColor clearColor];
    [_backScrollView addSubview:segBoyGire];
    
    
    //知名度选择
    NSDictionary *leftAboutKnowItem = @{@"title":@"知名度排名",@"normalBack":@"segment_big_left.png",@"selectBack":@"segment_big_left_selected.png",@"normalColor":[UIColor blackColor],@"selectColor":[UIColor whiteColor]};
    
    NSDictionary *rightAboutKnowiten = @{@"title":@"校财富排名",@"normalBack":@"segment_big_right.png",@"selectBack":@"segment_big_right_selected.png",@"normalColor":[UIColor blackColor],@"selectColor":[UIColor whiteColor]};
    
    AboutKnow =[[XXSegmentControl alloc]initWithFrame:CGRectMake(10, 62+15, 300, 47) withConfigArray:@[leftAboutKnowItem,rightAboutKnowiten]];
    AboutKnow.backgroundColor = [UIColor clearColor];
    [_backScrollView addSubview:AboutKnow];
    
    //中学生与大学生区别
    NSString *strollSchoolId = [XXUserDataCenter currentLoginUser].strollSchoolId;
    NSString *schoolType = [[XXCacheCenter shareCenter]returnUserSchoolTypeBySchoolId:strollSchoolId];
    
    CGFloat originY = 124+15;
    CGFloat tableHeight = 0.f;
    if ([schoolType intValue]!=0) {
        
        //学级选择
        NSDictionary *leftAboutKnowItem = @{@"title":@"高中",@"normalBack":@"segment_big_left.png",@"selectBack":@"segment_big_left_selected.png",@"normalColor":[UIColor blackColor],@"selectColor":[UIColor whiteColor]};
        
        NSDictionary *rightAboutKnowiten = @{@"title":@"初中",@"normalBack":@"segment_big_right.png",@"selectBack":@"segment_big_right_selected.png",@"normalColor":[UIColor blackColor],@"selectColor":[UIColor whiteColor]};
        
        schoolRoll =[[XXSegmentControl alloc]initWithFrame:CGRectMake(10, originY, 300, 47) withConfigArray:@[leftAboutKnowItem,rightAboutKnowiten]];
        schoolRoll.backgroundColor = [UIColor clearColor];
        [_backScrollView addSubview:schoolRoll];
        
        originY = originY+47+15;
        
        tableHeight = 45.5*2+46.5+46;
    }else{
        tableHeight = 45.5*3+46.5+46;
    }
    
    
    UITableView * tableView  =[[UITableView alloc]initWithFrame:CGRectMake(0, originY, 320,tableHeight) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.scrollEnabled = NO;
    tableView.backgroundColor = [XXCommonStyle xxThemeBackgroundColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_backScrollView addSubview:tableView];
    
    originY = tableView.frame.origin.y+tableView.frame.size.height+20;
    _backScrollView.contentSize = CGSizeMake(_backScrollView.frame.size.width,originY);
    
}


#pragma mark =======UITableView delegate and Datasoure Method

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _cellArray.count;
}
- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [[_cellArray objectAtIndex:indexPath.row]count]-1) {
        return 46.5;
    }else if(indexPath.row == 0){
        return 46;
    }else{
        return 45.5;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellStr = @"tableViewcell";
    XXUserFilterCell * cell  =[tableView dequeueReusableCellWithIdentifier:cellStr];
    if (cell==nil) {
        cell = [[XXUserFilterCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    if(indexPath.row==0){
        [cell setCellType:XXBaseCellTypeTop withBottomMargin:0.f withCellHeight:46.f];
    }else if(indexPath.row==_cellArray.count-1){
        [cell setCellType:XXBaseCellTypeBottom withBottomMargin:0.f withCellHeight:46.5f];
    }else{
        [cell setCellType:XXBaseCellTypeMiddel withBottomMargin:0.f withCellHeight:45.5f];
    }
    cell.showItemLbl.text = [[_cellArray objectAtIndex:indexPath.row]objectForKey:@"title"];

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectPath = indexPath;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
