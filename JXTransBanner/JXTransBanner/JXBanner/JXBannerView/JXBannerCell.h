//
//  JXBannerCell.h
//  JXTransBanner
//
//  Created by 王加祥 on 2018/5/18.
//  Copyright © 2018年 JX.Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JXBannerModel,JXBannerCell;

@protocol JXBannerCellDelegate <NSObject>

@optional
/** 开始长按 */
- (void)bannerCellActionForLongPressStart:(JXBannerCell *)cell;
/** 结束长按 */
- (void)bannerCellActionForLongPressEnd:(JXBannerCell *)cell;
@end

@interface JXBannerCell : UICollectionViewCell
/** 长按代理 */
@property (nonatomic,weak) id<JXBannerCellDelegate> delegate;
/** 设置数据 */
- (void)setupBannerDataWithModel:(JXBannerModel *)model;

@end
