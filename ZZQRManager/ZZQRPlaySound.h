//
//  ZZQRPlaySound.h
//  ZZQRManager
//
//  Created by 刘威振 on 2017/2/21.
//  Copyright © 2017年 LiuWeiZhen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZZQRPlaySound : NSObject

/**
 *  扫描结束后播放声音
 */
+ (void)playDefaultSound;
+ (void)playDefaultSound:(int)count;

@end
