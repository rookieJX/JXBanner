//
//  JXBannerCell.m
//  JXTransBanner
//
//  Created by 王加祥 on 2018/5/18.
//  Copyright © 2018年 JX.Wang. All rights reserved.
//

#import "JXBannerCell.h"
#import "UIImageView+WebCache.h"
#import "JXBannerModel.h"

#define kJXBannerCellMargin 10.0f // 左右间距

@interface JXBannerCell ()

/** 轮播图 */
@property (nonatomic,strong) UIImageView * bannerImageView;

@end

@implementation JXBannerCell

#pragma mark - Init
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

#pragma mark - UI
- (void)setupUI {
    self.bannerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kJXBannerCellMargin, 0, self.frame.size.width-kJXBannerCellMargin-kJXBannerCellMargin, self.frame.size.height)];
    self.bannerImageView.image = [UIImage imageNamed:@"01"];
    [self.contentView addSubview:self.bannerImageView];
}

- (void)setupBannerDataWithModel:(JXBannerModel *)model {
    [self.bannerImageView sd_setImageWithURL:[NSURL URLWithString:model.imageUrlStr] placeholderImage:[UIImage imageNamed:@"01"]];
}
@end
