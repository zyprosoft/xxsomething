//
//  NearByUserListViewController.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "XXBaseUserListViewController.h"
#import "BFLocationManager.h"

@interface NearByUserListViewController : XXBaseUserListViewController
{
    BFLocationManager *_locationManager;
    long _latitude;
    long _longtitude;
}
@end
