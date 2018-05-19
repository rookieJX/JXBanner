//
//  ViewController.m
//  JXTransBanner
//
//  Created by 王加祥 on 2018/5/18.
//  Copyright © 2018年 JX.Wang. All rights reserved.
//

#import "ViewController.h"
#import "JXBannerView.h"
#import "JXBannerModel.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    JXBannerView *bannerView = [[JXBannerView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 300)];
    bannerView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:bannerView];
    
    JXBannerModel *model1 = [[JXBannerModel alloc] init];
    model1.imageUrlStr = @"http://md-juhe.oss-cn-hangzhou.aliyuncs.com/upload/ad/20180417/6265b5b9bf8686f009cf44c366cfa4abd26b1a79.png";
    model1.backImageUrlStr = @"http://md-juhe.oss-cn-hangzhou.aliyuncs.com/upload/ad/20180417/9bc42ce40490c854eab2e9969ac8e328caab0a17.png";
    
    JXBannerModel *model2 = [[JXBannerModel alloc] init];
    model2.imageUrlStr = @"http://md-juhe.oss-cn-hangzhou.aliyuncs.com/upload/ad/20180417/16f7ab6124ae4688f0adef43ff3ab3b1f09ccc67.png";
    model2.backImageUrlStr = @"http://md-juhe.oss-cn-hangzhou.aliyuncs.com/upload/ad/20180417/81e9ad49cba8dc479a09d146a1fabf4b9ef3504d.png";
    
    NSArray *bannerArray = @[model1,model2];
    [bannerView setupBannerSources:bannerArray];
    
    
    UIView *transFromView = [[UIView alloc] initWithFrame:CGRectMake(0, 400, [UIScreen mainScreen].bounds.size.width, 300)];
    transFromView.backgroundColor = [UIColor redColor];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:2 animations:^{
            transFromView.transform = CGAffineTransformMakeScale(0.85, 0.85);
        }];
    });
    [self.view addSubview:transFromView];
    
}


@end
