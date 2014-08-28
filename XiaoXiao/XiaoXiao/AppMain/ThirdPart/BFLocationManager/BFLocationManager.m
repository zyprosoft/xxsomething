//
//  BFLocationManager.m
//  BarfooBlog
//
//  Created by ZYVincent on 12-12-24.
//  Copyright (c) 2012年 barfoo. All rights reserved.
//

#import "BFLocationManager.h"

@implementation BFLocationManager
@synthesize locationManager,loactionCoordinate;
@synthesize reciever,recieveMethod;

- (id)init
{
    if (self = [super init]) {
        
        
    }
    return self;
}

//对外接口
- (void)startGetLocationInfoWithDelegate:(id)newReciever withRecieveMethod:(NSString *)newRecieveMethod
{
    
    if (!newReciever) {
        return;
    }
    if (!newRecieveMethod) {
        return;
    }
    
    if (self.reciever) {
        self.reciever = nil;
    }
    
    if (self.recieveMethod) {
        self.recieveMethod = nil;
    }
    
    self.reciever = newReciever;
    self.recieveMethod = newRecieveMethod;
    
    //开始获取信息
    [self startGetCoordination];
    
}
- (void)startGetLocationInfoWithDelegate:(id)newReciever withUpdateBlock:(BFLocationManagerFinishUpdateBlock)updateBlock
{
    //开始获取信息
    [self startGetCoordination];
    _updateBlock = [updateBlock copy];
}

//---------- 通用获取经纬度位置 
- (void)startGetCoordination
{
    if (!self.locationManager) {
        
        self.locationManager = [[CLLocationManager alloc]init];
        
        self.locationManager.delegate = self;
        
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        self.locationManager.distanceFilter = 20.0f;
        
        [self.locationManager startUpdatingLocation];
        
        
    }else {
        
        [self.locationManager stopUpdatingLocation];
        [self.locationManager startUpdatingLocation];
    }
    
}

#pragma mark - 获取经纬度代理方法
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    if (newLocation) {
        
        self.loactionCoordinate = newLocation.coordinate;
        
        [manager stopUpdatingLocation];
        
        if (_updateBlock) {
            _updateBlock(self.loactionCoordinate.latitude,self.loactionCoordinate.longitude);
        }
    }
    
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"faild start update location");
    if (_updateBlock) {
        _updateBlock(0,0);
    }
}


@end
