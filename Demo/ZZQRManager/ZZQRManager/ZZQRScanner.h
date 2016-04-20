//
//  ZZQRScanner.h
//  ZZQRManager
//
//  Created by 刘威振 on 2/3/16.
//  Copyright © 2016 LiuWeiZhen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class ZZQRScanner;
typedef void (^ZZQRScannerResultType)(ZZQRScanner *scanner, AVMetadataMachineReadableCodeObject *codeObject);

@interface ZZQRScanner : NSObject

@property (nonatomic, readonly) BOOL isScanning;

- (void)startScanInView:(UIView *)view resultHandler:(ZZQRScannerResultType)resultHandler;
- (void)startScanInView:(UIView *)view machineReadableCodeObjects:(NSArray *)codeObjects resultHandler:(ZZQRScannerResultType)resultHandler;
- (void)stopScan;
- (void)resumeScan;

@end
