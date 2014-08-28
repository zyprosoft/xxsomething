//
//  XXAudioManager.m
//  AudioRecord
//
//  Created by ZYVincent on 13-12-19.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "XXAudioManager.h"
#import "VoiceConverter.h"

#define XXAudioManagerTempFileDirectory @"XXAudioTemplateDirectory"

#define XXMaxAudioRecordTime 60*60  //一分钟

#define XXCacheAudioForRemoteAudioRelationShipListUDFKey @"XXCacheAudioForRemoteAudioRelationShipUDFKey"

@implementation XXAudioManager

#pragma mark - api
- (id)init
{
    if (self = [super init]) {
        [self createCacheDirectory];
    }
    return self;
}
+ (XXAudioManager*)shareManager
{
    static XXAudioManager *audioManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!audioManager) {
            audioManager = [[XXAudioManager alloc]init];
            
        }
    });
    return audioManager;
}

/**
 生成当前时间字符串
 @returns 当前时间字符串
 */
- (NSString*)getCurrentTimeString
{
    NSDateFormatter *dateformat=[[NSDateFormatter  alloc]init];
    [dateformat setDateFormat:@"yyyyMMddHHmmss"];
    return [dateformat stringFromDate:[NSDate date]];
}

/**
 获取录音设置
 @returns 录音设置
 */
- (NSDictionary*)getAudioRecorderSettingDict
{
    NSDictionary *recordSetting = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithFloat: 8000.0],AVSampleRateKey, //采样率
                                   [NSNumber numberWithInt: kAudioFormatLinearPCM],AVFormatIDKey,
                                   [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,//采样位数 默认 16
                                   [NSNumber numberWithInt: 1], AVNumberOfChannelsKey,//通道的数目
                                   //                                   [NSNumber numberWithBool:NO],AVLinearPCMIsBigEndianKey,//大端还是小端 是内存的组织方式
                                   //                                   [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,//采样信号是整数还是浮点数
                                                                      [NSNumber numberWithInt: AVAudioQualityMedium],AVEncoderAudioQualityKey,//音频编码质量
                                   nil];
    return recordSetting;
}
- (void)createCacheDirectory
{
    NSArray *dirPaths;
    NSString *docsDir;
    
    dirPaths = NSSearchPathForDirectoriesInDomains(
                                                   NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths lastObject];
    
    NSString *xxAudioDirectory = [docsDir stringByAppendingPathComponent:XXAudioManagerTempFileDirectory];

    BOOL isDir = YES;
    if (![[NSFileManager defaultManager]fileExistsAtPath:xxAudioDirectory isDirectory:&isDir]) {
        
        [[NSFileManager defaultManager]createDirectoryAtPath:xxAudioDirectory withIntermediateDirectories:YES attributes:NO error:nil];
    }
    
    //创建本地录音对远程映射目录
    if (![[NSUserDefaults standardUserDefaults]objectForKey:XXCacheAudioForRemoteAudioRelationShipListUDFKey]) {
        
        NSMutableDictionary *shipList = [NSMutableDictionary dictionary];
        [[NSUserDefaults standardUserDefaults]setObject:shipList forKey:XXCacheAudioForRemoteAudioRelationShipListUDFKey];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    
}
- (NSString*)cacheDirectory
{
    NSArray *dirPaths;
    NSString *docsDir;
    
    dirPaths = NSSearchPathForDirectoriesInDomains(
                                                   NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths lastObject];
    
    NSString *xxAudioDirectory = [docsDir stringByAppendingPathComponent:XXAudioManagerTempFileDirectory];

    return xxAudioDirectory;
}

#pragma mark - 获取文件大小
- (NSInteger) getFileSize:(NSString*) path{
    NSFileManager * filemanager = [NSFileManager defaultManager];
    if([filemanager fileExistsAtPath:path]){
        NSDictionary * attributes = [filemanager attributesOfItemAtPath:path error:nil];
        NSNumber *theFileSize;
        if ( (theFileSize = [attributes objectForKey:NSFileSize]) )
            return  [theFileSize intValue];
        else
            return -1;
    }
    else{
        return -1;
    }
}

- (NSURL*)buildRecordSavePath
{
    //template file name
    NSString *soundFileName = [NSString stringWithFormat:@"%@.wav",[self getCurrentTimeString]] ;
    
    NSString *soundFilePath = [[self cacheDirectory]
                               stringByAppendingPathComponent:soundFileName];
    return [NSURL URLWithString:soundFilePath];
}

- (NSString*)buildCachePathForFileName:(NSString*)fileName
{
    NSString *soundFilePath = [[self cacheDirectory]
                               stringByAppendingPathComponent:fileName];
    return soundFilePath;
}
- (NSString*)getFileNameFromUrl:(NSString*)urlString
{
    NSArray *urlSepratorArray = [urlString componentsSeparatedByString:@"/"];
    NSArray *namesArray = [[urlSepratorArray lastObject]componentsSeparatedByString:@"."];
    
    return [namesArray objectAtIndex:0];
}
- (NSString*)urlToFileName:(NSString*)url
{
    return [url stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
}

- (void)createAudioRecord
{
    NSDictionary *recordSettings = [self getAudioRecorderSettingDict];
    
    NSError *error = nil;
        
    self.audioRecorder = [[AVAudioRecorder alloc]
                          initWithURL:[self buildRecordSavePath]
                     settings:recordSettings
                     error:&error];
    self.audioRecorder.delegate = self;
    
    if (error)
    {
        NSLog(@"error: %@", [error localizedDescription]);
    } else {
        self.audioRecorder.meteringEnabled = YES;
        [self.audioRecorder prepareToRecord];
        //开始录音
        [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayAndRecord error:nil];
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
        [self.audioRecorder recordForDuration:XXMaxAudioRecordTime];
        _recordStop = NO;
        _recordTime = 0;
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(audioTimeTimer:) userInfo:nil repeats:YES];
    }
}

#pragma mark - audio record delegate
- (void)audioRecorderBeginInterruption:(AVAudioRecorder *)recorder
{
    
}
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    _recordStop = YES;
    if (flag) {
        NSLog(@"record success!");
        
        //转换成AMR
        NSString *amrFile = [NSString stringWithFormat:@"%@.amr",[self getFileNameFromUrl:self.audioRecorder.url.absoluteString]];
        [VoiceConverter wavToAmr:self.audioRecorder.url.absoluteString amrSavePath:[self buildCachePathForFileName:amrFile]];
        NSData *originData = [NSData dataWithContentsOfURL:self.audioRecorder.url];
        DDLogVerbose(@"origin data :%d",originData.length);
        NSData *dateLength = [NSData dataWithContentsOfFile:[self buildCachePathForFileName:amrFile]];
        DDLogVerbose(@"amr file:%d",dateLength.length);
        if (_finishBlock) {
            NSString *timeLengthString = [NSString stringWithFormat:@"%d",_recordTime-1];
            _finishBlock([self buildCachePathForFileName:amrFile],self.audioRecorder.url.absoluteString,timeLengthString);
        }
    }
}

- (void)checkIsWavAudioCached:(NSString*)amrFile
{
    
}

- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error
{
    
}

- (void)audioManagerStartRecordWithFinishRecordAction:(XXAudioManagerFinishRecordBlock)finishBlock
{
    _finishBlock = [finishBlock copy];
    [self createAudioRecord];
    [VoiceConverter changeStu];
    
}
- (void)audioManagerEndRecord
{
    if (self.audioRecorder.isRecording) {
        [VoiceConverter changeStu];
        [self.audioRecorder stop];
    }
}
- (void)audioTimeTimer:(NSTimer*)aTimer
{
    if (!_recordStop) {
        _recordTime++;
    }else{
        [aTimer invalidate];
    }
}

- (void)audioManagerPlayAudioForRemoteAMRUrl:(NSString *)remoteAMRUrl
{
    //is cached
    NSMutableDictionary *shipList = [[NSUserDefaults standardUserDefaults]objectForKey:XXCacheAudioForRemoteAudioRelationShipListUDFKey];
    DDLogVerbose(@"shipList :%@",shipList);
    DDLogVerbose(@"cache url %@",[shipList objectForKey:remoteAMRUrl]);
    if (![shipList objectForKey:remoteAMRUrl]) {
        
        DDLogVerbose(@"no amr cache!");
        if ([self.delegate respondsToSelector:@selector(audioManagerDidStartDownload)]) {
            [self.delegate audioManagerDidStartDownload];
        }
        //
        NSString *fileName = [self urlToFileName:remoteAMRUrl];
        NSString *cachePath = [self buildCachePathForFileName:fileName];
        [[XXMainDataCenter shareCenter]downloadFileWithLinkPath:remoteAMRUrl WithDestSavePath:cachePath withSuccess:^(NSString *successMsg) {
            [self saveRemoteAMRToWav:cachePath withRemoteUrl:remoteAMRUrl whileFinishShouldPlay:YES];
        } withFaild:^(NSString *faildMsg) {
            [SVProgressHUD showErrorWithStatus:faildMsg];
            if ([self.delegate respondsToSelector:@selector(audioManagerDidDownloadFaild)]) {
                [self.delegate audioManagerDidDownloadFaild];
            }
        }];
        
    }else{
        NSString *localFilePath = [shipList objectForKey:remoteAMRUrl];
        [self audioManagerPlayLocalWavWithPath:localFilePath];
        
    }
}
- (void)audioManagerPlayLocalWavWithPath:(NSString *)filePath
{
    DDLogVerbose(@"audio will Play local File :%@",filePath);
    
    [self audioManagerPlayLocalWav:filePath];
}

- (void)audioManagerPlayLocalWav:(NSString*)filePath
{
    self.audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL URLWithString:filePath] error:nil];
    self.audioPlayer.delegate = self;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    if ([self.delegate respondsToSelector:@selector(audioManagerDidStartPlay)]) {
        [self.delegate audioManagerDidStartPlay];
    }
    [self.audioPlayer play];
}
- (void)audioManagerEndPlayNow
{
    if ([self.audioPlayer isPlaying]) {
        [self.audioPlayer stop];
        if ([self.delegate respondsToSelector:@selector(audioManagerDidEndPlay)]) {
            [self.delegate audioManagerDidEndPlay];
        }
    }
}

- (void)saveLocalAudioFile:(NSString *)localFilePath forRemoteAMRFile:(NSString *)remoteAMRUrl
{
    NSMutableDictionary *shipList = [[NSUserDefaults standardUserDefaults]objectForKey:XXCacheAudioForRemoteAudioRelationShipListUDFKey];
    [shipList setObject:localFilePath forKey:remoteAMRUrl];
    [[NSUserDefaults standardUserDefaults]setObject:shipList forKey:XXCacheAudioForRemoteAudioRelationShipListUDFKey];
}
- (void)saveRemoteAMRToWav:(NSString *)downloadAMRFilePath withRemoteUrl:(NSString *)remoteAMRUrl
{
    [self saveRemoteAMRToWav:downloadAMRFilePath withRemoteUrl:remoteAMRUrl whileFinishShouldPlay:NO];
}

- (void)saveRemoteAMRToWav:(NSString *)downloadAMRFilePath withRemoteUrl:(NSString *)remoteAMRUrl whileFinishShouldPlay:(BOOL)shouldPlay
{
    NSMutableDictionary *shipList = [[NSUserDefaults standardUserDefaults]objectForKey:XXCacheAudioForRemoteAudioRelationShipListUDFKey];
    if (!shipList) {
        shipList = [NSMutableDictionary dictionary];
    }
    
    NSString *amrFileName = [self urlToFileName:remoteAMRUrl];
    amrFileName = [amrFileName stringByReplacingOccurrencesOfString:@".amr" withString:@".wav"];
    NSString *cachePath = [self buildCachePathForFileName:amrFileName];
    
    [VoiceConverter amrToWav:downloadAMRFilePath wavSavePath:cachePath];
    if ([self.delegate respondsToSelector:@selector(audioManagerDidFinishDownload)]) {
        [self.delegate audioManagerDidFinishDownload];
    }
    
    //建立关系
    NSData *downloadAmrData = [NSData dataWithContentsOfFile:downloadAMRFilePath];
    DDLogVerbose(@"download amr data length:%d",downloadAmrData.length);
    DDLogVerbose(@"save remoteAMRUrl :%@ forLocal:%@",remoteAMRUrl,cachePath);
    
//    [shipList setObject:cachePath forKey:remoteAMRUrl];//没有这个映射关系就没法缓存语音数据
    [[NSUserDefaults standardUserDefaults]setObject:shipList forKey:XXCacheAudioForRemoteAudioRelationShipListUDFKey];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    //立即播放
    if (shouldPlay) {
        
        [self audioManagerPlayLocalWav:cachePath];
    }

}

//录音结束立马发送
- (void)audioManagerStartRecordWithFinishRecordAction
{
    
}

#pragma mark - audio player play delegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if ([self.delegate respondsToSelector:@selector(audioManagerDidEndPlay)]) {
        [self.delegate audioManagerDidEndPlay];
    }
}
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    if ([self.delegate respondsToSelector:@selector(audioManagerDidEndPlay)]) {
        [self.delegate audioManagerDidEndPlay];
    }
}
- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player
{
    if ([self.delegate respondsToSelector:@selector(audioManagerDidEndPlay)]) {
        [self.delegate audioManagerDidEndPlay];
    }
}


@end
