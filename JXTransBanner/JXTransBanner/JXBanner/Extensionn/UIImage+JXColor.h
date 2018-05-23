//
//  UIImage+JXColor.h
//  JXTransBanner
//
//  Created by ss on 2018/5/23.
//  Copyright © 2018年 JX.Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (JXColor)
/** 根据颜色生成纯色图片 */
+ (UIImage *)imageWithColor:(UIColor *)color;
@end
