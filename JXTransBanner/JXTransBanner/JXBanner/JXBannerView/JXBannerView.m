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
#import "JXPageControl.h"
#import "JXBannerMaskView.h"

#define kJXBannerViewCellIdentifier @"kJXBannerViewCellIdentifier"
#define kJXBannerCellClass          [JXBannerCell class]

#define kJXWidth [UIScreen mainScreen].bounds.size.width // 宽度

#define kJXBannerTransformScale 0.85  // 变形比例
#define kJXBannerTransFormTime  0.5   // 变形时间

#define kJX_IPHONEX_TOP 88.0f  // 如果是iPhone X，banner轮播距离顶部距离
#define kJX_IPHONE_TOP  64.0f  // 如果是iPhone，banner轮播距离顶部距离

#define kJXBannerBackImageViewBottomMargin 30.0f // 背景图片距离底部间距

#define JXUI_IS_IPHONE      ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) // 判断是否是iPhone
#define JXUI_IS_IPHONEX     (JXUI_IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 812.0) // 判断是否是iPhone X

@interface JXBannerView ()<UICollectionViewDelegate,UICollectionViewDataSource,JXBannerCellDelegate>
/** 数据源 */
@property (nonatomic,strong) NSMutableArray * bannerSources;
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
/** 最后一次轮播图停止的位置 */
@property(nonatomic, assign) CGFloat lastContentOffset;
/** 背景图片 */
@property (nonatomic,strong) UIImageView * bannerBackImageView;
/** 背景底部图片 */
@property (nonatomic,strong) UIImageView * bannerBackBottomImageView;
/** 背景 */
@property (nonatomic,strong) UIView  *bannerMaskView;
/** 变形背景 */
@property (nonatomic,strong) JXBannerMaskView *bannerTransformMaskViewLeft;
/** 变形背景 */
@property (nonatomic,strong) JXBannerMaskView *bannerTransformMaskViewRight;
/** 指示器 */
@property (nonatomic,strong) JXPageControl *pageControl;
@end

@implementation JXBannerView

#pragma mark -  Init
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
    self.timerInterVal  = 5;
    self.bannerSources = @[].mutableCopy;
    
    [self addSubview:self.bannerBackBottomImageView];
    [self addSubview:self.bannerBackImageView];
    [self addSubview:self.bannerView];
    [self addSubview:self.pageControl];
    
    self.bannerBackImageView.maskView = self.bannerMaskView;
    [self.bannerMaskView addSubview:self.bannerTransformMaskViewRight];
    [self.bannerMaskView addSubview:self.bannerTransformMaskViewLeft];
}

#pragma mark - Meth
- (void)setupBannerSources:(NSArray *)banners {
    if (banners.count == 0) return;
    
    [self.bannerSources removeAllObjects];
    [self.bannerSources addObjectsFromArray:banners];
    self.pageControl.numberOfPages  = banners.count;
  
    if (self.bannerSources.count > 0) {
        [self.bannerSources insertObject:[banners lastObject] atIndex:0];
        [self.bannerSources addObject:[banners firstObject]];
        [self.bannerView setContentOffset:CGPointMake(kJXWidth, 0) animated:NO];
        [self setupCurrentBackBottomImageViewWithIndex:1];
        [self setupCurrentBackImageViewWithIndex:1];
    }
    
    [self.bannerView reloadData];
    
    [self startTimer];
    
}

#pragma mark - UICollectionViewDelegate && Source
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.bannerSources.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JXBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kJXBannerViewCellIdentifier forIndexPath:indexPath];
    cell.delegate   = self;
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
    NSLog(@"开始拖动------");
    [self stopTimer];
}

// 手动转动结束
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSLog(@"手动拖动结束----");
    [self startTimer];
    
    [self setupCurrentBackBottomImageViewWithIndex:self.currentBannerIndex];
    
    [self setupBannerScrollEnd:scrollView];
    
}

// 自动转动结束
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    NSLog(@"自动拖动结束----");
    
    [self setupCurrentBackBottomImageViewWithIndex:self.currentBannerIndex];
    
    [self setupBannerScrollEnd:scrollView];
    
}
#pragma mark - JXBannerCellDelegate
- (void)bannerCellActionForLongPressStart:(JXBannerCell *)cell {
    NSLog(@"长按开始-----");
    [self stopTimer];
    [UIView animateWithDuration:kJXBannerTransFormTime animations:^{
        cell.transform = CGAffineTransformMakeScale(kJXBannerTransformScale, kJXBannerTransformScale);
    }];
}
- (void)bannerCellActionForLongPressEnd:(JXBannerCell *)cell {
    NSLog(@"长按结束-----");
    [self startTimer];
    [UIView animateWithDuration:kJXBannerTransFormTime animations:^{
        cell.transform = CGAffineTransformMakeScale(1, 1);
    }];
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
    if (self.bannerSources.count == 0) return;
    NSUInteger currentIndex = [self currentBannerIndex];
    NSUInteger targetIndex  = currentIndex + 1;
    
    // 设置转动效果
    UICollectionViewCell *cell = [self.bannerView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:currentIndex inSection:0]];
    [UIView animateWithDuration:kJXBannerTransFormTime animations:^{
        cell.transform = CGAffineTransformMakeScale(kJXBannerTransformScale, kJXBannerTransformScale);
    } completion:^(BOOL finished) {
        [self scrollToIndex:targetIndex];
    }];
}

- (void)scrollToIndex:(NSInteger)targetIndex {
    if (targetIndex >= self.bannerSources.count) return;
    [self.bannerView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}

// 轮播图正向轮播
- (void)setupBannerStartPositive:(UIScrollView *)scrollView {
    NSInteger currentIndex = scrollView.contentOffset.x / scrollView.contentSize.width;
    NSInteger nextIndex = (currentIndex + 1) >= self.bannerSources.count ? 0 : currentIndex + 1;
    
    UICollectionViewCell *cell1 = [self.bannerView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:currentIndex inSection:0]];
    UICollectionViewCell *cell2 = [self.bannerView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:nextIndex inSection:0]];
    
    cell1.transform = CGAffineTransformMakeScale(kJXBannerTransformScale, kJXBannerTransformScale);
    cell2.transform = CGAffineTransformMakeScale(kJXBannerTransformScale, kJXBannerTransformScale);
    
    // 设置背景图片 （+1是为了防止每次移动到最后下标会增加1）
    NSInteger currentPage = scrollView.contentOffset.x / (scrollView.bounds.size.width+1);
    NSLog(@"正向拖动轮播-----%ld",currentPage);
    NSInteger nextPage    = (currentPage + 1) >= self.bannerSources.count ? 0 : currentPage + 1;
    [self setupCurrentBackImageViewWithIndex:nextPage];
    
    [self.bannerTransformMaskViewRight setRadius:((scrollView.contentOffset.x - kJXWidth * currentPage)*2) direction:JXBannerMaskViewDirectionTypeRight];
    [self.bannerTransformMaskViewLeft setRadius:0 direction:JXBannerMaskViewDirectionTypeLeft];
    
    [self setupBannerBoundary:scrollView];
    

}

// 轮播图反向轮播
- (void)setupBannerStartReverse:(UIScrollView *)scrollView {
    NSLog(@"反向拖动轮播-----");
    NSInteger currentIndex = self.currentBannerIndex;
    NSInteger preIndex = (currentIndex - 1 < 0) ? self.bannerSources.count : currentIndex - 1;
    
    UICollectionViewCell *cell1 = [self.bannerView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:currentIndex inSection:0]];
    UICollectionViewCell *cell2 = [self.bannerView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:preIndex inSection:0]];
    
    cell1.transform = CGAffineTransformMakeScale(kJXBannerTransformScale, kJXBannerTransformScale);
    cell2.transform = CGAffineTransformMakeScale(kJXBannerTransformScale, kJXBannerTransformScale);
    
    // 设置背景图片
    NSInteger currentPage = scrollView.contentOffset.x / scrollView.bounds.size.width;
    [self setupCurrentBackImageViewWithIndex:currentPage];
    [self.bannerTransformMaskViewRight setRadius:0 direction:JXBannerMaskViewDirectionTypeRight];
    [self.bannerTransformMaskViewLeft setRadius:fabs(( scrollView.contentOffset.x -kJXWidth * currentPage - kJXWidth))*2 direction:JXBannerMaskViewDirectionTypeLeft];
    
    [self setupBannerBoundary:scrollView];
    
}

// 轮播结束后复原
- (void)setupBannerScrollEnd:(UIScrollView *)scrollView {
    NSInteger currentIndex = [self currentBannerIndex];
    
    UICollectionViewCell *boundryCell = nil;
    
    if (currentIndex == 0) {
        boundryCell = [self.bannerView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:(self.bannerSources.count - 2) inSection:0]];
    } else if ((int)currentIndex == self.bannerSources.count - 1 ) {
        boundryCell = [self.bannerView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]];
    }
    
    UICollectionViewCell *cell1 = [self.bannerView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:currentIndex inSection:0]];
    UICollectionViewCell *cell2 = [self.bannerView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:(currentIndex + 1 >= self.bannerSources.count) ? 0 : currentIndex + 1 inSection:0]];
    UICollectionViewCell *cell3 = [self.bannerView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:(currentIndex - 1 < 0) ? self.bannerSources.count : currentIndex - 1 inSection:0]];
    
    [UIView animateWithDuration:kJXBannerTransFormTime animations:^{
        
        boundryCell.transform = CGAffineTransformMakeScale(1, 1);
        cell1.transform = CGAffineTransformMakeScale(1, 1);
        cell2.transform = CGAffineTransformMakeScale(1, 1);
        cell3.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

// 轮播图临界位置处理
- (void)setupBannerBoundary:(UIScrollView *)scrollView {
    
    CGFloat page = scrollView.contentOffset.x / scrollView.bounds.size.width ;
    if (page == 0) {
        
        [scrollView setContentOffset:CGPointMake(kJXWidth*(self.bannerSources.count - 2), 0) animated:NO];
        self.pageControl.currentPage = self.bannerSources.count - 2;
    } else if ((int)page == self.bannerSources.count - 1 ) {
        
        [scrollView setContentOffset:CGPointMake(kJXWidth, 0) animated:NO];
        self.pageControl.currentPage = 0;
    } else {
        self.pageControl.currentPage    = (int)page - 1;
    }
}

// 处理当前背景图片
- (void)setupCurrentBackImageViewWithIndex:(NSInteger)index {
    if (self.bannerSources.count <= index) return;
    JXBannerModel *model = [self.bannerSources objectAtIndex:index];
    [self.bannerBackImageView sd_setImageWithURL:[NSURL URLWithString:model.backImageUrlStr]];
}
// 处理当前背景底部图片
- (void)setupCurrentBackBottomImageViewWithIndex:(NSInteger)index {
    if (self.bannerSources.count <= index) return;
    JXBannerModel *model = [self.bannerSources objectAtIndex:index];
    [self.bannerBackBottomImageView sd_setImageWithURL:[NSURL URLWithString:model.backImageUrlStr]];
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
    }
    return _bannerView;
}

- (UIImageView *)bannerBackImageView{
    if (_bannerBackImageView == nil) {
        _bannerBackImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-kJXBannerBackImageViewBottomMargin)];
    }
    return _bannerBackImageView;
}

- (UIImageView *)bannerBackBottomImageView {
    if (_bannerBackBottomImageView == nil) {
        _bannerBackBottomImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-kJXBannerBackImageViewBottomMargin)];
    }
    return _bannerBackBottomImageView;
}

- (UIView *)bannerMaskView {
    if (_bannerMaskView == nil) {
        _bannerMaskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-kJXBannerBackImageViewBottomMargin)];
    }
    return _bannerMaskView;
}

- (JXBannerMaskView *)bannerTransformMaskViewLeft {
    if (_bannerTransformMaskViewLeft == nil) {
        _bannerTransformMaskViewLeft = [[JXBannerMaskView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-kJXBannerBackImageViewBottomMargin)];
    }
    return _bannerTransformMaskViewLeft;
}

- (JXBannerMaskView *)bannerTransformMaskViewRight {
    if (_bannerTransformMaskViewRight == nil) {
        _bannerTransformMaskViewRight = [[JXBannerMaskView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-kJXBannerBackImageViewBottomMargin)];
    }
    return _bannerTransformMaskViewRight;
}

- (JXPageControl *)pageControl {
    if (_pageControl == nil) {
        _pageControl = [[JXPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height-30, self.frame.size.width, 30)];
    }
    return _pageControl;
}

@end
