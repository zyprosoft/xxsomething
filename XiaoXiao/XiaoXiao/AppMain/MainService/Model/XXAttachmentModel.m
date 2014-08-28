//
//  XXAttachmentModel.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-23.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "XXAttachmentModel.h"

@implementation XXAttachmentModel

- (id)initWithContentDict:(NSDictionary *)contentDict
{
    if (self = [super init]) {
        
        //默认值
        self.attachementId = @"";
        self.createUserId = @"";
        self.description = @"";
        self.link = @"";
        self.fileName = @"";
        self.addTime = @"";

        self.attachementId = [contentDict objectForKey:@"attachment_id"];
        self.createUserId = [contentDict objectForKey:@"user_id"];
        self.description = [contentDict objectForKey:@"description"];
        self.link = [contentDict objectForKey:@"link"];
        self.fileName = [contentDict objectForKey:@"filename"];
    }
    return self;
}

- (id)initWithCoder:(NSCoder*)aDecoder
{
    if (self = [super init]) {
        
        self.attachementId = [aDecoder decodeObjectForKey:@"attachementId"];
        self.createUserId = [aDecoder decodeObjectForKey:@"createUserId"];
        self.description = [aDecoder decodeObjectForKey:@"description"];
        self.link = [aDecoder decodeObjectForKey:@"link"];
        self.fileName = [aDecoder decodeObjectForKey:@"fileName"];
        self.addTime = [aDecoder decodeObjectForKey:@"addTime"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder*)aCoder
{
    [aCoder encodeObject:self.attachementId forKey:@"attachementId"];
    [aCoder encodeObject:self.createUserId forKey:@"createUserId"];
    [aCoder encodeObject:self.description forKey:@"description"];
    [aCoder encodeObject:self.link forKey:@"link"];
    [aCoder encodeObject:self.fileName forKey:@"fileName"];
    [aCoder encodeObject:self.addTime forKey:@"addTime"];

}

@end
