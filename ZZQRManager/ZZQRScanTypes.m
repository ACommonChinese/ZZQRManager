//
//  ZZQRScanTypes.m
//  ZZQRManager
//
//  Created by 刘威振 on 2017/2/22.
//  Copyright © 2017年 LiuWeiZhen. All rights reserved.
//

#import "ZZQRScanTypes.h"
#import <AVFoundation/AVFoundation.h>

@implementation ZZQRScanTypes

+ (NSArray *)scanTypes {
    return @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
}

+ (NSString *)barcode1FilterType {
    return @"CICode128BarcodeGenerator";
}

+ (NSString *)barcode2FilterType {
    return @"CIQRCodeGenerator";
}

@end
