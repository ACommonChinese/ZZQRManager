//
//  ZZQRScanner.m
//  ZZQRManager
//
//  Created by 刘威振 on 2/3/16.
//  Copyright © 2016 LiuWeiZhen. All rights reserved.
//  https://www.shinobicontrols.com/blog/ios7-day-by-day-day-16-decoding-qr-codes-with-avfoundation

#import "ZZQRScanner.h"
#import <AVFoundation/AVFoundation.h>

@interface ZZQRScanner () <AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic) AVCaptureSession *session;
@property (nonatomic) AVCaptureVideoPreviewLayer *preview;
@property (nonatomic, copy) ZZQRScannerResultType resultHandler;
@end

@implementation ZZQRScanner

- (void)startScanInView:(UIView *)view resultHandler:(ZZQRScannerResultType)resultHandler {
    [self startScanInView:view machineReadableCodeObjects:@[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeFace] resultHandler:resultHandler];
}

- (void)startScanInView:(UIView *)view machineReadableCodeObjects:(NSArray *)codeObjects resultHandler:(ZZQRScannerResultType)resultHandler {
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (error) {
        NSLog(@"%@", error.localizedDescription);
        return;
    }
    self.session = [[AVCaptureSession alloc] init];
    [self.session addInput:input];
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    [self.session addOutput:output];
    [output setMetadataObjectTypes:codeObjects];
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    self.preview = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.preview.videoGravity = AVLayerVideoGravityResizeAspectFill; // The videoGravity property is used to specify how the video should appear within the bounds of the layer. Since the aspect-ratio of the video is not equal to that of the screen, we want to chop off the edges of the video so that it appears to fill the entire screen, hence the use of AVLayerVideoGravityResizeAspectFill.
    self.preview.frame = view.bounds;
    [view.layer insertSublayer:self.preview atIndex:0];
    self.resultHandler = resultHandler;
    [self.session startRunning];
}

#pragma mark - <AVCaptureMetadataOutputObjectsDelegate>
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    for (AVMetadataObject *metadata in metadataObjects) {
        if ([metadata isKindOfClass:[AVMetadataMachineReadableCodeObject class]]) {
            AVMetadataMachineReadableCodeObject *machineCodeObject = (AVMetadataMachineReadableCodeObject *)[self.preview transformedMetadataObjectForMetadataObject:metadata];
            [self.session stopRunning];
            if (self.resultHandler) {
                self.resultHandler(self, machineCodeObject);
            }
            return;
        }
    }
    /**
    [self.session stopRunning];
    AVMetadataObject *metadata = [metadataObjects objectAtIndex:0];
    AVMetadataMachineReadableCodeObject *machineCodeObject = (AVMetadataMachineReadableCodeObject *)[self.preview transformedMetadataObjectForMetadataObject:metadata];
    if (self.resultHandler) {
        self.resultHandler(self, machineCodeObject);
    }*/
}

/**
 - (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection 
 {
    [self stopScan];
    AVMetadataObject *metadata = [metadataObjects objectAtIndex:0];
    [self.preview transformedMetadataObjectForMetadataObject:metadata];
    CGRect interestRect = [machineCodeObject bounds];
    NSLog(@"%@", NSStringFromCGRect(interestRect));
    NSString *codeStr  = nil;
    if ([metadata respondsToSelector:@selector(stringValue)]) {
        codeStr = [(AVMetadataMachineReadableCodeObject *)metadata stringValue];
    }
    if (self.resultHandler) {
        self.resultHandler(self, interestRect, codeStr);
    }
 }
 */

/**
for (AVMetadataObject *object in metadataObjects) {
    if ([object.type isEqual:AVMetadataObjectTypeFace]) {
        AVMetadataFaceObject *face = (AVMetadataFaceObject *)object;
        CMTime timestamp = [face time];
        CGRect faceRectangle = face.bounds;
        //        NSInteger faceID = face.faceID;
        CGFloat rollAngle = face.rollAngle;
        CGFloat yawAngle = face.yawAngle;
        AVMetadataFaceObject *adjusted = (AVMetadataFaceObject *)[self.preview transformedMetadataObjectForMetadataObject:face];
    }
}
 */

- (BOOL)isScanning {
    return self.session.isRunning;
}

- (void)stopScan {
    [self.session stopRunning];
}

- (void)resumeScan {
    [self.session startRunning];
}

- (void)dealloc {
    // NSLog(@"内存没有问题");
    // NSLog(@"%s", __func__);
}

@end





