//
//  XXSimpleAudio.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-17.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "XXSimpleAudio.h"
#import "BRYSoundEffectPlayer.h"

NSString *const XXRefreshAudioEffect = @"refreshaudio.amr";
NSString *const XXTeaseSendAudioEffect = @"";
NSString *const XXPullShootEffect = @"pull_shoot.m4r";
NSString *const XXShootNowEffect = @"shoot_now.m4r";

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
    [[BRYSoundEffectPlayer sharedInstance]playSound:[XXSimpleAudio bundleAudioEffectWithName:@"msg_send.m4r"]];
}

+ (void)playTeaseSendEffect
{
    
}

+ (void)playPullShootEffect
{
    [[BRYSoundEffectPlayer sharedInstance]playSound:[XXSimpleAudio bundleAudioEffectWithName:XXPullShootEffect]];
}
+ (void)playShootNowEffect
{
    [[BRYSoundEffectPlayer sharedInstance]playSound:[XXSimpleAudio bundleAudioEffectWithName:XXShootNowEffect]];
}

+ (void)playMsgSendEffect
{
    [[BRYSoundEffectPlayer sharedInstance]playSound:[XXSimpleAudio bundleAudioEffectWithName:@"msg_send.m4r"]];
}

+ (void)playShootFindEffect
{
    [[BRYSoundEffectPlayer sharedInstance]playSound:[XXSimpleAudio bundleAudioEffectWithName:@"shoot_find.m4r"]];

}

+ (void)playShootNoneEffect
{
    [[BRYSoundEffectPlayer sharedInstance]playSound:[XXSimpleAudio bundleAudioEffectWithName:@"shoot_none.m4r"]];
}


@end
