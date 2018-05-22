//
//  JXBannerMaskView.h
//  JXTransBanner
//
//  Created by 王加祥 on 2018/5/22.
//  Copyright © 2018年 JX.Wang. All rights reserved.
//  变形图片

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, JXBannerMaskViewDirectionType) {
    JXBannerMaskViewDirectionTypeUnKnow,    // 未定义方向
    JXBannerMaskViewDirectionTypeLeft,      // 相当于拖动图片向左移动（与自动移动方向相反）
    JXBannerMaskViewDirectionTypeRight      // 自动移动方向
};

@interface JXBannerMaskView : UIView

- (void)setRadius:(CGFloat)radius direction:(JXBannerMaskViewDirectionType)directionType;

@end
