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

@interface ViewController ()<JXBannerViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    JXBannerView *bannerView = [[JXBannerView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 300)];
    bannerView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:bannerView];
    
    JXBannerModel *model1 = [[JXBannerModel alloc] init];
    model1.imageUrlStr = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1527069414919&di=4be144aa2966b48d7c4362daf7c22947&imgtype=0&src=http%3A%2F%2Fent.northtimes.com%2Fu%2Fcms%2Fwww%2F201711%2F300913434d4d.jpg";
    model1.backImageUrlStr = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1527069414919&di=4be144aa2966b48d7c4362daf7c22947&imgtype=0&src=http%3A%2F%2Fent.northtimes.com%2Fu%2Fcms%2Fwww%2F201711%2F300913434d4d.jpg";
    
    JXBannerModel *model2 = [[JXBannerModel alloc] init];
    model2.imageUrlStr = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1527069441345&di=1c810b4392e5a1ddb8a7a71acc23fa5a&imgtype=0&src=http%3A%2F%2Fpic2.52pk.com%2Ffiles%2F170731%2F7777784_1I6232M.png";
    model2.backImageUrlStr = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1527069441345&di=1c810b4392e5a1ddb8a7a71acc23fa5a&imgtype=0&src=http%3A%2F%2Fpic2.52pk.com%2Ffiles%2F170731%2F7777784_1I6232M.png";
    
    JXBannerModel *model3 = [[JXBannerModel alloc] init];
    model3.imageUrlStr = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1526929052623&di=fdbb7da424acfb6f5d32b97c461e5676&imgtype=0&src=http%3A%2F%2Fqimg.hxnews.com%2F2018%2F0329%2F1522291784816.jpg";
    model3.backImageUrlStr = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1526929052623&di=fdbb7da424acfb6f5d32b97c461e5676&imgtype=0&src=http%3A%2F%2Fqimg.hxnews.com%2F2018%2F0329%2F1522291784816.jpg";
    
    
    JXBannerModel *model4 = [[JXBannerModel alloc] init];
    model4.imageUrlStr = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1526929052620&di=fe1d4b47a1f803366586b729516382d4&imgtype=0&src=http%3A%2F%2Fnews.youth.cn%2Fyl%2F201412%2FW020141214362909268739.jpg";
    model4.backImageUrlStr = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1526929052620&di=fe1d4b47a1f803366586b729516382d4&imgtype=0&src=http%3A%2F%2Fnews.youth.cn%2Fyl%2F201412%2FW020141214362909268739.jpg";
    
    NSArray *bannerArray = @[model1,model2];
    [bannerView setupBannerSources:bannerArray];
    
    
//    UIView *transFromView = [[UIView alloc] initWithFrame:CGRectMake(0, 400, [UIScreen mainScreen].bounds.size.width, 300)];
//    transFromView.backgroundColor = [UIColor redColor];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [UIView animateWithDuration:2 animations:^{
//            transFromView.transform = CGAffineTransformMakeScale(0.85, 0.85);
//        }];
//    });
//    [self.view addSubview:transFromView];
    
}



@end
