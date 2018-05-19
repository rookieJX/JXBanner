//
//  JXBannerView.m
//  JXTransBanner
//
//  Created by 王加祥 on 2018/5/18.
//  Copyright © 2018年 JX.Wang. All rights reserved.
//

#import "JXBannerView.h"
#import "JXBannerModel.h"
#import "JXBannerCell.h"
#import "UIImageView+WebCache.h"

#define kJXBannerViewCellIdentifier @"kJXBannerViewCellIdentifier"
#define kJXBannerCellClass          [JXBannerCell class]

#define kJX_IPHONEX_TOP 88.0f  // 如果是iPhone X，banner轮播距离顶部距离
#define kJX_IPHONE_TOP  64.0f  // 如果是iPhone，banner轮播距离顶部距离

#define kJXBannerBackImageViewBottomMargin 30.0f // 背景图片距离底部间距

#define JXUI_IS_IPHONE      ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) // 判断是否是iPhone
#define JXUI_IS_IPHONEX     (JXUI_IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 812.0) // 判断是否是iPhone X

@interface JXBannerView ()<UICollectionViewDelegate,UICollectionViewDataSource>
/** 数据源 */
@property (nonatomic,strong) NSArray * bannerSources;
/** 数据源个数 */
@property (nonatomic,assign) NSInteger bannerSourceCount;
/** 轮播图背景 */
@property (nonatomic,strong) UICollectionView * bannerView;
/** 轮播图布局 */
@property (nonatomic,strong) UICollectionViewFlowLayout * bannerFlowLayout;
/** 轮播图距离顶部间距 */
@property (nonatomic,assign) CGFloat bannerTopMargin;
/** 定时器 */
@property (nonatomic,strong) NSTimer * timer;
/** 定时器时间间隔 */
@property (nonatomic,assign) double timerInterVal;
/** 当前轮播图位置 */
@property (nonatomic,assign) NSInteger currentBannerIndex;
/** 开始拖拽时当前位置 */
@property(nonatomic, assign) NSInteger draggingIndex;
/** 最后一次轮播图停止的位置 */
@property(nonatomic, assign) CGFloat lastContentOffset;
/** 背景图片 */
@property (nonatomic,strong) UIImageView * bannerBackImageView;

@end

@implementation JXBannerView

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
    self.timerInterVal  = 2;
    
    [self addSubview:self.bannerBackImageView];
    
}

- (void)setupBannerSources:(NSArray *)banners {
    if (banners.count == 0) return;
    
    self.bannerSources = banners;
    self.bannerSourceCount  = banners.count;
    
    [self.bannerView reloadData];
    
    [self startTimer];
    
}

#pragma mark - UICollectionViewDelegate && Source
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.bannerSourceCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JXBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kJXBannerViewCellIdentifier forIndexPath:indexPath];
    JXBannerModel  *model = [self.bannerSources objectAtIndex:indexPath.row];
    [cell setupBannerDataWithModel:model];
    return cell;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat curretContentOffset = scrollView.contentOffset.x;
    
    if (scrollView.isDragging || scrollView.isDecelerating) { // 拖动
        if (self.lastContentOffset > curretContentOffset) { // 轮播图反向轮播
            [self setupBannerStartReverse:scrollView];
        } else { // 轮播图正向轮播
            [self setupBannerStartPositive:scrollView];
        }
    } else { // 自动滚动（只有正向轮播）
        [self setupBannerStartPositive:scrollView];
    }
    
    self.lastContentOffset = curretContentOffset;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.draggingIndex = [self currentBannerIndex];
    [self stopTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self startTimer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.lastContentOffset = scrollView.contentOffset.x;
    
    [self setupBannerScrollEnd:scrollView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self setupBannerScrollEnd:scrollView];
}

#pragma mark - Timer
// 定时器模块
- (void)startTimer {
    [self stopTimer];
    
    self.timer = [NSTimer timerWithTimeInterval:self.timerInterVal target:self selector:@selector(actionForAutoScroll) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}
- (void)stopTimer {
    if (_timer != nil) {
        [_timer invalidate];
        _timer = nil;
    }
}

#pragma mark - Target
// 定时器任务
- (void)actionForAutoScroll {
    if (self.bannerSourceCount == 0) return;
    NSUInteger currentIndex = [self currentBannerIndex];
    NSUInteger targetIndex  = currentIndex + 1;
    
    // 设置转动效果
    UICollectionViewCell *cell = [self.bannerView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:currentIndex inSection:0]];
    [UIView animateWithDuration:0.25 animations:^{
        cell.transform = CGAffineTransformMakeScale(0.85, 0.85);
    } completion:^(BOOL finished) {
        [self scrollToIndex:targetIndex];
    }];
}

- (void)scrollToIndex:(NSInteger)targetIndex {
    if (targetIndex >= self.bannerSourceCount) {
        [self.bannerView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        return;
    }
    [self.bannerView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}

// 轮播图正向轮播
- (void)setupBannerStartPositive:(UIScrollView *)scrollView {
    UICollectionViewCell *cell1 = [self.bannerView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.draggingIndex inSection:0]];
    UICollectionViewCell *cell2 = [self.bannerView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:(self.draggingIndex + 1 >= self.bannerSourceCount) ? 0 : self.draggingIndex + 1 inSection:0]];
    
    [UIView animateWithDuration:0.1 animations:^{
        cell1.transform = CGAffineTransformMakeScale(0.85, 0.85);
        cell2.transform = CGAffineTransformMakeScale(0.85, 0.85);
    }];
}

// 轮播图反向轮播
- (void)setupBannerStartReverse:(UIScrollView *)scrollView {
    UICollectionViewCell *cell1 = [self.bannerView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.draggingIndex inSection:0]];
    UICollectionViewCell *cell2 = [self.bannerView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:(self.draggingIndex - 1 < 0) ? self.bannerSourceCount : self.draggingIndex - 1 inSection:0]];
    
    [UIView animateWithDuration:0.1 animations:^{
        cell1.transform = CGAffineTransformMakeScale(0.85, 0.85);
        cell2.transform = CGAffineTransformMakeScale(0.85, 0.85);
    }];
}

// 轮播结束后复原
- (void)setupBannerScrollEnd:(UIScrollView *)scrollView {
    NSInteger currentIndex = [self currentBannerIndex];
    
    UICollectionViewCell *cell1 = [self.bannerView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:currentIndex inSection:0]];
    UICollectionViewCell *cell2 = [self.bannerView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:(currentIndex + 1 >= self.bannerSourceCount) ? 0 : currentIndex + 1 inSection:0]];
    UICollectionViewCell *cell3 = [self.bannerView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:(currentIndex - 1 < 0) ? self.bannerSourceCount : currentIndex - 1 inSection:0]];
    
    [UIView animateWithDuration:0.2 animations:^{
        cell1.transform = CGAffineTransformMakeScale(1, 1);
        cell2.transform = CGAffineTransformMakeScale(1, 1);
        cell3.transform = CGAffineTransformMakeScale(1, 1);
    }];
}
#pragma mark - Get
- (CGFloat)bannerTopMargin {
    return JXUI_IS_IPHONEX ? kJX_IPHONEX_TOP : kJX_IPHONE_TOP;
}

- (NSInteger)currentBannerIndex {
    if (_bannerView.frame.size.width == 0 || _bannerView.frame.size.height == 0) return 0;
    NSInteger index;
    index = _bannerView.contentOffset.x / _bannerView.frame.size.width + 0.5;
    return MAX(0, index);
}
#pragma mark - LazyLoad
- (UICollectionViewFlowLayout *)bannerFlowLayout{
    if (_bannerFlowLayout == nil) {
        _bannerFlowLayout = [[UICollectionViewFlowLayout alloc] init];
        _bannerFlowLayout.itemSize  = CGSizeMake(self.frame.size.width, self.frame.size.height-self.bannerTopMargin);
        _bannerFlowLayout.minimumLineSpacing    = 0;
        _bannerFlowLayout.scrollDirection   = UICollectionViewScrollDirectionHorizontal;
    }
    return _bannerFlowLayout;
}

- (UICollectionView *)bannerView{
    if (_bannerView == nil) {
        _bannerView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.bannerTopMargin, self.frame.size.width, self.frame.size.height-self.bannerTopMargin) collectionViewLayout:self.bannerFlowLayout];
        _bannerView.delegate    = self;
        _bannerView.dataSource  = self;
        _bannerView.pagingEnabled   = YES;
        _bannerView.backgroundColor = [UIColor clearColor];
        _bannerView.showsHorizontalScrollIndicator  = NO;
        [_bannerView registerClass:kJXBannerCellClass forCellWithReuseIdentifier:kJXBannerViewCellIdentifier];
        [self addSubview:_bannerView];
    }
    return _bannerView;
}

- (UIImageView *)bannerBackImageView{
    if (_bannerBackImageView == nil) {
        _bannerBackImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-kJXBannerBackImageViewBottomMargin)];
    }
    return _bannerBackImageView;
}
@end
