//
//  ZZQRPlaySound.m
//  ZZQRManager
//
//  Created by 刘威振 on 2017/2/21.
//  Copyright © 2017年 LiuWeiZhen. All rights reserved.
//

#import "ZZQRPlaySound.h"
#import <AudioToolbox/AudioToolbox.h>
#import "ZZQRImageHelper.h"

@implementation ZZQRPlaySound

/**
 *  扫描结束后播放声音
 */
+ (void)playDefaultSound {
    [self playDefaultSound:1];
}

+ (void)playDefaultSound:(int)count {
    SystemSoundID completeSound;
    NSInteger cbDataCount = count;
    NSString *path = [ZZQRImageHelper resourcePath:@"di.mp3"];
    NSAssert(path.length > 0, @"audio file not exist, check file");
    NSURL *audioPath = [NSURL fileURLWithPath:path];
    NSAssert(audioPath, @"audio file not exist!");
#if __has_feature(objc_arc)
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)audioPath, &completeSound);
#else
    AudioServicesCreateSystemSoundID((CFURLRef)audioPath, &completeSound);
#endif
    AudioServicesAddSystemSoundCompletion(completeSound, NULL, NULL, soundCompletionCallback, (void*)(cbDataCount-1));
    AudioServicesPlaySystemSound(completeSound);
}

static void soundCompletionCallback(SystemSoundID  ssid, void* data) {
    int count = (int)data;
    AudioServicesRemoveSystemSoundCompletion (ssid);
    AudioServicesDisposeSystemSoundID(ssid);
    if (count > 0) {
        [ZZQRPlaySound playDefaultSound:1];
    }
}

@end

