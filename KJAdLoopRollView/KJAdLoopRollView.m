//
//  KJAdLoopRoll.m
//  Fragrance
//
//  Created by Apple on 15/4/29.
//  Copyright (c) 2015年 Apple. All rights reserved.
//

#import "KJAdLoopRollView.h"

//NSTimer *timer;   //若要在类方法里面使用，请声明为全局变量
// 私有属性，方法
@interface KJAdLoopRollView()
{
    CGFloat imageHeight;    //高度
    CGFloat imageWidth;     //宽度
    NSInteger imageCount;   //广告图片的显示个数
    NSInteger imageIndex;   //当前显示的图片标识，用于timer显示（只显示中间的图片，不显示左右为了循环增加的两个View）
}
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UIPageControl *pageControl;
@property (nonatomic, retain) NSArray *imageArray;  //图片数组，传递图片名
@property (nonatomic, retain) NSTimer *timer;
@end

@implementation KJAdLoopRollView
-(id)initWithFrame:(CGRect)frame andImageArray:(NSArray *)imageArr
{
    self = [super initWithFrame:frame];
    if (self) {
        imageWidth = self.frame.size.width;
        imageHeight = self.frame.size.height -20; //20留给pageControl显示
        self.imageArray = [NSArray arrayWithArray:imageArr];
        imageCount = self.imageArray.count;
        imageIndex = 1;
        [self setupUI];
        [self setupTimer];
    }
    return self;
}
-(void)setPagecontrolColor:(UIColor *)color
{
    self.pageControl.currentPageIndicatorTintColor = color;
}
// 创建界面入口
-(void)setupUI
{
    [self releasTimer];
    [self setupSrollView];
    [self setupPageControl];
}
-(void)setupSrollView
{
    // 初始化scrollView
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, imageWidth, imageHeight)];
    self.scrollView.bounces = NO;//取出弹簧效果
    self.scrollView.pagingEnabled = YES;//整页翻动
    self.scrollView.contentOffset = CGPointMake(imageWidth, 0);
    //在传入的图片数量上增加了两个视图，用于循环显示。当到达最后一个时再次往前滑，则让最后的视图显示第一个视图，达到循环的效果，同理当位于头部时，再次往后拉，则让最钱的视图显示最后一张图片。
    self.scrollView.contentSize = CGSizeMake(imageWidth*(imageCount+2), imageHeight);
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.userInteractionEnabled = YES;
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.delegate = self;
    [self addSubview:self.scrollView];
    
    //加载图片
    for (int i=0; i<(imageCount+2); i++) {
        // 加载第一张图片
        if (i == 0) {
            UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[self.imageArray objectAtIndex:0]]];
            imageView.frame = CGRectMake(imageWidth*(imageCount+1), 0, imageWidth, imageHeight);//相当于第一张图片放在了scroll view最后的位置上
            imageView.userInteractionEnabled = YES;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImage)];
            [imageView addGestureRecognizer:tapGes];
            [self.scrollView addSubview:imageView];
        }
        // 加载最后一张图片
        else if (i == imageCount+1){
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[self.imageArray objectAtIndex:(imageCount-1)]]];
            imageView.frame = CGRectMake(0, 0, imageWidth, imageHeight);//相当于显示第一张图片
            imageView.userInteractionEnabled = YES;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImage)];
            [imageView addGestureRecognizer:tapGes];
            [self.scrollView addSubview:imageView];
        }
        // 其他照片
        else if ( 0 < i <= imageCount)
        {
            UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[self.imageArray objectAtIndex:(i-1)]]];
            imageView.frame = CGRectMake(imageWidth*i, 0, imageWidth, imageHeight);
            imageView.userInteractionEnabled = YES;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImage)];
            [imageView addGestureRecognizer:tapGes];
            [self.scrollView addSubview:imageView];
        }
    }
}
-(void)setupPageControl
{
    // pageControl显示在接近中间位置
    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(imageWidth/2-10*imageCount, 50, 70, 20)];
    self.pageControl.numberOfPages = imageCount;//page总数
    self.pageControl.currentPage = 0;//当前page(默认为0)
    self.pageControl.pageIndicatorTintColor = [UIColor grayColor];//未选中的page颜色
    self.pageControl.currentPageIndicatorTintColor = [UIColor blackColor];//默认的当前显示page颜色
    [self.pageControl addTarget:self action:@selector(tapPage:) forControlEvents:UIControlEventValueChanged];//点击page的小点时的响应
    [self addSubview:self.pageControl];
}
// 点击广告图片时，实现点击图片的委托。传递的是page页以0开始，接收时对应应加1
-(void)tapImage
{
    if ([self.delegate respondsToSelector:@selector(tapImageAtIndex:)]) {
        [self.delegate tapImageAtIndex:self.pageControl.currentPage];
    }
}
// 点击page小点时，跳转到指定图片
-(void)tapPage:(UIPageControl *)sender
{
    UIPageControl *page = (UIPageControl *)sender;
    NSInteger page1 = page.currentPage;
    [self.scrollView setContentOffset:CGPointMake(imageWidth*(page1+1), 0)];
}
-(void)setupTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(timeLoop) userInfo:nil repeats:YES];
}
-(void)timeLoop
{
    // 获取当前的显示页
    NSInteger currPage = (self.scrollView.contentOffset.x-self.scrollView.frame.size.width/(imageCount+2)) / self.scrollView.frame.size.width + 1;
//    NSLog(@"currPage: %ld", (long)currPage);
    // 若显示到最后一张了，则将下一张要显示的置为第一张（达到循环的效果）
    if (currPage == imageCount) {
        imageIndex = 1;
    }
    // 否则，将要显示的职位page+1,因为page是以0开始的
    else{
        imageIndex = currPage+1;
    }
    // 直接滚动到指定的Scroll Image
    [self.scrollView setContentOffset:CGPointMake(imageWidth*imageIndex, 0) animated:YES];
    // 更新当前的page
    self.pageControl.currentPage = self.scrollView.contentOffset.x/imageWidth - 1;
}
#pragma mark UIScroll View Delegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger currPage = (self.scrollView.contentOffset.x-self.scrollView.frame.size.width/(imageCount+2)) / self.scrollView.frame.size.width + 1;
    NSLog(@"currPage: %ld", (long)currPage);
    if (currPage == 0) {
        [self.scrollView scrollRectToVisible:CGRectMake(imageWidth*imageCount, 0, imageWidth, imageHeight) animated:NO];
    }
    else if (currPage == (imageCount+1)){
        [self.scrollView scrollRectToVisible:CGRectMake(imageWidth, 0, imageWidth, imageHeight) animated:NO];
    }
}
// scroll滑动完成
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //计算当前的page页（它是以0开始的，所以在除以imageWidth后要减去1）
    self.pageControl.currentPage = self.scrollView.contentOffset.x/imageWidth - 1;
}
//TODO:将timer释放掉
-(void)releasTimer
{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}
@end
