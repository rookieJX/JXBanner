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
    model1.imageUrlStr = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1526929052618&di=0199e3fe834d8d1a1083df7c4b3b2ad0&imgtype=0&src=http%3A%2F%2Fimg.go007.com%2F2017%2F07%2F17%2F59598f8502e3b551_0.jpg";
    model1.backImageUrlStr = @"http://md-juhe.oss-cn-hangzhou.aliyuncs.com/upload/ad/20180417/9bc42ce40490c854eab2e9969ac8e328caab0a17.png";
    
    JXBannerModel *model2 = [[JXBannerModel alloc] init];
    model2.imageUrlStr = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1526929052618&di=18dc092b0e6fc8a321248cb62c54c365&imgtype=0&src=http%3A%2F%2Fimage.uczzd.cn%2F6328233074651725745.jpeg%3Fid%3D0%26from%3Dexport";
    model2.backImageUrlStr = @"http://md-juhe.oss-cn-hangzhou.aliyuncs.com/upload/ad/20180417/81e9ad49cba8dc479a09d146a1fabf4b9ef3504d.png";
    
    JXBannerModel *model3 = [[JXBannerModel alloc] init];
    model3.imageUrlStr = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1526929052623&di=fdbb7da424acfb6f5d32b97c461e5676&imgtype=0&src=http%3A%2F%2Fqimg.hxnews.com%2F2018%2F0329%2F1522291784816.jpg";
    model3.backImageUrlStr = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1526929052623&di=fdbb7da424acfb6f5d32b97c461e5676&imgtype=0&src=http%3A%2F%2Fqimg.hxnews.com%2F2018%2F0329%2F1522291784816.jpg";
    
    
    JXBannerModel *model4 = [[JXBannerModel alloc] init];
    model4.imageUrlStr = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1526929052620&di=fe1d4b47a1f803366586b729516382d4&imgtype=0&src=http%3A%2F%2Fnews.youth.cn%2Fyl%2F201412%2FW020141214362909268739.jpg";
    model4.backImageUrlStr = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1526929052620&di=fe1d4b47a1f803366586b729516382d4&imgtype=0&src=http%3A%2F%2Fnews.youth.cn%2Fyl%2F201412%2FW020141214362909268739.jpg";
    
    NSArray *bannerArray = @[model1,model2,model3,model4];
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
