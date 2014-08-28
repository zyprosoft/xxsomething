//
//  XXSchoolModel.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-18.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "XXSchoolModel.h"

@implementation XXSchoolModel

- (id)initWithContentDict:(NSDictionary *)contentDict
{
    if (self = [super init]) {
        
        //默认值
        self.schoolId = @"";
        self.schoolName = @"";
        self.province = @"";
        self.city = @"";
        self.area = @"";
        self.type = @"";

        self.schoolId = [contentDict objectForKey:@"id"];
        self.schoolName = [contentDict objectForKey:@"title"];
        self.province = [contentDict objectForKey:@"province"];
        self.city = [contentDict objectForKey:@"city"];
        self.area = [contentDict objectForKey:@"area"];
        self.type = [contentDict objectForKey:@"type"];
        
    }
    return self;
}

- (id)initWithCoder:(NSCoder*)aDecoder
{
    if (self = [super init]) {
        
        self.schoolId = [aDecoder decodeObjectForKey:@"schoolId"];
        self.schoolName = [aDecoder decodeObjectForKey:@"schoolName"];
        self.province = [aDecoder decodeObjectForKey:@"province"];
        self.city = [aDecoder decodeObjectForKey:@"city"];
        self.area = [aDecoder decodeObjectForKey:@"area"];
        self.type = [aDecoder decodeObjectForKey:@"type"];

        //搜索的时候用来传递参数，存储的时候可以为空
        self.searchKeyword = [aDecoder decodeObjectForKey:@"searchKeyword"];

    }
    return self;
}

- (void)encodeWithCoder:(NSCoder*)aCoder
{
    [aCoder encodeObject:self.schoolId forKey:@"schoolId"];
    [aCoder encodeObject:self.schoolName forKey:@"schoolName"];
    [aCoder encodeObject:self.province forKey:@"province"];
    [aCoder encodeObject:self.city forKey:@"city"];
    [aCoder encodeObject:self.area forKey:@"area"];
    [aCoder encodeObject:self.type forKey:@"type"];

    //搜索的时候用来传递参数，存储的时候可以为空
    [aCoder encodeObject:self.searchKeyword forKey:@"searchKeyword"];

}

@end
