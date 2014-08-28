//
//  XXAudioManager.h
//  AudioRecord
//
//  Created by ZYVincent on 13-12-19.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "XXMainDataCenter.h"

@protocol XXAudioManagerDelegate <NSObject>

- (void)audioManagerDidEndPlay;
- (void)audioManagerDidStartPlay;
- (void)audioManagerDidCancelPlay;
- (void)audioManagerDidStartDownload;
- (void)audioManagerDidFinishDownload;
- (void)audioManagerDidDownloadFaild;

@end
typedef void (^XXAudioManagerFinishRecordBlock) (NSString *audioSavePath,NSString *wavSavePath,NSString *timeLength);

@interface XXAudioManager : NSObject <AVAudioRecorderDelegate, AVAudioPlayerDelegate>
{
    XXAudioManagerFinishRecordBlock _finishBlock;
    BOOL  _recordStop;
    NSInteger _recordTime;
    NSTimer    *_recordTimer;
}
@property (nonatomic,strong)AVAudioRecorder *audioRecorder;
@property (nonatomic,strong)AVAudioPlayer *audioPlayer;
@property (nonatomic,weak)id<XXAudioManagerDelegate> delegate;

+ (XXAudioManager*)shareManager;

- (void)audioManagerStartRecordWithFinishRecordAction:(XXAudioManagerFinishRecordBlock)finishBlock;
- (void)audioManagerEndRecord;

- (void)audioManagerPlayAudioForRemoteAMRUrl:(NSString*)remoteAMRUrl;
- (void)audioManagerPlayLocalWavWithPath:(NSString*)filePath;
- (void)audioManagerEndPlayNow;

- (NSString*)getFileNameFromUrl:(NSString*)urlString;

//自己录音的时候，保存一个与远程服务器的映射
- (void)saveLocalAudioFile:(NSString*)localFilePath forRemoteAMRFile:(NSString*)remoteAMRUrl;
//将服务器的AMR数据下载到本地，保存一份Wav数据，建立映射关系
- (void)saveRemoteAMRToWav:(NSString*)downloadAMRFilePath withRemoteUrl:(NSString*)remoteAMRUrl;
- (void)saveRemoteAMRToWav:(NSString *)downloadAMRFilePath withRemoteUrl:(NSString *)remoteAMRUrl whileFinishShouldPlay:(BOOL)shouldPlay;

@end
