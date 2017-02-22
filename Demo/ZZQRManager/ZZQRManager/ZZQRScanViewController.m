//
//  ZZQRScanViewController.m
//  ZZQRManager
//
//  Created by 刘威振 on 2/3/16.
//  Copyright © 2016 LiuWeiZhen. All rights reserved.
//

#import "ZZQRScanViewController.h"
#import "ZZQRScanner.h"
#import "ZZQROptionView.h"
#import "ZZQRIndicatorView.h"
#import "ZZQRImageHelper.h"
#import "ZZQRPlaySound.h"
#import "ZZQRPlaceholderView.h"

@interface ZZQRScanViewController ()

@property (nonatomic) ZZQRIndicatorView *indicatorView; // show view，scale bigger/smaller to locate the area
@property (nonatomic) ZZQRScanner *scanner;
@property (nonatomic) NSString *result;
@property (nonatomic) ZZQRPlaceholderView *placeholderView;
@end

@implementation ZZQRScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.placeholderView = [[ZZQRPlaceholderView alloc] init];
    [self.placeholderView showWithMode:ZZQRPlaceholderViewModeIndicator];
    
    [self performSelector:@selector(initUI) withObject:nil afterDelay:0.25];
}

- (void)initUI {
    [self.placeholderView dismiss], self.placeholderView = nil;
    
    self.indicatorView = [[ZZQRIndicatorView alloc] initWithFrame:self.view.bounds];
    self.indicatorView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_indicatorView];
    
    // 选项视图：二维码扫描/读取相册/开灯
    ZZQROptionView *optionView = [ZZQROptionView optionViewWithFrame:CGRectMake(0, self.view.bounds.size.height-100, [[UIScreen mainScreen] bounds].size.width, 100)];
    [self.view addSubview:optionView];
    
    __weak __typeof(self) weakself = self;
    optionView.callbackHandler = ^(NSInteger index) {
        switch (index) {
            case 0: { // from album
                [self stopScan];
                [ZZQRImageHelper getQRStrByPickImageWithController:self completionHandler:^(CIImage *image, NSString *decodeStr) {
                    // 取消选图
                    if (image == nil && decodeStr == nil) {
                        [self startScan];
                        return ;
                    }
                    if (decodeStr == nil) { // 不是合法的二维码图片
                        self.placeholderView = [[ZZQRPlaceholderView alloc] init];
                        [self.placeholderView showWithMode:ZZQRPlaceholderViewModeRefresh];
                        QRRefreshView *refreshView = (QRRefreshView *)self.placeholderView.contentView;
                        [refreshView.refreshButton addTarget:self action:@selector(refresh) forControlEvents:UIControlEventTouchUpInside];
                        [refreshView.backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
                        return;
                    }
                    
                    if (self.resultHandler) {
                        self.resultHandler(self, decodeStr);
                    }
                }];
                break;
            }
            case 1: { // turn the light on
                [weakself lightOn];
                break;
            }
            case 2: {
                [weakself cancel];
                break;
            }
            default:
                break;
        }
    };
    
    [self startScan];
}

- (void)refresh {
    [self.placeholderView dismiss];
    [self startScan];
}

- (void)back {
    [self.placeholderView dismiss];
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  开灯
 */
- (void)lightOn {
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (captureDevice.torchMode == AVCaptureTorchModeOff) {
        [captureDevice lockForConfiguration:nil];
        captureDevice.torchMode = AVCaptureTorchModeOn; // 开启闪光灯
    } else {
        captureDevice.torchMode = AVCaptureTorchModeOff; // 关闭闪光灯
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self stopScan];
}

- (void)stopScan {
    [self.indicatorView indicateEnd];
    [self.scanner stopScan];
}

- (void)startScan {
    [self.indicatorView indicateStart];
    
    if (self.scanner != nil) {
        [self.scanner resumeScan];
        return;
    }
    
    // 判断是否允许使用相机 iOS7 and later 设置--隐私--相机
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
            NSString*str = [NSString stringWithFormat:@"请在系统设置－%@－相机中打开允许使用相机",  [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleNameKey]];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:str delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return ;
        }
    }
    
    self.scanner = [[ZZQRScanner alloc] init];
    __weak __typeof(self) weakself = self;
    [self.scanner startScanInView:weakself.view resultHandler:^(ZZQRScanner *scanner, AVMetadataMachineReadableCodeObject *codeObject) {
        [ZZQRPlaySound playDefaultSound];
        
        // weakself.indicatorView.duration = 2.0; // default 0.25
        weakself.indicatorView.codeObject  = codeObject;
        [weakself.indicatorView indicateLockInWithCompletion:^(NSString *str) {
            if (weakself.resultHandler) {
                weakself.resultHandler(weakself, str);
            }
        }];
    }];

    /**
    [self.scanner startScanInView:weakself.view resultHandler:^(ZZQRScanner *scanner, CGRect interestRect, NSString *result) {
        
        weakself.result                  = result;
        CABasicAnimation *frameAnimation = [CABasicAnimation animationWithKeyPath:@"bounds"];
        frameAnimation.duration          = 0.4f;
        frameAnimation.timingFunction    = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        frameAnimation.fromValue         = [NSValue valueWithCGRect:weakself.indicatorView.frame];
        frameAnimation.toValue           = [NSValue valueWithCGRect:interestRect];
        frameAnimation.delegate          = weakself;
        weakself.indicatorView = [];
        [weakself.indicatorView setFrame:interestRect];
        [weakself.indicatorView.layer addAnimation:frameAnimation forKey:@"MoveAnimationKey"];
        
        NSLog(@"\n(%lf,%lf) (%lf,%lf) (%lf,%lf), (%lf,%lf)\n", interestRect.origin.x, interestRect.origin.y, interestRect.origin.x, CGRectGetMaxY(interestRect), CGRectGetMaxX(interestRect), CGRectGetMaxY(interestRect), CGRectGetMaxX(interestRect), interestRect.origin.y);
    }];
     */
}

- (void)cancel {
    [self.scanner stopScan];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - decode QRCode image 解码二维码图片
// https://www.shinobicontrols.com/blog/ios8-day-by-day-day-13-coreimage-detectors
- (CIImage *)prepareRectangleDetector:(CIImage *)ciImage {
    NSDictionary *options = @{CIDetectorAccuracy : CIDetectorAccuracyHigh};
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:options];
    NSArray *features = [detector featuresInImage:ciImage];
    for (CIFeature *feature in features) {
        if ([feature isKindOfClass:[CIQRCodeFeature class]]) {
            CIQRCodeFeature *qrFeature = (CIQRCodeFeature *)feature;
            //CIRectangleFeature *rectangleFeature = (CIRectangleFeature *)feature;
            //resultImage = [self drawHighlightOverlayForImage:ciImage feature:rectangleFeature];
            [qrFeature messageString];
        }
    }
    return nil;
}

#pragma mark -

- (void)dealloc {
    // NSLog(@"memory is ok");
    // NSLog(@"%s", __func__);
}

@end

