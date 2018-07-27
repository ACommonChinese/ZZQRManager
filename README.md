# ZZQRManager
**二维码/一维码扫描示意：**
two-dimensional or one-dimensional barcode scan info:


![](./images/0.png)

二维码扫描： iOS7.0 & later  
二维码解码图片：iOS8.0 & later

配置方法：    
把文件夹ZZQRManager托入工程即可，或通过Pod安装：  

```
pod 'ZZQRManager', ~> '1.0.0'
```

使用系统AVFoundation框架进行扫描和解码图片以及二维码的生成。  
二维码扫描(含有解码二维码图片功能)：  

```
#import "ZZQRManager.h"
...
// 扫描
- (IBAction)scan:(id)sender {
    ZZQRScanViewController *controller = [[ZZQRScanViewController alloc] init];
    // 设置扫描结果回调block
    [controller setResultHandler:^(ZZQRScanViewController *controller, NSString *result) {
        [controller dismissViewControllerAnimated:YES completion:^{
            self.resultLabel.text = result;
        }];
    }];
    [self presentViewController:controller animated:YES completion:nil];
}
```
效果图：  
![](./images/1.jpg)
![](./images/2.jpg)
![](./images/3.jpg)

---------

二维码生成：  

```
- (void)generateQRCode:(id)sender {
    self.resultImageView.image = [ZZQRImageHelper generateBarcode2ImageWithStr:self.inputField.text size:self.resultImageView.frame.size.width];
}
```
