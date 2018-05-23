//
//  UIImage+JXColor.m
//  JXTransBanner
//
//  Created by ss on 2018/5/23.
//  Copyright © 2018年 JX.Wang. All rights reserved.
//

#import "UIImage+JXColor.h"

@implementation UIImage (JXColor)
+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
@end
