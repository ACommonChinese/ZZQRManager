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

@property (nonatomic) ZZQRIndicatorView *indicatorView;
@property (nonatomic) ZZQRScanner *scanner;
@property (nonatomic) NSString *result;
@property (nonatomic) ZZQRPlaceholderView *placeholderView;
@end

@implementation ZZQRScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    if ([self notSupportCamera]) {
        return;
    } else {
        [self initUI];
        [self startScan];
    }
}

- (BOOL)notSupportCamera {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = self.view.bounds;
        button.center = self.view.center;
        button.backgroundColor = [UIColor whiteColor];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        UIFont *font = [UIFont systemFontOfSize:20.0];
        [button.titleLabel setFont:font];
        [button setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        [button setTitle:@"设备不支持扫描，点击返回" forState:UIControlStateNormal];
        [button.titleLabel setAdjustsFontSizeToFitWidth:YES];
        button.center = self.view.center;
        [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        return YES;
    }
    return NO;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)pickImageAndGetQRCode {
    [ZZQRImageHelper getQRStrByPickImageWithController:self completionHandler:^(CIImage *image, NSString *decodeStr) {
        // Cancel choose image
        if (image == nil && decodeStr == nil) {
            [self startScan];
            return ;
        }
        if (decodeStr == nil) { // invalid qr string
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
}

- (void)showPlaceholderViewWithModel:(ZZQRPlaceholderViewMode)mode {
    if (!_placeholderView) {
        _placeholderView = [[ZZQRPlaceholderView alloc] init];
    }
    [_placeholderView showWithMode:mode];
}

- (void)initUI {
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
                [weakself stopScan];
                [weakself pickImageAndGetQRCode];
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
}

- (void)refresh {
    [self.placeholderView dismiss];
    [self startScan];
}

- (void)back {
    if (self.placeholderView) {
        [self.placeholderView dismiss];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

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
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.indicatorView indicateStart];
    });
    
    if (self.scanner != nil) {
        [self.scanner resumeScan];
        return;
    }
    
    // 判断是否允许使用相机 iOS7 and later 设置--隐私--相机
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
            NSString*str = [NSString stringWithFormat:@"请在系统设置－%@－相机中打开允许使用相机",  [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleNameKey]];
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }]];
            [self presentViewController:alertController animated:YES completion:nil];
            return;
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
}

- (void)cancel {
    [self.scanner stopScan];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - decode QRCode image
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

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end


