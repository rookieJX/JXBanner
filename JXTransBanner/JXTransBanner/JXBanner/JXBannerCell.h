//
//  JXBannerCell.h
//  JXTransBanner
//
//  Created by 王加祥 on 2018/5/18.
//  Copyright © 2018年 JX.Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JXBannerModel;

@interface JXBannerCell : UICollectionViewCell

/** 设置数据 */
- (void)setupBannerDataWithModel:(JXBannerModel *)model;

@end
