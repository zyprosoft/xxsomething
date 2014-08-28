//
//  XXUserModel.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    
    XXUserMiddleSchool = 0,
    XXUserHighSchool,
    XXUserCollege,
    
}XXUserType;

@interface XXUserModel : NSObject
@property (nonatomic,strong)NSString *userId;
@property (nonatomic,strong)NSString *account;
@property (nonatomic,strong)NSString *password;
@property (nonatomic,strong)NSString *nickName;
@property (nonatomic,strong)NSString *score;
@property (nonatomic,strong)NSString *schoolId;
@property (nonatomic,strong)NSString *strollSchoolId;
@property (nonatomic,strong)NSString *headUrl;
@property (nonatomic,strong)NSString *email;
@property (nonatomic,strong)NSString *grade;
@property (nonatomic,strong)NSString *sex;
@property (nonatomic,strong)NSString *birthDay;
@property (nonatomic,strong)NSString *signature;
@property (nonatomic,strong)NSString *bgImage;
@property (nonatomic,strong)NSString *constellation;
@property (nonatomic,strong)NSString *postCount;
@property (nonatomic,strong)NSString *registTime;
@property (nonatomic,strong)NSAttributedString *attributedContent;
@property (nonatomic,strong)NSString *schoolName;
@property (nonatomic,strong)NSString *wellknow;
@property (nonatomic,strong)NSString *praiseCount;
@property (nonatomic,strong)NSString *tooken;
@property (nonatomic,strong)NSString *status;
@property (nonatomic,strong)NSString *latitude;
@property (nonatomic,strong)NSString *longtitude;
@property (nonatomic,strong)NSString *distance; //附近的用户时可以用上
@property (nonatomic,strong)NSString *college;//学院
@property (nonatomic,strong)NSString *schoolRoll;//学级
@property (nonatomic,strong)NSString *type;//用户类型
@property (nonatomic,strong)NSString *isCareMe;
@property (nonatomic,strong)NSString *isCareYou;
@property (nonatomic,strong)NSString *teaseCount;
@property (nonatomic,strong)NSString *commentCount;
@property (nonatomic,strong)NSString *careMeCount;
@property (nonatomic,strong)NSString *meCareCount;
@property (nonatomic,strong)NSString *schoolRank;
@property (nonatomic,strong)NSString *visitCount;
@property (nonatomic,strong)NSString *city;
@property (nonatomic,strong)NSString *province;
@property (nonatomic,strong)NSString *strollSchoolName;
@property (nonatomic,strong)NSString *latestDistance;
@property (nonatomic,strong)NSString *lastTime;
@property (nonatomic,strong)NSString *visitTime;
@property (nonatomic,strong)NSString *hasNewPosts;

//temp
@property (nonatomic,strong)NSString *careMeNew;
@property (nonatomic,strong)NSString *meCareNew;
@property (nonatomic,strong)NSString *isInMyCareList;

//remind
@property (nonatomic,strong)NSString *friendHasNewShareCount;
@property (nonatomic,strong)NSString *visitUserNewCount;
@property (nonatomic,strong)NSString *commentNewCount;
@property (nonatomic,strong)NSString *teaseNewCount;

@property (nonatomic,strong)NSString *keyword;//搜索关心列表时用来传值用,可以不编码保存
@property (nonatomic,strong)NSString *allowBackgroundChatMessageRecieve;//是否支持后台接收xmpp消息
@property (nonatomic,strong)NSString *isUserInfoWell;//资料是否完善
@property (nonatomic,strong)NSString *isInSchool;//是不是校内人

//user save contact
@property (nonatomic,strong)NSString *ownUser;


- (id)initWithContentDict:(NSDictionary*)contentDict;

@end
