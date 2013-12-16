//
//  XXSimpleAudio.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-17.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "XXSimpleAudio.h"

NSString *const XXRefreshAudioEffect = @"refreshaudio.amr";
NSString *const XXTeaseSendAudioEffect = @"";

@implementation XXSimpleAudio

+ (NSString *)bundleAudioEffectWithName:(NSString*)name
{
    if ([name rangeOfString:@"."].location == NSNotFound) {
        DDLogWarn(@"effect name must has . to show what sound type it is!");
        return nil;
    }
    
    NSArray *fileNameArray = [name componentsSeparatedByString:@"."];
    
    return [[NSBundle mainBundle]pathForResource:[fileNameArray objectAtIndex:0] ofType:[fileNameArray objectAtIndex:1]];
}
+ (void)playRefreshEffect
{
    if ([XXSimpleAudio bundleAudioEffectWithName:XXRefreshAudioEffect]) {
        [MCSoundBoard addAudioAtPath:[XXSimpleAudio bundleAudioEffectWithName:XXRefreshAudioEffect] forKey:XXRefreshAudioEffect];
        [MCSoundBoard playSoundForKey:XXRefreshAudioEffect];
    }else{
        DDLogWarn(@"audio can't be find!");
    }
  
}

+ (void)playTeaseSendEffect
{
    
}


@end
