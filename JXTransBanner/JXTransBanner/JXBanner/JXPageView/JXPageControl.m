//
//  JXPageControl.m
//  JXTransBanner
//
//  Created by ss on 2018/5/23.
//  Copyright © 2018年 JX.Wang. All rights reserved.
//

#import "JXPageControl.h"
#import "UIImage+JXColor.h"

@interface JXPageControl ()
{
    UIImage* activeImage;
    UIImage* inactiveImage;
}
@end

@implementation JXPageControl

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) { 
        activeImage = [UIImage imageWithColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]];
        inactiveImage = [UIImage imageWithColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1]];
    }
    return self;
}


-(void)updateDots
{
    for (int i =0; i < [self.subviews count]; i++) {
        
        UIView * dot = [self.subviews objectAtIndex:i];
        dot.backgroundColor = [UIColor clearColor];
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, 11, 2)];
        
        if (i == self.currentPage) {
            imageView.image = inactiveImage;
        } else {
            imageView.image = activeImage;
        }
        
        for (UIView * subViews in dot.subviews ) {
            [subViews removeFromSuperview];
        }
        
        [dot addSubview:imageView];
        
    }
    
}

//重写current方法
-(void)setCurrentPage:(NSInteger)page {
    
    [super setCurrentPage:page];
    
    [self updateDots];
    
}

- (void)setNumberOfPages:(NSInteger)numberOfPages {
    
    [super setNumberOfPages:numberOfPages];
    
    [self updateDots];
    
}

@end
