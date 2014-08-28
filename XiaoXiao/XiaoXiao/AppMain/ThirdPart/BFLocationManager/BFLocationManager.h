//
//  BFLocationManager.h
//  BarfooBlog
//
//  Created by ZYVincent on 12-12-24.
//  Copyright (c) 2012年 barfoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
// 地理位置获取

typedef void (^BFLocationManagerFinishUpdateBlock) (long lat,long lng);

@interface BFLocationManager : NSObject<CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    
    CLLocationCoordinate2D loactionCoordinate;
    
    id  reciever;
    NSString *recieveMethod;

    BFLocationManagerFinishUpdateBlock _updateBlock;
}
@property (nonatomic,retain)CLLocationManager *locationManager;
@property (nonatomic,assign)CLLocationCoordinate2D loactionCoordinate;
@property (nonatomic,retain)id reciever;
@property (nonatomic,retain)NSString *recieveMethod;

- (void)startGetLocationInfoWithDelegate:(id)newReciever withRecieveMethod:(NSString*)newRecieveMethod;
- (void)startGetLocationInfoWithDelegate:(id)newReciever withUpdateBlock:(BFLocationManagerFinishUpdateBlock)updateBlock;

@end
