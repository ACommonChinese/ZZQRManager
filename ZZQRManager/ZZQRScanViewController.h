//
//  ZZQRScanViewController.h
//  ZZQRManager
//
//  Created by 刘威振 on 2/3/16.
//  Copyright © 2016 LiuWeiZhen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZZQRScanViewController;

@interface ZZQRScanViewController : UIViewController

@property (nonatomic, copy) void (^resultHandler)(ZZQRScanViewController *controller, NSString *result);

- (void)setResultHandler:(void (^)(ZZQRScanViewController *controller, NSString *result))resultHandler;

@end
