//
//  ViewController.m
//  ZZQRManager
//
//  Created by 刘威振 on 2/4/16.
//  Copyright © 2016 LiuWeiZhen. All rights reserved.
//

#import "FirstViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "SecondViewController.h"
#import "ZZQRScanTypes.h"

@interface FirstViewController () <AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, retain) UILabel *showLabel;
@property (nonatomic) AVCaptureSession *session;
@property (nonatomic) AVCaptureVideoPreviewLayer *preview;
@property (nonatomic) UIButton *button;
@end

/**
 *  此控制器显示了二维码扫描的基本流程
 *  点击 ZZQRManager 按钮，进入SecondViewController，使用库ZZQRManager, 进行二维码扫描生成等操作
 */
@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}

- (void)initUI {
    self.title = @"二维码Demo";
    
    // 显示二维码信息Label
    self.showLabel                 = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, self.view.bounds.size.width - 40, 80)];
    self.showLabel.backgroundColor = [UIColor darkGrayColor];
    self.showLabel.textColor       = [UIColor whiteColor];
    self.showLabel.text            = @"此处显示二维码/条形码扫描结果\n 把二维码/条形码居中扫描屏幕";
    self.showLabel.numberOfLines   = 0;
    self.showLabel.textAlignment   = NSTextAlignmentCenter;
    [self.view addSubview:self.showLabel];
    
    // 扫描按钮
    self.button = [UIButton buttonWithType:UIButtonTypeSystem];
    _button.frame     = CGRectMake(20, CGRectGetHeight(self.view.frame)-60, self.view.bounds.size.width-40, 40);
    [_button setTitle:@"扫描" forState:UIControlStateNormal];
    [_button setTitle:@"停止扫描" forState:UIControlStateSelected];
    [_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_button setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [_button setTintColor:[UIColor clearColor]];
    [_button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_button];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"ZZQRManager" style:UIBarButtonItemStylePlain target:self action:@selector(gotoSecondController:)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

// 开始、停止
- (void)buttonClick:(UIButton *)button {
    button.selected = !button.selected;
    if (button.selected) {
        [self startScan];
    } else {
        [self stopScan];
    }
}

// 开始扫描
- (void)startReadingMachineReadableCodeObjects:(NSArray *)codeObjects inView:(UIView *)view {
    // 摄像头
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // 输入口
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (error) {
        NSLog(@"%@", error.localizedDescription);
        return;
    }
    
    // 会话session(连接输入口和输出口)
    self.session = [[AVCaptureSession alloc] init];
    [self.session addInput:input]; // 连接输入口
    
    // 输出口
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    [self.session addOutput:output]; // 连接输出口
    
    // 设置输出口类型和代理, 我们通过其代理方法拿到输出的数据
    [output setMetadataObjectTypes:codeObjects];
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()]; // 使用主线程队列，相应比较同步，使用其他队列，相应不同步，但是session的startRunning或stopRunning会阻塞线程
    
    // 设置展示层（预览层），显示扫描界面/区域
    self.preview = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.preview.frame = view.bounds;
    [view.layer insertSublayer:self.preview atIndex:0];
    
    // Noted: Block thread!!!
    [self.session startRunning];
}

- (void)startScan {
    [self startReadingMachineReadableCodeObjects:[ZZQRScanTypes scanTypes] inView:self.view];
}

- (void)stopScan {
    self.button.selected = NO;
    [self.session stopRunning]; // Not good idea here, because it block the main thread！！！
    [self.preview removeFromSuperlayer];
}

// 识别到二维码 并解析转换为字符串
#pragma mark - <AVCaptureMetadataOutputObjectsDelegate>
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    [self stopScan];
    
    AVMetadataObject *metadata = [metadataObjects objectAtIndex:0];
    NSString *codeStr = nil;
    if ([metadata respondsToSelector:@selector(stringValue)]) {
        codeStr = [(AVMetadataMachineReadableCodeObject *)metadata stringValue];
    }
    
    self.showLabel.text = codeStr;
}

#pragma mark - 进入第二个控制器，对二维码扫描进行封装操作
- (void)gotoSecondController:(id)sender {
    SecondViewController *controller = [[SecondViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
