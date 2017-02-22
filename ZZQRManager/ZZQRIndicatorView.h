//
//  ZZQRIndicatorView.h
//  ZZQRManager
//
//  Created by 刘威振 on 2/8/16.
//  Copyright © 2016 LiuWeiZhen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "ZZQRPoint.h"

@interface ZZQRIndicatorView : UIView

@property (nonatomic) AVMetadataMachineReadableCodeObject *codeObject;
@property (nonatomic) double duration;

/**
 *  开始动画－－搜索
 */
- (void)indicateStart;

/**
 *  结束动画－－搜索
 */
- (void)indicateEnd;

/**
 *  锁定目标，在二维码的周边画线
 */
- (void)indicateLockInWithCompletion:(void (^)(NSString *str))completion;

@end
