//
//  ZZQRImageHelper.h
//  ZZQRManager
//
//  Created by 刘威振 on 2/14/16.
//  Copyright © 2016 LiuWeiZhen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ZZQRImageHelper : NSObject

+ (UIImage *)generateBarcode1ImageWithStr:(NSString *)str size:(CGSize)size;

/**
 *  根据字符串生成相应的二维码图片
 *
 *  @param str  字符串
 *  @param size 要生成的二维码图片的尺寸
 *  @return 生成的二维码图片
 */
+ (UIImage *)generateBarcode2ImageWithStr:(NSString *)str size:(CGFloat)size;


/**
 *  从相册中选择图片并解码
 *
 *  @param controller        视图控制器
 *  @param completionHandler 选择好图片并解码后的block回调
 */
+ (void)getQRStrByPickImageWithController:(UIViewController *)controller completionHandler:(void (^)(CIImage *image, NSString *decodeStr))completionHandler;

/**
 *  解码图片
 *
 *  @param image 要解码的图片
 *  @return 解码图片得到的字符串
 */
+ (NSString *)decodeImage:(CIImage *)image;

/**
 * 获取ZXQManager.bundle中的图片
 *
 * @param imageName 图片名
 * @return UIImage对象
 */
+ (UIImage *)imageNamed:(NSString *)imageName;

/**
 * 获取ZXQManager.bundle中的资源路径
 *
 * @param fileName 文件名
 * @return 完整的资源路径
 */
+ (NSString *)resourcePath:(NSString *)fileName;

@end

