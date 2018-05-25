//
//  JXBannerView.h
//  JXTransBanner
//
//  Created by 王加祥 on 2018/5/18.
//  Copyright © 2018年 JX.Wang. All rights reserved.
//  模仿转转banner样式

#import <UIKit/UIKit.h>

@class JXBannerView,JXBannerModel;

@protocol JXBannerViewDelegate <NSObject>

@optional
- (void)bannerView:(JXBannerView *)view didClickItemWithModel:(JXBannerModel *)model;

@end


@interface JXBannerView : UIView

@property (nonatomic,weak) id<JXBannerViewDelegate> jx_delegate;

/** 设置数据源 */
- (void)setupBannerSources:(NSArray *)banners;

@end
