//
//  SecondViewController.m
//  ZZQRManager
//
//  Created by 刘威振 on 2/3/16.
//  Copyright © 2016 LiuWeiZhen. All rights reserved.
//

#import "SecondViewController.h"
#import "ZZQRManager.h"

@interface SecondViewController ()

@property (weak, nonatomic) IBOutlet UITextField *inputField;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UIImageView *resultImageView;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUp];
}

- (void)setUp {
    // 生成二维码
    self.inputField.rightViewMode = UITextFieldViewModeAlways;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0, 0, 50, 40);
    [button setTitle:@"生成" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor darkGrayColor];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(generateQRCode:) forControlEvents:UIControlEventTouchUpInside];
    self.inputField.rightView = button;
}

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

- (void)generateQRCode:(id)sender {
    self.resultImageView.image = [ZZQRImageHelper generateBarcode2ImageWithStr:self.inputField.text size:self.resultImageView.frame.size.width];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

@end
