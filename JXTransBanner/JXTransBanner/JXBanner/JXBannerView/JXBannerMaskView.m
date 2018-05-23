//
//  JXBannerMaskView.m
//  JXTransBanner
//
//  Created by 王加祥 on 2018/5/22.
//  Copyright © 2018年 JX.Wang. All rights reserved.
//

#import "JXBannerMaskView.h"

@interface JXBannerMaskView ()

@property (assign, readonly, nonatomic) CGFloat maskRadius;

@property (assign, readonly, nonatomic) JXBannerMaskViewDirectionType direction;

@end

@implementation JXBannerMaskView
- (void)setRadius:(CGFloat)radius direction:(JXBannerMaskViewDirectionType)directionType {
    _maskRadius = radius;
    _direction = directionType;
    
    if (_direction != JXBannerMaskViewDirectionTypeUnKnow) {
        [self setNeedsDisplay];
    }
    
}


- (void)drawRect:(CGRect)rect {
    self.backgroundColor = [UIColor clearColor];
    if (_direction != JXBannerMaskViewDirectionTypeUnKnow) {
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        if (_direction == JXBannerMaskViewDirectionTypeRight){
            CGContextAddArc(ctx, self.center.x + rect.size.width/2, self.center.y, _maskRadius, 0, M_PI * 2, NO);
        }else{
            CGContextAddArc(ctx, self.center.x - rect.size.width/2, self.center.y, _maskRadius, 0, M_PI * 2, NO);
        }
        CGContextSetFillColorWithColor(ctx, [[UIColor whiteColor] CGColor]);
        CGContextFillPath(ctx);
    }
}

@end
